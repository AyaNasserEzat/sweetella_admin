import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';

class ImageUploadBox extends StatelessWidget {
  const ImageUploadBox({
    required this.label,
    required this.onTap,
    this.imagePath,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tokens.text.label),
        SizedBox(height: tokens.space.sm),
        GestureDetector(
          onTap: onTap,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: colors.brand,
              strokeWidth: 1.5,
              dashPattern: const [6, 4],
              radius: Radius.circular(tokens.radius.md),
            ),
            child: Container(
              width: double.infinity,
              height: tokens.size.productImageHeight + 84,
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: BorderRadius.circular(tokens.radius.md),
              ),
              child: imagePath == null || imagePath!.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(tokens.space.md),
                          decoration: BoxDecoration(
                            color: colors.brandSoft,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.cloud_upload_outlined,
                            color: colors.brand,
                            size: tokens.size.icon + 14,
                          ),
                        ),
                        SizedBox(height: tokens.space.md),
                        RichText(
                          text: TextSpan(
                            style: tokens.text.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Drop your images here or select ',
                              ),
                              TextSpan(
                                text: 'click to browse',
                                style: tokens.text.bodySmall.copyWith(
                                  color: colors.brand,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(tokens.radius.md),
                      child: kIsWeb
                          ? Image.network(
                              imagePath!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.broken_image_outlined,
                                size: tokens.size.icon + 22,
                                color: colors.icon,
                              ),
                            )
                          : Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.broken_image_outlined,
                                size: tokens.size.icon + 22,
                                color: colors.icon,
                              ),
                            ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
