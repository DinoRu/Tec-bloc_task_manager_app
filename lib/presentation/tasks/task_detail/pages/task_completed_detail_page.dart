import 'package:flutter/material.dart';
import 'package:tec_bloc/common/widgets/build_text.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/font_sizes.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';

class TaskCompletedDetailPage extends StatelessWidget {
  final TaskEntity task;
  const TaskCompletedDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.kPrimaryColor
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.kWhiteColor,),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.kPrimaryColor.withOpacity(.5)),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText(
                    "Код", 
                    AppColors.kPrimaryColor, 
                    textSmall, 
                    FontWeight.bold,
                    TextAlign.start, 
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 5),
                  buildText(
                    task.code ?? "N/A", 
                    AppColors.kBlackColor, 
                    textMedium, 
                    FontWeight.normal, 
                    TextAlign.start, 
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 15),
                  buildText(
                    "Диспетчерское наименование ОЭСХ", 
                    AppColors.kPrimaryColor, 
                    textSmall, 
                    FontWeight.bold, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 5),
                  buildText(
                    task.dispatcher ?? "N/A", 
                    AppColors.kBlackColor, 
                    textSmall, 
                    FontWeight.normal, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 15),
                  buildText(
                    "Адрес объекта", 
                    AppColors.kPrimaryColor, 
                    textSmall, 
                    FontWeight.bold, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 5),
                   buildText(
                    task.location ?? "N/A", 
                    AppColors.kBlackColor, 
                    textSmall, 
                    FontWeight.normal, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 15),
                  buildText(
                    "Дата работ по плану", 
                    AppColors.kPrimaryColor, 
                    textSmall, 
                    FontWeight.bold, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 5),
                   buildText(
                    task.plannedDate ?? "N/A", 
                    AppColors.kBlackColor, 
                    textSmall, 
                    FontWeight.normal, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 15),
                  buildText(
                    "Дата выполнения", 
                    AppColors.kPrimaryColor, 
                    textSmall, 
                    FontWeight.bold, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 5),
                   buildText(
                    task.completedDate ?? "N/A", 
                    AppColors.kBlackColor, 
                    textSmall, 
                    FontWeight.normal, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 15),
                  buildText(
                    "Класс напряжения, кВ", 
                    AppColors.kPrimaryColor, 
                    textSmall, 
                    FontWeight.bold, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 5),
                  buildText(
                    "${task.voltage ?? 0.0 }", 
                    AppColors.kBlackColor, 
                    textSmall, 
                    FontWeight.normal, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 15),
                  buildText(
                    "Вид работ", 
                    AppColors.kPrimaryColor, 
                    textSmall, 
                    FontWeight.bold, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 5),
                  buildText(
                    task.workType ?? "N/A", 
                    AppColors.kBlackColor, 
                    textSmall, 
                    FontWeight.normal, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 15),
                  buildText(
                    "Изображение",
                    AppColors.kPrimaryColor, 
                    textSmall, 
                    FontWeight.bold, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.5,
                          height: 200,
                          child: task.photoUrl1 != null ? Image.network(task.photoUrl1!, fit: BoxFit.cover) : const Placeholder()
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.5,
                          height: 200,
                          child: Image.network(task.photoUrl2!, fit: BoxFit.cover,)
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  buildText(
                    "Комментарий",
                    AppColors.kPrimaryColor, 
                    textSmall, 
                    FontWeight.bold, 
                    TextAlign.start,
                    TextOverflow.clip
                  ),
                  const SizedBox(height: 5),
                  Text(
                    task.comment ?? "N/A",
                    maxLines: 5,
                    style: const TextStyle(
                      color: AppColors.kBlackColor,
                      fontSize: textMedium,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}


