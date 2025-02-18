import 'package:flutter/material.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/presentation/tasks/crreate_tasks/pages/create_task.dart';

AppBar taskAppBar(context, String? title) {
  return AppBar(
    flexibleSpace: Container(),
    backgroundColor: AppColors.kPrimaryColor,
    foregroundColor: Colors.white,
    title: title != null ? Text(title) : null,
    actions: [
      IconButton(
        onPressed: () {
          AppNavigator.push(context, const CreateTask());
        }, 
        icon: Icon(Icons.add_circle_outline, size: 35),
        tooltip: 'Добавить',
      ),
    ],
  );
}