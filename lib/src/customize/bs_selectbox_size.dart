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

  final EdgeInsetsGeometry padding;

  final double? fontSize;

  final double? searchInputFontSize;

  final double? optionFontSize;

  final double labelX;

  final double labelY;

  final double transitionLabelX;

  final double transitionLabelY;

  static const BsSelectBoxSize customSize = BsSelectBoxSize(
    fontSize: 14.0,
    optionFontSize: 14.0,
    searchInputFontSize: 14.0,
    labelX: 15.0,
    labelY: 13.0,
    transitionLabelX: -15.0,
    transitionLabelY: 5.0,
    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 12.0)
  );
}