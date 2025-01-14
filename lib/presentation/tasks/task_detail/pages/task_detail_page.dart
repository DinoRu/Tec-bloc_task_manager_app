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
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/common/widgets/build_text.dart';
import 'package:tec_bloc/common/widgets/show_snackbar.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/font_sizes.dart';
import 'package:tec_bloc/data/tasks/models/update_task_params.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/home.dart';
import 'package:tec_bloc/presentation/tasks/task_detail/bloc/update_cubit.dart';
import 'package:tec_bloc/presentation/tasks/task_detail/widgets/comment_textfield.dart';

import '../../../../core/permission_handler/gps_permission.dart';
import '../../../../core/services/metadata_service.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskEntity task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? photo1;
  XFile? photo2;
  bool submitted = false;
  bool isShowSecond = false;
  bool isShowSubmitBtn = false;
  late String photoUrl1;
  late String photoUrl2;
  bool isUploading = false;

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
          isShowSubmitBtn = true;
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

  Future<void> updateTask() async {
    setState(() {
      isUploading = true;
    });

    try {
      if (photo1 != null) {
        final String photoName1 = pictureName(widget.task.taskId, 0);
        photoUrl1 = await uploadImageToStorage(
          File(photo1!.path),
          "todo_picture/${widget.task.taskId}/$photoName1",
        );
      }

      if (photo2 != null) {
        final String photoName2 = pictureName(widget.task.taskId, 1);
        photoUrl2 = await uploadImageToStorage(
          File(photo2!.path),
          "todo_picture/${widget.task.taskId}/$photoName2",
        );
      }

      // Après téléchargement, soumission de la tâche
      await context.read<UpdateCubit>().updateTask(
            widget.task.taskId,
            UpdateTaskParams(
              photoUrl1: photoUrl1,
              photoUrl2: photoUrl2,
              comment: commentController.text,
            ),
          );
    } catch (e) {
      log("Erreur pendant l'upload: $e");
    } finally {
      setState(() {
        isUploading = false;
      });
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
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.kPrimaryColor),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.kWhiteColor,
                    ),
                  ),
                ),
              ),
            ),
            body: BlocListener<UpdateCubit, UpdateState>(
              listener: (context, state) {
                if (state is UpdateTaskLoaded ) {
                  showSnackBar(
                    context, 
                    "Задание выполнено успешно!"
                  );
                  AppNavigator.pushReplacement(context, const Home());
                  // Navigator.pop(context);
                } else if (state is UpdateTaskFailure) {
                  showSnackBar(
                    context,
                    "Задание не успешно выполнено!"
                  );
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: double.maxFinite,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.kPrimaryColor.withOpacity(.5)),
                        borderRadius: BorderRadius.circular(10)),
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          30, // Ajustez ce padding si nécessaire
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText(
                              "Код",
                              AppColors.kPrimaryColor,
                              textSmall,
                              FontWeight.bold,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 5),
                          buildText(
                              widget.task.code ?? "N/A",
                              AppColors.kBlackColor,
                              textMedium,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 15),
                          buildText(
                              "Диспетчерское наименование ОЭСХ",
                              AppColors.kPrimaryColor,
                              textSmall,
                              FontWeight.bold,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 5),
                          buildText(
                              widget.task.dispatcher ?? "N/A",
                              AppColors.kBlackColor,
                              textSmall,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 15),
                          buildText(
                              "Адрес объекта",
                              AppColors.kPrimaryColor,
                              textSmall,
                              FontWeight.bold,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 5),
                          buildText(
                              widget.task.location ?? "N/A",
                              AppColors.kBlackColor,
                              textSmall,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 15),
                          buildText(
                              "Дата работ по плану",
                              AppColors.kPrimaryColor,
                              textSmall,
                              FontWeight.bold,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 5),
                          buildText(
                              widget.task.plannedDate ?? "N/A",
                              AppColors.kBlackColor,
                              textSmall,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 15),
                          buildText(
                              "Класс напряжения, кВ",
                              AppColors.kPrimaryColor,
                              textSmall,
                              FontWeight.bold,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 5),
                          buildText(
                              "${widget.task.voltage ?? 0.0}",
                              AppColors.kBlackColor,
                              textSmall,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 15),
                          buildText(
                              "Вид работ",
                              AppColors.kPrimaryColor,
                              textSmall,
                              FontWeight.bold,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 5),
                          buildText(
                              widget.task.workType ?? "N/A",
                              AppColors.kBlackColor,
                              textSmall,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 15),
                          buildText(
                              "Комментарий",
                              AppColors.kPrimaryColor,
                              textSmall,
                              FontWeight.bold,
                              TextAlign.start,
                              TextOverflow.clip),
                          const SizedBox(height: 5),
                          CommentField(controller: commentController),
                          const SizedBox(height: 15),
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
                          ElevatedButton(
                              onPressed: () async {
                                await takePicture(isFirst: true);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt,
                                      color: AppColors.kWhiteColor),
                                  SizedBox(width: 10),
                                  Text(
                                    "Фото 1",
                                    style:
                                        TextStyle(color: AppColors.kWhiteColor),
                                  )
                                ],
                              )),
                          const SizedBox(height: 15),
                          if (isShowSecond)
                            ElevatedButton(
                                onPressed: () async {
                                  await takePicture(isFirst: false);
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt,
                                        color: AppColors.kWhiteColor),
                                    SizedBox(width: 10),
                                    Text(
                                      "Фото 2",
                                      style:
                                          TextStyle(color: AppColors.kWhiteColor),
                                    )
                                  ],
                                )),
                          const SizedBox(height: 15),
                          if (isShowSubmitBtn)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: isUploading ? null : updateTask,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: isUploading ? Colors.green.shade900 : AppColors.kRed,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: isUploading
                                      ?  CircularProgressIndicator(
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
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
