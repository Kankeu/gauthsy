part of animations;

/// A simple animation that "bounces in" its child.
class BounceInAnimation extends StatefulWidget {
  const BounceInAnimation({
    @required this.child,
    this.disable = false,
    this.duration = const Duration(milliseconds: 1000),
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration duration;
  final bool disable;
  final Duration delay;

  @override
  _BounceInAnimationState createState() => _BounceInAnimationState();
}

class _BounceInAnimationState extends State<BounceInAnimation>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        if (mounted) setState(() {});
      });

    _animation = CurveTween(curve: Curves.elasticOut).animate(_controller);

    Future.delayed(widget.delay).then((_) {
      if (mounted) _controller.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.disable ? 1 : _animation.value,
      child: widget.child,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
