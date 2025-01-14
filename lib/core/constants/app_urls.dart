class AppUrls {

  AppUrls._();

  static const baseUrl = "http://62.217.182.141:8000/";
  static const login = "${baseUrl}users/login";
  static const getTaskByUser = "${baseUrl}tasks/supervisor/tasks";
  static const addNewTask = "${baseUrl}tasks/add_task";
  static const getCompletedTaskByUser = "${baseUrl}tasks/completed/tasks";
  static String getUserByUsername(String userId) => "${baseUrl}users/user/$userId";
  static String getUserInfo = "${baseUrl}users/info";
  static String update(String taskId) => "${baseUrl}tasks/task/$taskId";
}