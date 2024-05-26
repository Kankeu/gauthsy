part of times;

class TimeAfter extends StatefulWidget {
  final String date;

  final bool detailed;

  final TextStyle textStyle;

  TimeAfter({@required this.date, this.detailed = false, this.textStyle});

  @override
  _TimeAfterState createState() => _TimeAfterState();
}

class _TimeAfterState extends State<TimeAfter> {
  bool get dark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final dateAfterFormatter = DateAfterFormatter(widget.date);
    return Text(
        widget.detailed
            ? dateAfterFormatter.detailedText()
            : dateAfterFormatter.smallText(),
        style: widget.textStyle);
  }
}

class DateAfterFormatter {
  final String date;

  DateAfterFormatter(this.date);

  List<String> get days => [
        'Mon.',
        'Tue.',
        'Wed.',
        'Thu.',
        'Fri.',
        'Sat.',
        'Sun.',
      ];

  DateTime get dateParsed =>
      date == null ? null : DateTime.parse(this.date).toLocal();

  List<String> get months => [
        'Jan.',
        'Feb.',
        'Mar.',
        'Apr.',
        'May',
        'June',
        'July',
        'Aug.',
        'Sept.',
        'Oct.',
        'Nov.',
        'Dec.'
      ];

  String smallText() {
    final Duration duration = dateParsed.difference(DateTime.now());
    if (duration.inDays == 0) return DateFormat('HH:mm').format(dateParsed);
    if (duration.inDays ~/ 30 >= 1)
      return "In " +
          (duration.inDays ~/ 30).toString() +
          " ${'month'.pluralIf(duration.inDays ~/ 30)}";
    if (duration.inDays ~/ 7 >= 1)
      return "In " +
          (duration.inDays ~/ 7).toString() +
          " ${'week'.pluralIf(duration.inDays ~/ 7)}";
    return "In " +
        duration.inDays.toString() +
        " ${'day'.pluralIf(duration.inDays)}";
  }

  String detailedText() {
    final Duration duration = dateParsed.difference(DateTime.now());
    final DateTime date = dateParsed;
    if (duration.inDays == 0) return DateFormat('HH:mm').format(dateParsed);
    if (duration.inDays <= 7)
      return "${days[date.weekday - 1]} at ${NumberFormat("###00").format(date.hour)}:${NumberFormat("###00").format(date.minute)}";
    return "${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]} ${date.year} at ${NumberFormat("###00").format(date.hour)}:${NumberFormat("###00").format(date.minute)}";
  }
}
