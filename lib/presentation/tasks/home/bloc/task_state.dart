part of 'task_cubit.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskInitialState extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  const TaskLoaded({required this.tasks});
}

class LoadTasksFailure extends TaskState{}


class PendingTasksLoading extends TaskState {}

class PendingTasksLoaded extends TaskState {
  final List<TaskEntity> tasks;
  const PendingTasksLoaded(this.tasks);
}

class PendingTasksFailure extends TaskState {
  final String? error;
  const PendingTasksFailure(this.error);
}
