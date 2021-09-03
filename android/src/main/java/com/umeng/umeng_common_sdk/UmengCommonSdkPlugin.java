package com.umeng.umeng_common_sdk;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.BuildConfig;
import com.umeng.commonsdk.UMConfigure;

import java.lang.reflect.Method;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class UmengCommonSdkPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;

  private static void onAttachedEngineAdd() {
    try {
      Class<?> agent = Class.forName("com.umeng.analytics.MobclickAgent");
      Method[] methods = agent.getDeclaredMethods();
      for (Method m : methods) {
        android.util.Log.e("UMLog", "Reflect:" + m);
        if (m.getName().equals("onEventObject")) {
          versionMatch = true;
          break;
        }
      }
      if (!versionMatch) {
        android.util.Log.e("UMLog", "安卓SDK版本过低，建议升级至8以上");
        // return;
      } else {
        android.util.Log.e("UMLog", "安卓依赖版本检查成功");
      }
    } catch (Exception e) {
      e.printStackTrace();
      android.util.Log.e("UMLog", "SDK版本过低，请升级至8以上" + e.toString());
      return;
    }

    Method method = null;
    try {
      Class<?> config = Class.forName("com.umeng.commonsdk.UMConfigure");
      method = config.getDeclaredMethod("setWraperType", String.class, String.class);
      method.setAccessible(true);
      method.invoke(null, "flutter", "1.0");
      android.util.Log.i("UMLog", "setWraperType:flutter1.0 success");
    } catch (Exception e) {
      e.printStackTrace();
      android.util.Log.e("UMLog", "setWraperType:flutter1.0" + e.toString());
    }
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPlugin) {
    mContext = flutterPlugin.getApplicationContext();
    channel = new MethodChannel(flutterPlugin.getBinaryMessenger(), "umeng_common_sdk");
    channel.setMethodCallHandler(this);
    onAttachedEngineAdd();
  }

  static Context mContext;

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (!versionMatch) {
      Log.e("UMLog", "onMethodCall:" + call.method + ":安卓SDK版本过低，请升级至8以上");
      return;
    }
    if ("preInit".equals(call.method)) {
      // 自动采集选择
      // MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.AUTO);

      // 手动采集选择
      MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.MANUAL);
      UMConfigure.setProcessEvent(true);

      String appKey = call.argument("appKey");
      String channel = call.argument("channel");
      boolean enableLog = call.argument("enableLog");
      UMConfigure.preInit(mContext, appKey, channel);
      UMConfigure.setLogEnabled(enableLog);
      result.success(true);
    } else if ("init".equals(call.method)) {
      String appKey = call.argument("appKey");
      String channel = call.argument("channel");
      Integer deviceType = call.argument("deviceType");
      String pushSecret = call.argument("pushSecret");
      boolean mode = call.argument("mode");
      boolean process = call.argument("process");
      UMConfigure.setProcessEvent(process);
      MobclickAgent.setPageCollectionMode(mode?MobclickAgent.PageMode.AUTO:MobclickAgent.PageMode.MANUAL);
      UMConfigure.init(mContext, appKey, channel, deviceType, pushSecret);
      MobclickAgent.setCatchUncaughtExceptions(true);
      result.success(true);
    } else if ("onEvent".equals(call.method)) {
      String eventId = call.argument("eventId");
      Map<String, Object> properties = call.argument("properties");
      MobclickAgent.onEventObject(mContext, eventId, properties);
     // MobclickAgent.setSessionContinueMillis(1000l);
      result.success(true);
    }else if("onSignIn".equals(call.method)) {
      String userId = call.argument("userId");
      String provider = call.argument("provider");
      if(provider == null){
        MobclickAgent.onProfileSignIn(userId);
      }else{
        MobclickAgent.onProfileSignIn(provider,userId);
      }
    }else if("onPageStart".equals(call.method)) {
      String pageName = call.argument("pageName");
      MobclickAgent.onPageStart(pageName);
    }else if("onPageEnd".equals(call.method)) {
      String pageName = call.argument("pageName");
      MobclickAgent.onPageEnd(pageName);
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private static Boolean versionMatch = false;

}
