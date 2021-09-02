import 'dart:async';

import 'package:flutter/services.dart';

class UmengCommonSdk {
  static const MethodChannel _channel = const MethodChannel('umeng_common_sdk');

  ///
  /// 预初始化
  /// [appKey]
  /// [channel]
  /// [enableLog]
  ///
  static Future<bool> preInit({
    required String appKey,
    required String channel,
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
  /// [appKey]          AppKey
  /// [channel]
  /// [deviceType]
  /// [pushSecret]
  ///
  static Future<bool> init(
    String appKey,
    String channel,
    int deviceType,
    String pushSecret,
  ) async {
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
  static Future<bool> onEvent(
      String event, Map<String, dynamic> properties) async {
    return await _channel.invokeMethod('onEvent', {
      'eventId': event,
      'properties': properties,
    });
  }
}
