import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/widgets/task_card.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if ( state is TaskLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary,),
          );
        } else if ( state is TaskLoaded ) {
          log("${state.tasks.length}");
          if ( state.tasks.isEmpty) {
            return Center(
              child: Text("Задач не доступно..."),
            );
          }
          return ListView.separated(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return TaskCard(taskEntity: task);
            }, 
            separatorBuilder: (context, int index) {
              return const Divider(color: AppColors.primary);
            }, 
          );
        }  else {
          return const Center(
            child: Text('Ощибка...!'),
          );
        }
      }
    );
  }
}