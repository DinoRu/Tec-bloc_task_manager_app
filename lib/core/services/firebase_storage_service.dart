import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService({FirebaseStorage? firebaseStorage})
      : _storage = firebaseStorage ?? FirebaseStorage.instance;

  /// Upload a file to Firebase Storage and return the download URL.
  Future<String> uploadFile(String path, File file) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Failed to upload file: $e");
    }
  }
}


Future<String> uploadImageToStorage(File image, String path) async {
  UploadTask uploadTask = FirebaseStorage.instance.ref(path).putFile(image);
  TaskSnapshot taskSnapshot = await uploadTask;
  String imageUrl = await taskSnapshot.ref.getDownloadURL();
  return imageUrl;
}

String pictureName(String name, int index) {
  return "${name}_${DateTime.now().microsecondsSinceEpoch}_$index.jpg";
}