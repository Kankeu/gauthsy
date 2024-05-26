part of animations;

/// Fades out its [child] upon creation.
class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({
    Key key,
    this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
  }) : super(key: key);

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  _FadeInAnimationState createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
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
      });
    Future.delayed(widget.delay, () {
      if (mounted)
        _controller
        ..forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _controller.value,
      child: widget.child,
    );
  }
}
