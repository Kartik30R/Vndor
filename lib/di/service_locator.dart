import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:get_it/get_it.dart';
import 'package:vndor/di/storage_service.dart';
import 'package:vndor/features/dashboard/data/datasource/dashboard_report_datasource.dart';
import 'package:vndor/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:vndor/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:vndor/features/order/data/datasource/order_remote_datasource.dart';
import 'package:vndor/features/order/data/repository/order_repository_impl.dart';
import 'package:vndor/features/order/domain/usecases/create_order_usecase.dart';
import 'package:vndor/features/order/domain/repository/order_repository.dart';
import 'package:vndor/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:vndor/features/order/presentation/viewmodel/order_viewmodel.dart';
import 'package:vndor/features/product/data/datasource/product_remote_datasource.dart';
import 'package:vndor/features/product/data/repository/product_repository_impl.dart';
import 'package:vndor/features/product/domain/repository/product_repository.dart';
import 'package:vndor/features/product/domain/usecases/add_product_usecase.dart';
import 'package:vndor/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:vndor/features/product/domain/usecases/get_product_usecases.dart';
import 'package:vndor/features/product/domain/usecases/update_product_usecase.dart';
import 'package:vndor/features/product/presentation/viewmodel/product_viewmodel.dart';
import '../features/auth/data/data_source/auth_remote_datasource.dart';
import '../features/auth/data/repository/auth_repository_impl.dart';
import '../features/auth/domain/repository/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/presentation/view_models/auth_viewmodel.dart';
import '../features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import '../features/dashboard/presentation/viewmodels/dashboard_viewmodel.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerFactory(
    () => AuthViewModel(
      loginUseCase: sl(),
      registerUseCase: sl(),
      repository: sl(),
    ),
  );

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));

  sl.registerFactory(() => DashboardViewModel(sl()));

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));

  sl.registerFactory(
    () => ProductViewModel(
      getProducts: sl(),
      addProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
    ),
  );

  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));

  sl.registerFactory(() => OrderViewModel(getOrders: sl(), createOrder: sl()));
  sl.registerLazySingleton<StorageService>(() => StorageService());

}
