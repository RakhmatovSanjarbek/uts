import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_cargo/core/extensions/snackbar_extension.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

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
    context.read<ChatBloc>().add(GetChatsEvent());
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
        title: const Text(
          "Yordam",
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
      body: Column(
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
      ),
    );
  }

  bool _isSameDay(int ts1, int ts2) {
    final d1 = DateTime.fromMillisecondsSinceEpoch(ts1);
    final d2 = DateTime.fromMillisecondsSinceEpoch(ts2);
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Future<void> _refreshChat() async {
    context.read<ChatBloc>().add(GetChatsEvent());
    await Future.delayed(const Duration(seconds: 1));
  }
}