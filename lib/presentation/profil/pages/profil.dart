import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/common/widgets/build_text.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/font_sizes.dart';
import 'package:tec_bloc/presentation/auth/pages/login.dart';
import 'package:tec_bloc/presentation/profil/bloc/user_cubit.dart';
import 'package:tec_bloc/presentation/profil/cubit/logout_cubit.dart';
import 'package:tec_bloc/presentation/profil/widgets/user_info.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) {
    if (state is LogoutSuccess) {
      AppNavigator.pushAndRemove(context, const LoginPage());
    }
          },
          child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        flexibleSpace: Container(),
        foregroundColor: Colors.white,
        title: Text('Профыль'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.output, size: 35))
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        if (state is UserLoading) {
          return const Center(
            child:
                CircularProgressIndicator(color: AppColors.kPrimaryColor),
          );
        } else if (state is UserLoaded) {
          return UserInfo(user: state.user);
        } else {
          return const Center(child: Text("Error occur!"));
        }
      })),
        );
  }
}
