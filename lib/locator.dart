import 'package:chat_app/services/fake_auth_service.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
GetIt locator = GetIt.instance;
void setupLocator(){
locator.registerLazySingleton(() => FirebaseAuthService());
locator.registerLazySingleton(() => FakeAuthenticationService());
}