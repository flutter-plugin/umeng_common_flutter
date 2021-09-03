#import "UmengCommonSdkPlugin.h"
#import <UMCommon/UMConfigure.h>
#import <UMCommon/MobClick.h>

@interface UMengflutterpluginForUMCommon : NSObject
@end
@implementation UMengflutterpluginForUMCommon

+ (BOOL)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    BOOL resultCode = YES;
    if([@"preInit" isEqualToString:call.method]){
        NSString *appKey = call.arguments[@"appKey"];
        NSString *channel = call.arguments[@"channel"];
        NSNumber *enableLog =call.arguments[@"enableLog"];
        [UMConfigure setLogEnabled:enableLog.intValue == 1];
        result(@YES);
        NSLog(@"========>  appKey:%@   channel:%@    enableLog:%@",appKey,channel,enableLog);
    }else if ([@"init" isEqualToString:call.method]){
        NSString *appKey = call.arguments[@"appKey"];
        NSString *channel = call.arguments[@"channel"];
        [UMConfigure initWithAppkey:appKey channel:channel];
        result(@YES);
    }
    else{
        resultCode = NO;
    }
    return resultCode;
}
@end

@interface UMengflutterpluginForAnalytics : NSObject
@end
@implementation UMengflutterpluginForAnalytics : NSObject

+ (BOOL)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    BOOL resultCode = YES;
    if ([@"onEvent" isEqualToString:call.method]){
        NSString *eventId = call.arguments[@"eventId"];
        NSDictionary* properties = call.arguments[@"properties"];
        [MobClick event:eventId attributes:properties];
        result(@YES);
    }
    else if ([@"onSignIn" isEqualToString:call.method]){
        NSString *userId = call.arguments[@"userId"];
        NSString *provider = call.arguments[@"provider"];
        if(provider){
            [MobClick profileSignInWithPUID:userId provider:provider];
        }else{
            [MobClick profileSignInWithPUID:userId];
        }
        result(@YES);
    }
    else if ([@"onSignOff" isEqualToString:call.method]){
        [MobClick profileSignOff];
        result(@YES);
    }
    else if ([@"setPageCollectionModeAuto" isEqualToString:call.method]){
        [MobClick setAutoPageEnabled:YES];
        //result(@"success");
    }
    else if ([@"setPageCollectionModeManual" isEqualToString:call.method]){
        [MobClick setAutoPageEnabled:NO];
        //result(@"success");
    }
    else if ([@"onPageStart" isEqualToString:call.method]){
        NSString* pageName = call.arguments[@"pageName"];
        [MobClick beginLogPageView:pageName];
        result(@YES);
    }
    else if ([@"onPageEnd" isEqualToString:call.method]){
        NSString* pageName = call.arguments[@"pageName"];
        [MobClick endLogPageView:pageName];
        result(@YES);
    }
    else if ([@"reportError" isEqualToString:call.method]){
        NSLog(@"reportError API not existed ");
        //result(@"success");
     }
    else{
        resultCode = NO;
    }
    return resultCode;
}

@end

@implementation UmengCommonSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"umeng_common_sdk"
            binaryMessenger:[registrar messenger]];
  UmengCommonSdkPlugin* instance = [[UmengCommonSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    //result(FlutterMethodNotImplemented);
  }

    BOOL resultCode = [UMengflutterpluginForUMCommon handleMethodCall:call result:result];
    if (resultCode) return;

    resultCode = [UMengflutterpluginForAnalytics handleMethodCall:call result:result];
    if (resultCode) return;

    result(FlutterMethodNotImplemented);
}

@end
