part of times;


class TimeAgo extends StatefulWidget{

  final String date;

  final TextStyle textStyle;

  TimeAgo({@required this.date, this.textStyle});

  @override
  _TimeAgoState createState() => _TimeAgoState();

}

class _TimeAgoState extends State<TimeAgo>{

  bool get dark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    return Text(timeago.format(DateTime.parse(widget.date), locale: locale.languageCode), style: widget.textStyle ?? TextStyle(color: dark?Colors.white:Colors.black54),);
  }

}