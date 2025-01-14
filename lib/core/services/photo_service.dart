import 'dart:developer';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tec_bloc/core/services/metadata_service.dart';

final ImagePicker picker = ImagePicker();
XFile? photo1;
XFile? photo2;
bool isShowSecond = false;
bool isShowSubmitBtn = false;

class PhotoService {
  final ImagePicker _picker;

  PhotoService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  /// Take a photo with the camera and return a [File].
  Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      return photo != null ? File(photo.path) : null;
    } catch (e) {
      throw Exception("Failed to take photo: $e");
    }
  }
}




Future<void> takePicture({required bool isFirst}) async {
  final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
      preferredCameraDevice: CameraDevice.rear);
  if (pickedFile != null) {
    File image = File(pickedFile.path);
    bool hasGeo = await checkGeotags(image);
    log("Picture has Geo Tags: $hasGeo");

    if (!hasGeo) {
      Position position = await determinePosition();
      await addGeotagFlutterExif(pickedFile, position);
      await readMetadata(image);
      log(position.toString());
    }
    await readMetadata(image);
    if (isFirst) {
      photo1 = pickedFile;
      isShowSecond = true;
    } else {
      photo2 = pickedFile;
      isShowSubmitBtn = true;
    }
  }
}