import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
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
  const SupportChatPage({super.key});

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkAndLoadChat();
  }

  void _checkAndLoadChat() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      context.read<ChatBloc>().add(GetChatsEvent());
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(SendChatMessageEvent(message: text));
    _controller.clear();
  }

  Future<void> _sendImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image == null) return;
    context.read<ChatBloc>().add(SendChatMessageEvent(image: File(image.path)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        title: Text(
          AppStrings.help,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.blackColor),
        ),
        backgroundColor: AppColors.screenColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _refreshChat,
            icon: SvgPicture.asset(
              AppSvg.icRefresh,
              width: 24.0,
              height: 24.0,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final bool isAuthenticated = authState is AuthenticatedState;
          final bool isPending = authState is PendingState;
          final bool isRejected = authState is RejectedState;
          final bool isUnauthenticated = authState is UnauthenticatedState;

          if (!isAuthenticated) {
            return _buildUnavailableScreen(isPending, isRejected, isUnauthenticated);
          }

          return _buildChatContent();
        },
      ),
    );
  }

  Widget _buildUnavailableScreen(bool isPending, bool isRejected, bool isUnauthenticated) {
    String message = "";
    String buttonText = "";
    VoidCallback? onPressed;

    if (isPending) {
      message = "Akkauntingiz tekshirilmoqda. Chat xizmatidan foydalanish uchun akkaunt tasdiqlanishi kerak.";
      buttonText = "";
      onPressed = null;
    } else if (isRejected) {
      message = "Akkauntingiz rad etilgan. Chat xizmatidan foydalanish uchun qayta ro'yxatdan o'ting.";
      buttonText = "Qayta ro'yxatdan o'tish";
      onPressed = () {
        context.read<AuthBloc>().add(LogoutEvent());
        Navigator.pushNamed(context, "/login");
      };
    } else {
      message = "Chat xizmatidan foydalanish uchun ro'yxatdan o'ting va akkauntingizni tasdiqlang.";
      buttonText = "Ro'yxatdan o'tish";
      onPressed = () => Navigator.pushNamed(context, "/login");
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
              colorFilter: ColorFilter.mode(
                AppColors.grayColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grayColor,
              ),
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
                _scrollToBottom();
              } else if (state is ChatFailure) {
                context.showSnackBarMessage(state.error);
              }
            },
            builder: (context, state) {
              if (state is ChatLoading && state is! ChatSuccess) {
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
                          colorFilter: ColorFilter.mode(
                            AppColors.grayColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Xabarlar mavjud emas",
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isUser = !msg.isFromAdmin;
                    bool showDate = false;
                    if (index == 0) {
                      showDate = true;
                    } else {
                      final olderMsg = messages[index - 1];
                      if (!_isSameDay(
                        msg.timestampMs,
                        olderMsg.timestampMs,
                      )) {
                        showDate = true;
                      }
                    }
                    return Column(
                      children: [
                        if (showDate)
                          WDateDivider(timestamp: msg.timestampMs),
                        Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: WMessageBubble(message: msg, isUser: isUser),
                        ),
                      ],
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        WInputArea(
          controller: _controller,
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

  Future<void> _refreshChat() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      context.read<ChatBloc>().add(GetChatsEvent());
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}