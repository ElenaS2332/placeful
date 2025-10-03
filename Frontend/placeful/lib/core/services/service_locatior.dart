import 'package:get_it/get_it.dart';
import 'package:placeful/core/services/auth_service.dart';
import 'package:placeful/core/services/favorite_memories_list_service.dart';
import 'package:placeful/core/services/http_service.dart';
import 'package:placeful/core/services/location_service.dart';
import 'package:placeful/core/services/logger_service.dart';
import 'package:placeful/core/services/memories_service.dart';
import 'package:placeful/core/services/user_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => FavoriteMemoriesListService());
  getIt.registerLazySingleton(() => HttpService());
  getIt.registerLazySingleton(() => LocationService());
  getIt.registerLazySingleton(() => LoggerService());
  getIt.registerLazySingleton(() => MemoryService());
  getIt.registerLazySingleton(() => UserService());
}
