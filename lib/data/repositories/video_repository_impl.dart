import 'package:uts_cargo/data/datasource/video_remote_data_source.dart';
import 'package:uts_cargo/data/models/video_model/video_model.dart';
import 'package:uts_cargo/domain/repositories/video_repository.dart';

class VideoRepositoryImpl extends VideoRepository {
  final VideoRemoteDataSource remote;

  VideoRepositoryImpl(this.remote);

  @override
  Future<List<VideoModel>> getVideo() async {
    return await remote.getVideo();
  }
}
