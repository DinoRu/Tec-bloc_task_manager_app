import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/presentation/tasks/blocs/complete_tasks_cubit.dart/complete_tasks_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/widgets/completed_card.dart';
import 'package:tec_bloc/presentation/tasks/main/components/TaskAppBar.dart';

import '../../../../core/constants/app_colors.dart';

class CompletedTaskPage extends StatefulWidget {
  const CompletedTaskPage({super.key});

  @override
  State<CompletedTaskPage> createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {

  Future<void> _refreshList(BuildContext context) async {
    context.read<CompleteTasksCubit>().getCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: taskAppBar(context, 'Завершенные задачи'),
      body: RefreshIndicator(
        elevation: 0,
        onRefresh: () => _refreshList(context),
        child: BlocBuilder<CompleteTasksCubit, CompleteTasksState>(
          builder: (context, state) {
            if ( state is CompleteTasksLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if ( state is CompleteTaskLoaded) {
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
        ),
      )
    );
  }
}