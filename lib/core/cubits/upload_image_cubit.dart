import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/cubits/upload_image_usecase.dart';
import 'package:sweetella_admin/core/storage/domain/entities/uploaded_image.dart';
import 'package:sweetella_admin/core/storage/domain/use_cases/upload_image_use_case.dart';

class UploadImageCubit extends Cubit<ImageUploadState> {
  final UploadImageUseCase uploadImageUseCase;

  UploadImageCubit(this.uploadImageUseCase) : super(ImageUploadInitial());
  Future<UploadedImage?> upload(XFile image) async {
    emit(ImageUploadLoading());

    final result = await uploadImageUseCase(image);
    result.fold(
      (l) {
        emit(ImageUploadFailure(l));
        return null;
      },
      (result) {
        emit(ImageUploadSuccess(result));
        return result;
      },
    );
  }
}
