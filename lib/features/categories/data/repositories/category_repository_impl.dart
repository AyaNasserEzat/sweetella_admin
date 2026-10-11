import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/error/exception_handelr.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/core/services/image_compression_service.dart';
import 'package:sweetella_admin/core/services/upload_service.dart';
import 'package:sweetella_admin/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:sweetella_admin/features/categories/data/models/category_model.dart';
import 'package:sweetella_admin/features/categories/domain/entities/category.dart';
import 'package:sweetella_admin/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(
    this._remoteDataSource,
    this._compressionService,
    this._uploadService,
  );

  final CategoryRemoteDataSource _remoteDataSource;
  final ImageCompressionService _compressionService;
  final UploadService _uploadService;

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final models = await _remoteDataSource.getCategories();
      final categories = models.map((model) => model.toEntity()).toList();
      return Right(categories);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> addCategory(Category category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      await _remoteDataSource.addCategory(model);
      return const Right(unit);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCategory(Category category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      await _remoteDataSource.updateCategory(model);
      return const Right(unit);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    try {
      await _remoteDataSource.deleteCategory(id);
      return const Right(unit);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadCategoryImage(XFile image) async {
    try {
      final compressedImage = await _compressionService.compress(image);
      final imageUrl = await _uploadService.uploadImage(compressedImage);
      return Right(imageUrl);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
