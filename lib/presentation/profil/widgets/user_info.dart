import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/domain/auth/entity/user.dart';
import 'package:tec_bloc/presentation/profil/cubit/logout_cubit.dart';

import '../../../common/widgets/build_text.dart';
import '../../../common/widgets/profil_item.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/font_sizes.dart';

class UserInfo extends StatelessWidget {
  final UserEntity user;
  const UserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
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
                    user.fullName, 
                    AppColors.kBlackColor, 
                    textExtraLarge, 
                    FontWeight.w500, 
                    TextAlign.center, 
                    TextOverflow.clip
                  ),
                  buildText(
                    user.location ?? "Admin", 
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
          const Divider(indent: 30, endIndent: 30, color: AppColors.kPrimaryColor),
          Spacer(),
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
            onTap: () {
              context.read<LogoutCubit>().logout();
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}