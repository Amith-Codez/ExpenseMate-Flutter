import 'package:flutter/material.dart';

/// Lightweight bar chart drawn with CustomPainter (no chart package needed).
class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.values,
    required this.labels,
    required this.color,
    this.height = 180,
  });

  final List<double> values;
  final List<String> labels;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _BarPainter(values, labels, color, textColor),
        size: Size.infinite,
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter(this.values, this.labels, this.color, this.textColor);

  final List<double> values;
  final List<String> labels;
  final Color color;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    const labelSpace = 22.0;
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final chartHeight = size.height - labelSpace;
    final slot = size.width / values.length;
    final barWidth = slot * 0.55;
    for (var i = 0; i < values.length; i++) {
      final h = maxValue == 0
          ? 0.0
          : (values[i] / maxValue) * (chartHeight - 6);
      final left = i * slot + (slot - barWidth) / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, chartHeight - h, barWidth, h),
        const Radius.circular(8),
      );
      final isMax = values[i] == maxValue && maxValue > 0;
      canvas.drawRRect(
        rect,
        Paint()..color = isMax ? color : color.withValues(alpha: 0.45),
      );
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: slot);
      tp.paint(
        canvas,
        Offset(i * slot + (slot - tp.width) / 2, size.height - tp.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) =>
      old.values != values || old.color != color;
}
