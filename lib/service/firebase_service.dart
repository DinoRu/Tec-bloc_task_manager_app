import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<List<String>> uploadImageToFirebase(List<String> images) async {
    List<String> downloadUrls = [];
    final storagesRef = FirebaseStorage.instance.ref();

    for (var image in images) {
      final file = File(image);
      String fileName = "tasks/${DateTime.now().microsecondsSinceEpoch}.jpg";
      Reference ref = storagesRef.child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  }