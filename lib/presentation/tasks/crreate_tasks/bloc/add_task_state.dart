part of 'add_task_cubit.dart';

sealed class AddTaskState extends Equatable {
  const AddTaskState();

  @override
  List<Object> get props => [];
}

final class AddTaskInitial extends AddTaskState {}

class AddTaskLoading extends AddTaskState {}

class AddTaskSuccess extends AddTaskState {}

class AddTaskFailure extends AddTaskState {
  final String message;
  const AddTaskFailure(this.message);
}

