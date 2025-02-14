import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/core/configs/app_theme.dart';
import 'package:tec_bloc/data/tasks/local/usecases/get_local_usecase.dart';
import 'package:tec_bloc/domain/auth/usecases/logout_usecase.dart';
import 'package:tec_bloc/domain/tasks/usecases/create_task_usecase.dart';
import 'package:tec_bloc/domain/tasks/usecases/update_task_usecase.dart';
import 'package:tec_bloc/presentation/profil/bloc/user_cubit.dart';
import 'package:tec_bloc/presentation/profil/cubit/logout_cubit.dart';
import 'package:tec_bloc/presentation/splash/bloc/splash_cubit.dart';
import 'package:tec_bloc/presentation/splash/pages/splash.dart';
import 'package:tec_bloc/presentation/tasks/crreate_tasks/bloc/add_task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/crreate_tasks/cubit/take_photo_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/cubit/sync_cubit.dart';
import 'package:tec_bloc/presentation/tasks/task_detail/bloc/update_cubit.dart';
import 'package:tec_bloc/service_locator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SplashCubit()..appStarted(),
        ),
        BlocProvider<TakePhotoCubit>(
          create: (context) => TakePhotoCubit(),
        ),
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit(useCase: sl<GetLocalTaskUsecase>())..displayTask()
        ),
        BlocProvider<AddTaskCubit>(create: (context) => AddTaskCubit(sl<CreateTaskUsecase>())),
        BlocProvider(create: (context) => UpdateCubit(sl<UpdateTaskUsecase>())),
        BlocProvider(create: (context) => SyncCubit()),
        BlocProvider(create: (context) => UserCubit()..fetchUser()),
        BlocProvider(create: (context)  => LogoutCubit(sl<LogoutUsecase>()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: const Splash(),
      ),
    );
  }
}
