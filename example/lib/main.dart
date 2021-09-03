import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    UmengCommonSdk.preInit(
      appKey: Platform.isIOS
          ? '6131e783695f794bbd9ed608'
          : '6130b199695f794bbd9cb984',
      channel: 'qiaomeng',
      enableLog: true,
    ).then((value) {}).whenComplete(() {
      Future.delayed(Duration(seconds: 15), () {
        UmengCommonSdk.init(
          appKey: Platform.isIOS
              ? '6131e783695f794bbd9ed608'
              : '6130b199695f794bbd9cb984',
          channel: 'qiaomeng',
          deviceType: 1,
          pushSecret: Platform.isIOS
              ? '6131e783695f794bbd9ed608'
              : '6130b199695f794bbd9cb984',
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Running')),
        body: Column(
          children: [
            TextButton(
              onPressed: () async {
                await UmengCommonSdk.onEvent(
                  event: 'event_test',
                  properties: {
                    'key': 'Key数据',
                    'key1': 'Key1数据',
                  },
                );
              },
              child: Text('上报事件'),
            ),
            TextButton(
              onPressed: () async {
                await UmengCommonSdk.onPageStart(pageName: "/PAGE/HOST/A");
              },
              child: Text('页面打开'),
            ),
            TextButton(
              onPressed: () async {
                await UmengCommonSdk.onPageStart(pageName: "/PAGE/HOST/B");
              },
              child: Text('关闭'),
            ),
            TextButton(
              onPressed: () async {
                await UmengCommonSdk.onSignIn(userId: "user_id");
              },
              child: Text('用户登陆'),
            ),
          ],
        ),
      ),
    );
  }
}
