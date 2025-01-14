
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';

class TaskModel {
    final String taskId;
    final String code;
    final String dispatcher;
    final String location;
    final String plannedDate;
    final String workType;
    final double? voltage;
    final String? completedDate;
    final double? latitude;
    final double? longitude;
    final String? photoUrl1;
    final String? photoUrl2;
    final String? comment;

    const TaskModel({
      required this.taskId,
      required this.code,
      required this.dispatcher,
      required this.location,
      required this.plannedDate,
      required this.workType,
      required this.voltage,
      required this.completedDate,
      required this.latitude,
      required this.longitude,
      required this.photoUrl1,
      required this.photoUrl2,
      required this.comment
    });

    factory TaskModel.fromJson(Map<String, dynamic> json) {
      return TaskModel(
        taskId: json['task_id'], 
        code: json['code'], 
        dispatcher: json['dispatcher_name'], 
        location: json['location'] ?? "", 
        plannedDate: json['planner_date'] ?? "", 
        workType: json["work_type"] ?? "",
        voltage: json['voltage_class'], 
        completedDate: json['completion_date'] ?? "", 
        latitude: json['latitude'] ?? 0.0, 
        longitude: json['longitude'] ?? 0.0, 
        photoUrl1: json['photo_url_1'] ?? "", 
        photoUrl2: json['photo_url_2'] ?? "", 
        comment: json['comments'] ?? ""
      );
    }

    TaskEntity toEntity() {
      return TaskEntity(
        taskId: taskId,
        code: code,
        dispatcher: dispatcher,
        location: location,
        plannedDate: plannedDate,
        workType: workType,
        voltage: voltage,
        completedDate: completedDate,
        latitude: latitude,
        longitude: longitude,
        photoUrl1: photoUrl1,
        photoUrl2: photoUrl2,
        comment: comment
      );
    }

    Map<String, dynamic> toJson() => {
      "task_id": taskId,
      "code": code,
      "dispatcher_name": dispatcher,
      "location": location,
      "planner_date": plannedDate,
      "voltage_class": voltage,
      "completion_date": completedDate,
      "latitude": latitude,
      "longitude": longitude,
      "photo_url_1": photoUrl1,
      "photo_url_2": photoUrl2,
      "comments": comment,
    };
}
