import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/storage/data/data_sources/storage_remote_data_source.dart';

class CloudinaryRemoteDataSource implements StorageRemoteDataSource {
  final Dio dio;
  final String cloudName;
  final String uploadPreset;

  CloudinaryRemoteDataSource({
    required this.dio,
    required this.cloudName,
    required this.uploadPreset,
  });
  @override
  Future<Map<String, dynamic>> uploadImage(XFile image) async {
    final bytes = await image.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception('The selected image is empty.');
    }

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: image.name),
      'upload_preset': uploadPreset,
    });

    final response = await dio.post<Map<String, dynamic>>(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      data: formData,
    );

    final data = response.data;

    if (data == null ||
        data['secure_url'] is! String ||
        data['public_id'] is! String) {
      throw Exception('Invalid Cloudinary upload response.');
    }

    return data;
  }
}
