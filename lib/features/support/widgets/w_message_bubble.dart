import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/chat_model/chat_model.dart';

class WMessageBubble extends StatelessWidget {
  final ChatModel message;
  final bool isUser;

  const WMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

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
          bottomLeft: Radius.circular(isUser ? 16 : 0),
          bottomRight: Radius.circular(isUser ? 0 : 16),
        ),
      ),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (message.image != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImage(context, message.image!),
              ),
            ),
          if (message.message != null && message.message!.isNotEmpty)
            Text(
              message.message!,
              style: TextStyle(
                color: isUser ? AppColors.whiteColor : AppColors.blackColor,
                fontSize: 14.5,
              ),
            ),
          const SizedBox(height: 2),
          Text(
            DateUtilsHelper.formatTime(message.timestampMs),
            style: TextStyle(
              fontSize: 10,
              color: isUser ? AppColors.grayColor : AppColors.blackColor50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, String imagePath) {
    final bool isNetwork =
        imagePath.startsWith('http') || imagePath.startsWith('/media');
    final String fullPath = isNetwork && !imagePath.startsWith('http')
        ? "${Constants.baseUrl}$imagePath"
        : imagePath;

    return GestureDetector(
      onTap: () => _showFullScreenImage(context, fullPath, isNetwork),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: isNetwork
            ? Image.network(
                fullPath,
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
              )
            : Image.file(
                File(imagePath),
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  void _showFullScreenImage(
    BuildContext context,
    String imageUrl,
    bool isNetwork,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: InteractiveViewer(
          maxScale: 5.0,
          child: Center(
            child: isNetwork
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CircularProgressIndicator(
                        color: AppColors.mainColor,
                      );
                    },
                  )
                : Image.file(File(imageUrl), fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
