part of buttons;


class CopyButton extends StatefulWidget {
  final String value;

  CopyButton({@required this.value});

  @override
  _CopyButtonState createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.value==null?null:() {
        Clipboard.setData(new ClipboardData(text: widget.value));
        MToast.success("Copied");
      },
      child: Icon(Icons.content_copy, color: Colors.grey),
    );
  }
}