import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFebebf4),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      errorWidget: (context, url, error) => const SizedBox(
        width: 60,
        height: 60,
        child: ColoredBox(
          color: Color(0xFFEBEBF4),
          child: Icon(Icons.image_not_supported),
        ),
      ),
    );
  }
}
