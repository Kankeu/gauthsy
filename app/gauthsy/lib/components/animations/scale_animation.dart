part of animations;


/// An implicitly animated widget that will animate a change to [scale].
class ScaleAnimation extends ImplicitlyAnimatedWidget {
  const ScaleAnimation({
    @required this.scale,
    @required this.child,
    Curve curve = Curves.easeInCubic,
    Duration duration = const Duration(milliseconds: 100),
  }) : super(curve: curve, duration: duration);

  final double scale;
  final Widget child;

  @override
  _ScaleAnimationState createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends AnimatedWidgetBaseState<ScaleAnimation> {
  Tween<double> _scaleTween;

  @override
  void forEachTween(visitor) {
    _scaleTween = visitor(
      _scaleTween,
      widget.scale,
          (value) => Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scaleTween.evaluate(animation),
      child: widget.child,
    );
  }
}
