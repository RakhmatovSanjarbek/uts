import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_cargo/core/constants/constants.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../bloc/chat_bloc.dart';
import '../../../data/models/chat_model/chat_model.dart';

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
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: AppColors.screenColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
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
                    // Xabarlar pastdan yuqoriga o'sadi
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isUser = !msg.isFromAdmin;

                      // Sana dividerini chiqarish logikasi (reverse bo'lgani uchun index + 1)
                      bool showDate = false;
                      if (index == messages.length - 1) {
                        showDate = true;
                      } else {
                        final olderMsg = messages[index + 1];
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
                            _DateDivider(timestamp: msg.timestampMs),
                          Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: _MessageBubble(message: msg, isUser: isUser),
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
          _InputArea(
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

class _DateDivider extends StatelessWidget {
  final int timestamp;

  const _DateDivider({required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            DateUtilsHelper.formatDay(timestamp),
            style: TextStyle(
              color: AppColors.blackColor50,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatModel message;
  final bool isUser;

  const _MessageBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.78,
      ),
      decoration: BoxDecoration(
        color: isUser ? AppColors.userColor : AppColors.supportColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isUser ? 16 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.image != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "${Constants.baseUrl}${message.image!}",
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ),
          if (message.message != null && message.message!.isNotEmpty)
            Text(
              message.message!,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 14.5,
              ),
            ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateUtilsHelper.formatTime(message.timestampMs),
                style: TextStyle(
                  fontSize: 10,
                  color: isUser ? Colors.white70 : Colors.black45,
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 4),
                const Icon(Icons.done_all, size: 13, color: Colors.white70),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _InputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPickImage;

  const _InputArea({
    required this.controller,
    required this.onSend,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onPickImage,
            icon: SvgPicture.asset(
              AppSvg.icFile,
              color: AppColors.mainColor,
              height: 24,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                maxLines: 5,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: "Xabar yozing...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: AppColors.mainColor,
            radius: 22,
            child: IconButton(
              onPressed: onSend,
              icon: SvgPicture.asset(
                AppSvg.icSend,
                color: Colors.white,
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
