import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'features/data/datasources/auth_remote_data_source.dart';
import 'features/data/repositories/auth_repository_impl.dart';
import 'features/domain/repositories/auth_repository.dart';
import 'features/domain/usecases/login_usecase.dart';
import 'features/presentation/bloc/auth/auth_bloc.dart';

// SEGUROS imports
import 'features/data/datasources/seguros_remote_data_source.dart';
import 'features/data/repositories/seguros_repository_impl.dart';
import 'features/domain/repositories/seguros_repository.dart';
import 'features/domain/usecases/submit_seguro_usecase.dart';
import 'features/presentation/bloc/seguros/seguros_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ========================
  // AUTH FEATURE
  // ========================
  // BLoC
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // ========================
  // SEGUROS FEATURE
  // ========================
  sl.registerLazySingleton<SegurosRemoteDataSource>(
    () => SegurosRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<SegurosRepository>(
    () => SegurosRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => SubmitSeguroUseCase(sl()));

  sl.registerFactory(() => SegurosBloc(sl()));

  // ========================
  // External dependencies
  // ========================
  sl.registerLazySingleton(
    () =>
        Dio()
          ..options = BaseOptions(
            baseUrl: 'https://api.veflat.com/',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          )
          ..interceptors.add(
            LogInterceptor(requestBody: true, responseBody: true),
          ),
  );
}
