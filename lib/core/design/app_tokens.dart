import 'package:flutter/material.dart';

@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.color,
    required this.space,
    required this.size,
    required this.radius,
    required this.text,
    required this.shadow,
    required this.motion,
  });

  static const light = AppTokens(
    color: AppColorTokens.light,
    space: AppSpaceTokens.standard,
    size: AppSizeTokens.standard,
    radius: AppRadiusTokens.standard,
    text: AppTextTokens.light,
    shadow: AppShadowTokens.light,
    motion: AppMotionTokens.standard,
  );

  static const dark = AppTokens(
    color: AppColorTokens.dark,
    space: AppSpaceTokens.standard,
    size: AppSizeTokens.standard,
    radius: AppRadiusTokens.standard,
    text: AppTextTokens.dark,
    shadow: AppShadowTokens.dark,
    motion: AppMotionTokens.standard,
  );

  final AppColorTokens color;
  final AppSpaceTokens space;
  final AppSizeTokens size;
  final AppRadiusTokens radius;
  final AppTextTokens text;
  final AppShadowTokens shadow;
  final AppMotionTokens motion;

  @override
  AppTokens copyWith({
    AppColorTokens? color,
    AppSpaceTokens? space,
    AppSizeTokens? size,
    AppRadiusTokens? radius,
    AppTextTokens? text,
    AppShadowTokens? shadow,
    AppMotionTokens? motion,
  }) {
    return AppTokens(
      color: color ?? this.color,
      space: space ?? this.space,
      size: size ?? this.size,
      radius: radius ?? this.radius,
      text: text ?? this.text,
      shadow: shadow ?? this.shadow,
      motion: motion ?? this.motion,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;

    return AppTokens(
      color: color.lerp(other.color, t),
      space: space,
      size: size,
      radius: radius,
      text: text,
      shadow: shadow,
      motion: motion,
    );
  }
}

extension AppTokensX on BuildContext {
  AppTokens get tokens =>
      Theme.of(this).extension<AppTokens>() ?? AppTokens.light;
}

@immutable
class AppColorTokens {
  const AppColorTokens({
    required this.brand,
    required this.brandSoft,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
    required this.icon,
    required this.overlay,
  });

  static const light = AppColorTokens(
    brand: Color(0xFFD67C93),
    brandSoft: Color(0xFFFFE3E3),
    background: Color(0xFFF6F6F6),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF9F9F9),
    textPrimary: Color(0xFF2D2D2D),
    textSecondary: Color(0xFF777777),
    border: Color(0xFFE9E9E9),
    success: Color(0xFF2BAA75),
    successSoft: Color(0xFFEAF7F0),
    warning: Color(0xFFE3A85E),
    warningSoft: Color(0xFFFFF3DF),
    danger: Color(0xFFE96B7D),
    dangerSoft: Color(0xFFFFEBF0),
    info: Color(0xFF5E8BFF),
    infoSoft: Color(0xFFEAF1FF),
    icon: Color(0xFF404040),
    overlay: Color(0x1A2D2D2D),
  );

  static const dark = AppColorTokens(
    brand: Color(0xFFD67C93),
    brandSoft: Color(0xFF4A3037),
    background: Color(0xFF171717),
    surface: Color(0xFF222222),
    surfaceAlt: Color(0xFF2A2A2A),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFB5B5B5),
    border: Color(0xFF3A3A3A),
    success: Color(0xFF43C98D),
    successSoft: Color(0xFF203B30),
    warning: Color(0xFFE3A85E),
    warningSoft: Color(0xFF403421),
    danger: Color(0xFFE96B7D),
    dangerSoft: Color(0xFF40252B),
    info: Color(0xFF7197FF),
    infoSoft: Color(0xFF252F49),
    icon: Color(0xFFE0E0E0),
    overlay: Color(0x33000000),
  );

  final Color brand;
  final Color brandSoft;
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;
  final Color icon;
  final Color overlay;

  AppColorTokens lerp(AppColorTokens other, double t) {
    return AppColorTokens(
      brand: Color.lerp(brand, other.brand, t)!,
      brandSoft: Color.lerp(brandSoft, other.brandSoft, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoSoft: Color.lerp(infoSoft, other.infoSoft, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}

@immutable
class AppSpaceTokens {
  const AppSpaceTokens({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  static const standard = AppSpaceTokens(
    xs: 4,
    sm: 8,
    md: 12,
    lg: 16,
    xl: 20,
    xxl: 24,
    xxxl: 32,
  );

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;
}

@immutable
class AppSizeTokens {
  const AppSizeTokens({
    required this.sidebarWidth,
    required this.profileAvatar,
    required this.icon,
    required this.chartHeight,
    required this.productImageHeight,
    required this.searchWidth,
    required this.listRowHeight,
  });

  static const standard = AppSizeTokens(
    sidebarWidth: 248,
    profileAvatar: 40,
    icon: 18,
    chartHeight: 220,
    productImageHeight: 136,
    searchWidth: 280,
    listRowHeight: 52,
  );

  final double sidebarWidth;
  final double profileAvatar;
  final double icon;
  final double chartHeight;
  final double productImageHeight;
  final double searchWidth;
  final double listRowHeight;
}

@immutable
class AppRadiusTokens {
  const AppRadiusTokens({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.pill,
  });

  static const standard = AppRadiusTokens(
    sm: 8,
    md: 12,
    lg: 16,
    xl: 20,
    pill: 999,
  );

  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double pill;
}

@immutable
class AppTextTokens {
  const AppTextTokens({
    required this.display,
    required this.title,
    required this.titleSmall,
    required this.body,
    required this.bodySmall,
    required this.label,
    required this.value,
    required this.valueLarge,
    required this.amount,
    required this.button,
    required this.chip,
  });

  static const light = AppTextTokens(
    display: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: Color(0xFF2D2D2D),
    ),
    title: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Color(0xFF2D2D2D),
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Color(0xFF2D2D2D),
    ),
    body: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF2D2D2D),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF777777),
    ),
    label: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      color: Color(0xFF777777),
    ),
    value: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Color(0xFF2D2D2D),
    ),
    valueLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: Color(0xFF2D2D2D),
    ),
    amount: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Color(0xFF2D2D2D),
    ),
    button: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFFFFF),
    ),
    chip: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Color(0xFF2D2D2D),
    ),
  );

  static const dark = AppTextTokens(
    display: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF5F5F5),
    ),
    title: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF5F5F5),
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF5F5F5),
    ),
    body: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFFF5F5F5),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFFB5B5B5),
    ),
    label: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      color: Color(0xFFB5B5B5),
    ),
    value: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF5F5F5),
    ),
    valueLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF5F5F5),
    ),
    amount: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF5F5F5),
    ),
    button: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFFFFF),
    ),
    chip: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF5F5F5),
    ),
  );

  final TextStyle display;
  final TextStyle title;
  final TextStyle titleSmall;
  final TextStyle body;
  final TextStyle bodySmall;
  final TextStyle label;
  final TextStyle value;
  final TextStyle valueLarge;
  final TextStyle amount;
  final TextStyle button;
  final TextStyle chip;
}

@immutable
class AppShadowTokens {
  const AppShadowTokens({required this.low, required this.medium});

  static const light = AppShadowTokens(
    low: [
      BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 8)),
    ],
    medium: [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  );

  static const dark = AppShadowTokens(
    low: [
      BoxShadow(color: Color(0x40000000), blurRadius: 18, offset: Offset(0, 8)),
    ],
    medium: [
      BoxShadow(
        color: Color(0x66000000),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  );

  final List<BoxShadow> low;
  final List<BoxShadow> medium;
}

@immutable
class AppMotionTokens {
  const AppMotionTokens({
    required this.short,
    required this.medium,
    required this.long,
  });

  static const standard = AppMotionTokens(
    short: Duration(milliseconds: 180),
    medium: Duration(milliseconds: 260),
    long: Duration(milliseconds: 350),
  );

  final Duration short;
  final Duration medium;
  final Duration long;
}
