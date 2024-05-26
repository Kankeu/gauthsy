part of buttons;


class MIconButton extends StatelessWidget {
  final bool undo;
  final bool loading;
  final bool disabled;
  final Icon icon;
  final Function onPressed;
  final NeumorphicStyle style;
  final bool inline;

  MIconButton({
    @required this.onPressed,
    this.undo = false,
    this.style,
    this.inline=false,
    @required    this.icon,
    this.disabled = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return
      loading&&inline
          ? DoubleBounce() : NeumorphicButton(
        style: style??NeumorphicStyle(
            boxShape:
            NeumorphicBoxShape.circle()),
        onPressed: loading || disabled ? null : () => call(onPressed),
        child: loading
            ? DoubleBounce()
            : icon,
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
