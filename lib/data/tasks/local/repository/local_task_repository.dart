
import 'package:dartz/dartz.dart';
import 'package:tec_bloc/data/tasks/local/datasources/task_local_source.dart';
// import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';

import '../../../../domain/tasks/entity/task_entity.dart';
import '../../../../service_locator.dart';

abstract class LocalTaskRepository {
  Future<Either> getLocalTasks();
  // Future<Either> createLocalTask(TaskEntity task);
  Future<Either> updateLocalTask(TaskEntity task);
}


class LocalTaskRepositoryImpl extends LocalTaskRepository {
  // @override
  // Future<Either> createLocalTask(TaskEntity task) {
  //   throw UnimplementedError();
  // }

  @override
  Future<Either> getLocalTasks() async {
    return await sl<TaskLocalService>().getTasks();
  }
  
  @override
  Future<Either> updateLocalTask(TaskEntity task) {
    return sl<TaskLocalService>().updateTask(task);
  }
  
}