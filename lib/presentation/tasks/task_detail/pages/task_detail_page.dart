import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tec_bloc/common/helper/navigator/app_navigator.dart';
import 'package:tec_bloc/common/widgets/build_text.dart';
import 'package:tec_bloc/common/widgets/show_snackbar.dart';
import 'package:tec_bloc/core/constants/app_colors.dart';
import 'package:tec_bloc/core/constants/font_sizes.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/locals/db/db_helper.dart';
import 'package:tec_bloc/presentation/tasks/home/pages/home.dart';
import 'package:tec_bloc/presentation/tasks/task_detail/bloc/update_cubit.dart';
import 'package:tec_bloc/presentation/tasks/task_detail/widgets/comment_textfield.dart';

import '../../../../core/constants/app_text.dart';
import '../../../../core/permission_handler/gps_permission.dart';
import '../../../../service/api_service.dart';
import '../../crreate_tasks/widgets/input_field.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskEntity task;
  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _formKey = GlobalKey<FormState>();

  final DbHelper dbHelper = DbHelper();
  final ApiService _apiService = ApiService();
  final dispatcherController = TextEditingController();
  final addressController = TextEditingController();
  final jobTypeController = TextEditingController();
  final commentController = TextEditingController();
  String _workType = "ТО";
  List<String> _workTypes = [];

  double _voltage = 0.23;
  List<double> _voltages = [];

  Future<void> _loadWorkType() async {
    final workTypes = await _apiService.getWorkType();
    setState(() {
      _workTypes = workTypes;
    });
  }

   Future<void> _loadVoltage() async {
    final voltages = await _apiService.getVoltage();
    setState(() {
      _voltages = voltages;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWorkType();
    _loadVoltage();
    _voltage = widget.task.voltage!;
    _workType = widget.task.workType!;
    dispatcherController.text = widget.task.dispatcher!;
    addressController.text = widget.task.address!;
    jobTypeController.text = widget.task.job!;
    commentController.text = widget.task.comment!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
                        color: AppColors.kPrimaryColor),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.kWhiteColor,
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppText.workType,
                        style: titleStyle,
                      ),
                      
                      const SizedBox(height: 5),
                      buildText(
                          widget.task.job ?? "N/A",
                          AppColors.kBlackColor,
                          textMedium,
                          FontWeight.normal,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 15),
                      buildText(
                          "Диспетчерское наименование ОЭСХ",
                          AppColors.kPrimaryColor,
                          textSmall,
                          FontWeight.bold,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 5),
                      buildText(
                          widget.task.dispatcher ?? "N/A",
                          AppColors.kBlackColor,
                          textSmall,
                          FontWeight.normal,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 15),
                      buildText(
                          "Адрес объекта",
                          AppColors.kPrimaryColor,
                          textSmall,
                          FontWeight.bold,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 5),
                      buildText(
                          widget.task.address ?? "N/A",
                          AppColors.kBlackColor,
                          textSmall,
                          FontWeight.normal,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 15),
                      buildText(
                          "Дата работ по плану",
                          AppColors.kPrimaryColor,
                          textSmall,
                          FontWeight.bold,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 5),
                      buildText(
                          widget.task.plannerDate ?? "N/A",
                          AppColors.kBlackColor,
                          textSmall,
                          FontWeight.normal,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 15),
                      buildText(
                          "Класс напряжения, кВ",
                          AppColors.kPrimaryColor,
                          textSmall,
                          FontWeight.bold,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 5),
                      buildText(
                          "${widget.task.voltage ?? 0.0}",
                          AppColors.kBlackColor,
                          textSmall,
                          FontWeight.normal,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 15),
                      buildText(
                          "Вид работ",
                          AppColors.kPrimaryColor,
                          textSmall,
                          FontWeight.bold,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 5),
                      buildText(
                          widget.task.workType ?? "N/A",
                          AppColors.kBlackColor,
                          textSmall,
                          FontWeight.normal,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 15),
                      buildText(
                          "Комментарий",
                          AppColors.kPrimaryColor,
                          textSmall,
                          FontWeight.bold,
                          TextAlign.start,
                          TextOverflow.clip),
                      const SizedBox(height: 5),
                      CommentField(controller: commentController),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
