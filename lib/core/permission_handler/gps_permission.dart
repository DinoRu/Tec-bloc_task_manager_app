import 'package:permission_handler/permission_handler.dart';

Future<void> checkLocationPermission() async {
  var status = await Permission.location.status;
  if (status.isDenied) {
    status = await Permission.location.request();
  }
}