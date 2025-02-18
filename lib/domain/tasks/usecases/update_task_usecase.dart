import 'package:dartz/dartz.dart';
import 'package:tec_bloc/core/usecase/usecase.dart';
import 'package:tec_bloc/data/tasks/models/update_task_params.dart';
import 'package:tec_bloc/domain/tasks/repository/task_repository.dart';
import 'package:tec_bloc/service_locator.dart';

class UpdateTaskUsecase implements UseCase<Either, UpdateTaskData> {
  @override
  Future<Either> call({UpdateTaskData? params, int? taskId}) async {
    return await sl<TaskRepository>().updateTask(params!, taskId!);
  }
}