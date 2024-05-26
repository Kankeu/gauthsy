import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:gauthsy/views/starting/starting.dart';
import 'package:flutter/material.dart';
import 'package:on_boarding_ui/on_boarding_ui.dart';
import 'package:on_boarding_ui/model/slider.dart' as SliderModel;

class Boarding extends StatefulWidget {
  @override
  _BoardingState createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingUi(
          slides: [
            SliderModel.Slider(
              sliderHeading: "Identity verification",
              sliderSubHeading:
                  "You need a quick and easy identity verification solution, available anytime and anywhere, while not comprising on security and usability? Our AI-POWERED Identity verification  gives you the best of both worlds.",
              sliderImageUrl: UIData.images.boarding1,
            ),
            SliderModel.Slider(
              sliderHeading: "Scan your ID-Card",
              sliderSubHeading:
              "Scan your identity card or other identification document on both sides",
              sliderImageUrl: UIData.images.boarding2,
            ),
            SliderModel.Slider(
              sliderHeading: "Scan your face",
              sliderSubHeading:
                  "Then scan your face. Your identification is complete",
              sliderImageUrl: UIData.images.boarding3,
            )
          ],
          onFinish: () async {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => Starting()));
          },
          onChange: (i) async {

            return true;
          }),
    );
  }
}
