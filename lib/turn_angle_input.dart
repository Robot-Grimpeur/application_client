import 'package:application_client/config.dart';
import 'package:application_client/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TurnAngleInput extends StatefulWidget {
  const TurnAngleInput({Key? key}) : super(key: key);

  @override
  State<TurnAngleInput> createState() => _TurnAngleInputState();
}

class _TurnAngleInputState extends State<TurnAngleInput> {
  double _angle = 0;

  void _updateAngle(double newAngle) {
    setState(() {
      _angle = newAngle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = [
      300.0,
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
          child: isMobile
              ? Joystick(
                  angle: _angle,
                  updateAngle: _updateAngle,
                )
              : const Text('You\'re on desktop'),
        ))
      ],
    );
  }
}

class Joystick extends StatelessWidget {
  const Joystick(
      {Key? key,
      required double angle,
      required void Function(double newAngle) updateAngle})
      : _angle = angle,
        _updateAngle = updateAngle,
        super(key: key);

  final double _angle;
  final void Function(double newAngle) _updateAngle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final localPosition = details.localPosition;
        final size = context.size!;
        final relativeX = localPosition.dx - size.width / 2;
        final relativeY = size.height / 2 - localPosition.dy;

        const maxAngleBySide = maxTurnAngle / 2;
        final angle = atan2(relativeX, relativeY)
            .clamp(radians(-maxAngleBySide), radians(maxAngleBySide));
        _updateAngle(angle.abs() < radians(5) ? 0 : angle);
      },
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomPaint(painter: _JoystickPainter(angle: _angle))),
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
