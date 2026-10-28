import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/design/app_tokens.dart';
import 'package:sweetella_admin/core/widgets/custom_shadow_container.dart';

class ImageUploadBox extends StatelessWidget {
  const ImageUploadBox({required this.onTap, this.imagePath, super.key});

  final VoidCallback onTap;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final colors = tokens.color;
    final imagePath = this.imagePath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upload image', style: tokens.text.titleSmall),
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
            child: CustomShadowContanier(
              width: double.infinity,
              height: tokens.size.productImageHeight + 84,
              child: imagePath == null || imagePath.isEmpty
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
                      child:
                          kIsWeb ||
                              imagePath.startsWith('http://') ||
                              imagePath.startsWith('https://')
                          ? Image.network(
                              imagePath,
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
                              File(imagePath),
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
