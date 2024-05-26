part of images;

class Avatar extends StatelessWidget {
  final Widget child;
  final String path;
  final bool tile;
  final bool isFile;
  final bool isAsset;
  final double height;
  final double width;
  final BoxFit fit;
  final Color borderColor;

  Avatar({
 this.path,
 this.child,
    this.tile = false,
    this.height,
    this.borderColor,
    this.width,
    this.isAsset = false,
    this.isFile = false,
    this.fit = BoxFit.cover,
  }): assert(child!=null||path!=null);

  Widget get _image => isAsset
      ? Image.asset(path, fit: BoxFit.cover)
      : isFile
          ? Image.file(File(path), fit: BoxFit.cover)
          : Image.network(path, fit: fit, headers: graphql.headers);

  GraphQl get graphql => Kernel.Container().get("graphql");

  @override
  Widget build(BuildContext context) {
    print(graphql.headers);
    return tile
        ? Container(
            width: width,
            height: height,
            child: child??_image,
          )
        : circleAvatar(context);
  }

  Widget circleAvatar(context) {
    return Container(
      width: width,
      height: height,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: borderColor ?? Colors.white,
            width: 3.0,
          ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black12,
              ])),
      child: Neumorphic(
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            depth: NeumorphicTheme.embossDepth(context),
          ),
          child: child??new ClipOval(
            child: _image,
          )),
    );
  }
}
