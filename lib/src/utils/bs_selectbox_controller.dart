import 'package:bs_flutter_selectbox/src/utils/bs_selectbox_option.dart';

class BsSelectBoxController {

  BsSelectBoxController({
    this.selected,
    this.processing = false,
    this.multiple = false,
    this.options = const [],
  });

  bool processing;

  bool multiple;

  List<BsSelectBoxOption> options;

  List<BsSelectBoxOption>? selected;

  void clear() {
    if(selected != null)
      selected = null;
  }

  void setOptions(List<BsSelectBoxOption> allOptions) => options = allOptions;

  void addOption(BsSelectBoxOption option) => options.add(option);

  void addOptionAll(List<BsSelectBoxOption> options) => options.addAll(options);

  void setSelected(BsSelectBoxOption option) {
    if(!multiple)
      selected = [option];

    if(selected == null)
      selected = [];

    if(multiple)
      selected!.add(option);
  }

  void setSelectedAll(List<BsSelectBoxOption> options) => selected = options;

  void removeSelectedAt(int index) {
    if(selected != null) {
      selected!.removeAt(index);

      if (selected!.length == 0)
        clear();
    }
  }

  void removeSelected(BsSelectBoxOption option) {
    if(selected != null) {
      int index = selected!.indexWhere((element) => element.value == option.value);
      if(index != -1)
        selected!.removeAt(index);

      if (selected!.length == 0)
        clear();
    }
  }

  BsSelectBoxOption? getSelected() => selected != null ? selected!.first : null;

  List<BsSelectBoxOption> getSelectedAll() => selected!;

  String? getSelectedAsString() {
    if(selected != null) {
      StringBuffer string = StringBuffer();
      selected!.forEach((option) {
        string.write(option.value.toString() + ',');
      });

      return string.toString().length > 0
          ? string.toString().substring(0, string.toString().length - 1)
          : null;
    }

    return null;
  }
}