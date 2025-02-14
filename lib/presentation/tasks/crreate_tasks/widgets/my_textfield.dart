import 'package:flutter/material.dart';
import 'package:tec_bloc/common/widgets/build_text.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/font_sizes.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String text;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorMsg;
  final String? Function(String?)? onChanged;
  final int? minLine;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.keyboardType,
      required this.text,
      this.onTap,
      this.validator,
      this.focusNode,
      this.errorMsg,
      this.onChanged,
      this.minLine});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildText(
          text, 
          AppColors.kPrimaryColor, 
          textSmall, 
          FontWeight.bold, 
          TextAlign.start,
          TextOverflow.ellipsis
        ),
        const SizedBox(height: 10),
        TextFormField(
          validator: validator,
          controller: controller,
          keyboardType: keyboardType,
          focusNode: focusNode,
          onTap: onTap,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
            errorText: errorMsg,
          ),
        ),
      ],
    );
  }
}