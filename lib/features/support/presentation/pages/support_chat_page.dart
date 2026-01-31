import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uts_cargo/core/svg/app_svg.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';

import '../../../../core/utils/date_utils.dart';
import '../../data/mock/message_mock_data.dart';
import '../../domain/entities/message_entity.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({super.key});

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();

  final String userToken = "user";

  List<MessageEntity> messages = List.from(mockMessages);

  void sendText() {
    if (controller.text.trim().isEmpty) return;

    messages.add(
      MessageEntity(
        token: userToken,
        message: controller.text,
        date: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    controller.clear();
    setState(() {});
    scrollToBottom();
  }

  Future<void> sendImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    messages.add(
      MessageEntity(
        token: userToken,
        imagePath: image.path,
        date: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    setState(() {});
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  bool isNewDay(int index) {
    if (index == 0) return true;

    final prev = DateTime.fromMillisecondsSinceEpoch(messages[index - 1].date);
    final current = DateTime.fromMillisecondsSinceEpoch(messages[index].date);

    return prev.day != current.day ||
        prev.month != current.month ||
        prev.year != current.year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16.0, top: 24.0),
            padding: EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Yordam",
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg.token == userToken;

                return Column(
                  children: [
                    if (isNewDay(index))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          DateUtilsHelper.formatDay(msg.date),
                          style: TextStyle(
                            color: AppColors.blackColor50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: _MessageBubble(message: msg, isUser: isUser),
                    ),
                  ],
                );
              },
            ),
          ),
          _InputArea(),
        ],
      ),
    );
  }

  Widget _InputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: sendImage,
            child: Container(
              width: 56.0,
              height: 56.0,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(28.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                AppSvg.icFile,
                colorFilter: ColorFilter.mode(
                  AppColors.mainColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Container(
              height: 56.0,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(28.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Xabar yozing...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: sendText,
                    icon: SvgPicture.asset(
                      AppSvg.icSend,
                      colorFilter: ColorFilter.mode(
                        AppColors.mainColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isUser;

  const _MessageBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(
        color: isUser ? AppColors.userColor : AppColors.supportColor,
        borderRadius: isUser
            ? BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(message.imagePath!),
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          if (message.message != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                message.message!,
                style: TextStyle(
                  color: isUser ? AppColors.userTextColor : AppColors.blackColor,
                  fontSize: 14.0,
                ),
              ),
            ),
          const SizedBox(height: 4),
          Text(
            DateUtilsHelper.formatTime(message.date),
            style: TextStyle(
              fontSize: 10,
              color: isUser? AppColors.grayColor: AppColors.blackColor50,
            ),
          ),
        ],
      ),
    );
  }
}
