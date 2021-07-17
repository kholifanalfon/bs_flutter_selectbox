import 'package:bs_flutter_utils/bs_flutter_utils.dart';
import 'package:flutter/material.dart';

class BsSelectBoxStyle {
  const BsSelectBoxStyle({
    this.borderRadius = const BorderRadius.all(Radius.circular(5.0)),
    this.fontSize = 12.0,
    this.selectedBackgroundColor = const Color(0xfff1f1f1),
    this.selectedColor = const Color(0xff212529),
    this.color = const Color(0xff212529),
    this.placeholderColor = Colors.grey,
    this.border,
    this.disabledBackgroundColor = const Color(0xffe7e7e7),
    this.backgroundColor = Colors.white,
    this.arrowIcon = Icons.arrow_drop_down,
    this.boxShadowFocused = const [],
  });

  /// define border radius of [BsSelectBox]
  final BorderRadiusGeometry? borderRadius;

  /// define color of [BsSelectBox]
  final Color color;

  /// define placeholderColor of [BsSelectBox]
  final Color placeholderColor;

  /// define selectedBackgroundColor of [BsSelectBox]
  final Color selectedBackgroundColor;

  /// define selectedColor of [BsSelectBox]
  final Color selectedColor;

  /// define of disabledBackgroundColor of [BsSelectBox]
  final Color disabledBackgroundColor;

  /// define of backgroundColor of [BsSelectBox]
  final Color backgroundColor;

  /// define borderColor of [BsSelectBox]
  final BoxBorder? border;

  /// define fontSize of [BsSelectBox]
  final double fontSize;

  /// defien arrowIcon of [BsSelectBox]
  final IconData arrowIcon;

  final List<BoxShadow> boxShadowFocused;

  static const BsSelectBoxStyle bordered = BsSelectBoxStyle(
    border: Border(
      top: BorderSide(color: BsColor.borderColor),
      bottom: BorderSide(color: BsColor.borderColor),
      left: BorderSide(color: BsColor.borderColor),
      right: BorderSide(color: BsColor.borderColor),
    ),
    boxShadowFocused: [
      BoxShadow(
        color: BsColor.primaryShadow,
        offset: Offset(0, 0),
        spreadRadius: 2.5,
      )
    ]
  );
}
