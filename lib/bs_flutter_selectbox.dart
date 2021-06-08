
import 'dart:async';

import 'package:flutter/services.dart';

class BsFlutterSelectbox {
  static const MethodChannel _channel =
      const MethodChannel('bs_flutter_selectbox');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
