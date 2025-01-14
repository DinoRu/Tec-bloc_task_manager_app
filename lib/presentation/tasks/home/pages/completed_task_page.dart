import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/widgets/completed_card.dart';

import '../../../../core/constants/app_colors.dart';

class CompletedTaskPage extends StatelessWidget {
  const CompletedTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if ( state is TaskLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if ( state is TaskLoaded) {
          return ListView.separated(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return TaskCompletedCard(taskEntity: task);
            },
            separatorBuilder: (context, index) => const Divider(color: AppColors.kGrey3),
          );
        } else {
          return const Text("Something wrong!");
        } 
      }
    );
  }
}