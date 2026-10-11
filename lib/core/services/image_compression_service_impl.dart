import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image_codec;
import 'package:image_picker/image_picker.dart';
import 'package:sweetella_admin/core/services/image_compression_service.dart';

class ImageCompressionServiceImpl implements ImageCompressionService {
  const ImageCompressionServiceImpl();
  @override
  Future<XFile> compress(XFile image) async {
    final sourceBytes = await image.readAsBytes();
    final compressedBytes = await compute(_compressImageBytes, sourceBytes);

    debugPrint(
      '📷 Original size: '
      '${(sourceBytes.length / 1024).toStringAsFixed(2)} KB',
    );

    debugPrint(
      '🗜️ Compressed size: '
      '${(compressedBytes.length / 1024).toStringAsFixed(2)} KB',
    );

    final savedBytes = sourceBytes.length - compressedBytes.length;
    final percentage = sourceBytes.isEmpty
        ? 0.0
        : (savedBytes / sourceBytes.length) * 100;

    debugPrint(
      '📉 Size reduction: '
      '${percentage.toStringAsFixed(2)}%',
    );

    if (compressedBytes.length >= sourceBytes.length) {
      debugPrint('ℹ️ Compressed image is not smaller. Using original image.');
      return image;
    }

    final isPng = _hasPngSignature(compressedBytes);
    final extension = isPng ? 'png' : 'jpg';
    final mimeType = isPng ? 'image/png' : 'image/jpeg';
    final fileName = image.name.replaceFirst(RegExp(r'\.[^.]+$'), '');

    return XFile.fromData(
      compressedBytes,
      name: '$fileName.$extension',
      mimeType: mimeType,
    );
  }
  // @override
  // Future<XFile> compress(XFile image) async {
  //   final sourceBytes = await image.readAsBytes();
  //   final compressedBytes = await compute(_compressImageBytes, sourceBytes);

  //   if (compressedBytes.length >= sourceBytes.length) {
  //     return image;
  //   }

  //   final isPng = _hasPngSignature(compressedBytes);
  //   final extension = isPng ? 'png' : 'jpg';
  //   final mimeType = isPng ? 'image/png' : 'image/jpeg';
  //   final fileName = image.name.replaceFirst(RegExp(r'\.[^.]+$'), '');

  //   return XFile.fromData(
  //     compressedBytes,
  //     name: '$fileName.$extension',
  //     mimeType: mimeType,
  //   );
  // }
}

Uint8List _compressImageBytes(Uint8List sourceBytes) {
  final decodedImage = image_codec.decodeImage(sourceBytes);

  if (decodedImage == null) {
    throw const FormatException('Selected file is not a supported image.');
  }

  const maxDimension = 1920;
  final largestDimension = decodedImage.width > decodedImage.height
      ? decodedImage.width
      : decodedImage.height;
  final resizedImage = largestDimension > maxDimension
      ? image_codec.copyResize(
          decodedImage,
          width: (decodedImage.width * maxDimension / largestDimension)
              .round()
              .clamp(1, maxDimension),
          height: (decodedImage.height * maxDimension / largestDimension)
              .round()
              .clamp(1, maxDimension),
          interpolation: image_codec.Interpolation.average,
        )
      : decodedImage;

  return resizedImage.hasAlpha
      ? Uint8List.fromList(image_codec.encodePng(resizedImage, level: 6))
      : Uint8List.fromList(image_codec.encodeJpg(resizedImage, quality: 85));
}

bool _hasPngSignature(Uint8List bytes) =>
    bytes.length >= 4 &&
    bytes[0] == 0x89 &&
    bytes[1] == 0x50 &&
    bytes[2] == 0x4e &&
    bytes[3] == 0x47;
