part of buttons;

class MButtonText extends StatelessWidget {
  final String hint;
  final bool loading;
  final Function onPressed;
  final bool inline;
  final TextStyle textStyle;

  MButtonText(
      {@required this.onPressed,
      @required this.hint,
      this.textStyle,
      this.inline = true,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? NeumorphicProgressIndeterminate(
            style: ProgressStyle(depth: 0),
          )
        : Text(hint,
            style: TextStyle(
                    color: NeumorphicTheme.accentColor(context),
                    decoration: TextDecoration.underline)
                .merge(textStyle));

    return inline
        ? GestureDetector(
            onTap: onPressed,
            child: child,
          )
        : TextButton(onPressed: onPressed, child: child);
  }
}
