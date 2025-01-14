import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable{
  final String taskId;
  final String? code;
  final String? dispatcher;
  final String? location;
  final String? plannedDate;
  final String? workType;
  final double? voltage;
  final String? completedDate;
  final double? latitude;
  final double? longitude;
  final String? photoUrl1;
  final String? photoUrl2;
  final String? comment;

  const TaskEntity({
    required this.taskId,
    this.code,
    this.dispatcher,
    this.location,
    this.plannedDate,
    this.workType,
    this.voltage,
    this.completedDate,
    this.latitude,
    this.longitude,
    this.photoUrl1,
    this.photoUrl2,
    this.comment
  });
  
  @override
  List<Object?> get props => [
    taskId,
    code,
    location,
    plannedDate,
    workType,
    voltage,
    completedDate,
    latitude,
    longitude,
    photoUrl1,
    photoUrl2
  ];
}