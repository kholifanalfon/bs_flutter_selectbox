import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_responsive/bs_flutter_responsive.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  BsSelectBoxController _select1 = BsSelectBoxController(options: [
    BsSelectBoxOption(value: 1, text: Text('1')),
    BsSelectBoxOption(value: 2, text: Text('2')),
    BsSelectBoxOption(value: 3, text: Text('3')),
  ]);

  BsSelectBoxController _select2 = BsSelectBoxController(options: [
    BsSelectBoxOption(value: 1, text: Text('1')),
    BsSelectBoxOption(value: 2, text: Text('2')),
    BsSelectBoxOption(value: 3, text: Text('3')),
  ]);

  BsSelectBoxController _select3 = BsSelectBoxController(multiple: true, options: [
    BsSelectBoxOption(value: 1, text: Text('1')),
    BsSelectBoxOption(value: 2, text: Text('2')),
    BsSelectBoxOption(value: 3, text: Text('3')),
    BsSelectBoxOption(value: 4, text: Text('4')),
    BsSelectBoxOption(value: 5, text: Text('5')),
    BsSelectBoxOption(value: 6, text: Text('6')),
  ]);

  BsSelectBoxController _select4 = BsSelectBoxController();
  BsSelectBoxController _select5 = BsSelectBoxController();

  BsSelectBoxController _select6 = BsSelectBoxController(multiple: true, options: [
    BsSelectBoxOption(value: 1, text: Text('1')),
    BsSelectBoxOption(value: 2, text: Text('2')),
    BsSelectBoxOption(value: 3, text: Text('3')),
    BsSelectBoxOption(value: 4, text: Text('4')),
    BsSelectBoxOption(value: 5, text: Text('5')),
    BsSelectBoxOption(value: 6, text: Text('6')),
  ]);

  @override
  void initState() {
    super.initState();
  }

  Future<BsSelectBoxResponse> selectApi(Map<String, String> params) async {
    Uri url = Uri.http('localhost', 'api-json.php', params);
    Response response = await http.get(url);
    if (response.statusCode == 200) {
      List json = convert.jsonDecode(response.body);
      return BsSelectBoxResponse.createFromJson(json);
    }

    return BsSelectBoxResponse(options: []);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Select Box'),
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formState,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: BsSelectBox(
                    hintText: 'Pilih salah satu',
                    selectBoxController: _select1,
                    validators: [
                      BsSelectValidators.required
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: BsSelectBox(
                    hintTextLabel: 'Pilih salah satu',
                    selectBoxController: _select2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: BsSelectBox(
                    hintText: 'Pilih multiple',
                    selectBoxController: _select3,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: BsSelectBox(
                    searchable: true,
                    disabled: true,
                    hintText: 'Pilih salah satu',
                    selectBoxController: _select5,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: BsSelectBox(
                    hintText: 'Pilih salah satu',
                    searchable: true,
                    selectBoxController: _select4,
                    serverSide: selectApi,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: BsButton(
                    label: Text('Validate'),
                    prefixIcon: Icons.open_in_new,
                    style: BsButtonStyle.primary,
                    onPressed: () {
                      _formState.currentState!.validate();
                    },
                  ),
                ),
                BsButton(
                  label: Text('Open Modal'),
                  prefixIcon: Icons.open_in_new,
                  style: BsButtonStyle.primary,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => BsModal(
                        context: context,
                        dialog: BsModalDialog(
                          child: BsModalContent(
                            children: [
                              BsModalContainer(title: Text('Modal Select Box'), closeButton: true),
                              BsModalContainer(child: Column(
                                children: [
                                  BsCol(
                                    sizes: ColScreen(sm: Col.col_2),
                                    child: BsSelectBox(
                                      hintText: 'Pilih salah satu',
                                      searchable: true,
                                      selectBoxController: _select6,
                                      serverSide: selectApi,
                                    ),
                                  )
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
