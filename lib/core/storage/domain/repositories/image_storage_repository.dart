import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/error/failure.dart';
import '../entities/uploaded_image.dart';

abstract class ImageStorageRepository {
  Future<Either<Failure, UploadedImage>> uploadImage(XFile image);
}
