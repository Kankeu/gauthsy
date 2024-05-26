part of animations;

/// Fades out its [child] upon creation.
class FadeOutAnimation extends StatefulWidget {
  const FadeOutAnimation({
    Key key,
    this.child,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  _FadeOutAnimationState createState() => _FadeOutAnimationState();
}

class _FadeOutAnimationState extends State<FadeOutAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..forward();
  }

  @override
  void deactivate() {
    _controller.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeOutAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.isAnimating
        ? Opacity(
      opacity: 1.0 - _controller.value,
      child: widget.child,
    )
        : Container();
  }
}
