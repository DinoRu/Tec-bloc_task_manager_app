import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/common/widgets/build_text.dart';
import 'package:tec_bloc/common/widgets/show_snackbar.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/app_text.dart';
import 'package:tec_bloc/core/constants/font_sizes.dart';
import 'package:tec_bloc/data/tasks/models/update_task_params.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/locals/db/db_helper.dart';
import 'package:tec_bloc/locals/db/save_image_local.dart';
import 'package:tec_bloc/presentation/tasks/blocs/task_from_file_cubit/task_from_file_cubit.dart';
import 'package:tec_bloc/presentation/tasks/crreate_tasks/cubit/take_photo_cubit.dart';
import 'package:tec_bloc/presentation/tasks/task_detail/widgets/comment_textfield.dart';


class TaskDetailPage extends StatefulWidget {
  final TaskEntity task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final DbHelper dbHelper = DbHelper();

  bool isUploading = false;

  final TextEditingController commentController = TextEditingController();

  Future<void> updateTask(List<File> images) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isUploading = true;
      });
    }
    try {
      List<String> imagePaths = [];
      for(var image in images){
        final localPath = await saveImageLocally(image);
        imagePaths.add(localPath);
      }
      UpdateTaskParams params = UpdateTaskParams(
        photos: imagePaths,
        comment: commentController.text
      );
      final result = await dbHelper.updateFileTasks(widget.task.taskId, params);
      if (result > 0) {
        showSnackBar(context, 'Task updated successfully!. ${widget.task.taskId}');
        context.read<TaskFromFileCubit>().getFileTasks();
        Navigator.pop(context);
      } else {
        showSnackBar(context, "Error to update task: ${widget.task.taskId}");
      }
     
    } on Exception catch (e) {
      log("Error to upload: $e");
      showSnackBar(context, "Ощибка при загрузке $e");
      throw ("Exception error: $e");
    } finally {
      setState(() => isUploading = false);
      context.read<TakePhotoCubit>().reset();
    }
  }
  

  @override
  void initState() {
    super.initState();
    context.read<TakePhotoCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.kPrimaryColor,
            foregroundColor: AppColors.kWhiteColor,
            title: Text("${widget.task.taskId}"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                      widget.task.workType!, 
                      AppColors.kPrimaryColor, 
                      textMedium, 
                      FontWeight.bold, 
                      TextAlign.start, 
                      TextOverflow.clip
                    ),
                    const SizedBox(height: 5),
                    buildText(
                        widget.task.job ?? "N/A",
                        AppColors.kBlackColor,
                        textMedium,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 15),
                    buildText(
                        "Диспетчерское наименование ОЭСХ",
                        AppColors.kPrimaryColor,
                        textMedium,
                        FontWeight.bold,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 5),
                    buildText(
                        widget.task.dispatcher ?? "N/A",
                        AppColors.kBlackColor,
                        textMedium,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 15),
                    buildText(
                        "Адрес объекта",
                        AppColors.kPrimaryColor,
                        textMedium,
                        FontWeight.bold,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 5),
                    buildText(
                        widget.task.address ?? "N/A",
                        AppColors.kBlackColor,
                        textMedium,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 15),
                    buildText(
                        "Дата работ по плану",
                        AppColors.kPrimaryColor,
                        textMedium,
                        FontWeight.bold,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 5),
                    buildText(
                        widget.task.plannerDate ?? "N/A",
                        AppColors.kBlackColor,
                        textMedium,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 15),
                    buildText(
                        "Класс напряжения, кВ",
                        AppColors.kPrimaryColor,
                        textMedium,
                        FontWeight.bold,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 5),
                    buildText(
                        "${widget.task.voltage ?? 0.0}",
                        AppColors.kBlackColor,
                        textMedium,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 15),
                    buildText(
                        "Вид работ",
                        AppColors.kPrimaryColor,
                        textMedium,
                        FontWeight.bold,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 5),
                    buildText(
                        widget.task.workType ?? "N/A",
                        AppColors.kBlackColor,
                        textMedium,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 15),
                    buildText(
                        "Комментарий",
                        AppColors.kPrimaryColor,
                        textMedium,
                        FontWeight.bold,
                        TextAlign.start,
                        TextOverflow.clip),
                    const SizedBox(height: 5),
                    CommentField(controller: commentController),
                    const SizedBox(height: 15),
                    buildText(
                      "${AppText.image} (минимум 2 требуется)",
                      AppColors.kPrimaryColor, 
                      textMedium, 
                      FontWeight.bold, 
                      TextAlign.start, 
                      TextOverflow.clip
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<TakePhotoCubit, List<File>>(
                      builder: (context, photos) {
                        final totalPhotos = (widget.task.photos.length) + photos.length;
                        return Column(
                          children: [
                           if (widget.task.photos.isNotEmpty) ...[
                               Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: widget.task.photos.map((photo) => Image.file(File(photo), width: 180, height: 150, fit: BoxFit.cover)).toList(),
                              ),
                           ],
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
                            const SizedBox(height: 5),
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
                      }
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<TakePhotoCubit, List<File>>(
                      builder: (context, photos) {
                        bool isButtonEnabled = photos.length>=2 && photos.length <=5 && !isUploading;
                        return ElevatedButton(
                          onPressed: isButtonEnabled
                            ? () => updateTask(photos)
                            : null, 
                          child: isUploading
                              ? const CircularProgressIndicator(color: AppColors.kPrimaryColor)
                              : Center(
                                child: Text(
                                  "Выполнить",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              )
                        );
                      },
                    ),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
