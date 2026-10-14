import 'package:sweetella_admin/core/error/failure.dart';

import '../../../../core/storage/domain/entities/uploaded_image.dart';

sealed class ImageUploadState {}

class ImageUploadInitial extends ImageUploadState {}

class ImageUploadLoading extends ImageUploadState {}

class ImageUploadSuccess extends ImageUploadState {
  final UploadedImage image;

  ImageUploadSuccess(this.image);
}

class ImageUploadFailure extends ImageUploadState {
  final Failure message;

  ImageUploadFailure(this.message);
}
