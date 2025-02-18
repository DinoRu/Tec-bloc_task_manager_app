import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/pendings_task.dart';
import 'package:tec_bloc/presentation/tasks/home/widgets/task_card.dart';

import '../../blocs/task_from_file_cubit/task_from_file_cubit.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: BlocBuilder<TaskFromFileCubit, TaskFromFileState>(
        builder: (context, state) {
          if ( state is TaskFromFileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary,),
            );
          } else if ( state is TaskFromFileLoaded ) {
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
                return TaskCard(task: task);
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
      ),
    );
  }
}


AppBar _appBar(BuildContext context) {
  return AppBar(
    backgroundColor: AppColors.kPrimaryColor,
    foregroundColor: AppColors.kWhiteColor,
    title: Text("Задачи к выполнению"),
    actions: [
      IconButton(
        onPressed: () {
          context.read<TaskCubit>().displayPendingTasks();
          AppNavigator.push(context, const PendingTasks());
        }, 
        icon: Icon(Icons.arrow_forward_rounded)
      )
    ],
  );
}