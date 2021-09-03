import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UmengCommonSdk {
  static const MethodChannel _channel = const MethodChannel('umeng_common_sdk');

  ///
  /// 预初始化
  /// [appKey]              友盟控制台appKey
  /// [channel]             app的渠道,如：应用宝、小米、华为应用商店等
  /// [enableLog]           是否启用日志
  ///
  static Future<bool> preInit({
    @required String appKey,
    @required String channel,
    bool enableLog = false,
  }) async {
    final bool result = await _channel.invokeMethod('preInit', {
      'appKey': appKey,
      'channel': channel,
      'enableLog': enableLog,
    });
    return result;
  }

  ///
  /// 初始化
  /// [appKey]          友盟控制台appKey
  /// [channel]         app的渠道,如：应用宝、小米、华为应用商店等
  /// [deviceType]      设备类型1、手机、2、...
  /// [pushSecret]      密钥
  ///
  static Future<bool> init({
    @required String appKey,
    @required String channel,
    int deviceType = 1,
    String pushSecret,
  }) async {
    final dynamic result = await _channel.invokeMethod('init', {
      'appKey': appKey,
      'channel': channel,
      'deviceType': deviceType,
      'pushSecret': pushSecret,
    });
    return result;
  }

  ///
  /// 上报事件
  /// [event]       事件标志
  /// [properties]  事件参数
  ///
  static Future<bool> onEvent({
    @required String event,
    @required Map<String, dynamic> properties,
  }) async {
    return await _channel.invokeMethod('onEvent', {
      'eventId': event,
      'properties': properties,
    });
  }
}
