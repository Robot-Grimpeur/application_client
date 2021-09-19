import 'package:flutter/material.dart';
import 'dart:math';

const MAX_ANGLE = 120;

double radians(double degrees) => degrees * pi / 180;
double degrees(double radians) => radians * 180 / pi;

class Joystick extends StatefulWidget {
  const Joystick({Key? key}) : super(key: key);

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    final size = [
      500.0,
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height
    ].reduce(min);

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text("Angle: ${degrees(_angle).round()}",
                style: const TextStyle(fontSize: 28))),
        Center(
            child: SizedBox(
          width: size,
          height: size,
          child: GestureDetector(
            onPanUpdate: (details) {
              final localPosition = details.localPosition;
              final size = context.size!;
              final relativeX = localPosition.dx - size.width / 2;
              final relativeY = size.height / 2 - localPosition.dy;

              const maxAngleBySide = MAX_ANGLE / 2;
              final angle = atan2(relativeX, relativeY)
                  .clamp(radians(-maxAngleBySide), radians(maxAngleBySide));

              setState(() {
                _angle = angle.abs() < radians(5) ? 0 : angle;
              });
            },
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: CustomPaint(painter: _JoystickPainter(angle: _angle))),
          ),
        ))
      ],
    );
  }
}

class _JoystickPainter extends CustomPainter {
  _JoystickPainter({required angle})
      : _angle = angle - pi / 2,
        super();

  final double _angle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Colors.indigo;

    // Background
    {
      final radius = maxRadius - 10;

      canvas.drawCircle(
          center,
          radius,
          Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.blue);

      canvas.drawCircle(center, radius, strokePaint);
    }

    // Cursor
    {
      const radius = 40.0;
      final length = maxRadius - radius * 2;

      final offset =
          center + Offset(length * cos(_angle), length * sin(_angle));

      canvas.drawCircle(
          offset,
          radius,
          Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.white);

      canvas.drawCircle(offset, radius, strokePaint);
    }
  }

  @override
  bool shouldRepaint(_JoystickPainter oldDelegate) =>
      oldDelegate._angle != _angle;
}
