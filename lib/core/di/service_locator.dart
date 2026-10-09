import 'package:get_it/get_it.dart';
import 'package:sweetella_admin/core/services/firebase_service.dart';
import 'package:sweetella_admin/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:sweetella_admin/features/categories/data/repositories/category_repository_impl.dart';
import 'package:sweetella_admin/features/categories/domain/repositories/category_repository.dart';
import 'package:sweetella_admin/features/categories/domain/usecases/add_category.dart';
import 'package:sweetella_admin/features/categories/domain/usecases/delete_category.dart';
import 'package:sweetella_admin/features/categories/domain/usecases/get_categories.dart';
import 'package:sweetella_admin/features/categories/domain/usecases/update_category.dart';
import 'package:sweetella_admin/features/categories/presentation/cubit/category_cubit.dart';
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
  sl.registerLazySingleton(() => AddProduct(sl<ProductRepository>()));
  sl.registerLazySingleton(() => UpdateProduct(sl<ProductRepository>()));
  sl.registerLazySingleton(() => DeleteProduct(sl<ProductRepository>()));
  sl.registerFactory(
    () => ProductCubit(
      getProducts: sl<GetProducts>(),
      addProduct: sl<AddProduct>(),
      updateProduct: sl<UpdateProduct>(),
      deleteProduct: sl<DeleteProduct>(),
    ),
  );

  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(sl<FirebaseServices>()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl<CategoryRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetCategories(sl<CategoryRepository>()));
  sl.registerLazySingleton(() => AddCategory(sl<CategoryRepository>()));
  sl.registerLazySingleton(() => UpdateCategory(sl<CategoryRepository>()));
  sl.registerLazySingleton(() => DeleteCategory(sl<CategoryRepository>()));
  sl.registerFactory(
    () => CategoryCubit(
      getCategories: sl<GetCategories>(),
      addCategory: sl<AddCategory>(),
      updateCategory: sl<UpdateCategory>(),
      deleteCategory: sl<DeleteCategory>(),
    ),
  );
}
