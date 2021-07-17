import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:bs_flutter_selectbox/src/components/bs_wrapper_option.dart';
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
    required this.selectBoxController,
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

  final BsSelectBoxController selectBoxController;

  final BsSelectBoxServerSide? serverSide;

  final List<BsSelectValidators> validators;
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

  @override
  void initState() {
    _focusNode = widget.focusNode == null ? FocusNode() : widget.focusNode!;
    _focusNode.addListener(onFocus);

    _focusNodeKeyboard = FocusNode();

    _layerLink = LayerLink();
    _options = widget.selectBoxController.options;

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
      widget.selectBoxController.processing = true;
      if (_keyOverlay.currentState != null && _keyOverlay.currentState!.mounted)
        _keyOverlay.currentState!.setState(() {});

      widget.serverSide!({'searchValue': searchValue}).then((response) {
        updateState(() {
          widget.selectBoxController.processing = false;
          widget.selectBoxController.options = response.options;
          if (_keyOverlay.currentState != null  && _keyOverlay.currentState!.mounted)
            _keyOverlay.currentState!.setState(() {});
        });
      });
    });
  }

  void open() {
    BsOverlay.removeAll();
    _animated.forward();

    BsOverlayEntry overlayEntry = BsOverlay.add(OverlayEntry(builder: (context) {
      return BsWrapperOptions(
        key: _keyOverlay,
        link: _layerLink,
        containerKey: _key,
        selectBoxStyle: widget.style,
        selectBoxSize: widget.size,
        searchable: widget.searchable,
        noDataText: widget.noDataText!,
        placeholderSearch: widget.placeholderSearch!,
        selectBoxController: widget.selectBoxController,
        onClose: () => close(),
        onChange: (option) {
          if (widget.selectBoxController.multiple) {
            if (widget.selectBoxController.getSelected() != null) {
              int index = widget.selectBoxController.getSelectedAll()
                  .indexWhere((element) => element.getValue() == option.getValue());

              if (index != -1) widget.selectBoxController.removeSelectedAt(index);
              else widget.selectBoxController.setSelected(option);

            } else widget.selectBoxController.setSelected(option);

            updateState(() {});
          }

          if (!widget.selectBoxController.multiple) {
            widget.selectBoxController.setSelected(option);

            close();
          }

          formFieldState.didChange(option.getValueAsString());
        },
        onSearch: (value) {
          if (widget.serverSide != null) {
            api(searchValue: value);
          } else {
            updateState(() {
              widget.selectBoxController.options = _options.where((element) {
                return value == '' || element.searchable.contains(value);
              }).toList();
              if (_keyOverlay.currentState != null && _keyOverlay.currentState!.mounted)
                _keyOverlay.currentState!.setState(() {});
            });
          }
        },
      );
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
    widget.selectBoxController.clear();
    formFieldState.didChange(widget.selectBoxController.getSelectedAsString());
    updateState(() => _focusNode.requestFocus());
  }

  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return FormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: widget.selectBoxController.getSelectedAsString() == '' ? null : widget.selectBoxController.getSelectedAsString(),
      validator: (value) {
        _errorText = null;
        widget.validators.map((validator) {
          if (_errorText == null)
            _errorText = validator.validator(value);
        }).toList();
        return _errorText;
      },
      builder: (field) {
        formFieldState = field;

        BoxBorder? border = widget.style.border;
        if (isOpen)
          border = Border.all(color: Colors.black);

        if (field.hasError)
          border = Border.all(color: BsColor.danger);

        List<BoxShadow> boxShadow = [];
        if (_focusNode.hasFocus)
          boxShadow = widget.style.boxShadowFocused;

        if (field.hasError && widget.style.boxShadowFocused.length != 0)
          boxShadow = [
            BoxShadow(
              color: BsColor.dangerShadow,
              offset: Offset(0, 0),
              spreadRadius: 2.5,
            )
          ];

        return Column(
          children: [
            Container(
              child: Stack(
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
        );
      },
      onSaved: (value) {
        formFieldState.didChange(value);
        formFieldState.validate();
      },
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
          style: TextButton.styleFrom(),
          child: DefaultTextStyle(
            style: TextStyle(
              color: widget.style.color,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: widget.disabled ? widget.style.disabledBackgroundColor : widget.style.backgroundColor,
                border: border,
                borderRadius: widget.style.borderRadius,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: widget.size.padding,
                      child: widget.selectBoxController.getSelected() == null ? widget.hintText == null ? Text('') : Text(
                        widget.hintText!,
                        style: TextStyle(
                          color: valid ? widget.style.placeholderColor : Colors.red,
                          fontSize: widget.style.fontSize + 2
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ) : renderSelected(),
                    )
                  ),
                  widget.selectBoxController.getSelected() == null ? Container(width: 0, height: 0) : TextButton(
                    onPressed: () => clear(),
                    style: TextButton.styleFrom(minimumSize: Size(5.0, 5.0)),
                    child: Icon(Icons.close,
                      size: widget.size.fontSize! - 2,
                      color: widget.style.color
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: Icon(widget.style.arrowIcon,
                      size: widget.size.fontSize,
                      color: valid ? widget.style.color : Colors.red,
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
    if (!widget.selectBoxController.multiple)
      children.add(DefaultTextStyle(
        style: TextStyle(
          fontSize: widget.size.fontSize,
          color: widget.style.color,
        ),
        child: Container(child: widget.selectBoxController.getSelected()!.getText()),
      ));

    if (widget.selectBoxController.multiple)
      widget.selectBoxController.getSelectedAll().forEach((option) {
        children.add(Container(
          margin: EdgeInsets.only(right: 5.0, bottom: 1.0, top: 1.0),
          child: TextButton(
            onPressed: () {
              if (_keyOverlay.currentState != null &&
                  _keyOverlay.currentState!.mounted)
                _keyOverlay.currentState!.setState(() {});

              widget.selectBoxController.removeSelected(option);

              formFieldState.didChange(widget.selectBoxController.getSelectedAsString());

              updateState(() {});
            },
            style: TextButton.styleFrom(minimumSize: Size(5.0, 5.0)),
            child: Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 1.5, bottom: 1.5),
              decoration: BoxDecoration(
                color: widget.style.selectedBackgroundColor,
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
        ));
      });

    return Wrap(children: children);
  }

  Widget renderHintLabel(bool valid) {
    return AnimatedBuilder(
      animation: _animated,
      builder: (context, child) {
        double x = widget.size.labelX;
        double y = widget.size.labelY;
        double fontSize = widget.style.fontSize + 2.0;

        if (widget.selectBoxController.getSelected() != null) {
          x = -widget.size.transitionLabelX;
          y = -widget.size.transitionLabelY;
          fontSize = widget.style.fontSize - 2.0;
        } else if (widget.selectBoxController.getSelected() != null && isOpen) {
          x = -widget.size.transitionLabelX;
          y = -widget.size.transitionLabelY * _animated.value;
          fontSize = widget.style.fontSize - 2.0 * _animated.value;
        }

        return Transform(
          transform: Matrix4.identity()..translate(x, y),
          child: TextButton(
            onPressed: pressed,
            style: TextButton.styleFrom(minimumSize: Size(5.0, 5.0)),
            child: Container(
              color: Colors.white,
              child: Text(widget.hintTextLabel!,
                style: TextStyle(
                  color: valid ? widget.style.placeholderColor : BsColor.textError,
                  fontSize: fontSize,
                ),
                overflow: TextOverflow.ellipsis
              ),
            ),
          )
        );
      },
    );
  }
}
