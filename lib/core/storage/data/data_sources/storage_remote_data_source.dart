import 'package:image_picker/image_picker.dart';

abstract class StorageRemoteDataSource {
  Future<Map<String, dynamic>> uploadImage(XFile image);
}
