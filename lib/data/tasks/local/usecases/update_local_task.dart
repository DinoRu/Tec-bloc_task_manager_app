
import 'package:dartz/dartz.dart';
import 'package:tec_bloc/core/usecase/usecase.dart';
import 'package:tec_bloc/data/tasks/local/repository/local_task_repository.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';

import '../../../../service_locator.dart';

class UpdateLocalTaskUsecase implements UseCase<Either, TaskEntity>{
  @override
  Future<Either> call({TaskEntity? params}) async {
    return await sl<LocalTaskRepository>().updateLocalTask(params!);
  }
  
}