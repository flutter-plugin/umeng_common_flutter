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
  /// [mode]            页面采集模式，true:自动采集 false:手动采集
  /// [process]         是否支持子进程采集数据, true:支持  false:不支持
  ///
  static Future<bool> init({
    @required String appKey,
    @required String channel,
    int deviceType = 1,
    String pushSecret,
    bool mode = true,
    bool process = true,
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

  ///
  /// 账号统计-登陆
  /// [userId]            用户标识
  /// [provider]          账号来源。如果用户通过第三方账号登陆,微博，微信等
  ///
  static Future<bool> onSignIn({
    @required String userId,
    String provider,
  }) async {
    return await _channel.invokeMethod('onSignIn', {
      'userId': userId,
      'provider': provider,
    });
  }

  ///
  /// 账号统计-退出登陆
  ///
  static Future<bool> onSignOff() async {
    return await _channel.invokeMethod('onSignOff');
  }

  ///
  /// 页面采集-打开
  /// [pageName]        采集页面的名称
  ///
  static Future<bool> onPageStart({@required String pageName}) async {
    return await _channel.invokeMethod('onPageStart', {'pageName': pageName});
  }

  ////
  /// 页面采集关闭
  /// [pageName]        采集页面的名称
  ///
  static Future<bool> onPageEnd({@required String pageName}) async {
    return await _channel.invokeMethod('onPageEnd', {'pageName': pageName});
  }
}
