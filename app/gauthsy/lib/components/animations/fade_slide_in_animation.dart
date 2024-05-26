part of animations;

class FadeSlideInAnimation extends StatefulWidget {
  final int coefficient;
  final Widget child;
  final bool vertical;
  final bool lock;

  FadeSlideInAnimation(
      {@required this.coefficient,
      this.vertical = false,
        this.lock=false,
      @required this.child});

  @override
  _FadeSlideInAnimationState createState() => _FadeSlideInAnimationState();
}

class _FadeSlideInAnimationState extends State<FadeSlideInAnimation>
    with AutomaticKeepAliveClientMixin {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if(widget.lock) return widget.child;
   return FadeInAnimation(
        duration: Duration(seconds: 1),
        delay: Duration(milliseconds: 100 * widget.coefficient),
        child: SlideInAnimation(
            offset: Offset(
                widget.vertical
                    ? 0
                    : 50 * ((widget.coefficient + 1).toDouble()),
                widget.vertical
                    ? 100 * ((widget.coefficient + 1).toDouble())
                    : 0),
            delay: Duration(milliseconds: 500 + 100 * widget.coefficient),
            duration: Duration(seconds: 1),
            child: widget.child));
  }

  @override
  bool get wantKeepAlive => true;
}
