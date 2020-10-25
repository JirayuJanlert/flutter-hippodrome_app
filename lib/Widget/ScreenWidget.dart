import 'package:flutter/material.dart';

class ScreenWidget extends StatefulWidget {
  @override
  _ScreenWidgetState createState() => _ScreenWidgetState();
}

class _ScreenWidgetState extends State<ScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 320 / 41,
            child: CustomPaint(
              painter: CurveScreenPainter(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Screen here',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
class CurveScreenPainter extends CustomPainter {
  var strokeWidth = 8.0;
  var offset = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.deepPurple;
    paint.style = PaintingStyle.stroke;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = strokeWidth;

    var path = Path();
    path.moveTo(offset, size.height - offset);
    path.quadraticBezierTo(size.width / 2, -size.height + offset,
        size.width - offset, size.height - offset);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green[800];
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.lineTo(size.width, size.height);

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}