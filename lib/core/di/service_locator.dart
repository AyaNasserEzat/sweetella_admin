import 'package:get_it/get_it.dart';
import 'package:sweetella_admin/core/services/firebase_service.dart';
import 'package:sweetella_admin/features/products/data/datasources/product_remote_data_source.dart';
import 'package:sweetella_admin/features/products/data/datasources/product_remote_data_source_impl.dart';
import 'package:sweetella_admin/features/products/data/repositories/product_repository_impl.dart';
import 'package:sweetella_admin/features/products/domain/repositories/product_repository.dart';
import 'package:sweetella_admin/features/products/domain/usecases/product_use_cases.dart';
import 'package:sweetella_admin/features/products/presentation/cubit/product_cubit.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<FirebaseServices>(
    () => FirebaseServices.createDefault(),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<FirebaseServices>()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetProducts(sl<ProductRepository>()));
  sl.registerLazySingleton(() => GetProductCategories(sl<ProductRepository>()));
  sl.registerLazySingleton(() => AddProduct(sl<ProductRepository>()));
  sl.registerLazySingleton(() => UpdateProduct(sl<ProductRepository>()));
  sl.registerLazySingleton(() => DeleteProduct(sl<ProductRepository>()));
  sl.registerFactory(
    () => ProductCubit(
      getProducts: sl<GetProducts>(),
      getCategories: sl<GetProductCategories>(),
      addProduct: sl<AddProduct>(),
      updateProduct: sl<UpdateProduct>(),
      deleteProduct: sl<DeleteProduct>(),
    ),
  );
}
