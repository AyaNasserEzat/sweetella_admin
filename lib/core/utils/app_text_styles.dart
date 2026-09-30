import 'package:flutter/material.dart';
import 'package:sweetella_admin/core/utils/app_colors.dart';

class AppTextStyles {
  static const text32BoldWhite = TextStyle(
    fontSize: 32,
    color: AppColors.white,
    letterSpacing: 1.5,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 900)],
  );
  static const text16BoldWhite = TextStyle(
    fontSize: 16,
    color: AppColors.white,
    letterSpacing: 1.5,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 900)],
  );
  static const text18SmiBoldwhite = TextStyle(
    fontSize: 18,
    color: AppColors.white,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 700)],
  );
  static const text12SmiBoldwhite = TextStyle(
    fontSize: 12,
    color: AppColors.white,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 700)],
  );
  static const text24BoldPink = TextStyle(
    fontSize: 24,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.bold,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 900)],
  );
  static const text20BoldPink = TextStyle(
    fontSize: 20,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.bold,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 900)],
  );
  static const text14BoldPink = TextStyle(
    fontSize: 16,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.bold,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 800)],
  );

  static const text18BoldDarkGray = TextStyle(
    fontSize: 18,
    color: AppColors.greyDark,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 900)],
  );
  static const text16BoldBlack = TextStyle(
    fontSize: 16,
    color: AppColors.greyDark,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 900)],
  );
  static const text18SmiyBoldDarkGray = TextStyle(
    fontSize: 18,
    color: AppColors.greyDark,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 700)],
  );
  static TextStyle text16SmiyBoldblack54 = TextStyle(
    fontSize: 16,
    color: Colors.black54,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 700)],
  );

  static const text20BoldDarkGray = TextStyle(
    fontSize: 20,
    fontFamily: 'Nunito',
    color: AppColors.greyDark,
    fontVariations: [FontVariation('wght', 900)],
  );

  static const text24BoldDarkGray = TextStyle(
    fontSize: 24,
    fontFamily: 'Nunito',
    color: AppColors.greyDark,
    fontVariations: [FontVariation('wght', 900)],
  );

  static const priceTextGreen = TextStyle(
    fontSize: 16,
    color: Colors.green,
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 900)],
  );

  static const text16Grey = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 16,
    fontVariations: [FontVariation('wght', 900)],
    color: Colors.grey,
  );
  static const text14Grey = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    fontVariations: [FontVariation('wght', 800)],
    color: Colors.grey,
  );
  static const text18GreyLineThrough = TextStyle(
    fontFamily: 'Nunito',
    fontVariations: [FontVariation('wght', 400)],
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
  );
}
