import 'dart:convert';
import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final int taskId;
  final String? workType;
  final String? dispatcher;
  final String? address;
  final String? plannerDate;
  final String? job;
  final double? voltage;
  final String? completionDate;
  final List<String> photos; // ✅ Stocke toutes les photos sous forme de liste
  final String? comment;
  final bool isCompleted;

  const TaskEntity({
    required this.taskId,
    this.workType,
    this.dispatcher,
    this.address,
    this.plannerDate,
    this.job,
    this.voltage,
    this.completionDate,
    this.photos = const [], // ✅ Initialise une liste vide par défaut
    this.comment,
    required this.isCompleted,
  });

  /// Convertit l'objet en un Map JSON
  Map<String, dynamic> toJson() {
    return {
      "taskId": taskId,
      "workType": workType,
      "dispatcher": dispatcher,
      "address": address,
      "plannerDate": plannerDate,
      "job": job,
      "voltage": voltage,
      "completionDate": completionDate,
      "photos": jsonEncode(photos), // ✅ Stocker la liste sous forme de JSON string
      "comment": comment,
      "isCompleted": isCompleted ? 1 : 0, // ✅ SQLite stocke les booléens sous forme d'entier
    };
  }

  /// Création d'un objet TaskEntity à partir d'un JSON
  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    return TaskEntity(
      taskId: json["taskId"],
      workType: json["workType"],
      dispatcher: json["dispatcher"],
      address: json["address"],
      plannerDate: json["plannerDate"],
      job: json["job"],
      voltage: json["voltage"]?.toDouble(),
      completionDate: json["completionDate"],
      photos: jsonDecode(json["photos"] ?? '[]').cast<String>(), // ✅ Convertit JSON en liste de String
      comment: json["comment"],
      isCompleted: json["isCompleted"] == 1, // ✅ Convertit l'entier en booléen
    );
  }

  /// Crée une copie modifiée de l'instance actuelle
  TaskEntity copyWith({
    int? taskId,
    String? workType,
    String? dispatcher,
    String? address,
    String? plannerDate,
    String? job,
    double? voltage,
    String? completionDate,
    List<String>? photos,
    String? comment,
    bool? isCompleted,
  }) {
    return TaskEntity(
      taskId: taskId ?? this.taskId,
      workType: workType ?? this.workType,
      dispatcher: dispatcher ?? this.dispatcher,
      address: address ?? this.address,
      plannerDate: plannerDate ?? this.plannerDate,
      job: job ?? this.job,
      voltage: voltage ?? this.voltage,
      completionDate: completionDate ?? this.completionDate,
      photos: photos ?? this.photos, // ✅ Garde la liste actuelle si aucune nouvelle n'est fournie
      comment: comment ?? this.comment,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        taskId,
        workType,
        dispatcher,
        address,
        plannerDate,
        job,
        voltage,
        completionDate,
        photos,
        comment,
        isCompleted,
      ];
}
