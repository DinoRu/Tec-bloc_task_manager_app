class UpdateTaskParams {
  final String photoUrl1;
  final String photoUrl2;
  final String photoUrl3;
  final String photoUrl4;
  final String photoUrl5;
  final String? comment;

  const UpdateTaskParams({
    required this.photoUrl1,
    required this.photoUrl2,
    required this.photoUrl3,
    required this.photoUrl4,
    required this.photoUrl5,
    this.comment
  });

  Map<String, dynamic> toJson() => {
    "photo_url_1": photoUrl1,
    "photo_url_2": photoUrl2,
    "photo_url_3": photoUrl3,
    "photo_url_4": photoUrl4,
    "photo_url_5": photoUrl5,
    "comments": comment,
  };
}