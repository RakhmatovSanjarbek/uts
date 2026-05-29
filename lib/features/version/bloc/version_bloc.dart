import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../data/models/version_model/version_model.dart';
import '../../../domain/repositories/version_repository.dart';

part 'version_event.dart';
part 'version_state.dart';

class VersionBloc extends Bloc<VersionEvent, VersionState> {
  final VersionRepository repository;

  VersionBloc(this.repository) : super(const VersionInitial()) {
    on<CheckAppVersionEvent>(_onCheck);
  }

  Future<void> _onCheck(
      CheckAppVersionEvent event,
      Emitter<VersionState> emit,
      ) async {
    emit(const VersionLoading());

    final result = await repository.getAppVersion();

    await result.fold(
          (error) async => emit(VersionError(error)),
          (model) async {
        try {
          final info = await PackageInfo.fromPlatform();
          final currentVersion = info.version;

          if (!emit.isDone) {
            if (_isUpdateRequired(currentVersion, model.version)) {
              emit(VersionUpdateRequired(model));
            } else {
              emit(const VersionUpToDate());
            }
          }
        } catch (e) {
          if (!emit.isDone) {
            emit(VersionError(e.toString()));
          }
        }
      },
    );
  }

  bool _isUpdateRequired(String current, String latest) {
    final c = current.split('.').map(int.parse).toList();
    final l = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < l.length; i++) {
      final cv = i < c.length ? c[i] : 0;
      if (l[i] > cv) return true;
      if (l[i] < cv) return false;
    }
    return false;
  }
}