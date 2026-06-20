import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:uts_cargo/core/extensions/snack_extension.dart';
import 'package:uts_cargo/core/string/app_string.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/auth/bloc/auth_bloc.dart';
import '../../../data/models/user_model/user_model.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/w_date_divider.dart';
import '../widgets/w_message_bubble.dart';
import '../widgets/w_nput_area.dart';

class SupportChatPage extends StatefulWidget {
  final bool isActive;

  const SupportChatPage({super.key, required this.isActive});

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  UserModel? _userModel;
  Timer? _refreshTimer;
  bool _isFirstLoad = true;
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    if (widget.isActive) {
      _loadChat();
      _startAutoRefresh();
    }
  }

  @override
  void didUpdateWidget(covariant SupportChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _loadChat();
      _startAutoRefresh();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAutoRefresh();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _refreshTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 350), _scrollToBottom);
    }
  }

  void _loadChat() {
    context.read<ChatBloc>().add(GetChatsEvent());
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && widget.isActive) {
        context.read<ChatBloc>().add(GetChatsEvent(isAutoRefresh: true));
      }
    });
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  void _scrollToBottom({bool force = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _dismissKeyboard() {
    _focusNode.unfocus();
  }

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _dismissKeyboard();
    context.read<ChatBloc>().add(SendChatMessageEvent(message: text));
    _controller.clear();
    _scrollToBottom();
  }

  Future<void> _sendImage() async {
    _dismissKeyboard();
    final source = await _showSourceDialog();
    if (source == null) return;

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1920,
      maxHeight: 1920,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (picked == null) return;

    // DEBUG — konsolda ko'rish uchun
    final file = File(picked.path);
    final exists = await file.exists();
    final size = exists ? await file.length() : 0;
    print('📸 Rasm yo\'li: ${picked.path}');
    print('📁 Fayl mavjud: $exists');
    print('📦 Hajmi: $size bytes');

    context.read<ChatBloc>().add(
      SendChatMessageEvent(image: file),
    );
    _scrollToBottom();
  }

  Future<ImageSource?> _showSourceDialog() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galereya'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: AppColors.screenColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            AppStrings.help,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
          ),
          backgroundColor: AppColors.screenColor,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                _loadChat();
                _scrollToBottom(force: true);
              },
              icon: SvgPicture.asset(
                AppSvg.icRefresh,
                width: 24.0,
                height: 24.0,
                colorFilter: const ColorFilter.mode(
                  AppColors.mainColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is RejectedState) _userModel = authState.user;

            if (authState is! AuthenticatedState) {
              return _buildUnavailableScreen(
                isPending: authState is PendingState,
                isRejected: authState is RejectedState,
                isUnauthenticated: authState is UnauthenticatedState,
              );
            }

            return _buildChatContent();
          },
        ),
      ),
    );
  }

  Widget _buildUnavailableScreen({
    required bool isPending,
    required bool isRejected,
    required bool isUnauthenticated,
  }) {
    String message = '';
    String buttonText = '';
    VoidCallback? onPressed;

    if (isUnauthenticated) {
      message = AppStrings.registerToUse;
      buttonText = AppStrings.registration;
      onPressed = () => Navigator.pushNamed(context, '/login');
    } else if (isPending) {
      message = AppStrings.accountChecking;
    } else if (isRejected) {
      message = AppStrings.accountRejectedReRegister;
      buttonText = AppStrings.reRegister;
      onPressed = () {
        if (_userModel != null && _userModel!.phone.isNotEmpty) {
          Navigator.pushNamed(context, '/register', arguments: _userModel!.phone);
        }
      };
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppSvg.icMessage,
              width: 80,
              height: 80,
              colorFilter: const ColorFilter.mode(
                AppColors.grayColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.grayColor),
            ),
            if (buttonText.isNotEmpty && onPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(buttonText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChatContent() {
    return Column(
      children: [
        Expanded(
          child: BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is ChatSuccess) {
                final count = state.response.chats.length;
                final hasNew = count > _lastMessageCount;
                _lastMessageCount = count;
                if (_isFirstLoad || hasNew) {
                  _isFirstLoad = false;
                  _scrollToBottom();
                }
              } else if (state is ChatFailure) {
                context.showSnackBarMessage(state.error);
              }
            },
            builder: (context, state) {
              if (state is ChatLoading && _isFirstLoad) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ChatSuccess) {
                final messages = state.response.chats;
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppSvg.icMessage,
                          width: 60,
                          height: 60,
                          colorFilter: const ColorFilter.mode(
                            AppColors.grayColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.noMessages,
                          style: const TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      final isAtBottom =
                          _scrollController.position.pixels >=
                              _scrollController.position.maxScrollExtent - 80;
                      if (isAtBottom) _dismissKeyboard();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isUser = !msg.isFromAdmin;
                      final showDate = index == 0 ||
                          !_isSameDay(
                            msg.timestampMs,
                            messages[index - 1].timestampMs,
                          );
                      return Column(
                        children: [
                          if (showDate) WDateDivider(timestamp: msg.timestampMs),
                          Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: WMessageBubble(message: msg, isUser: isUser),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        WInputArea(
          controller: _controller,
          focusNode: _focusNode,
          onSend: _sendText,
          onPickImage: _sendImage,
        ),
      ],
    );
  }

  bool _isSameDay(int ts1, int ts2) {
    final d1 = DateTime.fromMillisecondsSinceEpoch(ts1);
    final d2 = DateTime.fromMillisecondsSinceEpoch(ts2);
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}