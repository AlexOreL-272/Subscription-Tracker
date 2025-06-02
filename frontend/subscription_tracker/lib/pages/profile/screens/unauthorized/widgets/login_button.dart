import 'dart:math';

import 'package:flutter/material.dart';
import 'package:subscription_tracker/widgets/theme_definitor.dart';

class OutlinedLoginButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final Color color;
  final VoidCallback onPressed;

  const OutlinedLoginButton({
    required this.label,
    required this.iconPath,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,

      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,

        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        ),

        side: WidgetStateProperty.all(BorderSide(color: color, width: 2.0)),

        fixedSize: WidgetStateProperty.all(
          Size(MediaQuery.of(context).size.width, 44.0),
        ),

        iconSize: WidgetStateProperty.all(20.0),
        iconColor: WidgetStateProperty.all(color),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Image.asset(iconPath, width: 24.0),
          SizedBox(width: 16.0),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class FilledButton extends StatefulWidget {
  final String label;
  final Color color;

  final double? width;
  final double height;

  final VoidCallback onPressed;

  final isLoading;

  const FilledButton({
    required this.label,
    required this.color,

    this.width,
    required this.height,

    required this.onPressed,

    this.isLoading = false,

    super.key,
  });

  @override
  State<FilledButton> createState() => _FilledButtonState();
}

class _FilledButtonState extends State<FilledButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void didUpdateWidget(FilledButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_animationController.isAnimating) {
      _animationController.repeat();
    } else if (!widget.isLoading) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final backgroundColor =
        isDark ? UIBaseColors.backgroundDark : UIBaseColors.backgroundLight;

    final buttonWidth = widget.width ?? MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,

      children: [
        TextButton(
          onPressed: () {
            if (widget.isLoading) {
              return;
            }

            widget.onPressed();
          },

          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,

            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            ),

            fixedSize: WidgetStateProperty.all(
              Size(buttonWidth, widget.height),
            ),

            backgroundColor: WidgetStateProperty.all(
              widget.isLoading ? backgroundColor : widget.color,
            ),
          ),

          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color:
                  widget.isLoading ^ isDark
                      ? UIBaseColors.textLight
                      : UIBaseColors.textDark,
            ),
          ),
        ),

        if (widget.isLoading)
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _animationController,

              builder: (context, child) {
                return CustomPaint(
                  size: Size(buttonWidth, widget.height),

                  painter: _GapBorderPainter(
                    progress: _animationController.value,
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                    gapSize: 200,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _GapBorderPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double width;
  final double gapSize;

  _GapBorderPainter({
    required this.progress,
    required this.color,
    required this.width,
    required this.gapSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = width
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(
      width / 2,
      width / 2,
      size.width - width,
      size.height - width,
    );
    const borderRadius = Radius.circular(16);

    final gapStart = progress;
    final gapEnd = (gapStart + (gapSize / _calculatePerimeter(size))) % 1.0;

    _drawBorderPart(canvas, rect, borderRadius, paint, gapEnd, gapStart);
  }

  void _drawBorderPart(
    Canvas canvas,
    Rect rect,
    Radius borderRadius,
    Paint paint,
    double start,
    double end,
  ) {
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect, borderRadius));

    final metrics = path.computeMetrics().first;
    final totalLength = metrics.length;
    final gapStart = start * totalLength;
    final gapEnd = end * totalLength;

    if (gapStart < gapEnd) {
      final extractPath = metrics.extractPath(gapStart, gapEnd);
      canvas.drawPath(extractPath, paint);
    } else {
      final extractPath1 = metrics.extractPath(gapStart, totalLength);
      final extractPath2 = metrics.extractPath(0, gapEnd);
      canvas.drawPath(extractPath1, paint);
      canvas.drawPath(extractPath2, paint);
    }
  }

  double _calculatePerimeter(Size size) {
    const cornerLength = 2 * pi * 16 / 4;
    final straightLength = 2 * (size.width + size.height - 4 * 16);
    return straightLength + 4 * cornerLength;
  }

  @override
  bool shouldRepaint(covariant _GapBorderPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        width != oldDelegate.width ||
        gapSize != oldDelegate.gapSize;
  }
}
