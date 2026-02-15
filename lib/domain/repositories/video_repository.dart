import 'package:uts_cargo/data/models/video_model/video_model.dart';

abstract class VideoRepository {
  Future<List<VideoModel>> getVideo();
}
