import 'package:flutter/material.dart';
import 'package:placeful/features/memories/viewmodels/take_image_viewmodel.dart';

class CameraShutter extends StatefulWidget {
  const CameraShutter({super.key, required this.viewModel});

  final TakeImageViewModel viewModel;

  @override
  State<CameraShutter> createState() => _CameraShutterState();
}

class _CameraShutterState extends State<CameraShutter>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _outerAnimationController;
  late Animation<double> tapAnimation;
  late Animation<double> outerAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _outerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );

    tapAnimation = Tween<double>(begin: 30, end: 28).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.slowMiddle),
    )..addListener(() {
      setState(() {});
    });

    outerAnimation = Tween<double>(begin: 36, end: 32).animate(
      CurvedAnimation(
        parent: _outerAnimationController,
        curve: Curves.bounceIn,
      ),
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown:
          (_) => {
            _animationController.forward(),
            _outerAnimationController.forward(),
            widget.viewModel.takePicture(),
          },
      onTapUp:
          (_) => {
            _animationController.reverse(),
            _outerAnimationController.reverse(),
          },
      onTapCancel:
          () => {
            _animationController.reverse(),
            _outerAnimationController.reverse(),
          },
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          children: [
            CustomPaint(
              painter: _CirclePainter(
                color: Colors.red,
                radius: 20,
                style: PaintingStyle.stroke,
              ),
            ),
            CustomPaint(
              painter: _CirclePainter(
                color: Colors.white,
                radius: 40,
                style: PaintingStyle.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Color color;
  final double radius;
  final PaintingStyle style;

  _CirclePainter({
    required this.color,
    required this.radius,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = style;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) => true;
}
