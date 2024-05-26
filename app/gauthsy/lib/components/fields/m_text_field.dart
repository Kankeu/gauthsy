part of fields;

class MTextField extends StatefulWidget {
  final String label;
  final String hint;
  final int maxLength;
  final String value;
  final bool autofocus;
  final bool clearable;
  final bool isPassword;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final Function validator;
  final TextInputType keyboardType;

  final ValueChanged<String> onChanged;

  final TextEditingController controller;

  MTextField({
    @required this.hint,
    this.label,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    @required this.value,
    this.isPassword = false,
    this.autofocus=false,
    this.clearable = false,
    this.validator,
    this.onChanged,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  _MTextFieldState createState() => _MTextFieldState();
}

class _MTextFieldState extends State<MTextField> {
  bool obscureText = false;
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.isPassword!=true&&widget.value != null && controller.text != widget.value&&widget.controller==null)
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {controller.value = TextEditingValue(text: widget.value);});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            widget.label ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        Neumorphic(
          margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
          style: NeumorphicStyle(
            depth: NeumorphicTheme.embossDepth(context),
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
          ),
          child: TextFormField(
              validator: widget.validator,
              maxLength: widget.maxLength,
              keyboardType: widget.keyboardType,
              obscureText: obscureText,
              controller: controller,
              maxLines: widget.keyboardType==TextInputType.multiline?6:1,
              minLines: widget.keyboardType==TextInputType.multiline?6:1,
              maxLengthEnforced: true,
              autofocus: widget.autofocus,
              decoration: InputDecoration(
                  counterText: "",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  border: InputBorder.none,
                  hintText: widget.hint,
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon??(widget.clearable
                      ? GestureDetector(
                          onTap: () => controller.clear(),
                          child: Icon(Icons.clear),
                        )
                      : !widget.isPassword
                          ? null
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: Icon(obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )))),
        )
      ],
    );
  }

  @override
  void initState() {
    obscureText = widget.isPassword;
    if(widget.controller!=null)
    controller=widget.controller;
    if (widget.value != null)
      controller.value = TextEditingValue(text: widget.value);
    controller.addListener(() {
      widget.onChanged(controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
