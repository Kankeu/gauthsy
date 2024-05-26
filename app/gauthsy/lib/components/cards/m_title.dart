import 'package:flutter/material.dart';

class MTitle extends StatelessWidget {
  final String text;

  final String hint;

  final Color color;

  final EdgeInsets padding;

  final EdgeInsets margin;

  final double fontSize;
  final FontWeight fontWeight;

  final TextOverflow overflow;
  final TextAlign textAlign;
  final Color hintColor;

  MTitle(
      {this.text,
      this.hint,
      this.color,
      this.padding = const EdgeInsets.all(15.0),
      this.margin,
        this.hintColor,
      this.overflow = TextOverflow.ellipsis,
      this.fontSize = 17,
      this.fontWeight,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: hint == null
          ? Text(text,
              textAlign: textAlign,
              overflow: overflow,
              style: TextStyle(
                  fontSize: this.fontSize,
                  color: color,
                  fontWeight: fontWeight))
          : Column(
              children: <Widget>[
                Text(text,
                    textAlign: textAlign,
                    overflow: overflow,
                    style: TextStyle(
                        fontSize: this.fontSize,
                        color: color,
                        fontWeight: fontWeight)),
                SizedBox(height: 5),
                Text(hint,
                    textAlign: textAlign,
                    overflow: overflow,
                    style: TextStyle(fontSize: 12, color: hintColor??Colors.grey)),
              ],
            ),
    );
  }
}
