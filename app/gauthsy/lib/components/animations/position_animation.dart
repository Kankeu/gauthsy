import 'package:flutter/material.dart';

class PositionAnimation extends StatefulWidget {
  final Key key;
  final Offset end;
  final Offset start;
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Function onAnimationEnd;

  PositionAnimation(
      {@required this.child,
      this.key,
      @required this.end,
      this.start = const Offset(0, 0),
      this.duration = const Duration(seconds: 3),
      this.delay = const Duration(milliseconds: 500),
      this.onAnimationEnd});

  @override
  _PositionAnimationState createState() => _PositionAnimationState();
}

class _PositionAnimationState extends State<PositionAnimation> {
  double _bottom = 0;
  double _left = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      key: widget.key,
      duration: widget.duration,
      bottom: _bottom,
      left: _left,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    _bottom = widget.start.dy;
    _left = widget.start.dx;
    Future.delayed(
        widget.delay,
        () => setState(() {
              _bottom = widget.end.dy;
              _left = widget.end.dx;
              if (widget.onAnimationEnd != null)
                Future.delayed(widget.duration, widget.onAnimationEnd);
            }));
  }
}
