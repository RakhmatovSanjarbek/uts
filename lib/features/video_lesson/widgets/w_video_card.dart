import 'package:flutter/material.dart';
import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/video_lesson/widgets/video_player_screen.dart';

import '../../../core/utils/video_utils.dart';
import '../../../data/models/video_model/video_model.dart';

class WVideoCard extends StatelessWidget {
  final VideoModel video;
  final String? videoTitle;

  const WVideoCard({
    super.key,
    required this.video,
    this.videoTitle,
  });

  @override
  Widget build(BuildContext context) {
    final videoId = VideoUtils.extractVideoId(video.videoUrl);

    if (videoId == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _openVideoPlayer(context, videoId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(videoId),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Channel icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.mainColor,
                          AppColors.mainColor.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'YT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title and date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          videoTitle ?? 'YouTube Video',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              VideoUtils.formatDate(video.createdAt),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String videoId) {
    return Stack(
      children: [
        // Thumbnail image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          child: Image.network(
            VideoUtils.getThumbnailUrl(videoId),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey[500],
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                ),
              );
            },
          ),
        ),

        // Play button overlay
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openVideoPlayer(BuildContext context, String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => VideoPlayerScreen(
          videoId: videoId,
          videoTitle: videoTitle ?? 'YouTube Video',
        ),
      ),
    );
  }
}