import 'dart:convert';

class UpdateTaskParams {
  final List<String> photos;
  final String? comment;

  const UpdateTaskParams({
    required this.photos,
    this.comment,
  }) : assert(photos.length <= 5, 'Maximum de 5 photos autorisées.');



  Map<String, dynamic> toJson() => {
    "photos": jsonEncode(photos),
    "comment": comment
  };
}


class UpdateTaskData {
  final String photoUrl1;
  final String photoUrl2;
  final String? photoUrl3;
  final String? photoUrl4;
  final String? photoUrl5;
  final String? comment;

  const UpdateTaskData({
    required this.photoUrl1,
    required this.photoUrl2,
    this.photoUrl3,
    this.photoUrl4,
    this.photoUrl5,
    this.comment
  });

  Map<String, dynamic> toJson() => {
    "photo_url_1": photoUrl1,
    "photo_url_2": photoUrl2,
    "photo_url_3": photoUrl3 ?? "",
    "photo_url_4": photoUrl4 ?? "",
    "photo_url_5": photoUrl5 ?? "",
    "comments": comment,
  };
}