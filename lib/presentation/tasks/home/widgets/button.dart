import 'package:flutter/material.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: 100,
        // height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.kPrimaryColor, // Move color property here
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Text(label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }
}