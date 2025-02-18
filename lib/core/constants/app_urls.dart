class AppUrls {

  AppUrls._();

  static const baseUrl = "http://62.217.182.141:8000/";

  // AUTH
  static const login = "${baseUrl}auth/login";
  static const createTask = "${baseUrl}task/";
  static const allTask = "${baseUrl}task/";
  static const completedTasks = "${baseUrl}task/completed";
  static String me = "${baseUrl}auth/me";
  
  // TASKS
  static const getOrCreateTask = "$baseUrl/task";
  static String getTask(int taskID) => "$baseUrl/task/$taskID";
  static String updateTask(int taskId) => "${baseUrl}task/$taskId";

  // WorkType
  static const getWorkType = "${baseUrl}workType/";

  // Voltage
  static const getVoltage = "${baseUrl}voltage/";

}