import 'package:flutter/cupertino.dart';

class BsSelectBoxOption {

  const BsSelectBoxOption({
    required this.value,
    required this.text,
    String? searchable,
    this.other,
  }) : _searchable = searchable;

  final dynamic value;

  final Widget text;

  final dynamic other;

  final String? _searchable;

  String get searchable => _searchable != null ? _searchable! : value.toString();
}