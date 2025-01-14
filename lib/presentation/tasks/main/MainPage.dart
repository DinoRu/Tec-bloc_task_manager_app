import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/domain/auth/usecases/logout_usecase.dart';
import 'package:tec_bloc/domain/tasks/usecases/add_new_task_usecase.dart';
import 'package:tec_bloc/domain/tasks/usecases/get_completed_tasks_usecase.dart';
import 'package:tec_bloc/domain/tasks/usecases/get_tasks_usecase.dart';
import 'package:tec_bloc/presentation/profil/bloc/user_cubit.dart';
import 'package:tec_bloc/presentation/profil/cubit/logout_cubit.dart';
import 'package:tec_bloc/presentation/tasks/add_tasks/bloc/add_task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/home.dart';
import 'package:tec_bloc/service_locator.dart';

import '../../profil/pages/profil.dart';
import '../add_tasks/pages/addtask.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int currentIndex = 0;
  final List<Widget> pages = [
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskCubit(useCase: sl<GetTasksUsecase>()),
        ),
        BlocProvider(
          create: (context) => TaskCubit(useCase: sl<GetCompletedTasksUsecase>()),
        ),
      ],
      child: const Home(),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit()..fetchUser(),
        ),
        BlocProvider(
          create: (context) => LogoutCubit(sl<LogoutUsecase>()),
        ),
      ],
      child: Profil(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppNavigator.push(
              context,
              BlocProvider(
                create: (context) => AddTaskCubit(sl<AddNewTaskUsecase>()),
                child: const AddTask(),
              ),
            );
          },
          elevation: 4.0,
          shape: CircleBorder(),
          child: Icon(Icons.add, color: AppColors.kWhiteColor),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Профиль',
            ),
          ],
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
