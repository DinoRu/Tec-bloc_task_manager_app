part of 'sync_cubit.dart';

sealed class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object> get props => [];
}

final class SyncInitial extends SyncState {}

class SyncLoading extends SyncState {}

class TaskSyncSuccess extends SyncState {
  final String message;
  const TaskSyncSuccess(this.message);
}

class TaskSyncFailure extends SyncState {
  final String message;
  const TaskSyncFailure(this.message);
}

class AllTaskSyncSuccess extends SyncState {
  final String message;
  const AllTaskSyncSuccess(this.message);
}