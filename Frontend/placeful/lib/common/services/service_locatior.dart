import 'package:get_it/get_it.dart';
import 'package:placeful/common/services/auth_service.dart';
import 'package:placeful/common/services/camera_service.dart';
import 'package:placeful/common/services/favorite_memories_list_service.dart';
import 'package:placeful/common/services/http_service.dart';
import 'package:placeful/common/services/location_service.dart';
import 'package:placeful/common/services/logger_service.dart';
import 'package:placeful/common/services/memory_service.dart';
import 'package:placeful/common/services/user_friendship_service.dart';
import 'package:placeful/common/services/user_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => FavoriteMemoriesListService());
  getIt.registerLazySingleton(() => HttpService());
  getIt.registerLazySingleton(() => LocationService());
  getIt.registerLazySingleton(() => LoggerService());
  getIt.registerLazySingleton(() => MemoryService());
  getIt.registerLazySingleton(() => UserService());
  getIt.registerLazySingleton(() => CameraService());
  getIt.registerLazySingleton(() => UserFriendshipService());
}
