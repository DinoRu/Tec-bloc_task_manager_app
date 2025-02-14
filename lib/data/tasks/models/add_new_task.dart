class CreateTaskParams {
  final String workType;
  final String dispatcher;
  final String address;
  final double voltage;
  final String job;
  final String photoUrl1;
  final String photoUrl2;
  final String? photoUrl3;
  final String? photoUrl4;
  final String? photoUrl5;
  String? comment;

  CreateTaskParams({
    required this.workType,
    required this.dispatcher,
    required this.address,
    required this.voltage,
    required this.job,
    required this.photoUrl1,
    required this.photoUrl2,
    this.photoUrl3,
    this.photoUrl4,
    this.photoUrl5,
    required this.comment
  });

  Map<String, dynamic> toJson() => {
    "work_type": workType,
    "dispatcher_name": dispatcher,
    "address": address,
    "job": job,
    "voltage": voltage,
    "photo_url_1": photoUrl1,
    "photo_url_2": photoUrl2,
    "photo_url_3": photoUrl3 ?? "",
    "photo_url_4": photoUrl4 ?? "",
    "photo_url_5": photoUrl5 ?? "",
    "comments": comment ?? ""
  };
}