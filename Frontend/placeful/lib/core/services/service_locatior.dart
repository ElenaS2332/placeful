import 'package:get_it/get_it.dart';
import 'package:placeful/core/services/auth_service.dart';
import 'package:placeful/core/services/logger_service.dart';
import 'package:placeful/core/services/user_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => UserService());
  getIt.registerLazySingleton(() => LoggerService());
}