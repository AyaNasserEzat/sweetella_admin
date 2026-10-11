import 'package:image_picker/image_picker.dart';

abstract class UploadService {
  Future<String> uploadImage(XFile image);
}
