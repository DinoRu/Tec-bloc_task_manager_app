import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/common/widgets/show_snackbar.dart';
import 'package:tec_bloc/domain/auth/entity/user.dart';
import 'package:tec_bloc/domain/auth/usecases/logout_usecase.dart';
import 'package:tec_bloc/presentation/auth/pages/login.dart';
import 'package:tec_bloc/presentation/profil/pages/instruction_page.dart';
import 'package:tec_bloc/presentation/tasks/home/bloc/task_cubit.dart';
import 'package:tec_bloc/service_locator.dart';

import '../../../common/widgets/build_text.dart';
import '../../../common/widgets/profil_item.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/font_sizes.dart';

class UserInfo extends StatefulWidget {
  final UserEntity user;
  const UserInfo({super.key, required this.user});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  Future<void> _logout() async {
    final logoutUsecase = sl<LogoutUsecase>();
    final result = await logoutUsecase();
    result.fold(
      (failure) {
        showSnackBar(context, "Error to logout");
      },
      (_) {
        context.read<TaskCubit>().displayTask();
        AppNavigator.pushAndRemove(context, const LoginPage());
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Image.asset(
                  "assets/icons/user.png",
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                      widget.user.fullName, 
                      AppColors.kBlackColor, 
                      textExtraLarge, 
                      FontWeight.w500, 
                      TextAlign.center, 
                      TextOverflow.clip
                    ),
                    buildText(
                      widget.user.role == "user" ? "Пользователь" : "Администратор",
                      AppColors.kBlackColor,
                      textSmall, 
                      FontWeight.normal, 
                      TextAlign.center, 
                      TextOverflow.clip
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Spacer(),
            profilItem(
              icon: Icons.menu_book, 
              text: "Инструкция", 
              color: AppColors.kPrimaryColor,
              onTap: () {
                AppNavigator.push(context, const InstructionPage());
              },
            ),
            profilItem(
              icon: Icons.settings, 
              text: "Настройки", 
              color: AppColors.kPrimaryColor,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            profilItem(
              icon: Icons.logout, 
              text: "Выход из систем", 
              color: AppColors.kRed,
              onTap: _logout
            ),
            const SizedBox(height: 30),
        ],
      ),
    );
  }
}