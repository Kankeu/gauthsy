import 'dart:math';
import 'package:flutter/cupertino.dart';
import '../../constants/constants.dart';
import '../../on_boarding_ui.dart';
import '../../model/slider.dart' as SliderModel;


class SlideItem extends StatelessWidget {
  final List<SliderModel.Slider> slides;

  final int index;

  const SlideItem(this.slides, this.index);


  @override
  Widget build(BuildContext context) {
    final minSize = min(MediaQuery
        .of(context)
        .size
        .width, MediaQuery
        .of(context)
        .size
        .height);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: minSize * 0.6,
          width: minSize * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(slides[index].sliderImageUrl))),
        ),
        SizedBox(
          height: 60.0,
        ),
        Text(
          slides[index].sliderHeading,
          style: TextStyle(
            fontFamily: Constants.POPPINS,
            fontWeight: FontWeight.w700,
            fontSize: 20.5,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              slides[index].sliderSubHeading,
              style: TextStyle(
                fontFamily: Constants.OPEN_SANS,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 12.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        )
      ],
    );
  }
}
