import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/common/widgets/show_snackbar.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/presentation/profil/pages/profil.dart';
import 'package:tec_bloc/presentation/tasks/crreate_tasks/pages/create_task.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/cubit/sync_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/widgets/button.dart';
import 'package:tec_bloc/presentation/tasks/home/widgets/task_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _refresh(BuildContext context) async {
    context.read<TaskCubit>().displayTask();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () => AppNavigator.push(context, Profil()), 
                  icon: Icon(Icons.person, size: 40,)
                )
              ),
              actions: [
                MyButton(
                    label: "+ Добавить",
                    onTap: () => AppNavigator.push(context, CreateTask())),
                const SizedBox(width: 5)
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: Stack(children: [
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: BlocBuilder<TaskCubit, TaskState>(
                      builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.kPrimaryColor));
                    } else if (state is TaskLoaded) {
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
                                return TaskTile(task: task);
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
                BlocListener<SyncCubit, SyncState>(
                  listener: (context, state) {
                    if (state is AllTaskSyncSuccess) {
                      context.read<TaskCubit>().displayTask();
                    } else if (state is TaskSyncFailure) {
                      showSnackBar(context, state.message);
                    }
                  },
                  child: BlocBuilder<SyncCubit, SyncState>(
                    builder: (context, syncState) {
                      return BlocBuilder<TaskCubit, TaskState>(
                          builder: (context, state) {
                        if (state is TaskLoaded && state.tasks.isNotEmpty) {
                          if (syncState is SyncLoading) {
                            return const Center(
                              child: CircularProgressIndicator(color: Colors.red),
                            );
                          }
                          return Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: ElevatedButton(
                                onPressed: () => context.read<SyncCubit>().onSyncLocalTasks(),
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
              ]),
            )));
  }
}
