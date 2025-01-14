part of 'update_cubit.dart';

sealed class UpdateState extends Equatable {
  const UpdateState();

  @override
  List<Object> get props => [];
}

final class UpdateInitial extends UpdateState {}

class UpdateTaskLoading extends UpdateState {}

class UpdateTaskLoaded extends UpdateState {}

class UpdateTaskFailure extends UpdateState {
  final String message;
  const UpdateTaskFailure(this.message);
}
