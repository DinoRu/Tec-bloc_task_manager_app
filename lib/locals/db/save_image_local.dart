import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> saveImageLocally(File image) async {
  final directory = await getApplicationDocumentsDirectory();
  final fileName = "task_${DateTime.now().microsecondsSinceEpoch}.jpg";
  final localPath = '${directory.path}/$fileName';
  final savedImage = await image.copy(localPath);
  return savedImage.path;
}