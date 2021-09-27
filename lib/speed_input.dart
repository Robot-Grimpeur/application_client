import 'package:application_client/config.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SpeedInput extends StatefulWidget {
  const SpeedInput({Key? key}) : super(key: key);

  @override
  State<SpeedInput> createState() => _SpeedInputState();
}

class _SpeedInputState extends State<SpeedInput> {
  double _speed = 0;

  void _updateSpeed(double newSpeed) {
    setState(() {
      _speed = newSpeed;
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
            child: Text("Vitesse: ${_speed.round()}",
                style: const TextStyle(fontSize: 28))),
        Center(
            child: SizedBox(
          width: size,
          height: size,
          child: Lever(
            speed: _speed,
            updateSpeed: _updateSpeed,
          ),
        ))
      ],
    );
  }
}

class Lever extends StatelessWidget {
  const Lever(
      {Key? key,
      required double speed,
      required void Function(double newSpeed) updateSpeed})
      : _speed = speed,
        _updateSpeed = updateSpeed,
        super(key: key);

  final double _speed;
  final void Function(double newSpeed) _updateSpeed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final localPosition = details.localPosition;
        final size = context.size!;
        final relativeY = size.height / 2 - localPosition.dy;

        const maxSpeedBySide = maxSpeed / 2;
        final speed = relativeY.clamp(-maxSpeedBySide, maxSpeedBySide);
        _updateSpeed(speed);
      },
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomPaint(painter: _LeverPainter(speed: _speed))),
    );
  }
}

class _LeverPainter extends CustomPainter {
  _LeverPainter({required speed})
      : _speed = speed,
        super();

  final double _speed;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    double width = 100;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Colors.indigo;

    // Background
    {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: center, width: width, height: size.height),
              const Radius.circular(1000)),
          Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.blue);

      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: center, width: width, height: size.height),
              const Radius.circular(1000)),
          strokePaint);
    }

    // Cursor
    {
      const radius = 40.0;
      final offset = center +
          Offset(
              0,
              -(_speed *
                  (size.height - (radius * 2) - (width - radius * 2)) /
                  maxSpeed));

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
  bool shouldRepaint(_LeverPainter oldDelegate) => oldDelegate._speed != _speed;
}
