import 'package:flutter/material.dart';

class ImageScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double height;
  final double width;

  ImageScannerAnimation(this.stopped, this.height,this.width,
      {Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    final scorePosition = (animation.value * this.height) - 16;

    Color color1 = Color(0x5532CD32);
    Color color2 = Color(0x0032CD32);

    if (animation.status == AnimationStatus.reverse) {
      color1 = Color(0x0032CD32);
      color2 = Color(0x5532CD32);
    }

    return Positioned(
        bottom: scorePosition,
        child: Opacity(
            opacity: (stopped) ? 0.0 : 1.0,
            child: Container(
              height: 30.0,
              width: width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 1],
                    colors: [color1, color2],
                  )),
            )));
  }
}
