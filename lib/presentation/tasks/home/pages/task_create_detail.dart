import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/presentation/tasks/home/widgets/item_widget.dart';

import '../../../../core/constants/app_text.dart';

class TaskCreateDetail extends StatelessWidget {
  final TaskEntity task;
  const TaskCreateDetail({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: detailAppBar(task),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemWidget(
              title: AppText.workType,
              value: task.workType,
            ),
            ItemWidget(title:  AppText.dispatcher, value: task.dispatcher),
            ItemWidget(title: AppText.address, value: task.address),
            ItemWidget(title: AppText.voltage, value: task.voltage),
            ItemWidget(title: AppText.jobType, value: task.job),
            ItemWidget(title:  AppText.comment, value: task.comment),
            photoWidget(AppText.image, task.photos)

          ],
        ),
      ),
    );
  }
}

AppBar detailAppBar(TaskEntity task) {
  return AppBar(
    backgroundColor: AppColors.kPrimaryColor,
    foregroundColor: AppColors.kWhiteColor,
    elevation: 2,
    flexibleSpace: Container(),
    title: Text(task.taskId.toString()),
  );
}


Widget photoWidget(String title, List<String> paths) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.kPrimaryColor),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: paths.length,
          itemBuilder: (context, index) {
            final path = paths[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: path.startsWith('http')
                  ? Image.network(
                      path,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 50),
                    )
                  : Image.file(
                      File(path),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 50),
                    ),
            );
          },
        ),
      ],
    ),
  );
}