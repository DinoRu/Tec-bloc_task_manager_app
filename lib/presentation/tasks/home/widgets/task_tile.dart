
import 'package:flutter/material.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/presentation/tasks/crreate_tasks/widgets/input_field.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/task_create_detail.dart';

class TaskTile extends StatelessWidget {
  final TaskEntity task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, TaskCreateDetail(task: task));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 12, top: 15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.kPrimaryColor)
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${task.address}",
                      style: titleStyle,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${task.workType}",
                      style: titleStyle,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      task.job ?? '',
                      style: subTitleStyle
                    ),
                  ],
                )
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: task.isCompleted == true ? 105 : 90,
                width: 0.9,
                color: task.isCompleted == true ? Colors.green : Colors.red,
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Row(
                  children: [
                    task.isCompleted == true
                      ? Icon(Icons.done_rounded, color: Colors.green.shade900,)
                      : Container(),
                    Text(
                      task.isCompleted == true ? "Выполнено" : "В процессе",
                      style: TextStyle(
                        color: task.isCompleted == true ? Colors.green.shade900 : Colors.red,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}