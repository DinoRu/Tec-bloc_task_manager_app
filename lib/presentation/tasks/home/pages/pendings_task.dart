import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/cubit/sync_pending_tasks_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/widgets/task_card.dart';

import '../../../../common/widgets/show_snackbar.dart';

class PendingTasks extends StatelessWidget {
  const PendingTasks({super.key});

   @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: appBar(context),
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: BlocBuilder<TaskCubit, TaskState>(
                      builder: (context, state) {
                    if (state is PendingTasksLoading) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.kPrimaryColor));
                    } else if (state is PendingTasksLoaded) {
                      if (state.tasks.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Center(child: Text("Задачи отсутсвуют..."))
                        );
                      }
                      return Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.tasks.length,
                              itemBuilder: (context, index) {
                                final task = state.tasks[index];
                                return TaskCard(task: task);
                              }),
                          const SizedBox(height: 100),
                        ],
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(child: Text("Ощибка...!")));
                    }
                  }),
                ),
                BlocListener<SyncPendingTasksCubit, SyncPendingTasksState>(
                  listener: (context, state) {
                    if (state is SyncAllPendingTaskSuccess) {
                      context.read<TaskCubit>().displayPendingTasks();
                    } else if (state is SyncPendingTaskFailure) {
                      showSnackBar(context, state.message!);
                    }
                  },
                  child: BlocBuilder<SyncPendingTasksCubit, SyncPendingTasksState>(
                    builder: (context, syncState) {
                      return BlocBuilder<TaskCubit, TaskState>(
                          builder: (context, state) {
                        if (state is PendingTasksLoaded && state.tasks.isNotEmpty) {
                          if (syncState is SyncPendingTaksLoading) {
                            return const Center(
                              child: CircularProgressIndicator(color: Colors.red),
                            );
                          }
                          return Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: ElevatedButton(
                                onPressed: () => context.read<SyncPendingTasksCubit>().onSyncLocalTasks(),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15)),
                                child: Center(
                                  child: Text(
                                    'Отправить',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )),
                          );
                        }
                        return const SizedBox.shrink();
                      });
                    },
                  ),
                )
            ])));
  }
}

AppBar appBar(BuildContext context) {
  return AppBar(
    backgroundColor: AppColors.kPrimaryColor,
    foregroundColor: AppColors.kWhiteColor,
    title: Text("Данные в ождании"),
  );
}