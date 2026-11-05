import 'package:flutter/material.dart';

/// Original, asset-free cartoon cup illustration. Works on web and Android.
class PopCup extends StatelessWidget {
  const PopCup({super.key, this.size = 180, this.color = const Color(0xFFFF4B91)});
  final double size;
  final Color color;
  @override Widget build(BuildContext context) => SizedBox(
    width: size, height: size,
    child: CustomPaint(painter: _CupPainter(color)),
  );
}
class _CupPainter extends CustomPainter {
  _CupPainter(this.color);
  final Color color;
  @override void paint(Canvas canvas, Size s) {
    canvas.save(); canvas.scale(s.width / 200, s.height / 200);
    final stroke = Paint()..color = Colors.black..strokeWidth = 6..style = PaintingStyle.stroke..strokeJoin = StrokeJoin.round..strokeCap = StrokeCap.round;
    final body = Path()..moveTo(35, 65)..lineTo(165, 65)..lineTo(150, 175)..quadraticBezierTo(100, 193, 50, 175)..close();
    canvas.drawPath(body, Paint()..color = color);
    canvas.drawPath(body, stroke);
    canvas.drawOval(const Rect.fromLTWH(33, 51, 134, 30), Paint()..color = const Color(0xFFFFF5FB));
    canvas.drawOval(const Rect.fromLTWH(33, 51, 134, 30), stroke);
    canvas.drawLine(const Offset(122, 58), const Offset(146, 17), stroke);
    canvas.drawLine(const Offset(146, 17), const Offset(165, 25), stroke);
    canvas.drawCircle(const Offset(78, 119), 6, Paint()..color=Colors.black);
    canvas.drawCircle(const Offset(123, 119), 6, Paint()..color=Colors.black);
    final smile=Path()..moveTo(85, 143)..quadraticBezierTo(102, 163, 119, 143);
    canvas.drawPath(smile, stroke);
    for (final p in [const Offset(63,141),const Offset(138,141)]) {
      canvas.drawOval(Rect.fromCenter(center:p,width:17,height:9),Paint()..color=const Color(0xFFFFB4C9));
    }
    final sparkle=Paint()..color=const Color(0xFFFFD928)..strokeWidth=5..strokeCap=StrokeCap.round;
    for (final p in [const Offset(25,38),const Offset(177,98)]) {
      canvas.drawLine(p.translate(-8,0),p.translate(8,0),sparkle);
      canvas.drawLine(p.translate(0,-8),p.translate(0,8),sparkle);
    }
    canvas.restore();
  }
  @override bool shouldRepaint(covariant _CupPainter oldDelegate) => oldDelegate.color != color;
}
