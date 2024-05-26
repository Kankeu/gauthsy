library ui_data;

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gauthsy/kernel/container/container.dart' as Kernel;
import 'package:gauthsy/shared_prefs/shared_prefs.dart';

part 'ui_data_dark.dart';

part 'ui_data_light.dart';

class UIData extends DynamicTheme {
  UIData({ThemedWidgetBuilder builder})
      : super(
            defaultBrightness: getBrightness(),
            data: (Brightness brightness) => getThemeData(brightness),
            themedWidgetBuilder: builder);


  static bool get dark => getBrightness() == Brightness.dark;

  static _Colors get colors => dark ? UIDataDark.colors : UIDataLight.colors;

  static Brightness getBrightness() {
    return Brightness.light;
  }

  static ThemeData getThemeData(Brightness brightness) {

    return ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(size: 25)),
        brightness: getBrightness(),
        primaryColor: colors.primary,
        textTheme: textTheme);
  }

  static Color complementColor(Color color) {
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  static changeBrightness(BuildContext context) {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  static TextTheme get textTheme {
    const displayFont = "Comfortaa";
    const bodyFont = "OpenSans";

    final complimentaryColor = colors.color;

    return Typography.englishLike2018.apply(fontFamily: bodyFont).copyWith(
          // display
          headline1: TextStyle(
            fontSize: 64,
            letterSpacing: 6,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor,
          ),
          headline2: TextStyle(
            fontSize: 48,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: dark ? Colors.white : complimentaryColor,
          ),
          headline3: TextStyle(
            fontFamily: displayFont,
            color: complimentaryColor,
          ),
          headline4: TextStyle(
            fontSize: 18,
            letterSpacing: 2,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: dark ? Colors.white : complimentaryColor.withOpacity(0.8),
          ),

          // title
          headline6: TextStyle(
            fontFamily: displayFont,
            letterSpacing: 2,
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: complimentaryColor,
          ),

          subtitle1: TextStyle(
            letterSpacing: 1,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor.withOpacity(0.9),
          ),

          subtitle2: TextStyle(
            height: 0.9,
            fontFamily: bodyFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor,
          ),

          // body
          bodyText1: TextStyle(
            fontSize: 16,
            fontFamily: bodyFont,
            color: complimentaryColor,
          ),

          bodyText2: TextStyle(
            fontSize: 14,
            fontFamily: bodyFont,
            color: complimentaryColor.withOpacity(0.7),
          ),
        );
  }

  static final images = _Images();
  static final sounds = _Sounds();
}

class _Images {
  final String loading = 'assets/images/loading.gif';
  final String logo = 'assets/images/logo.png';
  final String networkError = "assets/images/500.svg";

  final String notFound = "assets/images/404.svg";
  final String upgrade = "assets/images/upgrade.jpg";
  final String wifi = "assets/animations/wifi.flr";

  final String boarding1 = 'assets/images/boarding1.png';
  final String boarding2 = 'assets/images/boarding2.png';
  final String boarding3 = 'assets/images/boarding3.png';
}

abstract class _Colors {
  Color get primary;

  Color get error;

  Color get success;

  Color get price;

  Color get info;

  Color get background;

  Color get background1;

  Color get background2;

  Color get color;

  Color get grey;

  List<Color> get backgroundGradient;

  List<Color> get backgroundGradient1;

  List<Color> get backgroundGradient2;

  Color get bubbleMe;

  @override
  Color get bubbleHim;
}

class _Sounds {
  final String notification = "sounds/notification.mp3";
}
