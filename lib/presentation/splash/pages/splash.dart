import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/app_text.dart';
import 'package:tec_bloc/presentation/auth/pages/login.dart';
import 'package:tec_bloc/presentation/splash/bloc/splash_cubit.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/home.dart';


class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
       if (state is UnAuthenticated) {
        AppNavigator.pushReplacement(context, const LoginPage());
       }
       if (state is Authenticated) {
        AppNavigator.pushReplacement(context, const Home());
       }
      },
      child: Scaffold(
        body: Center(
          child: Text(
            AppText.title,
            style: TextStyle(
                color: AppColors.kPrimaryColor,
                fontSize: 35,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
