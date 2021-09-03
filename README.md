# 使用步骤

# 1、安装

在工程 pubspec.yaml 中加入 dependencies
```
dependencies:
  umeng_common_sdk:
    git:
      url: git@github.com:flutter-plugin/umeng_common_flutter.git
      ref: master
```
# 2、使用
```
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
```

# 3、初始化
```
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
```

# 4、上报事件
```
await UmengCommonSdk.onEvent(
                  event: 'event_test',
                  properties: {
                    'key': '测试上传数据',
                    'key1': '测试上传数据',
                  },
                );
```