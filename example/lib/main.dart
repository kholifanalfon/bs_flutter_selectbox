import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_responsive/bs_flutter_responsive.dart';
import 'package:flutter/cupertino.dart';
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
      home: GestureDetector(
        onTap: () {
          SelectBoxOverlay.removeAll();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Select Box'),
          ),
          body: Scrollbar(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formState,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: BsSelectBox(
                          hintText: 'Pilih salah satu',
                          controller: _select1,
                          validators: [
                            BsSelectValidators.required
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: BsSelectBox(
                          padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                          hintTextLabel: 'Pilih salah satu',
                          controller: _select2,
                          searchable: true,
                          dialogStyle: BsDialogBoxStyle(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          style: BsSelectBoxStyle(
                              backgroundColor: Colors.blueAccent,
                              hintTextColor: Colors.white,
                              selectedColor: Color(0xff3872d1),
                              textColor: Colors.white,
                              borderRadius: BorderRadius.circular(50.0),
                              focusedTextColor: Color(0xff3367bd)
                          ),
                          paddingDialog: EdgeInsets.all(15),
                          marginDialog: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: BsSelectBox(
                          padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                          hintTextLabel: 'Pilih salah satu',
                          controller: _select2,
                          searchable: true,
                          style: BsSelectBoxStyle(
                            backgroundColor: Colors.lightGreen,
                            hintTextColor: Colors.white,
                            selectedColor: Color(0xff608733),
                            textColor: Colors.white,
                            focusedTextColor: Color(0xff608733),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          dialogStyle: BsDialogBoxStyle(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          paddingDialog: EdgeInsets.all(15),
                          marginDialog: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: BsSelectBox(
                          hintText: 'Pilih multiple',
                          controller: _select3,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: BsSelectBox(
                          searchable: true,
                          disabled: true,
                          hintText: 'Pilih salah satu',
                          controller: _select5,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: BsSelectBox(
                          hintText: 'Pilih salah satu',
                          searchable: true,
                          controller: _select4,
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
                                            controller: _select6,
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
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: BsSelectBox(
                          margin: EdgeInsets.only(top: 200.0),
                          hintText: 'Pilih salah satu',
                          controller: _select1,
                          validators: [
                            BsSelectValidators.required
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
