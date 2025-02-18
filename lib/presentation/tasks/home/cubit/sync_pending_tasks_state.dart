part of 'sync_pending_tasks_cubit.dart';

sealed class SyncPendingTasksState extends Equatable {
  const SyncPendingTasksState();

  @override
  List<Object> get props => [];
}

final class SyncPendingTasksInitial extends SyncPendingTasksState {}


class SyncPendingTaksLoading extends SyncPendingTasksState {}

class SyncPendingTaksSuccess extends SyncPendingTasksState {
  final String? message;
  const SyncPendingTaksSuccess(this.message);
}


class SyncPendingTaskFailure extends SyncPendingTasksState {
  final String? message;
  const SyncPendingTaskFailure(this.message);
}


class SyncAllPendingTaskSuccess extends SyncPendingTasksState {
  final String? message;
  const SyncAllPendingTaskSuccess(this.message);
}