part of ui_data;

class UIDataDark {
  static final _ColorsDark colors = _ColorsDark();
}

class _ColorsDark implements _Colors {
  @override
  Color get primary => Color(0xff1c3144);

  @override
  Color get info => Colors.lightBlue;

  @override
  Color get background => backgroundGradient[0];

  @override
  Color get background1 => backgroundGradient[1];

  @override
  Color get background2 => backgroundGradient[1];

  @override
  List<Color> get backgroundGradient => [Colors.black, Color(0xff17233d)];

  @override
  List<Color> get backgroundGradient1 => [Colors.black, Color(0xff17233d)];

  @override
  List<Color> get backgroundGradient2 => [
        Colors.lightBlue,
        Colors.blueAccent,
      ];

  @override
  Color get error => Colors.red;

  @override
  Color get success => Colors.green;

  @override
  Color get price => Colors.green;

  @override
  Color get color =>
      background.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  @override
  Color get grey => Colors.grey.shade100;

  @override
  Color get bubbleMe => Colors.greenAccent.shade100;

  @override
  Color get bubbleHim => Colors.white;
}
