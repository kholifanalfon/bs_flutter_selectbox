import 'package:flutter/cupertino.dart';

class BsSelectBoxSize {

  const BsSelectBoxSize({
    this.fontSize = 14.0,
    this.optionFontSize = 14.0,
    this.searchInputFontSize = 14.0,
    this.labelX = 15.0,
    this.labelY = 13.0,
    this.transitionLabelX = -8.0,
    this.transitionLabelY = 5.0,
    this.padding = const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 12.0),
  });

  /// define padding of [BsSelectBox]
  final EdgeInsetsGeometry padding;

  /// define font size of [BsSelectBox]
  final double? fontSize;

  /// define searchInputFontSize on [BsSelectBox] in [BsWrapperOptions]
  final double? searchInputFontSize;

  /// define optionFontSize of [BsSelectBox]
  final double? optionFontSize;

  /// define label text position x when using hintLabelText
  final double labelX;

  /// define label text position y when using hintLabelText
  final double labelY;

  /// define label text position x when using hintLabelText and have selected value
  final double transitionLabelX;

  /// define label text position y when using hintLabelText and have selected value
  final double transitionLabelY;
}