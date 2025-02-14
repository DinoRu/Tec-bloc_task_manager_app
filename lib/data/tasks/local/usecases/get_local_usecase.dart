
import 'package:dartz/dartz.dart';
import 'package:tec_bloc/core/usecase/usecase.dart';
import 'package:tec_bloc/data/tasks/local/repository/local_task_repository.dart';

import '../../../../service_locator.dart';

class GetLocalTaskUsecase implements UseCase<Either, dynamic>{
  @override
  Future<Either> call({params}) async {
    return sl<LocalTaskRepository>().getLocalTasks();
  }
}