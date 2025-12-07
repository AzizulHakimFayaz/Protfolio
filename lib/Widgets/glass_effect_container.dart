import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class GlassEffectContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlassEffectContainer({
    super.key,
    this.width,
    this.height,
    this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(15);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.textPrimaryDark.withOpacity(0.1),
            borderRadius: radius,
            border: Border.all(
              color: AppColors.textPrimaryDark.withOpacity(0.2),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.textPrimaryDark.withOpacity(0.2),
                AppColors.textPrimaryDark.withOpacity(0.05),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
