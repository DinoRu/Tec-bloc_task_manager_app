part of 'complete_tasks_cubit.dart';

sealed class CompleteTasksState extends Equatable {
  const CompleteTasksState();

  @override
  List<Object> get props => [];
}

final class CompleteTasksInitial extends CompleteTasksState {}

class CompleteTasksLoading extends CompleteTasksState {}


class CompleteTaskLoaded extends CompleteTasksState {
  final List<TaskEntity> tasks;
  const CompleteTaskLoaded({required this.tasks});
}

class CompleteTasksFailure extends CompleteTasksState {
  final String error;
  const CompleteTasksFailure(this.error);
}