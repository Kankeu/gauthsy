import 'package:gauthsy/components/images/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gauthsy/components/animations/animations.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animatable<Color> circleColor = TweenSequence<Color>(
    [
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: UIData.colors.primary,
          end: UIData.colors.primary,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Container(
        child: SlideAnimation(
            duration: const Duration(milliseconds: 600),
            endPosition: Offset(0, -MediaQuery.of(context).size.height),
            child: Center(
                child: FadeInAnimation(
              duration: const Duration(milliseconds: 1000),
              child: BounceInAnimation(
                delay: const Duration(milliseconds: 1000),
                child: Container(
                  height: 200,
                  width: 200,
                  child: Material(
                      shape: CircleBorder(),
                      child: Stack(
                        children: <Widget>[
                          Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return CircularProgressIndicator(
                                      backgroundColor:
                                          UIData.colors.background,
                                      valueColor:
                                          circleColor.animate(_controller),
                                    );
                                  })),
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                              child: Avatar(
                                path: UIData.images.logo,
                                isAsset: true,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ))),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
