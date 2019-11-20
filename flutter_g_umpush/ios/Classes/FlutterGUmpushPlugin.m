#import "FlutterGUmpushPlugin.h"

#import  <UMCommon/UMCommon.h>  // 公共组件是所有友盟产品的基础组件，必选
#import  <UMPush/UMessage.h>  // Push组件
#import  <UserNotifications/UserNotifications.h>// Push组件必须的系统库

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#define UMAppKey @"5b06be93f43e485fae000077"

//@implementation FlutterGUmpushPlugin
//+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//  FlutterMethodChannel* channel = [FlutterMethodChannel
//      methodChannelWithName:@"flutter_g_umpush"
//            binaryMessenger:[registrar messenger]];
//  FlutterGUmpushPlugin* instance = [[FlutterGUmpushPlugin alloc] init];
//  [registrar addMethodCallDelegate:instance channel:channel];
//}
//
//- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//  if ([@"getPlatformVersion" isEqualToString:call.method]) {
//    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
//  } else {
//    result(FlutterMethodNotImplemented);
//  }
//}




@interface FlutterGUmpushPlugin () <UNUserNotificationCenterDelegate>

@end

#endif


@implementation FlutterGUmpushPlugin{
    FlutterMethodChannel *_channel;
    NSDictionary *_launchNotification;
    BOOL _resumingFromBackground;
}


+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    NSLog(@"umeng_push_plugin registerWithRegistrar registrar: %@", registrar);
    
    FlutterMethodChannel* channel =
    [FlutterMethodChannel methodChannelWithName:@"flutter_g_umpush"
                                binaryMessenger:[registrar messenger]];
    FlutterGUmpushPlugin* instance = [[FlutterGUmpushPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
        _resumingFromBackground = NO;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSLog(@"方法名称: %@", call.method);
    NSString *method = call.method;
    if ([@"setBadgeClear" isEqualToString:method]) {
        result(@YES);
    }else if([@"setAutoAlert" isEqualToString:method]) {
        result(@YES);
    }else if([@"initWithAppkey" isEqualToString:method]) {//初始化
        
        NSLog(@"返回数据%@", call.arguments);
        [self initWithAppkey:@"ky"];
        [self performSelector:@selector(ddddddd) withObject:self afterDelay:5];
        result(@YES);
    }
    else if([@"addAlias" isEqualToString:method]) {//别名
        [self addAlias:@"ky"];
        result(@YES);
    }
    else if([@"addtags" isEqualToString:method]) {//标签
        [self addtags:@"ky"];
        result(@YES);
    }else if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
    else {
        result(FlutterMethodNotImplemented);
    }

}

-(void)ddddddd{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"key1",@"你好",@"key2",@"我好",@"key3",@"他好",@"key4",@"大家好", nil];
    [_channel invokeMethod:@"openNotification" arguments:dict];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (![deviceToken isKindOfClass:[NSData class]]) return;

    [UMessage registerDeviceToken:deviceToken];

    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken success");

    NSLog(@"deviceToken————>>>%@",[[[[deviceToken description]
                                     stringByReplacingOccurrencesOfString: @"<"withString: @""]
                                    stringByReplacingOccurrencesOfString: @">"withString: @""]
                                   stringByReplacingOccurrencesOfString: @" "withString: @""]);
}

#pragma mark-友盟推送
-(void)UMpushOptions:(NSDictionary *)launchOptions{

    //配置友盟SDK产品并并统一初始化
    [UMConfigure initWithAppkey:UMAppKey channel:@"App Store"];
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
    
    //设置是否允许SDK自动清空角标
//    [UMessage setBadgeClear:NO];
    //设置是否允许SDK当应用在前台运行收到Push时弹出Alert框
//    [UMessage setAutoAlert:NO];
}


-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    //友盟推送初始化
    [self UMpushOptions:launchOptions];
    return YES;
}

//iOS10以下使用这两个方法接收通知
-(BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
     completionHandler(UIBackgroundFetchResultNewData);
    return YES;
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [_channel invokeMethod:@"UMPush" arguments:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
//        [_channel invokeMethod:@"方法名" arguments:userInfo result:^(id  _Nullable result) {
//            //x回调
//        }];
        [_channel invokeMethod:@"UMPush" arguments:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}

-(void)initWithAppkey:(NSString*)appKey{
    NSLog(@"友盟初始化");
    //配置友盟SDK产品并并统一初始化
    [UMConfigure initWithAppkey:appKey channel:@"App Store"];
}

-(void)setBadgeClear:(BOOL)isClear{
    NSLog(@"友盟是否清除角标");
    //设置是否允许SDK自动清空角标
    [UMessage setBadgeClear:isClear];
}

//设置是否允许SDK当应用在前台运行收到Push时弹出Alert框
-(void)setAutoAlert:(BOOL)isAlert{
    NSLog(@"友盟是否弹框");
    [UMessage setAutoAlert:isAlert];
}
       

#pragma mark-设置别名
-(void)addAlias:(NSString*)account{
    NSLog(@"友盟设置别名");
    //绑定别名
    [UMessage addAlias:account type:@"iOS" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
    }];
//    //重置别名
//    [UMessage setAlias:@"test@umeng.com" type:@"UMENGTEST" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//    }];
//    //移除别名
//    [UMessage removeAlias:@"test@umeng.com" type:@"UMENGTEST" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//    }];
}

#pragma mark-设置标签
-(void)addtags:(NSString*)tag{
    NSLog(@"友盟设置标签");
    //添加标签
    [UMessage addTags:tag response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {}];
}

#pragma mark 字典转化字符串
-(NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
