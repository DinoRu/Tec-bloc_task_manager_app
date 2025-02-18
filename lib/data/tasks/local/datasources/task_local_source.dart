

import 'package:dartz/dartz.dart';
import 'package:tec_bloc/data/tasks/local/usecases/get_pending_tasks.dart';
import 'package:tec_bloc/locals/db/db_helper.dart';

import '../../../../core/failures/failure.dart';
import '../../../../domain/tasks/entity/task_entity.dart';

abstract class TaskLocalService {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, List<TaskEntity>>> getPendingTasks();
  Future<Either<Failure, bool>> updateTask(TaskEntity task);

}


class TaskLocalServiceImpl implements TaskLocalService {
  final DbHelper dbHelper = DbHelper();
  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final localTasks = await dbHelper.getTasks();
      return Right(localTasks);
    } catch (e) {
      return Left(Failure("Error to fetch data: $e"));
    }
  }
  
  @override
  Future<Either<Failure, bool>> updateTask(TaskEntity task) async {
    try {
      final result = await dbHelper.updateTask(task);
      if (result > 0) {
        return Right(true);
      }
      return Left(Failure("Failed to update task"));
    } catch (e) {
      return Left(Failure("Error to update task: $e"));
    }
  }
  
  @override
  Future<Either<Failure, List<TaskEntity>>> getPendingTasks() async {
    try {
      final tasks = await dbHelper.getPendingTasks();
      return Right(tasks);
    } catch (e) {
      return Left(Failure("Error to fetch data: $e"));
    }
  }
  
}