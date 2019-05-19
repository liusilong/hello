import 'dart:async';

import 'package:flutter/services.dart';

class Hello {
  static const MethodChannel _channel = const MethodChannel('hello.lsl');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> getName(String message) async {
    /**
     * 调用 Native getName 方法，传入参数：message
     */
    final String name =
        await _channel.invokeMethod('getName', {"message": message});
    return name;
  }

  static void setMethodCallHandler(Future<dynamic> handler(MethodCall call)) {
    _channel.setMethodCallHandler(handler);
  }

  static Future<Null> showToast({String message, int duration}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("message", () => message);
    args.putIfAbsent("duration", () => duration);
    await _channel.invokeMethod('showToast', args);
    return null;
  }
}
