part of 'take_photo_cubit.dart';

sealed class TakePhotoState extends Equatable {
  const TakePhotoState();

  @override
  List<Object> get props => [];
}

final class TakePhotoInitial extends TakePhotoState {}
