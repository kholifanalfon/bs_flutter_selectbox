import 'dart:async';

import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:bs_flutter_selectbox/src/utils/bs_selectbox_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BsWrapperOptions extends StatefulWidget {

  BsWrapperOptions({
    Key? key,
    required this.containerKey,
    required this.link,
    required this.size,
    required this.offset,
    required this.noDataText,
    required this.placeholderSearch,
    required this.selectBoxStyle,
    required this.selectBoxSize,
    required this.selectBoxController,
    required this.onChange,
    this.searchable = false,
    this.onSearch,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BsWrapperOptionsState();
  }

  final Size size;

  final Offset offset;

  final bool? searchable;

  final LayerLink link;

  final String noDataText;

  final String placeholderSearch;

  final GlobalKey<State> containerKey;

  final BsSelectBoxStyle selectBoxStyle;

  final BsSelectBoxSize selectBoxSize;

  final BsSelectBoxController selectBoxController;

  final ValueChanged<String>? onSearch;

  final ValueChanged<BsSelectBoxOption> onChange;
}

class _BsWrapperOptionsState extends State<BsWrapperOptions> {

  late double _overlayTop;
  late double _overlayWidth;

  late FocusNode _focusNode;
  late TextEditingController _controller;

  Timer? _timer;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(onFocus);
    _focusNode.requestFocus();

    _controller = TextEditingController();

    _overlayTop = widget.size.height + 2;
    _overlayWidth = widget.size.width;
    super.initState();
  }

  void onFocus() => setState(() {});

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void doneTyping(dynamic value, ValueChanged<dynamic> callback) {
    if(_timer != null)
      _timer!.cancel();

    _timer = Timer(Duration(milliseconds: 300), () => callback(value));
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 100), () {
      RenderBox renderBox = widget.containerKey.currentContext!.findRenderObject() as RenderBox;
      if(mounted && (_overlayTop != renderBox.size.height + 2 || _overlayWidth != renderBox.size.width)) {
        setState(() {
          _overlayTop = renderBox.size.height + 2;
          _overlayWidth = renderBox.size.width;
        });
      }
    });

    double _heightDialog = 250.0;
    double itemHeight = 0;

    widget.selectBoxController.options.map((e) {
      itemHeight += 37.0;
    }).toList();

    if(itemHeight <= _heightDialog)
      _heightDialog = itemHeight;

    double maxScreen = MediaQuery.of(context).size.height - 20.0;
    if(widget.offset.dy + widget.size.height + _heightDialog > maxScreen)
      _overlayTop = -(_heightDialog + widget.size.height + 25.0);

    return Stack(
      children: [
        Positioned(
          width: _overlayWidth,
          child: CompositedTransformFollower(
            link: widget.link,
            showWhenUnlinked: false,
            offset: Offset(0.0, _overlayTop),
            child: Material(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: widget.selectBoxStyle.borderColor),
                  borderRadius: widget.selectBoxStyle.borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8.0,
                      spreadRadius: 0.0,
                      offset: Offset(2.0, 2.0)
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !widget.searchable! ? Container() : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: widget.selectBoxStyle.borderColor),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: widget.placeholderSearch,
                            hintStyle: TextStyle(fontSize: widget.selectBoxSize.searchInputFontSize),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12.0),
                            isDense: true,
                          ),
                          onChanged: (value) => doneTyping(value, (value) {
                            if(widget.onSearch != null)
                              widget.onSearch!(value);
                          }),
                        )
                    ),
                    !widget.selectBoxController.processing ? Container() : Center(
                      child: Container(
                          padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 5.0, bottom: 5.0),
                          margin: EdgeInsets.only(top: 8.0),
                          child: Text("Memproses ...", style: TextStyle(
                              fontSize: widget.selectBoxSize.optionFontSize,
                              fontWeight: FontWeight.w100,
                              fontStyle: FontStyle.italic
                          ))
                      ),
                    ),
                    widget.selectBoxController.processing || widget.selectBoxController.options.length != 0 ? Container() : Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 8.0),
                        padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 5.0, bottom: 5.0),
                        child: Text(widget.noDataText, style: TextStyle(
                          fontSize: widget.selectBoxSize.optionFontSize,
                          fontWeight: FontWeight.w100,
                          fontStyle: FontStyle.italic
                        ))
                      ),
                    ),
                    widget.selectBoxController.processing || widget.selectBoxController.options.length == 0 ? Container() : Container(
                      height: _heightDialog,
                      margin: EdgeInsets.only(top: 5.0),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.selectBoxController.options.map((option) {
                              Color color = Colors.white;
                              if(widget.selectBoxController.getSelected() != null) {
                                int index = widget.selectBoxController.getSelectedAll().indexWhere((element) => element.value == option.value);
                                if (index != -1)
                                  color = Color(0xfff1f1f1);
                              }

                              return Row(
                                children: [
                                  Expanded(child: Container(
                                    margin: EdgeInsets.only(bottom: 2.0),
                                    child: TextButton(
                                      onPressed: () {
                                        widget.onChange(option);
                                        _focusNode.unfocus();
                                        setState(() {
                                        });
                                      },
                                      style: TextButton.styleFrom(backgroundColor: color),
                                      child: DefaultTextStyle(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: widget.selectBoxSize.optionFontSize
                                        ),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0, bottom: 10.0),
                                          child: option.text,
                                        ),
                                      ),
                                    ),
                                  ))
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

}