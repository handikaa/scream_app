import 'package:flutter/material.dart';

import '../style.dart';

class StartButton extends TextButton {
  @override
  // ignore: overridden_fields
  late final ButtonStyle style;

  StartButton(
      {super.key,
      required super.onPressed,
      required super.child,
      Color? bgColor,
      TextStyle? textStyle,
      }) {
    style = ButtonStyle(
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 5)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      )),
      backgroundColor: MaterialStateProperty.all(
        bgColor ?? lGred,
      ),
      textStyle: MaterialStateProperty.all(textStyle)
    );
  }
}
