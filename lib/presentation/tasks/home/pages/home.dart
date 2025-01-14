import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/app_text.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/domain/tasks/usecases/get_completed_tasks_usecase.dart';
import 'package:tec_bloc/domain/tasks/usecases/get_tasks_usecase.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/completed_task_page.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/task_page.dart';

import '../../../../service_locator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String searchQuery = "";
  late TabController _tabController;
  List<TaskEntity> filterTasks = [];
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  void _searchTasks(String query, BuildContext context) {
    final taskCubit = context.read<TaskCubit>();
    if (query.isEmpty) {
      filterTasks = taskCubit.allTasks; // Réinitialiser les tâches
    } else {
      filterTasks = taskCubit.allTasks.where((task) {
        return task.code!.toLowerCase().contains(query.toLowerCase()) ||
            task.dispatcher!.toLowerCase().contains(query.toLowerCase()) ||
            task.workType!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    setState(() {}); // Met à jour l'affichage
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: AppBar(
              elevation: 0,
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Text(
                      AppText.title,
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      enabled: true,
                      controller: _searchController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.primary)
                          ),
                          hintText: "ТО, Диспечерская..., тип работа",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          suffixIcon: const Icon(Icons.tune),
                      ),
                      onChanged: (value) {
                        debugPrint("Search items: $value");
                      },
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Выполняется"),
                  Tab(text: "Выполнено")
                ],
                labelColor: AppColors.primary,
                dividerColor: Colors.grey.shade100,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: AppColors.primary,
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
            BlocProvider(
              create: (context) =>
                  TaskCubit(useCase: sl<GetTasksUsecase>())..displayTask(),
              child: const TaskPage(),
            ),
            BlocProvider(
              create: (context) => TaskCubit(useCase: sl<GetCompletedTasksUsecase>())..displayTask(),
              child: const CompletedTaskPage(),
            )
          ]
        ),
            ),
      ),
          );
  }
}
