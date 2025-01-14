import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gauthsy/components/animations/animations.dart';

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({@required this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.white10.withOpacity(0);

  double slide = 0.0;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: SlideContainer(
            slideDirection: SlideContainerDirection.vertical,
            autoSlideDuration: Duration(milliseconds: 300),
            onSlide: (double v) {
              setState(() {
                this.slide = v > 1 ? 1 : v < 0 ? 0 : v;
              });
            },
            minSlideDistanceToValidate: 120,
            maxSlideDistance: 150,
            onSlideCompleted: () => Navigator.pop(context),
            onSlideValidated: () => HapticFeedback.mediumImpact(),
            onSlideUnvalidated: () => HapticFeedback.mediumImpact(),
            child: Opacity(opacity: 1.0 - slide, child: child)));
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String get barrierLabel => null;
}
