import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tec_bloc/core/constants/app_urls.dart';
import 'package:tec_bloc/core/failures/failure.dart';
import 'package:tec_bloc/data/tasks/models/add_new_task.dart';
import 'package:tec_bloc/data/tasks/models/task_model.dart';
import 'package:tec_bloc/data/tasks/models/update_task_params.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/locals/db/db_helper.dart';

abstract class TaskRemoteService {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, bool>> createTask(CreateTaskParams params);
  Future<Either<Failure, bool>> updateTask(UpdateTaskParams params, int taskId);
}

class TaskRemoteServiceImpl extends TaskRemoteService {

  final DbHelper dbHelper = DbHelper();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static const String tokenKey = "auth_token";
  final http.Client client;
  TaskRemoteServiceImpl({required this.client});


  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    final token = await secureStorage.read(key: tokenKey);
    if (token == null) {
      return Left(Failure("User not authenticated."));
    }
    try {
      final localTasks = await dbHelper.getTasks();
      if (localTasks.isNotEmpty) {
        log('CACHE :  HIT');
        return right(localTasks);
      }
      final response = await client.get(
        Uri.parse(AppUrls.allTask),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization": "Bearer $token"
        }
      );
      if (response.statusCode == 200) {
        Utf8Decoder decoder = const Utf8Decoder();
        String decoderBody = decoder.convert(response.bodyBytes);
        final List<dynamic> result = jsonDecode(decoderBody);
        final taskModels = result.map((json) => TaskModel.fromJson(json)).toList();
        final tasks = taskModels.map((task) => task.toEntity()).toList();
        // 📥 Sauvegarde dans SQLite
        for (TaskEntity task in tasks) {
          await dbHelper.insertTask(task);
        }
        log("API: HIT");
        return Right(tasks);
      } else if (response.statusCode == 404) {
        log("Task not found");
        return Left(
          Failure("Tasks not found.")
        );
      } else {
        log("Server error");
        return Left(Failure("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      return Left(Failure("Error to fetch data: $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(UpdateTaskParams params, int taskId) async {
    final token = await secureStorage.read(key: tokenKey);
    if (token == null) {
      return Left(Failure("User not authenticated or token is expired."));
    }
    try {

      final response = await client.patch(
        Uri.parse(AppUrls.updateTask(taskId)),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(params.toJson())
      );
     if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(Failure("Failed to update task. Status code: ${response.statusCode}"));
      }
    } catch (e) {
      return Left(Failure("Error updating task: $e"));
    }
  }
  
  @override
  Future<Either<Failure, bool>> createTask(CreateTaskParams params) async {
    final token = await secureStorage.read(key: tokenKey);
    if (token == null) {
      return Left(Failure("User not authenticated or token is expired."));
    }
    try {

      final response = await client.post(
        Uri.parse(AppUrls.createTask),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(params.toJson())
      );
     if (response.statusCode == 201) {
        return const Right(true);
      } else {
        log("Error: ${response.statusCode}");
        return Left(Failure("Failed to update task. Status code: ${response.statusCode}"));
      }
    } catch (e) {
      log(e.toString());
      return Left(Failure("Error updating task: $e"));
    }
  }

}

