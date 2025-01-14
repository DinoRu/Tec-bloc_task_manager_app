import 'package:flutter/material.dart';
import 'package:tec_bloc/core/constants/font_sizes.dart';

Widget profilItem({
      required IconData icon, 
      required String text, 
      required Color color, 
      void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(width: 10),
        Text(
          text, 
          style: TextStyle(
            color: color,
            fontSize: textExtraLarge
          )
        )
      ],
    ),
  );
} 