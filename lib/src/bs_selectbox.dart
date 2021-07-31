import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:bs_flutter_selectbox/src/components/bs_wrapper_option.dart';
import 'package:bs_flutter_selectbox/src/customize/bs_dialogbox_style.dart';
import 'package:bs_flutter_selectbox/src/utils/bs_selectbox_controller.dart';
import 'package:bs_flutter_selectbox/src/utils/bs_serverside.dart';
import 'package:bs_flutter_utils/bs_flutter_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'customize/bs_selectbox_size.dart';
export 'customize/bs_selectbox_style.dart';
export 'utils/bs_overlay.dart';

class BsSelectBox extends StatefulWidget {
  const BsSelectBox({
    Key? key,
    required this.controller,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(12.0),
    this.focusNode,
    this.hintText,
    this.hintTextLabel,
    this.noDataText = 'No data found',
    this.placeholderSearch = 'Search ...',
    this.size = const BsSelectBoxSize(),
    this.style = BsSelectBoxStyle.bordered,
    this.serverSide,
    this.searchable = false,
    this.disabled = false,
    this.validators = const [],
    this.onChange,
    this.dialogStyle = const BsDialogBoxStyle(),
    this.paddingDialog = const EdgeInsets.all(10.0),
    this.marginDialog = const EdgeInsets.only(top: 2.0, bottom: 2.0)
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BsSelectBoxState();
  }

  final FocusNode? focusNode;

  final BsSelectBoxSize size;

  final BsSelectBoxStyle style;

  final String? hintText;

  final String? hintTextLabel;

  final String? noDataText;

  final String? placeholderSearch;

  final bool searchable;

  final bool disabled;

  final BsSelectBoxController controller;

  final BsSelectBoxServerSide? serverSide;

  final List<BsSelectValidator> validators;

  final EdgeInsets margin;

  final EdgeInsets padding;

  final ValueChanged<BsSelectBoxOption>? onChange;

  final BsDialogBoxStyle dialogStyle;

  final EdgeInsetsGeometry paddingDialog;

  final EdgeInsets marginDialog;
}

class _BsSelectBoxState extends State<BsSelectBox>
    with SingleTickerProviderStateMixin {
  GlobalKey<State> _key = GlobalKey<State>();
  GlobalKey<State> _keyOverlay = GlobalKey<State>();

  Duration duration = Duration(milliseconds: 100);
  bool isOpen = false;
  late FocusNode _focusNode;
  late FocusNode _focusNodeKeyboard;

  late LayerLink _layerLink;
  late AnimationController _animated;
  late List<BsSelectBoxOption> _options;

  late FormFieldState formFieldState;

  BsWrapperOptions? _wrapperOptions;

  @override
  void initState() {
    _focusNode = widget.focusNode == null ? FocusNode() : widget.focusNode!;
    _focusNode.addListener(onFocus);

    _focusNodeKeyboard = FocusNode();

    _layerLink = LayerLink();
    _options = widget.controller.options;

    _animated = AnimationController(vsync: this, duration: duration);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant BsSelectBox oldWidget) {
    _animated.duration = duration;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animated.dispose();
    super.dispose();
  }

  void onFocus() {
    if (_focusNode.hasFocus && !widget.disabled) open();
  }

  void onKeyPressed(RawKeyEvent event) {
    if(event.logicalKey == LogicalKeyboardKey.escape)
      close();
  }

  void updateState(Function function) {
    if(mounted)
      setState(() => function());
  }

  void pressed() {
    if (!widget.disabled) {
      if (!isOpen) open();
      else close();
    }

    return null;
  }

  void api({String searchValue = ''}) {
    updateState(() {
      widget.controller.processing = true;
      if (_keyOverlay.currentState != null && _keyOverlay.currentState!.mounted)
        _keyOverlay.currentState!.setState(() {});

      widget.serverSide!({'searchValue': searchValue}).then((response) {
        updateState(() {
          widget.controller.processing = false;
          widget.controller.options = response.options;
          if (_wrapperOptions != null)
            _wrapperOptions!.update();
        });
      });
    });
  }

  void open() {
    BsOverlay.removeAll();
    _animated.forward();

    _wrapperOptions = BsWrapperOptions(
      key: _keyOverlay,
      link: _layerLink,
      containerKey: _key,
      padding: widget.paddingDialog,
      margin: widget.marginDialog,
      selectBoxStyle: widget.style,
      selectBoxSize: widget.size,
      style: widget.dialogStyle,
      searchable: widget.searchable,
      noDataText: widget.noDataText!,
      placeholderSearch: widget.placeholderSearch!,
      controller: widget.controller,
      containerMargin: widget.margin,
      onClose: () => close(),
      onChange: (option) {
        if (widget.controller.multiple) {
          if (widget.controller.getSelected() != null) {
            int index = widget.controller.getSelectedAll()
                .indexWhere((element) => element.getValue() == option.getValue());

            if (index != -1) widget.controller.removeSelectedAt(index);
            else widget.controller.setSelected(option);

          } else widget.controller.setSelected(option);

          updateState(() {});
        }

        if (!widget.controller.multiple) {
          widget.controller.setSelected(option);

          close();
        }

        if(widget.onChange != null)
          widget.onChange!(option);

        formFieldState.didChange(option.getValueAsString());
      },
      onSearch: (value) {
        if (widget.serverSide != null) {
          api(searchValue: value);
        } else {
          updateState(() {
            widget.controller.options = _options.where((element) {
              return value == '' || element.searchable.contains(value);
            }).toList();
            if (_keyOverlay.currentState != null && _keyOverlay.currentState!.mounted)
              _keyOverlay.currentState!.setState(() {});
          });
        }
      },
    );

    BsOverlayEntry overlayEntry = BsOverlay.add(OverlayEntry(builder: (context) {
      return _wrapperOptions!;
    }), () => updateState(() => isOpen = false));

    Overlay.of(context)!.insert(overlayEntry.overlayEntry);
    FocusScope.of(context).requestFocus(_focusNodeKeyboard);
    
    if (widget.serverSide != null) api();

    updateState(() => isOpen = true);
  }

  void close() {
    BsOverlay.removeAll();
    _animated.reverse();

    updateState(() => isOpen = false);
  }

  void clear() {
    BsOverlay.removeAll();
    widget.controller.clear();
    formFieldState.didChange(widget.controller.getSelectedAsString());
    updateState(() => _focusNode.requestFocus());
  }

  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool returned = true;
        if(isOpen) {
          returned = false;
          close();
        }

        return returned;
      },
      child: FormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: widget.controller.getSelectedAsString() == '' ? null : widget.controller.getSelectedAsString(),
        validator: (value) {
          _errorText = null;
          widget.validators.map((validator) {
            if (_errorText == null)
              _errorText = validator.validator(value);
          }).toList();
          return _errorText;
        },
        builder: (field) {
          Future.delayed(Duration(milliseconds: 100), () {
            if (field.mounted && widget.controller.getSelectedAsString() != '')
              field.didChange(widget.controller.getSelectedAsString());
          });

          formFieldState = field;

          BoxBorder? border = widget.style.border;
          if (isOpen)
            border = widget.style.focusedBorder;

          if (field.hasError)
            border = Border.all(color: BsColor.danger);

          List<BoxShadow> boxShadow = [];
          if (isOpen)
            boxShadow = widget.style.focusedBoxShadow;

          if (field.hasError && widget.style.focusedBoxShadow.length != 0)
            boxShadow = [
              BoxShadow(
                color: BsColor.dangerShadow,
                offset: Offset(0, 0),
                spreadRadius: 2.5,
              )
            ];

          return Container(
            margin: widget.margin,
            child: Column(
              children: [
                Container(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      renderContainer(
                        valid: !field.hasError,
                        border: border,
                        boxShadow: boxShadow,
                        onChange: (value) => field.didChange(value),
                      ),
                      widget.hintTextLabel == null ? Container(width: 0, height: 0)
                          : renderHintLabel(!field.hasError),
                    ],
                  ),
                ),
                !field.hasError ? Container() : Container(
                  margin: EdgeInsets.only(top: 5.0, left: 2.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    field.errorText!,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: BsColor.textError
                    ),
                  ),
                )
              ],
            ),
          );
        },
        onSaved: (value) {
          formFieldState.didChange(value);
          formFieldState.validate();
        },
      ),
    );
  }

  Widget renderContainer({
    required bool valid,
    required ValueChanged<String> onChange,
    BoxBorder? border,
    List<BoxShadow> boxShadow = const []
  }) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: RawKeyboardListener(
        focusNode: _focusNodeKeyboard,
        onKey: onKeyPressed,
        child: TextButton(
          key: _key,
          focusNode: _focusNode,
          onPressed: pressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(10.0, 10.0)
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: widget.style.textColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: widget.disabled ? widget.style.disabledColor : widget.style.backgroundColor,
                border: border,
                borderRadius: widget.style.borderRadius,
                boxShadow: boxShadow
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: widget.padding,
                      child: widget.controller.getSelected() == null ? widget.hintText == null ? Text('') : Text(
                        widget.hintText!,
                        style: TextStyle(
                          color: valid ? widget.style.hintTextColor : Colors.red,
                          fontSize: widget.style.fontSize + 2
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ) : renderSelected(),
                    )
                  ),
                  !isOpen ? Container(width: 0, height: 0) : Container(
                    padding: EdgeInsets.all(5.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => close(),
                        child: Icon(Icons.check,
                          size: widget.size.fontSize! - 2,
                          color: widget.style.textColor
                        ),
                      ),
                    ),
                  ),
                  widget.controller.getSelected() == null ? Container(width: 0, height: 0) : Container(
                    padding: EdgeInsets.all(5.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => clear(),
                        child: Icon(Icons.close,
                          size: widget.size.fontSize! - 2,
                          color: widget.style.textColor
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: Icon(widget.style.arrowIcon,
                      size: widget.size.fontSize,
                      color: valid ? widget.style.textColor : Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderSelected() {
    List<Widget> children = [];
    if (!widget.controller.multiple)
      children.add(DefaultTextStyle(
        style: TextStyle(
          fontSize: widget.size.fontSize,
          color: widget.style.textColor,
        ),
        child: Container(child: widget.controller.getSelected()!.getText()),
      ));

    if (widget.controller.multiple)
      widget.controller.getSelectedAll().forEach((option) {
        children.add(Container(
          margin: EdgeInsets.only(right: 5.0, bottom: 1.0, top: 1.0),
          child: Material(
            child: InkWell(
              onTap: () {
                if (_keyOverlay.currentState != null &&
                    _keyOverlay.currentState!.mounted)
                  _keyOverlay.currentState!.setState(() {});

                widget.controller.removeSelected(option);

                formFieldState.didChange(widget.controller.getSelectedAsString());

                updateState(() {});
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
                decoration: BoxDecoration(
                  color: widget.style.selectedColor,
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 5.0),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: widget.style.fontSize - 2,
                          color: widget.style.selectedColor,
                        ),
                        child: option.getText(),
                      )
                    ),
                    Icon(Icons.close,
                      size: widget.style.fontSize - 2,
                      color: widget.style.selectedColor
                    ),
                  ],
                ),
              ),
            ),
          )
        ));
      });

    return Wrap(children: children);
  }

  Widget renderHintLabel(bool valid) {
    return AnimatedBuilder(
      animation: _animated,
      builder: (context, child) {
        double x = widget.size.labelX;
        double? y = widget.size.labelY;
        double fontSize = widget.style.fontSize + 2.0;

        if (widget.controller.getSelected() != null) {
          x = widget.size.transitionLabelX;
          y = widget.size.transitionLabelY;
          fontSize = widget.style.fontSize - 2.0;
        } else if (widget.controller.getSelected() != null && isOpen) {
          x = widget.size.transitionLabelX;
          y = widget.size.transitionLabelY * _animated.value;
          fontSize = widget.style.fontSize - 2.0 * _animated.value;
        }

        Color backgroundColor = Colors.transparent;
        Color color = widget.style.hintTextColor;
        if(isOpen)
          color = widget.style.focusedTextColor;

        if(widget.controller.getSelected() != null) {
          color = widget.style.backgroundColor;
          backgroundColor = Colors.white;
        }

        if(!valid)
          color = BsColor.danger;

        return Positioned.fill(
          left: x,
          top: y,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: pressed,
                child: Container(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: widget.style.borderRadius
                  ),
                  child: Text(widget.hintTextLabel!,
                    style: TextStyle(
                      color: color,
                      fontSize: fontSize,
                    ),
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
