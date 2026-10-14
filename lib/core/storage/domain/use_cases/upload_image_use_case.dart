import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/error/failure.dart';

import '../entities/uploaded_image.dart';
import '../repositories/image_storage_repository.dart';

class UploadImageUseCase {
  final ImageStorageRepository repository;

  const UploadImageUseCase(this.repository);

  Future<Either<Failure, UploadedImage>> call(XFile image) {
    return repository.uploadImage(image);
  }
}
