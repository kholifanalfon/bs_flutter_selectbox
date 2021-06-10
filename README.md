# Bs Flutter Select Box

Web HTML select option with serverside

![Alt text](https://raw.githubusercontent.com/kholifanalfon/bs_flutter_selectbox/main/screenshot/general.png "Bs Select Box")

Feature:
- Select option with server side data
- Searchable select option
- Multiple select option
- Select label

This plugin is the best alternative for select2 library

## Getting Started
Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  ...
  bs_flutter: any
```

### Select Box
Example: [`main.dart`](https://github.com/kholifanalfon/bs_flutter/blob/main/example/lib/main.dart)

To create a select box you need to import:

```dart
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
```

After create controller:

```dart
// ...
  BsSelectBoxController _select1 = BsSelectBoxController(
    options: [
      BsSelectBoxOption(value: 1, text: Text('1')),
      BsSelectBoxOption(value: 2, text: Text('2')),
      BsSelectBoxOption(value: 3, text: Text('3')),
    ]
  );
// ...
```

After all is done copy the code below:

```dart
// ...
  BsSelectBox(
    hintText: 'Pilih salah satu',
    selectBoxController: _select1,
  ),
// ...
```

![Alt text](https://raw.githubusercontent.com/kholifanalfon/bs_flutter_selectbox/main/screenshot/select.png "Normal Select Box")


If you need to customize size and style, use properties `style` and `size`. And create your custom size with class `BsSelectBoxSize` or `BsSelectBoxStyle` to custom style

```dart
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
```

```dart
  static const BsSelectBoxStyle outline = BsSelectBoxStyle(
    borderRadius: BorderRadius.all(Radius.circular(5.0))
  );
```

### Note
- `labelX` and `labelY` is used to set label position if using `hintTextLabel`
- `transitionLabelX` and `transitionLabelY` is used to set label position if using `hintTextLabel` when have selected value
- `BsSelectBoxStyle` have properties `borderRadius`, `color`, `placeholderColor`, `selectedBackgroundColor`, `selectedColor`, `disabledBackgroundColor`, `backgroundColor`, `borderColor`, `fontSize`, `arrowIcon`

### Select Box Style 2 (hintTextLabel)

Select box using `hintTextLabel`
```dart
// ...
  BsSelectBox(
    hintTextLabel: 'Pilih salah satu',
    selectBoxController: _select1,
  ),
// ...
```

![Alt text](https://raw.githubusercontent.com/kholifanalfon/bs_flutter_selectbox/main/screenshot/selectbox2.png "Label Hint Text Select Box")

### Select Box Multiple

To create a select box with multiple allowed set `multiple` properties in `BsSelectBoxController` to true:

```dart
// ...
  BsSelectBoxController _select2 = BsSelectBoxController(
    multiple: true,
    options: [
      BsSelectBoxOption(value: 1, text: Text('1')),
      BsSelectBoxOption(value: 2, text: Text('2')),
      BsSelectBoxOption(value: 3, text: Text('3')),
      BsSelectBoxOption(value: 4, text: Text('4')),
      BsSelectBoxOption(value: 5, text: Text('5')),
      BsSelectBoxOption(value: 6, text: Text('6')),
    ]
  );
// ...
```

![Alt text](https://raw.githubusercontent.com/kholifanalfon/bs_flutter_selectbox/main/screenshot/selectbox3.png "Multiple Select Box")

### Select Box Server Side

To create a select box with server side data, use `serverSide` property 

```dart
  BsSelectBox(
    hintText: 'Pilih salah satu',
    searchable: true,
    selectBoxController: _select3,
    serverSide: selectApi,
  )
```

### Note
- To enable searchable option, set `searchable` property `true`
- `serverSide` property need returned `Future<BsSelectBoxResponse>`

`selectApi` function
```dart
// ...
  Future<BsSelectBoxResponse> selectApi(Map<String, String> params) async {
    params.addAll({'typecd': 'PRICETYPE'});
    Uri url = Uri.http('api.mosewa', 'webs/types/select', params);
    Response response = await http.get(url);
    if(response.statusCode == 200) {
      Map<String, dynamic> json = convert.jsonDecode(response.body);
      return BsSelectBoxResponse.createFromJson(json['data'],
        value: (data) => data['typeid'],
        renderText: (data) => Text(data['typename']),
      );
    }

    return BsSelectBoxResponse(options: []);
  }
// ...
```

### Note
- `createFromJson` is automatically put response data `value`, but you cant change it with define manual

Json response data
```json
{
  "result":true,
  "status":200,
  "message":null,
  "data":[
    {
      "typeid":131,
      "masterid":130,
      "typename":"Harga Jual",
      "typecd":"",
      "typeseq":1,
      "countchildren":0,
      "parent":{
      "typeid":130,
      "typename":"Tipe Harga",
      "typecd":"PRICETYPE"
    }
    },
    {
      "typeid":132,
      "masterid":130,
      "typename":"Harga Sewa",
      "typecd":"",
      "typeseq":1,
      "countchildren":0,
      "parent":{
      "typeid":130,
      "typename":"Tipe Harga",
      "typecd":"PRICETYPE"
      }
    }
  ]
}
```

![Alt text](https://raw.githubusercontent.com/kholifanalfon/bs_flutter_selectbox/main/screenshot/selectbox4.png "Server Side Select Box")