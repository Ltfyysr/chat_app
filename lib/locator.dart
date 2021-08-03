import 'package:chat_app/repository/user_repository.dart';
import 'package:chat_app/services/fake_auth_service.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/services/firebase_storage_service.dart';
import 'package:chat_app/services/firestore_db_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
GetIt locator = GetIt.instance;
void setupLocator(){
locator.registerLazySingleton(() => FirebaseAuthService());
locator.registerLazySingleton(() => FakeAuthenticationService());
locator.registerLazySingleton(() => UserRepository());
locator.registerLazySingleton(() => FirestoreDBService());
locator.registerLazySingleton(() => FirebaseStorageService());
}