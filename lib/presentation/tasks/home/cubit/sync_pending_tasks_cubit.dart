import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tec_bloc/data/tasks/models/update_task_params.dart';
import 'package:tec_bloc/domain/tasks/usecases/update_task_usecase.dart';

import '../../../../locals/db/db_helper.dart';
import '../../../../service/connexion_service.dart';
import '../../../../service/firebase_service.dart';

part 'sync_pending_tasks_state.dart';

class SyncPendingTasksCubit extends Cubit<SyncPendingTasksState> {
  SyncPendingTasksCubit() : super(SyncPendingTasksInitial());

  Future<int> _syncUnsyncedPendingTasks() async {
    final DbHelper dbHelper = DbHelper();
    final unsyncedTasks = await dbHelper.getPendingTasks();
    int syncedCount = 0;
    for (var task in unsyncedTasks) {
      try {
        final imageUrls = await uploadImageToFirebase(task.photos);

        if (imageUrls.length < 2) {
          emit(SyncPendingTaskFailure("Требуется минимум 2 фотографии"));
        }
        final updatedTask = task.copyWith(photos: imageUrls);

        final result = await UpdateTaskUsecase().call(
          params: UpdateTaskData(
            photoUrl1: imageUrls[0],
            photoUrl2: imageUrls[1],
            photoUrl3: imageUrls.length > 2 ? imageUrls[2] : null,
            photoUrl4: imageUrls.length > 3 ? imageUrls[3] : null,
            photoUrl5: imageUrls.length > 4 ? imageUrls[4] : null,
            comment: updatedTask.comment!,
          ),
          taskId: updatedTask.taskId
        );

        result.fold(
          (failure) {
            emit(SyncPendingTaskFailure("Failed to sync task: ${failure.message}"));
          },
          (success) {
            dbHelper.deleteTaskFromFile(task.taskId);
            syncedCount++;
          },
        );
      } catch (e) {
        emit(SyncPendingTaskFailure("Error syncing task: $e"));
      }
    }
    return syncedCount;
  }


   Future<void> onSyncLocalTasks() async {
    final bool isOnline = await isConnected();
    if (!isOnline) {
      emit(SyncPendingTaskFailure("Проверте интернет соединение"));
      return;
    }
    emit(SyncPendingTaksLoading());
    try {
      final int syncedCount = await _syncUnsyncedPendingTasks();
      emit(SyncAllPendingTaskSuccess('Успешно синхронизировано $syncedCount задач(и)'));
    } catch (e) {
      emit(SyncPendingTaskFailure("Ошибка синхронизации: $e"));
    }
  }

}
