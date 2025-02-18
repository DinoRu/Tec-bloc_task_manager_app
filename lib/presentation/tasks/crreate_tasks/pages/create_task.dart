import 'dart:io';
import 'dart:math';
import 'dart:developer' as dv;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/common/widgets/build_text.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/app_text.dart';
import 'package:tec_bloc/core/constants/font_sizes.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/locals/db/db_helper.dart';
import 'package:tec_bloc/locals/db/save_image_local.dart';
import 'package:tec_bloc/presentation/tasks/crreate_tasks/bloc/add_task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/crreate_tasks/widgets/input_field.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/task_detail/bloc/update_cubit.dart';
import 'package:tec_bloc/service/api_service.dart';

import '../../../../common/helper/navigator/app_navigator.dart';
import '../../../../common/widgets/show_snackbar.dart';
import '../../home/pages/home.dart';
import '../cubit/take_photo_cubit.dart';

class CreateTask extends StatefulWidget {
  final TaskEntity? task;
  const CreateTask({super.key, this.task});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final DbHelper dbHelper = DbHelper();
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final dispatcherController = TextEditingController();
  final addressController = TextEditingController();
  final jobTypeController = TextEditingController();
  final commentController = TextEditingController();
  bool _isUploading = false;

  String _workType = "ТО";
  List<String> _workTypes = [];

  double _voltage = 0.23;
  List<double> _voltages = [];

  final random = Random();

  int generateRandomTaskId() {
    return random.nextInt(100000); // Génère un nombre entier aléatoire entre 0 et 99999
  }

  @override
  void initState() {
    super.initState();
    context.read<TakePhotoCubit>().reset();
    _loadWorkType();
    _loadVoltage();
    _initializeData();
  }

  void _initializeData() {
    if (widget.task != null) {
      dispatcherController.text = widget.task!.dispatcher!;
      addressController.text = widget.task!.address!;
      jobTypeController.text = widget.task!.job!;
      commentController.text = widget.task!.comment!;
    }
  }

  Future<void> _loadWorkType() async {
    final workTypes = await _apiService.getWorkType();
    setState(() {
      _workTypes = workTypes;
    });
  }

  Future<void> _loadVoltage() async {
    final voltages = await _apiService.getVoltage();
    setState(() {
      _voltages = voltages;
    });
  }

  Future<void> createOrUpdateTask(List<File> images) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      try {
        List<String> imagePaths = [];
        for(var image in images){
          final localPath = await saveImageLocally(image);
          imagePaths.add(localPath);
        }
        TaskEntity task = TaskEntity(
          taskId: generateRandomTaskId(),
          workType: _workType,
          dispatcher: dispatcherController.text,
          address: addressController.text,
          voltage: _voltage,
          job: jobTypeController.text,
          photos: imagePaths,
          isCompleted: false,
          comment: commentController.text,
        );
        await context.read<AddTaskCubit>().createLocalTask(task);
      } on Exception catch (e) {
        dv.log("Erreur pendant l'upload: $e");
        showSnackBar(context, "Ощибка при загрузке $e");
        throw ("Exception error: $e");
      } finally {
        setState(() => _isUploading = false);
        context.read<TakePhotoCubit>().reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kPrimaryColor,
          foregroundColor: AppColors.kWhiteColor,
          centerTitle: true,
          title: Text("Добавить задач"),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AddTaskCubit, AddTaskState>(
              listener: (context, state) {
                if (state is AddTaskSuccess) {
                  showSnackBar(context, "Задание выполнено успешно!");
                  Navigator.pop(context);
                  context.read<TaskCubit>().displayTask();
                } else if (state is AddTaskFailure) {
                  showSnackBar(context, "Задание не успешно выполнено!");
                }
              },
            ),
            BlocListener<UpdateCubit, UpdateState>(
              listener: (context, state) {
                if (state is UpdateTaskLoaded) {
                  showSnackBar(context,  "Задание выполнено успешно!");
                  AppNavigator.pushReplacement(context, const Home());
                } else if (state is UpdateTaskFailure) {
                  showSnackBar(context, "Задание не успешно выполнено!");
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.workType,
                      style: titleStyle,
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField2(
                      value: _workType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _workType = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey))),
                      items: _workTypes.map((String value) {
                        return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: subTitleStyle,
                            ));
                      }).toList(),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    MyInputField(
                      title: AppText.dispatcher,
                      hint: AppText.dispatcher,
                      controller: dispatcherController,
                    ),
                    const SizedBox(height: 8),
                    MyInputField(
                      title: AppText.address,
                      hint: AppText.address,
                      controller: addressController,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppText.voltage,
                      style: titleStyle,
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField2<String>(
                      value: "$_voltage",
                      onChanged: (String? newValue) {
                        setState(() {
                          _voltage = double.parse(newValue!);
                        });
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey))),
                      items: _voltages.map((double value) {
                        return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(
                              "$value",
                              style: subTitleStyle,
                            ));
                      }).toList(),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    MyInputField(
                      title: AppText.jobType,
                      hint: AppText.jobType,
                      controller: jobTypeController,
                    ),
                    const SizedBox(height: 8),
                    MyInputField(
                      title: AppText.comment,
                      hint: AppText.comment,
                      controller: commentController,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${AppText.image} (минимум 2 требуется)",
                      style: subTitleStyle,
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<TakePhotoCubit, List<File>>(
                      builder: (context, photos) {
                         final totalPhotos = (widget.task?.photos.length ?? 0) + photos.length;
                        return Column(
                          children: [
                            if (widget.task != null)
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: widget.task!.photos.map((photo) {
                                  widget.task!.photos.indexOf(photo);
                                  return Stack(
                                    children: [
                                      Image.file(File(photo),
                                          width: 180, height: 150, fit: BoxFit.cover),
                                    ],
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: photos.map((photo) {
                                int index = photos.indexOf(photo);
                                return Stack(
                                  children: [
                                    Image.file(photo,
                                        width: 180,
                                        height: 150,
                                        fit: BoxFit.cover),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () => context
                                            .read<TakePhotoCubit>()
                                            .removeImage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                          child: const Icon(Icons.close,
                                              color: Colors.white, size: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            if (totalPhotos < 5)
                              GestureDetector(
                                onTap: () =>
                                    context.read<TakePhotoCubit>().pickImage(),
                                child: Container(
                                  width: 200,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Добавить фото",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    if (widget.task != null) ...[
                      const SizedBox.shrink(),
                    ] else ...[
                      BlocBuilder<TakePhotoCubit, List<File>>(
                        builder: (context, photos) {
                          bool isButtonEnabled = photos.length >= 2 && photos.length <=5  && !_isUploading;
                          return ElevatedButton(
                            onPressed: isButtonEnabled
                                ? () => createOrUpdateTask(photos)
                                : null,
                            child: _isUploading
                                ? const CircularProgressIndicator(
                                    color: AppColors.kPrimaryColor)
                                : Center(
                                    child: Text(
                                      "Выполнить",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                      ),
                                  )),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 100)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
