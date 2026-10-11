import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image_codec;
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/services/image_compression_service_impl.dart';

void main() {
  late ImageCompressionServiceImpl service;

  setUp(() {
    service = const ImageCompressionServiceImpl();
  });

  test('resizes large images and returns a smaller JPEG', () async {
    final source = image_codec.Image(width: 2400, height: 1200);
    final sourceBytes = image_codec.encodeJpg(source, quality: 100);

    final compressed = await service.compress(
      XFile.fromData(sourceBytes, name: 'category.jpg', mimeType: 'image/jpeg'),
    );
    final compressedBytes = await compressed.readAsBytes();
    final decoded = image_codec.decodeImage(compressedBytes);

    expect(compressedBytes.length, lessThan(sourceBytes.length));
    expect(decoded?.width, 1920);
    expect(compressed.mimeType, 'image/jpeg');
  });

  test('rejects unsupported image data', () async {
    final image = XFile.fromData(
      Uint8List.fromList([1, 2, 3]),
      name: 'invalid.bin',
    );

    expect(() => service.compress(image), throwsA(isA<FormatException>()));
  });
}
