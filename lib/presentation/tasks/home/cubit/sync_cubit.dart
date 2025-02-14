import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tec_bloc/service/connexion_service.dart';

import '../../../../data/tasks/models/add_new_task.dart';
import '../../../../domain/tasks/usecases/create_task_usecase.dart';
import '../../../../locals/db/db_helper.dart';
import '../../../../service/firebase_service.dart';

part 'sync_state.dart';

class SyncCubit extends Cubit<SyncState> {
  SyncCubit() : super(SyncInitial());

  Future<int> _syncUnsyncedTasks() async {
    final DbHelper dbHelper = DbHelper();
    final unsyncedTasks = await dbHelper.getTasks();
    int syncedCount = 0;
    for (var task in unsyncedTasks) {
      try {
        final imageUrls = await uploadImageToFirebase(task.photos);

        if (imageUrls.length < 2) {
          emit(TaskSyncFailure("Требуется минимум 2 фотографии"));
        }
        final updatedTask = task.copyWith(photos: imageUrls);

        final result = await CreateTaskUsecase().call(
          params: CreateTaskParams(
            workType: updatedTask.workType!,
            dispatcher: updatedTask.dispatcher!,
            address: updatedTask.address!,
            voltage: updatedTask.voltage!,
            job: updatedTask.job!,
            photoUrl1: imageUrls[0],
            photoUrl2: imageUrls[1],
            photoUrl3: imageUrls.length > 2 ? imageUrls[2] : null,
            photoUrl4: imageUrls.length > 3 ? imageUrls[3] : null,
            photoUrl5: imageUrls.length > 4 ? imageUrls[4] : null,
            comment: updatedTask.comment!,
          ),
        );

        result.fold(
          (failure) {
            emit(TaskSyncFailure("Failed to sync task: ${failure.message}"));
          },
          (success) {
            dbHelper.markAsSynced(task.taskId);
            syncedCount++;
          },
        );
      } catch (e) {
        emit(TaskSyncFailure("Error syncing task: $e"));
      }
    }
    return syncedCount;
  }

  Future<void> onSyncLocalTasks() async {
    final bool isOnline = await isConnected();
    if (!isOnline) {
      emit(TaskSyncFailure("Проверте интернет соединение"));
      return;
    }
    emit(SyncLoading());
    try {
      final int syncedCount = await _syncUnsyncedTasks();
      emit(AllTaskSyncSuccess('Успешно синхронизировано $syncedCount задач(и)'));
    } catch (e) {
      emit(TaskSyncFailure("Ошибка синхронизации: $e"));
    }
  }

}
