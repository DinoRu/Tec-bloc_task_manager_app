import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/core/configs/app_theme.dart';
import 'package:tec_bloc/presentation/splash/bloc/splash_cubit.dart';
import 'package:tec_bloc/presentation/splash/pages/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: const Splash(),
      ),
    );
  }
}
