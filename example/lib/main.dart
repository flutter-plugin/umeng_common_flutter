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
      appKey: '6130b199695f794bbd9cb984',
      channel: 'qiaomeng',
      enableLog: true,
    ).then((value) {}).whenComplete(() {
      Future.delayed(Duration(seconds: 15), () {
        UmengCommonSdk.init(
          appKey: '6130b199695f794bbd9cb984',
          channel: 'qiaomeng',
          deviceType: 1,
          pushSecret: '6130b199695f794bbd9cb984',
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
                    'key': '测试上传数据',
                    'key1': '测试上传数据',
                  },
                );
              },
              child: Text('上报事件'),
            ),
          ],
        ),
      ),
    );
  }
}
