class UpdateTaskParams {
  final String photoUrl1;
  final String photoUrl2;
  final String? comment;

  const UpdateTaskParams({
    required this.photoUrl1,
    required this.photoUrl2,
    this.comment
  });

  Map<String, dynamic> toJson() => {
    "photo_url_1": photoUrl1,
    "photo_url_2": photoUrl2,
    "comments": comment,
  };
}