import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model/slider.dart' as SliderModel;
import 'screens/landing_page.dart';

class Configs {
  static Configs _instance;
  final List<SliderModel.Slider> slides;
  final Function onFinish;
  final Future<bool> Function(int) onChange;

  Configs(this.slides, this.onFinish, this.onChange);

  static Configs getInstance({List<SliderModel.Slider> slides,Function onFinish, Function(int) onChange}) {
    if(_instance == null){
      _instance = Configs(slides,onFinish,  onChange);
    }

    return _instance;
  }

   // rest of the class
}


class OnBoardingUi extends StatelessWidget{
  final List<SliderModel.Slider> slides;
  final Function onFinish;
  final Future<bool> Function(int) onChange;

  OnBoardingUi({@required this.slides,@required this.onFinish, @required this.onChange});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    Configs.getInstance(slides: slides,onFinish: onFinish, onChange: onChange);

    return  LandingPage();
  }

}
