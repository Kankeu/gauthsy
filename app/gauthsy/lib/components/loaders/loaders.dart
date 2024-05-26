library loaders;

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gauthsy/kernel/container/container.dart' as prefix0;
import 'package:gauthsy/kernel/router/router.dart' as KR;
import 'package:flutter/widgets.dart';

class Loaders {
  static NavigatorState navigator;

  static BuildContext context;

  static void doubleBounce(BuildContext context, bool active) {
    Loaders.context = context;
    if (!active && navigator != null) {
      navigator.pop();
    } else {
      _setLoader(DoubleBounce());
    }
  }

  static void fadingCube(bool active) {
    Loaders.context = prefix0.Container().get('ctx');
    if (!active && navigator != null) {
      navigator.pop();
    } else {
      _setLoader(FadingCube());
    }
  }

  static void _setLoader(Widget child) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          navigator = Navigator.of(context);
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: child,
            ),
          );
        });
  }
}

class LoadersOverlay {
  static BuildContext get ctx => prefix0.Container().get<BuildContext>('ctx');
  static final _over = OverlayEntry(builder: (_) => FadingCube());

  static void toggle(bool value) {
    if (value)
      prefix0.Container().get<KR.Router>('router').navigator.overlay.insert(_over);
    else
      _over.remove();
  }
}

class FadingCube extends StatelessWidget {
  final double size;

  FadingCube({this.size = 50});

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCube(
        size: size, color: NeumorphicTheme.accentColor(context));
  }
}

class DoubleBounce extends StatelessWidget {
  final double size;
  final Color color;

  DoubleBounce({this.color,this.size=70});

  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
        size: size, color: color ?? NeumorphicTheme.accentColor(context));
  }
}
