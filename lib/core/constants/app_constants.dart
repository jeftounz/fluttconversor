import 'package:flutter/material.dart';

class AppColors {
  static const textSecondary = Color(0xFF344054);
  static const textTertiary = Color(0xFF475467);
  static const textPlaceholder = Color(0xFF667085);
  static const buttonPrimaryBg = Color(0xFF1E1E1E);
  static const borderPrimary = Color(0xFFD0D5DD);
  static const backgroundWhite = Color(0xFFFFFFFF);
  static const backgroundBlack = Color(0xFF000000);
}

class AppTextStyles {
  static const titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textTertiary,
  );

  static const formLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const linkText = TextStyle(
    fontSize: 14,
    color: AppColors.textTertiary,
    decoration: TextDecoration.underline,
  );
}
