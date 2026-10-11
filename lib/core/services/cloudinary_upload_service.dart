import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/services/upload_service.dart';

class CloudinaryUploadService implements UploadService {
  CloudinaryUploadService(this._dio);

  static const _cloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'dbrqzrmey',
  );
  static const _uploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
    defaultValue: 'ml_default',
  );

  final Dio _dio;

  @override
  Future<String> uploadImage(XFile image) async {
    if (_cloudName.isEmpty || _uploadPreset.isEmpty) {
      throw StateError(
        'Set CLOUDINARY_CLOUD_NAME and CLOUDINARY_UPLOAD_PRESET at build time.',
      );
    }

    final response = await _dio.post<Map<String, dynamic>>(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      data: FormData.fromMap({
        'file': MultipartFile.fromBytes(
          await image.readAsBytes(),
          filename: image.name,
        ),
        'upload_preset': _uploadPreset,
      }),
    );
    final secureUrl = response.data?['secure_url'];

    if (secureUrl is! String || secureUrl.isEmpty) {
      throw const FormatException(
        'Cloudinary upload response did not include a secure_url.',
      );
    }

    return secureUrl;
  }
}
