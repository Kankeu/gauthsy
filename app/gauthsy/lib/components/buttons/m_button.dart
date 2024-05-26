part of buttons;

class MButton extends StatelessWidget {
  final Key key;
  final bool tile;
  final bool undo;
  final bool loading;
  final bool disabled;
  final String hint;
  final double depth;
  final Color color;
  final bool outline;
  final double width;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Function onPressed;
  final String badgeContent;

  MButton({
    @required this.onPressed,
    @required this.hint,
    this.undo = false,
    this.depth,
    this.color,
    this.tile = false,
    this.outline = false,
    this.margin,
    this.padding,
    this.width,
    this.key,
    this.badgeContent,
    this.disabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      position: BadgePosition(start: 10,top: -10),
      badgeColor: NeumorphicTheme.variantColor(context),
      showBadge: badgeContent!=null,
      badgeContent:badgeContent!=null? Text(badgeContent,style: TextStyle(color: Colors.white)):null,
      child: NeumorphicButton(
        key: key,
      onPressed: loading || disabled ? null : () => call(onPressed),
      style: NeumorphicStyle(
        color: outline ? null : color,
        depth: loading
            ? NeumorphicTheme.depth(context)
            : (depth ?? NeumorphicTheme.depth(context)),
        border: NeumorphicBorder(
            color: color ?? NeumorphicTheme.accentColor(context)),
        boxShape:
            tile ? NeumorphicBoxShape.rect() : NeumorphicBoxShape.stadium(),
      ),
      margin: margin,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        width: width ?? double.infinity,
        child: loading
            ? NeumorphicProgressIndeterminate(
                style: ProgressStyle(depth: 0),
              )
            : Text(
                hint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: outline ? color : color.complement(),
                ),
              ),
      )),
    );
  }

  bool can = true;
  bool lock = false;

  void call(VoidCallback next) {
    if (!undo) return next();
    if (!lock) {
      lock = true;
      MFlushBar.flushBarUndo(onTap: () {
        MToast.success("Undo");
        can = false;
      });
      Future.delayed(Duration(seconds: 3), () async {
        if (can) next();
        can = true;
        lock = false;
      });
    }
  }
}
