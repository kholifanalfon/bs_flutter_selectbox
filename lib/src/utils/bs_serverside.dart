import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';

typedef BsRenderText = Widget Function(dynamic data);
typedef BsSetOptionValue = dynamic Function(dynamic data);
typedef BsSelectBoxServerSide = Future<BsSelectBoxResponse> Function(Map<String, String> params);

class BsSelectBoxResponse {

  const BsSelectBoxResponse({
    this.options = const [],
  });

  final List<BsSelectBoxOption> options;

  factory BsSelectBoxResponse.createFromJson(List map, {BsSetOptionValue? value, BsRenderText? renderText}) {
    return BsSelectBoxResponse(
      options: map.map((e) {
        return BsSelectBoxOption(value: value == null ? e['value'] : value(e), text: renderText == null ? Text(e['text']) : renderText(e));
      }).toList()
    );
  }
}