import 'package:flutter/material.dart';

class Cindicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
    Cindicator({
    this.size = 20.0,
    required this.color,
    this.strokeWidth = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color!),
          ),
          height: size,
          width: size,
        ),
      ],
    );
  }
}
