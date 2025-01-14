class AddNewTaskParams {
  final String taskId;
  final String code;
  final String dispatcher;
  final String location;
  final String plannedDate;
  final double voltage;
  final String workType;
  final String photoUrl1;
  final String photoUrl2;
  String? comment;

  AddNewTaskParams({
    required this.taskId,
    required this.code,
    required this.dispatcher,
    required this.location,
    required this.plannedDate,
    required this.voltage,
    required this.workType,
    required this.photoUrl1,
    required this.photoUrl2,
    required this.comment
  });

  Map<String, dynamic> toJson() => {
    "task_id": taskId,
    "code": code,
    "dispatcher_name": dispatcher,
    "location": location,
    "planner_date": plannedDate,
    "work_type": workType,
    "voltage_class": voltage,
    "photo_url_1": photoUrl1,
    "photo_url_2": photoUrl2,
    "comments": comment ?? ""
  };
}