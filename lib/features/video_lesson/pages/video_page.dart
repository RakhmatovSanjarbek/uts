import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uts_cargo/core/theme/app_colors.dart';
import 'package:uts_cargo/features/video_lesson/bloc/video_bloc.dart';
import 'package:uts_cargo/features/video_lesson/widgets/w_video_card.dart';
import 'package:uts_cargo/features/video_lesson/widgets/w_video_empty.dart';
import 'package:uts_cargo/features/video_lesson/widgets/w_video_loading.dart';

import '../../../core/utils/video_utils.dart';
import '../../../data/models/video_model/video_model.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<VideoModel> videos = [];
  final Map<int, String> _videoTitles = {};

  @override
  void initState() {
    super.initState();
    context.read<VideoBloc>().add(GetVideoEvent());
  }
  Future<String?> _fetchVideoTitle(String videoUrl) async {
    try {
      final videoId = VideoUtils.extractVideoId(videoUrl);
      if (videoId == null) return null;

      final response = await http.get(
        Uri.parse('https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=$videoId&format=json'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['title'] ?? 'YouTube Video';
      }
    } catch (e) {
      print('Title olishda xatolik: $e');
    }
    return null;
  }
  Future<void> _loadVideoTitles() async {
    for (var video in videos) {
      if (!_videoTitles.containsKey(video.id)) {
        final title = await _fetchVideoTitle(video.videoUrl);
        if (mounted) {
          setState(() {
            _videoTitles[video.id] = title ?? 'YouTube Video';
          });
        }
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      appBar: AppBar(
        title: const Text(
          'Video Darslar',
          style: TextStyle(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.screenColor,
        elevation: 0,
      ),
      body: BlocConsumer<VideoBloc, VideoState>(
        listener: (context, state) {
          if (state is VideoSuccess) {
            setState(() {
              videos = state.model.toList();
            });
            _loadVideoTitles();
          }
        },
        builder: (context, state) {
          if (state is VideoLoading) {
            return const WVideoLoading();
          }

          if (videos.isEmpty) {
            return const WVideoEmpty();
          }

          return RefreshIndicator(
            onRefresh: _refreshVideos,
            color: AppColors.mainColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                final title = _videoTitles[video.id];

                return WVideoCard(
                  video: video,
                  videoTitle: title,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshVideos() async {
    _videoTitles.clear();
    context.read<VideoBloc>().add(GetVideoEvent());
  }
}