import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
import 'package:flutter_exif_plugin/tags.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

late FlutterExif exif;
late Map<String, IfdTag>? metaData;


Future<bool> checkGeotags(File imageFile) async {
  final bytes = await imageFile.readAsBytes();
  final data = await readExifFromBytes(bytes);
  if (data.isNotEmpty) {
    return data.containsKey('GPS GPSLatitude') &&
        data.containsKey('GPS GPSLongitude');
  }
  return false;
}

Future<void> readMetadata(File imageFile) async {
  final bytes = await imageFile.readAsBytes();
  final data = await readExifFromBytes(bytes);
  if (data.isEmpty) {
    debugPrint("No EXIF information found");
  } else {
    metaData = data;
    log(data.toString());
    // Example: Print GPS Latitude and Longitude
    if (data.containsKey('GPS GPSLatitude') &&
        data.containsKey('GPS GPSLongitude')) {
      debugPrint('Latitude: ${data['GPS GPSLatitude']}');
      debugPrint('Longitude: ${data['GPS GPSLongitude']}');
    }
  }
}

Future<Position> determinePosition() async {
  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return position;
}

List<int> convertToExifFormat(double value) {
  final degrees = value.abs().floor();
  final minutes = ((value.abs() - degrees) * 60).floor();
  final seconds = (((value.abs() - degrees) * 60 - minutes) * 60).round();
  return [degrees, minutes, seconds];
}

Future<void> addGeotagFlutterExif(XFile image, Position position) async {
  List<int> latitude = convertToExifFormat(position.latitude);
  List<int> longitude = convertToExifFormat(position.longitude);
  try {
    exif = FlutterExif.fromPath(image.path);
    exif.setLatLong(position.latitude, position.longitude);
    exif.setAttribute(
        TAG_USER_COMMENT,
        jsonEncode({
          'GPS GPSLatitude': '${latitude[0]}, ${latitude[1]}, ${latitude[2]}',
          'GPS GPSLongitude':
              '${longitude[0]}, ${longitude[1]}, ${longitude[2]}',
          'GPS GPSLatitudeRef': position.latitude >= 0 ? 'N' : 'S',
          'GPS GPSLongitudeRef': position.longitude >= 0 ? 'E' : 'W',
        }));
    exif.saveAttributes();
  } catch (e) {
    log("Error writing EXIFS tags: ${e.toString()}");
    log(e.toString());
  }
}
