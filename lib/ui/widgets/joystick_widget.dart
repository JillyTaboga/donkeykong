import 'package:flutter/material.dart';

typedef OnMove(Offset newOffset);

class StickWidget extends StatefulWidget {
  const StickWidget({
    Key key,
    this.onMove,
  }) : super(key: key);
  final OnMove onMove;

  @override
  _StickWidgetState createState() => _StickWidgetState();
}

class _StickWidgetState extends State<StickWidget> {
  final double stickSize = 60;
  Offset position;

  updatePosition(Offset newPosition) {
    double newDx;
    double newDy;

    if (newPosition.dx > stickSize) {
      newDx = stickSize;
    } else if (newPosition.dx < 0) {
      newDx = 0;
    } else {
      newDx = newPosition.dx;
    }

    if (newPosition.dy > stickSize) {
      newDy = stickSize;
    } else if (newPosition.dy < 0) {
      newDy = 0;
    } else {
      newDy = newPosition.dy;
    }
    widget.onMove(Offset(newDx - (stickSize / 2), newDy - (stickSize / 2)));
    setState(() {
      position = Offset(newDx, newDy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      bottom: 0,
      child: Container(
        width: stickSize * 2,
        height: stickSize * 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: StickBasePainter(
                position: position,
              ),
            ),
            Positioned(
              top: position?.dy,
              left: position?.dx,
              child: GestureDetector(
                onPanUpdate: (detail) {
                  updatePosition(detail.localPosition);
                },
                onPanEnd: (detail) {
                  updatePosition(Offset(30, 30));
                },
                child: Container(
                  width: stickSize,
                  height: stickSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StickBasePainter extends CustomPainter {
  StickBasePainter({
    this.position = const Offset(0, 0),
  });

  final Offset position;
  final Paint paintStick = Paint()
    ..color = Colors.white
    ..strokeWidth = 20
    ..style = PaintingStyle.stroke;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var finalPosition;
    position == null
        ? finalPosition = Offset.zero
        : finalPosition = Offset(position.dx - 30, position.dy - 30);
    canvas.drawLine(
      finalPosition,
      Offset(0, 50),
      paintStick,
    );
  }
}
