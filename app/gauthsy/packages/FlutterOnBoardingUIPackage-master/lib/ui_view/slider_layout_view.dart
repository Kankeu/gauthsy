import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../on_boarding_ui.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../constants/constants.dart';
import '../widgets/slide_dots.dart';
import '../widgets/slide_items/slide_item.dart';

class SliderLayoutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) async {
    if (await Configs.getInstance().onChange(index))
      setState(() {
        _currentPage = index;
      });
    else
      setState(() {
        _pageController.jumpToPage(index - 1);
      });
  }

  @override
  Widget build(BuildContext context) => topSliderLayout();

  Widget topSliderLayout() {
    var slides = Configs.getInstance().slides;
    return Container(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: slides.length,
                itemBuilder: (ctx, i) => SlideItem(slides, i),
              ),
              Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  Align(
                      alignment: Alignment.bottomRight,
                      child: NeumorphicButton(
                        onPressed: () {
                          if (_pageController.page.floor() !=
                              slides.length - 1) {
                            _pageController.jumpToPage(_currentPage + 1);
                          } else {
                            Configs.getInstance().onFinish();
                          }
                        },
                        style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.circle()),
                        padding: const EdgeInsets.all(12.0),
                        child: _currentPage + 1 == slides.length
                            ? Icon(Icons.check, size: 40)
                            : Icon(Icons.navigate_next, size: 40),
                      )),
                  if(_currentPage>0)
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: NeumorphicButton(
                        onPressed:() {
                          _pageController.jumpToPage(_currentPage - 1);
                        },
                        style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.circle()),
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(Icons.navigate_before, size: 40),
                      )),
                  Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < slides.length; i++)
                          if (i == _currentPage)
                            SlideDots(true)
                          else
                            SlideDots(false)
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
