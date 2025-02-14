import 'package:dartz/dartz.dart';
import 'package:tec_bloc/core/usecase/usecase.dart';
import 'package:tec_bloc/data/tasks/models/add_new_task.dart';
import 'package:tec_bloc/domain/tasks/repository/task_repository.dart';
import 'package:tec_bloc/service_locator.dart';

class CreateTaskUsecase implements UseCase<Either, CreateTaskParams> {

  @override
  Future<Either> call({CreateTaskParams? params}) async {
    return await sl<TaskRepository>().createTask(params!);
  }
  
}