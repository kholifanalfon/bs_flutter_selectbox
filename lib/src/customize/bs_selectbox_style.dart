import 'package:flutter/material.dart';

class BsSelectBoxStyle {

  const BsSelectBoxStyle({
    this.borderRadius,
    this.fontSize = 12.0,
    this.selectedBackgroundColor = const Color(0xfff1f1f1),
    this.selectedColor = const Color(0xff212529),
    this.color = const Color(0xff212529),
    this.placeholderColor = Colors.grey,
    this.borderColor = const Color(0xffdee2e6),
    this.disabledBackgroundColor = const Color(0xffe7e7e7),
    this.backgroundColor = Colors.white,
    this.arrowIcon = Icons.arrow_drop_down,
  });

  final BorderRadiusGeometry? borderRadius;

  final Color color;

  final Color placeholderColor;

  final Color selectedBackgroundColor;

  final Color selectedColor;

  final Color disabledBackgroundColor;

  final Color backgroundColor;

  final Color borderColor;

  final double fontSize;

  final IconData arrowIcon;

  static const BsSelectBoxStyle outline = BsSelectBoxStyle(
    borderRadius: BorderRadius.all(Radius.circular(5.0))
  );
}