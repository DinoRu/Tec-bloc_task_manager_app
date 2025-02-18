part of 'task_from_file_cubit.dart';

sealed class TaskFromFileState extends Equatable {
  const TaskFromFileState();

  @override
  List<Object> get props => [];
}


final class TaskFromFileInitial extends TaskFromFileState {}

final class TaskFromFileLoading extends TaskFromFileState {}

class TaskFromFileLoaded extends TaskFromFileState {
  final List<TaskEntity> tasks;
  const TaskFromFileLoaded({required this.tasks});
}

class TaskFromFileFailure extends TaskFromFileState{
  final String? error;

  const TaskFromFileFailure({this.error});
}





