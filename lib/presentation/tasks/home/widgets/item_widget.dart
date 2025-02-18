import 'package:flutter/material.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/presentation/tasks/crreate_tasks/widgets/input_field.dart';

class ItemWidget extends StatelessWidget {
  final String title;
  final dynamic value;

  const ItemWidget({super.key, required this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            title, 
            style: TextStyle(
              color: AppColors.kPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600
            )
          ),
          const SizedBox(height: 5),
          Text('$value', style: titleStyle)
        ],
      ),
    );
  }
}
