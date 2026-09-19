import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HealthCareLogo extends StatelessWidget {
  final double size;
  const HealthCareLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    final double innerSize = size * 0.72;
    final double iconSize = size * 0.38;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F3F0),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: BoxDecoration(
            color: AppColors.iconTeal,
            borderRadius: BorderRadius.circular(innerSize * 0.28),
          ),
          child: CustomPaint(
            size: Size(iconSize, iconSize),
            painter: _MedicalLogoPainter(),
          ),
        ),
      ),
    );
  }
}

class _MedicalLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // Draw central medical pin / cross symbol
    final double armWidth = size.width * 0.24;
    final double armLength = size.width * 0.42;

    // Horizontal bar
    final RRect hBar = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: armLength * 2, height: armWidth),
      Radius.circular(armWidth / 2),
    );
    canvas.drawRRect(hBar, paint);

    // Vertical bar
    final RRect vBar = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: armWidth, height: armLength * 2),
      Radius.circular(armWidth / 2),
    );
    canvas.drawRRect(vBar, paint);

    // Center circular accent / hole
    final Paint holePaint = Paint()
      ..color = AppColors.iconTeal
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), size.width * 0.1, holePaint);

    // Inner white dot
    canvas.drawCircle(Offset(cx, cy), size.width * 0.05, paint);

    // Corner 4 subtle accent dots matching screenshot
    final double dotDist = size.width * 0.32;
    final double dotRadius = size.width * 0.065;
    canvas.drawCircle(Offset(cx - dotDist, cy - dotDist), dotRadius, paint);
    canvas.drawCircle(Offset(cx + dotDist, cy - dotDist), dotRadius, paint);
    canvas.drawCircle(Offset(cx - dotDist, cy + dotDist), dotRadius, paint);
    canvas.drawCircle(Offset(cx + dotDist, cy + dotDist), dotRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
