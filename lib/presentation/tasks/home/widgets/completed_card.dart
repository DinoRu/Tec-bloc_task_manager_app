import 'package:flutter/material.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/common/widgets/build_text.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/font_sizes.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/presentation/tasks/task_detail/pages/task_completed_detail_page.dart';

class TaskCompletedCard extends StatelessWidget {
  final TaskEntity taskEntity;

  const TaskCompletedCard({super.key, required this.taskEntity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, TaskCompletedDetailPage(task: taskEntity));
      },
      child: Card(
        elevation: 0,
        child: Container(
          width: double.maxFinite,
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: true, 
                onChanged: (value) {} 
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                      taskEntity.address ?? "N/A", 
                      AppColors.kBlackColor, 
                      textSmall, 
                      FontWeight.w400, 
                      TextAlign.start, 
                      TextOverflow.clip
                    ),
                    const SizedBox(height: 10),
                    buildText(
                      taskEntity.dispatcher ?? "N/A", 
                      AppColors.kPrimaryColor, 
                      textMedium, 
                      FontWeight.w500, 
                      TextAlign.start, 
                      TextOverflow.clip
                    ),
                    const SizedBox(height: 5),
                    buildText(
                      taskEntity.workType ?? "N/A", 
                      AppColors.kBlackColor, 
                      textSmall, 
                      FontWeight.normal, 
                      TextAlign.start, 
                      TextOverflow.clip
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: AppColors.kPrimaryColor.withOpacity(.1),
                            borderRadius: const BorderRadius.all(Radius.circular(5))
                        ),
                        child: Row(
                          children: [
                           const Icon(Icons.calendar_month, size: 20),
                           const SizedBox(width: 10),
                           Expanded(
                            child: buildText(
                                taskEntity.completionDate ?? "N/A", 
                                AppColors.kBlackColor, 
                                textTiny, 
                                FontWeight.w700, 
                                TextAlign.start, 
                                TextOverflow.clip
                              )
                            )
                          ],
                        ),
                    )
                  ],
                )
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}


TextStyle medium = const TextStyle(fontSize: 18);
TextStyle large = const TextStyle(fontWeight: FontWeight.w500, fontSize: 24);