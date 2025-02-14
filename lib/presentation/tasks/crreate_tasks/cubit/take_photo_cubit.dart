import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'take_photo_state.dart';

class TakePhotoCubit extends Cubit<List<File>> {
  TakePhotoCubit() : super([]);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    if (state.length >=5) return;
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (pickedFile != null) {
      emit([...state, File(pickedFile.path)]);
    }
  }

  void removeImage(int index) {
    final updatedPhotos = List<File>.from(state)..removeAt(index);
    emit(updatedPhotos);
  }

  void reset() {
    emit([]);
  }
}
