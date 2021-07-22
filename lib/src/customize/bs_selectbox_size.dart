import 'package:flutter/cupertino.dart';

class BsSelectBoxSize {
  const BsSelectBoxSize({
    this.maxHeight = 300.0,
    this.fontSize = 14.0,
    this.optionFontSize = 14.0,
    this.searchInputFontSize = 14.0,
    this.labelX = 15.0,
    this.labelY = 0.0,
    this.transitionLabelX = -8.0,
    this.transitionLabelY = 45,
    this.padding = const EdgeInsets.all(14.0),
    this.paddingWrapper = const EdgeInsets.all(10.0)
  });

  final double maxHeight;

  /// define padding of [BsSelectBox]
  final EdgeInsetsGeometry padding;

  /// define padding of [BsSelectBox]
  final EdgeInsetsGeometry paddingWrapper;

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
