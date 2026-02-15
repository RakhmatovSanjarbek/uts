class VideoModel {
  final int id;
  final String videoUrl;
  final DateTime createdAt;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      videoUrl: json['video_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
