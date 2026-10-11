import 'package:image_picker/image_picker.dart';

abstract interface class ImageCompressionService {
  Future<XFile> compress(XFile image);
}
