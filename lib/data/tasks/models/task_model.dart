
import 'dart:convert';

import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';

class TaskModel {
    final int taskId;
    final String workType;
    final String dispatcher;
    final String address;
    final String plannerDate;
    final String job;
    final double voltage;
    final String? completionDate;
    final List<String> photos;
    final String? comment;
    final bool isCompleted;

    const TaskModel({
      required this.taskId,
      required this.workType,
      required this.dispatcher,
      required this.address,
      required this.plannerDate,
      required this.job,
      required this.voltage,
      required this.completionDate,
      required this.photos,
      required this.comment,
      required this.isCompleted
    });

    factory TaskModel.fromJson(Map<String, dynamic> json) {
      return TaskModel(
        taskId: json['id'] ?? 0,
        workType: json['work_type'], 
        dispatcher: json['dispatcher_name'], 
        address: json['address'] ?? "", 
        plannerDate: json['planner_date'] ?? "", 
        job: json["job"] ?? "",
        voltage: json['voltage'], 
        completionDate: json['completion_date'] ?? "", 
        photos: _parsePhotos(json),
        comment: json['comments'] ?? "",
        isCompleted: json['is_completed'] ?? false
      );
    }

    /// ✅ Conversion des photos sous forme de `List<String>`
    static List<String> _parsePhotos(Map<String, dynamic> json) {
      List<String> urls = [];
      for (int i = 1; i <= 5; i++) {
        final String? url = json['photo_url_$i'];
        if (url != null && url.isNotEmpty) {
          urls.add(url);
        }
      }
      return urls;
    }

    TaskEntity toEntity() {
      return TaskEntity(
        taskId: taskId,
        workType: workType,
        dispatcher: dispatcher,
        address: address,
        plannerDate: plannerDate,
        job: job,
        voltage: voltage,
        completionDate: completionDate,
        photos: photos,
        comment: comment,
        isCompleted: isCompleted
      );
    }

    Map<String, dynamic> toJson() => {
      "id": taskId,
      "work_type": workType,
      "dispatcher_name": dispatcher,
      "address": address,
      "planner_date": plannerDate,
      "voltage": voltage,
      "completion_date": completionDate,
      "photos": jsonEncode(photos),
      "comments": comment,
      "is_completed": isCompleted ? 1 : 0,
    };

    /// ✅ Convertir un `Map<String, dynamic>` SQLite en `TaskModel`
    factory TaskModel.fromDb(Map<String, dynamic> json) {
      return TaskModel(
        taskId: json['id'],
        workType: json['work_type'],
        dispatcher: json['dispatcher_name'],
        address: json['address'],
        plannerDate: json['planner_date'],
        job: json["job"],
        voltage: json['voltage'],
        completionDate: json['completion_date'],
        photos: List<String>.from(jsonDecode(json['photos'] ?? "[]")),
        comment: json['comments'],
        isCompleted: json['is_completed'] == 1,
      );
    }
}
