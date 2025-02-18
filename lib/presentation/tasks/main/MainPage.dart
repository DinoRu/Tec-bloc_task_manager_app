import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tec_bloc/presentation/profil/bloc/user_cubit.dart';
import 'package:tec_bloc/presentation/profil/pages/profil.dart';
import 'package:tec_bloc/presentation/tasks/blocs/complete_tasks_cubit.dart/complete_tasks_cubit.dart';
import 'package:tec_bloc/presentation/tasks/blocs/task_from_file_cubit/task_from_file_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/completed_task_page.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/home.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/task_page.dart';
import 'package:tec_bloc/presentation/tasks/main/components/appBottomNav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  final List<Widget> _pages = const [
    Home(),
    TaskPage(),
    CompletedTaskPage(),
    Profil()
  ];
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    switch (index) {
      case 0:
        context.read<TaskCubit>().displayTask();
        break;
      case 1:
        context.read<TaskFromFileCubit>().getFileTasks();
        break;
      case 2:
        context.read<CompleteTasksCubit>().getCompletedTasks();
        break;
      case 3:
        context.read<UserCubit>().fetchUser();
        break;
    }
  }

  Future<void> checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }
  }

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: appBottomNav(_currentIndex, _onTap),
    );
  }
}