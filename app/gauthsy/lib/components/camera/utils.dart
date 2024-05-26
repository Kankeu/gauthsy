part of cmlv;

Future<CameraDescription> _getCamera(CameraLensDirection dir,
    {front = false}) async {
  return await availableCameras().then(
    (cameras) => cameras.firstWhere(
      (camera) =>
          front ? camera.lensDirection != dir : camera.lensDirection == dir,
      orElse: () => front
          ? (cameras.isNotEmpty ? cameras.last : null)
          : (cameras.isNotEmpty ? cameras.first : null),
    ),
  );
}

Uint8List _concatenatePlanes(List<Plane> planes) {
  final WriteBuffer allBytes = WriteBuffer();
  planes.forEach((plane) => allBytes.putUint8List(plane.bytes));
  return allBytes.done().buffer.asUint8List();
}

FirebaseVisionImageMetadata buildMetaData(
  CameraImage image,
  ImageRotation rotation,
) {
  return FirebaseVisionImageMetadata(
    rawFormat: image.format.raw,
    size: Size(image.width.toDouble(), image.height.toDouble()),
    rotation: rotation,
    planeData: image.planes
        .map(
          (plane) => FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          ),
        )
        .toList(),
  );
}

Future<T> _detect<T>(
  File image,
  HandleDetection<T> handleDetection,
  ImageRotation rotation,
) async {
  //await Future.delayed(Duration(milliseconds: 500));

  /*PC.Image thumbnail = PC.copyCrop(
      PC.Image.fromBytes(
          image.width, image.height, _concatenatePlanes(image.planes)),
      0,0, image.width, image.height);*/
  //canny(thumbnail);

  /*getExternalStorageDirectory().then((value) async {
    final path = value.parent.parent.parent.parent.path + "/mrz/tmp/back.png";
    var file = File(path);
  if (!(await file.exists())) await file.create(recursive: true);
  var jpeg = await CameraImageConverter.convertCameraImageTo(image);
  //await file.writeAsBytes(jpeg);
  print("width: ${image.width} height: ${image.height}");






  double aspectRatio = 0.4873646209386282;
  double width;
  double height;
  //width = image.width * 0.9;
  //height = width / 1.42;


  double scaleX = image.width/CameraOverlay.getPos()[4];
  double scaleY = image.height/CameraOverlay.getPos()[5];

  /*final topOffset = CameraOverlay.getPos()[1]*scaleY ;
  final leftOffset = CameraOverlay.getPos()[0] * scaleX ;
*/
  final topOffset = CameraOverlay.getPos()[1] * scaleY *(image.width/image.height);
  final leftOffset = CameraOverlay.getPos()[0] * scaleX * (image.height/image.width);


  width = CameraOverlay.getPos()[2]*scaleX * (image.height/image.width);
  height = CameraOverlay.getPos()[3]*scaleY*(image.width/image.height);


  IMG.Image thumbnail = IMG.copyCrop(
      IMG.decodeImage(jpeg),
      leftOffset.toInt(),
      topOffset.toInt(),
      width.toInt(),
      height.toInt());

  // Save the thumbnail as a PNG.
 await file.writeAsBytes(IMG.encodePng(thumbnail));
  });*/
  /*IMG.Image image = IMG.decodeImage(file.readAsBytesSync());

  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  IMG.Image thumbnail = IMG.copyCrop(
      image,
      faces[0].boundingBox.left.toInt()-18,
      faces[0].boundingBox.top.toInt()-20,
      faces[0].boundingBox.width.toInt()+34,
      faces[0].boundingBox.height.toInt()+40);

  // Save the thumbnail as a PNG.
  File(path)..writeAsBytesSync(IMG.encodePng(thumbnail));*/
  //print("width: ${image.width} height: ${image.height}");
  return handleDetection(
    FirebaseVisionImage.fromFile(image)
   /* FirebaseVisionImage.fromBytes(
      _concatenatePlanes(image.planes),
      buildMetaData(image, rotation),
    ),*/
  );
}

ImageRotation _rotationIntToImageRotation(int rotation) {
  switch (rotation) {
    case 0:
      return ImageRotation.rotation0;
    case 90:
      return ImageRotation.rotation90;
    case 180:
      return ImageRotation.rotation180;
    default:
      assert(rotation == 270);
      return ImageRotation.rotation270;
  }
}

int _rotationImageRotationToInt(ImageRotation rotation) {
  switch (rotation) {
    case ImageRotation.rotation0:
      return 0;
    case ImageRotation.rotation90:
      return 90;
    case ImageRotation.rotation180:
      return 180;
    default:
      assert(rotation == ImageRotation.rotation270);
      return 270;
  }
}
