import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hello_lsl/hello_lsl.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _name = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _initCallbackHandler();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String name;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Hello.platformVersion;
      name = await Hello.getName("I am from Flutter...");
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n name is $_name'),
        ),
      ),
    );
  }

  void _initCallbackHandler() {
    Hello.setMethodCallHandler((call) {
      if (call.method == 'callback') {
        setState(() {
          _platformVersion = call.arguments;
        });
      }
    });
  }
}
