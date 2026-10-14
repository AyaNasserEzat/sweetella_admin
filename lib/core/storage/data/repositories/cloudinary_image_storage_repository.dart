import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/error/exception_handelr.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import 'package:sweetella_admin/core/storage/data/data_sources/storage_remote_data_source.dart';

import '../../domain/entities/uploaded_image.dart';
import '../../domain/repositories/image_storage_repository.dart';

class CloudinaryImageStorageRepository implements ImageStorageRepository {
  final StorageRemoteDataSource remoteDataSource;

  CloudinaryImageStorageRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, UploadedImage>> uploadImage(XFile image) async {
    try {
      final data = await remoteDataSource.uploadImage(image);
      return Right(
        UploadedImage(
          url: data['secure_url'] as String,
          publicId: data['public_id'] as String,
        ),
      );
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
