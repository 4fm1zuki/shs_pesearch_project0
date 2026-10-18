import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'donor_data.dart';

class LocalDemoMap extends StatelessWidget {
  final String? selectedBarangay;
  final Map<String, int> donorCounts;
  final TransformationController transformationController;
  final ValueChanged<String> onBarangaySelected;

  const LocalDemoMap({
    super.key,
    required this.selectedBarangay,
    required this.donorCounts,
    required this.transformationController,
    required this.onBarangaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = math.min(
          1.0,
          math.min(constraints.maxWidth / 720, constraints.maxHeight / 800),
        );
        final mapSize = Size(720 * scale, 800 * scale);

        return ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: InteractiveViewer(
            transformationController: transformationController,
            minScale: 0.65,
            maxScale: 3.2,
            boundaryMargin: const EdgeInsets.all(180),
            child: Center(
              child: SizedBox.fromSize(
                size: mapSize,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    final point = Offset(
                      details.localPosition.dx / mapSize.width,
                      details.localPosition.dy / mapSize.height,
                    );
                    for (final polygon in DonorData.polygons.reversed) {
                      if (polygon.getPath(const Size(1, 1)).contains(point)) {
                        onBarangaySelected(polygon.name);
                        return;
                      }
                    }
                  },
                  child: CustomPaint(
                    painter: _BarangayMapPainter(
                      selectedBarangay: selectedBarangay,
                      donorCounts: donorCounts,
                      colorScheme: Theme.of(context).colorScheme,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BarangayMapPainter extends CustomPainter {
  final String? selectedBarangay;
  final Map<String, int> donorCounts;
  final ColorScheme colorScheme;

  const _BarangayMapPainter({
    required this.selectedBarangay,
    required this.donorCounts,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = colorScheme.surfaceContainerLow;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final roadPaint = Paint()
      ..color = colorScheme.surfaceContainerHighest
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final roads = Path()
      ..moveTo(size.width * 0.08, size.height * 0.55)
      ..cubicTo(size.width * 0.34, size.height * 0.48, size.width * 0.55,
          size.height * 0.61, size.width * 0.94, size.height * 0.43)
      ..moveTo(size.width * 0.39, size.height * 0.04)
      ..cubicTo(size.width * 0.46, size.height * 0.32, size.width * 0.49,
          size.height * 0.67, size.width * 0.63, size.height * 0.96);
    canvas.drawPath(roads, roadPaint);

    for (final polygon in DonorData.polygons) {
      final path = polygon.getPath(size);
      final isSelected = polygon.name == selectedBarangay;
      final donorCount = donorCounts[polygon.name] ?? 0;
      final fill = Paint()
        ..color = isSelected
            ? colorScheme.primaryContainer
            : donorCount > 0
                ? colorScheme.primary
                    .withValues(alpha: 0.14 + donorCount * 0.025)
                : colorScheme.surfaceContainerHighest
        ..style = PaintingStyle.fill;
      final outline = Paint()
        ..color = isSelected ? colorScheme.primary : colorScheme.outlineVariant
        ..strokeWidth = isSelected ? 3 : 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, fill);
      canvas.drawPath(path, outline);

      final center = _centerOf(polygon.points, size);
      final label = TextPainter(
        text: TextSpan(
          text: polygon.name,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '...',
      )..layout(maxWidth: 94);
      label.paint(canvas, center - Offset(label.width / 2, label.height / 2));

      if (donorCount > 0) {
        final marker = Offset(center.dx, center.dy + 13);
        canvas.drawCircle(marker, 9, Paint()..color = colorScheme.primary);
        final countText = TextPainter(
          text: TextSpan(
            text: '$donorCount',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        countText.paint(
            canvas, marker - Offset(countText.width / 2, countText.height / 2));
      }
    }
  }

  Offset _centerOf(List<Offset> points, Size size) {
    final center = points.fold<Offset>(
      Offset.zero,
      (sum, point) => sum + point,
    );
    return Offset(
      center.dx / points.length * size.width,
      center.dy / points.length * size.height,
    );
  }

  @override
  bool shouldRepaint(covariant _BarangayMapPainter oldDelegate) =>
      oldDelegate.selectedBarangay != selectedBarangay ||
      oldDelegate.donorCounts != donorCounts ||
      oldDelegate.colorScheme != colorScheme;
}
