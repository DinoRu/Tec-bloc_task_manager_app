import 'package:dartz/dartz.dart';
import 'package:tec_bloc/core/usecase/usecase.dart';
import 'package:tec_bloc/data/tasks/models/add_new_task.dart';
import 'package:tec_bloc/domain/tasks/repository/task_repository.dart';
import 'package:tec_bloc/service_locator.dart';

class AddNewTaskUsecase implements UseCase<Either, AddNewTaskParams> {
  @override
  Future<Either> call({AddNewTaskParams? params}) async {
    return await sl<TaskRepository>().addNewTask(params!);
  }
  
}