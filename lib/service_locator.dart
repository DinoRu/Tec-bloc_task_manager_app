
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tec_bloc/data/auth/repository/auth_repository_impl.dart';
import 'package:tec_bloc/data/auth/source/auth_remote_service_impl.dart';
import 'package:tec_bloc/data/tasks/local/datasources/task_local_source.dart';
import 'package:tec_bloc/data/tasks/local/repository/local_task_repository.dart';
import 'package:tec_bloc/data/tasks/local/usecases/get_local_usecase.dart';
import 'package:tec_bloc/data/tasks/local/usecases/update_local_task.dart';
import 'package:tec_bloc/data/tasks/repository/task_repositoryImpl.dart';
import 'package:tec_bloc/data/tasks/source/task_remote_service.dart';
import 'package:tec_bloc/domain/auth/repository/auth.dart';
import 'package:tec_bloc/domain/auth/usecases/get_user_usecase.dart';
import 'package:tec_bloc/domain/auth/usecases/is_logged_in.dart';
import 'package:tec_bloc/domain/auth/usecases/login.dart';
import 'package:tec_bloc/domain/auth/usecases/logout_usecase.dart';
import 'package:tec_bloc/domain/tasks/repository/task_repository.dart';
import 'package:tec_bloc/domain/tasks/usecases/create_task_usecase.dart';
import 'package:tec_bloc/domain/tasks/usecases/get_tasks_usecase.dart';
import 'package:tec_bloc/domain/tasks/usecases/update_task_usecase.dart';

final sl = GetIt.instance;


Future<void> initializeDependencies() async {

   // Http Client
  sl.registerLazySingleton(() => http.Client());


  // Services
  sl.registerLazySingleton<AuthRemoteService>(() => AuthRemoteServiceImpl(client: sl()));

  sl.registerLazySingleton<TaskRemoteService>(() => TaskRemoteServiceImpl(client: sl()));

  sl.registerLazySingleton<TaskLocalService>(() => TaskLocalServiceImpl());

  // Remote repository
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl()
  );

  sl.registerSingleton<TaskRepository>(
    TaskRepositoryimpl()
  );

  sl.registerSingleton<LocalTaskRepository>(
    LocalTaskRepositoryImpl()
  );

  // usecases
  sl.registerSingleton<IsLoggedInUseCase>(
    IsLoggedInUseCase()
  );

  sl.registerSingleton<LoginUseCase>(
    LoginUseCase()
  );

  sl.registerSingleton<GetUserUseCase>(
    GetUserUseCase()
  );


  sl.registerSingleton<GetTasksUsecase>(
    GetTasksUsecase()
  );

  sl.registerSingleton<UpdateTaskUsecase>(
    UpdateTaskUsecase()
  );

  sl.registerSingleton<CreateTaskUsecase>(
    CreateTaskUsecase()
  );

  sl.registerSingleton<LogoutUsecase>(
    LogoutUsecase()
  );

  sl.registerSingleton<GetLocalTaskUsecase>(
    GetLocalTaskUsecase()
  );

  sl.registerSingleton<UpdateLocalTaskUsecase>(
    UpdateLocalTaskUsecase()
  );
}