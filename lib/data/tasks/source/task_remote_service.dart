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

abstract class TaskRemoteService {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, List<TaskEntity>>> getCompletedTasks();
  Future<Either<Failure, bool>> addTask(AddNewTaskParams params);
  Future<Either<Failure, bool>> updateTask(UpdateTaskParams params, String taskId);
}

class TaskRemoteServiceImpl extends TaskRemoteService {

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static const String tokenKey = "auth_token";
  final http.Client client;
  TaskRemoteServiceImpl({required this.client});

  @override
  Future<Either<Failure, List<TaskEntity>>> getCompletedTasks() async {
    final token = await secureStorage.read(key: tokenKey);
    try {
      final response = await client.get(
        Uri.parse(AppUrls.getCompletedTaskByUser),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token"
        }
      );
      if (response.statusCode == 200) {
        Utf8Decoder decoder = const Utf8Decoder();
        String decoderBody = decoder.convert(response.bodyBytes);
        final List<dynamic> result = jsonDecode(decoderBody);
        final tasksModels = result.map((json) => TaskModel.fromJson(json)).toList();
        final tasks = tasksModels.map((task) => task.toEntity()).toList();
        return Right(tasks);
      } else if (response.statusCode == 404) {
        return Left(Failure("No tasks found."));
      } else {
        return Left(Failure("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      log(e.toString());
      return Left(Failure("Error fetching tasks: $e"));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    final token = await secureStorage.read(key: tokenKey);
    if (token == null) {
      return Left(Failure("User not authenticated."));
    }
    try {
      final response = await client.get(
        Uri.parse(AppUrls.getTaskByUser),
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
        return Right(tasks);
      } else if (response.statusCode == 404) {
        return Left(
          Failure("Tasks not found.")
        );
      } else {
        return Left(Failure("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      return Left(Failure("Error to fetch data: $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(UpdateTaskParams params, String taskId) async {
    final token = await secureStorage.read(key: tokenKey);
    if (token == null) {
      return Left(Failure("User not authenticated or token is expired."));
    }
    try {

      final response = await client.put(
        Uri.parse(AppUrls.update(taskId)),
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
  Future<Either<Failure, bool>> addTask(AddNewTaskParams params) async {
    final token = await secureStorage.read(key: tokenKey);
    if (token == null) {
      return Left(Failure("User not authenticated or token is expired."));
    }
    try {

      final response = await client.post(
        Uri.parse(AppUrls.addNewTask),
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

