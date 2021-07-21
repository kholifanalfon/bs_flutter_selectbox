import 'dart:async';

import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:bs_flutter_selectbox/src/utils/bs_selectbox_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wrapper overlay of options
class BsWrapperOptions extends StatefulWidget {
  /// Constructor of BsWrapperOptions
  BsWrapperOptions({
    Key? key,
    required this.containerKey,
    required this.link,
    required this.noDataText,
    required this.placeholderSearch,
    required this.selectBoxStyle,
    required this.selectBoxSize,
    required this.selectBoxController,
    required this.onChange,
    required this.onClose,
    required this.containerMargin,
    this.searchable = false,
    this.onSearch,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BsWrapperOptionsState();
  }

  /// define searchable of [BsSelectBox]
  final bool? searchable;

  /// Used so that the overlay wrapper follows the select box
  final LayerLink link;

  /// define no data found text
  final String noDataText;

  /// placeholder search input
  final String placeholderSearch;

  /// To get updated size of [BsSelectBox]
  final GlobalKey<State> containerKey;

  /// define style of [BsWrapperOption] below of [BsSelectBox]
  final BsSelectBoxStyle selectBoxStyle;

  /// define size of [BsWrapperOption] below of [BsSelectBox]
  final BsSelectBoxSize selectBoxSize;

  /// define controller of [BsWrapperOption] below of [BsSelectBox]
  final BsSelectBoxController selectBoxController;

  /// define on search action of [BsWrapperOption] below of [BsSelectBox]
  final ValueChanged<String>? onSearch;

  /// define on change action of [BsWrapperOption] below of [BsSelectBox]
  final ValueChanged<BsSelectBoxOption> onChange;

  final VoidCallback onClose;

  final EdgeInsets containerMargin;
}

class _BsWrapperOptionsState extends State<BsWrapperOptions> {

  GlobalKey<State> _key = GlobalKey<State>();
  GlobalKey<State> _keyAll = GlobalKey<State>();

  late FocusNode _focusNode;
  late TextEditingController _controller;

  late Size _size;
  late Offset _offset;

  double _overlayTop = 0;
  double _overlayHeight = 0;

  Timer? _timer;

  bool _done = false;

  @override
  void initState() {
    _focusNode = FocusNode(onKey: (node, event) {
      if(event.logicalKey == LogicalKeyboardKey.escape)
        widget.onClose();

      return false;
    });
    _focusNode.addListener(onFocus);
    _focusNode.requestFocus();

    _controller = TextEditingController();

    RenderBox renderBox = widget.containerKey.currentContext!.findRenderObject() as RenderBox;
    _size = renderBox.size;
    _offset = renderBox.localToGlobal(Offset.zero);
    super.initState();
  }

  void onFocus() => updateState(() {});

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void doneTyping(dynamic value, ValueChanged<dynamic> callback) {
    if (_timer != null) _timer!.cancel();

    _timer = Timer(Duration(milliseconds: 300), () => callback(value));
  }

  void updateState(VoidCallback function) {
    if(mounted)
      setState(() {
        function();
      });
  }

  void _checkHeight() {
    Future.delayed(Duration(milliseconds: 100), () {
      /// Getting source size and offset from container toggle

      RenderBox renderBoxAll = _keyAll.currentContext!.findRenderObject() as RenderBox;
      Size sizeAll = renderBoxAll.size;

      RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      Size screenSize = MediaQuery.of(context).size;

      _overlayHeight = size.height;
      _overlayTop = _size.height + 2.0;

      Offset overlayMaxPosition = Offset(_offset.dx + _size.width + size.width, _offset.dy + _size.height + _overlayHeight);

      double topHeight = _offset.dy + _size.height - 10;
      double bottomHeight = screenSize.height - (_offset.dy + 10);

      if(overlayMaxPosition.dy > screenSize.height) {
        if (bottomHeight > topHeight) {
          if (bottomHeight > widget.selectBoxSize.maxHeight)
            _overlayHeight = widget.selectBoxSize.maxHeight;
          else
            _overlayHeight = bottomHeight;
        }

        else {
          if(size.height <= widget.selectBoxSize.maxHeight)
            _overlayHeight = size.height;
          else if (topHeight > widget.selectBoxSize.maxHeight)
            _overlayHeight = widget.selectBoxSize.maxHeight;
          else
            _overlayHeight = topHeight;

          _overlayTop = -sizeAll.height - 2;
        }
      }

      else {
        if(size.height > widget.selectBoxSize.maxHeight)
          _overlayHeight = widget.selectBoxSize.maxHeight;
      }

      updateState(() {
        _done = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!_done)
      _checkHeight();

    return Opacity(
      opacity: _done ? 1 : 0,
      child: Container(
        child: Stack(
          children: [
            Positioned(
              child: CompositedTransformFollower(
                link: widget.link,
                showWhenUnlinked: false,
                offset: Offset(0, _overlayTop),
                child: Column(
                  children: [
                    Material(
                      child: Container(
                        key: _keyAll,
                        width: _size.width,
                        padding: widget.selectBoxSize.paddingWrapper,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: widget.selectBoxStyle.border,
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
                          children: [
                            !widget.searchable! ? Container() : Container(
                              margin: EdgeInsets.only(bottom: 5.0),
                              decoration: BoxDecoration(
                                border: widget.selectBoxStyle.border,
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: TextField(
                                focusNode: _focusNode,
                                controller: _controller,
                                decoration: InputDecoration(
                                  hintText: widget.placeholderSearch,
                                  hintStyle: TextStyle(
                                      fontSize: widget.selectBoxSize.searchInputFontSize
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(12.0),
                                  isDense: true,
                                ),
                                onChanged: (value) => doneTyping(value, (value) {
                                  if (widget.onSearch != null)
                                    widget.onSearch!(value);
                                }),
                              )
                            ),
                            !widget.selectBoxController.processing ? Container() : Center(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
                                margin: EdgeInsets.only(top: 8.0),
                                child: Text("Memproses ...",
                                  style: TextStyle(
                                    fontSize: widget.selectBoxSize.optionFontSize,
                                    fontWeight: FontWeight.w100,
                                    fontStyle: FontStyle.italic
                                  )
                                )
                              ),
                            ),
                            widget.selectBoxController.processing || widget.selectBoxController.options.length != 0 ? Container() : Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 8.0),
                                padding: EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
                                child: Text(widget.noDataText,
                                  style: TextStyle(
                                    fontSize: widget.selectBoxSize.optionFontSize,
                                    fontWeight: FontWeight.w100,
                                    fontStyle: FontStyle.italic
                                  )
                                )
                              ),
                            ),
                            widget.selectBoxController.processing || widget.selectBoxController.options.length == 0 ? Container(key: _key) : Container(
                              key: _key,
                              height: _overlayHeight == 0 ? null : _overlayHeight,
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: widget.selectBoxController.options.map((option) {
                                      Color color = Colors.white;
                                      if (widget.selectBoxController.getSelected() != null) {
                                        int index = widget.selectBoxController.getSelectedAll()
                                            .indexWhere((element) => element.getValue() == option.getValue());

                                        if (index != -1)
                                          color = Color(0xfff1f1f1);
                                      }

                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(bottom: 2.0),
                                              child: Material(
                                                color: color,
                                                borderRadius: BorderRadius.circular(5.0),
                                                child: InkWell(
                                                    onTap: () {
                                                      widget.onChange(option);
                                                      _focusNode.unfocus();
                                                      updateState(() {});
                                                    },
                                                    child: DefaultTextStyle(
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: widget.selectBoxSize.optionFontSize
                                                      ),
                                                      child: Container(
                                                        alignment: Alignment.centerLeft,
                                                        padding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                                                        child: option.getText(),
                                                      ),
                                                    ),
                                                    borderRadius: BorderRadius.circular(5.0)
                                                ),
                                              ),
                                            )
                                          )
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
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
