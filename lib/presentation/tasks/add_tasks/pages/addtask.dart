import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:exif/exif.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
import 'package:flutter_exif_plugin/tags.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tec_bloc/common/widgets/build_text.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/app_text.dart';
import 'package:tec_bloc/core/constants/font_sizes.dart';
import 'package:tec_bloc/core/permission_handler/gps_permission.dart';
import 'package:tec_bloc/data/tasks/models/add_new_task.dart';
import 'package:tec_bloc/presentation/tasks/add_tasks/bloc/add_task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/add_tasks/widgets/my_textfield.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/helper/navigator/app_navigator.dart';
import '../../../../common/widgets/show_snackbar.dart';
import '../../home/pages/home.dart';
import '../../task_detail/widgets/comment_textfield.dart';

final Uuid uuid = Uuid();
String uniqueId = uuid.v4();

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final dispatcherController = TextEditingController();
  final workTypeController = TextEditingController();
  final plannedDateController = TextEditingController();
  final addressController = TextEditingController();
  final voltageController = TextEditingController();
  final commentController = TextEditingController();

  bool isShowSecond = false;
  bool isSubmiting = false;
  bool isLoading = false;

  late String photoUrl1;
  late String photoUrl2;

  final ImagePicker picker = ImagePicker();
  XFile? photo1;
  XFile? photo2;

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
      setState(() {
        metaData = data;
      });

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
      setState(() async {
        if (isFirst) {
          photo1 = pickedFile;
          isShowSecond = true;
        } else {
          photo2 = pickedFile;
          isSubmiting = true;
        }
      });
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

  Future<void> createTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        if (photo1 != null) {
          final String photoName1 = pictureName(uniqueId, 0);
          photoUrl1 = await uploadImageToStorage(
            File(photo1!.path),
            "todo_picture/$uniqueId/$photoName1",
          );
        }

        if (photo2 != null) {
          final String photoName2 = pictureName(uniqueId, 1);
          photoUrl2 = await uploadImageToStorage(
            File(photo2!.path),
            "todo_picture/$uniqueId/$photoName2",
          );
        }

        // Après téléchargement, soumission de la tâche
        if (photoUrl1.isNotEmpty) {
            await context.read<AddTaskCubit>().addTask(
              AddNewTaskParams(
                taskId: uniqueId,
                code: codeController.text,
                dispatcher: dispatcherController.text,
                location: addressController.text,
                plannedDate: plannedDateController.text,
                voltage: double.parse(voltageController.text),
                workType: workTypeController.text,
                photoUrl1: photoUrl1,
                photoUrl2: photoUrl2,
                comment: commentController.text,
            ),
          );
        } else {
          log("error photo don't uploaded to firebase!");
        }
      } catch (e) {
        log("Erreur pendant l'upload: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      log('Please enter correct value');
    }
  }

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: buildText("Добавить задач", AppColors.primary, textXExtraLarge,
              FontWeight.w900, TextAlign.center, TextOverflow.clip),
        ),
        body: BlocListener<AddTaskCubit, AddTaskState>(
          listener: (context, state) {
            if (state is AddTaskSuccess ) {
              showSnackBar(
                context, 
                "Задание выполнено успешно!"
              );
              AppNavigator.pushReplacement(context, const Home());
              // Navigator.pop(context);
            } else if (state is AddTaskFailure) {
              showSnackBar(
                context,
                "Задание не успешно выполнено!"
              );
              }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextField(
                      controller: codeController,
                      hintText: AppText.code,
                      keyboardType: TextInputType.text,
                      text: AppText.code,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppText.error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    MyTextField(
                      controller: dispatcherController,
                      hintText: AppText.dispatcher,
                      keyboardType: TextInputType.text,
                      text: AppText.dispatcher,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppText.error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    MyTextField(
                      controller: addressController,
                      hintText: AppText.address,
                      keyboardType: TextInputType.text,
                      text: AppText.address,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppText.error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    MyTextField(
                      controller: plannedDateController,
                      hintText: AppText.plannedDate,
                      keyboardType: TextInputType.text,
                      text: AppText.plannedDate,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppText.error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    MyTextField(
                      controller: voltageController,
                      hintText: AppText.voltage,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      text: AppText.voltage,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Пожалуйста, заполните это поле";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    MyTextField(
                      controller: workTypeController,
                      hintText: AppText.workType,
                      keyboardType: TextInputType.text,
                      text: AppText.workType,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppText.error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    buildText("Комментарий", AppColors.kPrimaryColor, textSmall,
                        FontWeight.bold, TextAlign.start, TextOverflow.clip),
                    const SizedBox(height: 5),
                    CommentField(controller: commentController),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (photo1 != null)
                          Expanded(
                            child: SizedBox(
                                height: 200,
                                child: Image.file(File(photo1!.path),
                                    fit: BoxFit.cover)),
                          ),
                        const SizedBox(width: 5),
                        if (photo2 != null)
                          Expanded(
                            child: SizedBox(
                                height: 200,
                                child: Image.file(File(photo2!.path),
                                    fit: BoxFit.cover)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () async {
                            await takePicture(isFirst: true);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            // backgroundColor: AppColors.kRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, color: AppColors.kWhiteColor),
                              SizedBox(width: 10),
                              Text(
                                "Фото 1",
                                style: TextStyle(color: AppColors.kWhiteColor),
                              )
                            ],
                          )),
                    ),
                    const SizedBox(height: 10),
                    if (isShowSecond)
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                            onPressed: () async {
                              await takePicture(isFirst: false);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              // backgroundColor: AppColors.kRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    color: AppColors.kWhiteColor),
                                SizedBox(width: 10),
                                Text(
                                  "Фото 2",
                                  style: TextStyle(color: AppColors.kWhiteColor),
                                )
                              ],
                            )),
                      ),
                    const SizedBox(height: 10),
                    if (isSubmiting)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: isLoading ? null : createTask,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: isLoading
                                  ? Colors.green.shade900
                                  : AppColors.kRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: AppColors.kPrimaryColor,
                                  )
                                : Center(
                                    child: buildText(
                                        "Выполнить",
                                        AppColors.kWhiteColor,
                                        textMedium,
                                        FontWeight.normal,
                                        TextAlign.center,
                                        TextOverflow.ellipsis),
                                  )),
                      ),
                      const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
            ),
      ));
  }
}
