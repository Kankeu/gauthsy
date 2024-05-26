import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/views/scanner/controller_scanner.dart';

import 'image_scanner_animation.dart';

class CameraOverlay extends StatefulWidget {
  final String title;
  final bool scanning;
  final ControllerScanner controllerScanner;

  const CameraOverlay(
      {Key key,
      this.child,
      @required this.title,
      @required this.scanning,
      @required this.controllerScanner})
      : super(key: key);

  static const _documentFrameRatio =
      1.42; // Passport's size (ISO/IEC 7810 ID-3) is 125mm × 88mm
  final Widget child;
  static RRect sRect;

  @override
  _CameraOverlayState createState() => _CameraOverlayState();

  static List<double> pos = [];

  static getPos() {
    return pos;
  }
}

class _CameraOverlayState extends State<CameraOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _animationStopped = false;

  double get height => MediaQuery.of(context).size.height;

  @override
  void initState() {
    _animationController = new AnimationController(
        duration: new Duration(seconds: 1), vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    animateScanAnimation(false);
    super.initState();
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: .9);
    } else {
      _animationController.forward(from: 0.1);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final overlayRect =
            _calculateOverlaySize(Size(c.maxWidth, c.maxHeight));
        return Stack(
          children: [
            widget.child,
            if(widget.controllerScanner.step<=3)
              ClipPath(
              clipper: _DocumentClipper(rect: overlayRect),
              child: Container(
                foregroundDecoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.45),
                ),
              ),
            ),
            if(widget.controllerScanner.step<=3)
            _WhiteOverlay(
                rect: overlayRect,
                child: Stack(
                  children: [
                    if (widget.scanning)
                      ImageScannerAnimation(
                        _animationStopped,
                        overlayRect.height,
                        overlayRect.width,
                        animation: _animationController,
                      )
                  ],
                )),
          ],
        );
      },
    );
  }

  RRect _calculateOverlaySize(Size size) {
    double width, height;
    print(
        "---------------width: ${size.width} height: ${size.height}--------------");
    // if (size.height > size.width) {
    if (widget.controllerScanner.step != 3) {
      width = size.width * 0.9;
      height = width / CameraOverlay._documentFrameRatio;
    } else {
      width = size.width * 0.75;
      height = size.height/2.3;
    }

    /*  } else {
      height = size.height * 0.75;
      width = height * CameraOverlay._documentFrameRatio;
    }*/
    final topOffset = (size.height - height) / 3;
    final leftOffset = (size.width - width) / 2;
    CameraOverlay.pos.clear();
    CameraOverlay.pos.add(leftOffset);
    CameraOverlay.pos.add(topOffset);
    CameraOverlay.pos.add(width);
    CameraOverlay.pos.add(height);
    CameraOverlay.pos.add(size.width);
    CameraOverlay.pos.add(size.height);
    CameraOverlay.pos.add(MediaQuery.of(context).devicePixelRatio);

    final rect = RRect.fromLTRBR(leftOffset, topOffset, leftOffset + width,
        topOffset + height, const Radius.circular(8));
    CameraOverlay.sRect = rect;
    return rect;
  }
}

class _DocumentClipper extends CustomClipper<Path> {
  _DocumentClipper({this.rect});

  final RRect rect;

  @override
  Path getClip(Size size) => Path()
    ..addRRect(rect)
    ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
    ..fillType = PathFillType.evenOdd;

  @override
  bool shouldReclip(_DocumentClipper oldClipper) => true;
}

class _WhiteOverlay extends StatelessWidget {
  const _WhiteOverlay({Key key, this.rect, this.child}) : super(key: key);
  final RRect rect;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rect.left,
      top: rect.top,
      child: Container(
        width: rect.width,
        height: rect.height,
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: const Color(0xFFFFFFFF)),
          borderRadius: BorderRadius.all(rect.tlRadius),
        ),
        child: child,
      ),
    );
  }
}
