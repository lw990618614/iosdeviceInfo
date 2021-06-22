//
//  AppDelegate.m
//  ClientTest
//
//  Created by 王鹏飞 on 16/7/1.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "AppDelegate.h"
#import "NSData+CRC32.h"
#import "NetWorkInfoManager.h"
#import "AFNetworking.h"

#import <UMCommon/UMCommon.h>
#import "ANYMethodLog.h"
#import "FMDeviceManager.h"
@interface UMUtils : NSObject


@end

@interface UMConfigureCache : NSObject


@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [ANYMethodLog logMethodWithClass:[NSFileManager class] condition:^BOOL(SEL sel) {
//        return YES;
//    } before:^(id target, SEL sel, NSArray *args, int deep) {
//        NSLog(@"UMConfigureCachetarget:%@ sel:%@", target, NSStringFromSelector(sel));
//    } after:nil];

    [NetWorkInfoManager sharedManager];
    
//    [UMConfigure initWithAppkey:@"60bd82994d0228352bbdbaaf" channel:@"App Store"];
//    [UMConfigure initWithAppkey:@"60c31214e044530ff0a1cc2f" channel:@"App Store"];
//    [UMConfigure initWithAppkey:@"60d00bff8a102159db7183ba" channel:@"App Store"];

// 值测试路劲而已 11 点55 大量启动
//    [UMConfigure initWithAppkey:@"60bb27a14d0228352bbcd731" channel:@"App Store"];
    //测试 所有的
//    [UMConfigure initWithAppkey:@"60d013a126a57f10182f3cbe" channel:@"App Store"];
    
    
//    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
//    NSMutableDictionary *options = [NSMutableDictionary dictionary];
//
//    /*
//     * SDK具有防调试功能，当使用xcode运行时(开发测试阶段),请取消下面代码注释，
//     * 开启调试模式,否则使用xcode运行会闪退。上架打包的时候需要删除或者注释掉这
//     * 行代码,如果检测到调试行为就会触发crash,起到对APP的保护作用
//     */
//
//    [options setValue:@"allowd" forKey:@"allowd"];  // TODO
////    [options setValue:@"sandbox" forKey:@"env"];
//    [options setValue:@"sandbox" forKey:@"product"];
//
//    [options setValue:@"noLocation" forKey:@"noLocation"]; //
//    [options setValue:@"youju" forKey:@"partner"];
//
//    [options setObject:^(NSString *blackBox){
//        //添加你的回调逻辑
////        printf("同盾设备指纹,回调函数获取到的blackBox:%s\n",[blackBox UTF8String]);
//        [self getDeviceInfoWithblackBox:blackBox];
//
//    } forKey:@"callback"];
//    //设置超时时间(单位:秒)
//    [options setValue:@"6" forKey:@"timeLimit"];
//    // 使用上述参数进行SDK初始化
//    manager->initWithOptions(options);
//
    
    return YES;
}

-(void)getDeviceInfoWithblackBox:(NSString *)info{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 
    manager.requestSerializer = [AFJSONRequestSerializer serializer];   // 请求JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // 响应JSON格式
 
    [manager.requestSerializer setValue:@"application/json;UTF-8" forHTTPHeaderField:@"Content-Type"];
 
//    NSString *url = [NSString stringWithFormat:@"http://114.116.231.177:8091/no/fraudApiInvoker/checkFraud?blackBox=%@&type=2",info];
    NSString *url = [NSString stringWithFormat:@"http://114.116.231.177:8091/no/fraudApiInvoker/checkFraud?"];
    NSDictionary *parameters = @{@"blackBox":info,
                                 @"type": @"2"};
    [manager GET:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功：%@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // 获取各种数据
    NSMutableData *sendData = [[NSMutableData alloc] initWithData:deviceToken];
    int32_t checksum = [deviceToken crc32];
    int32_t swapped = CFSwapInt32LittleToHost(checksum);
    char *a = (char*) &swapped;
    [sendData appendBytes:a length:sizeof(4)];
    
    //检验
    //    Byte *b1 = (Byte *)[sendData bytes];
    //    for (int i = 0; i < sendData.length; i++) {
    //        NSLog(@"b1[%d] == %d",i,b1[i]);
    //    }
    NSString *device_token_crc32 = [sendData base64EncodedStringWithOptions:0];
    //    NSLog(@"b1:%@",[sendData base64EncodedStringWithOptions:0]);
    //保存获取到的数据
    NSString *device_token = [NSString stringWithFormat:@"%@",deviceToken];
    [[NSUserDefaults standardUserDefaults]setObject:device_token forKey:@"device_token"];
    [[NSUserDefaults standardUserDefaults]setObject:device_token_crc32 forKey:@"device_token_crc32"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //    NSLog(@"deviceToken---------------》%@", deviceToken);
    //    NSLog(@"device_token--------------》%@", device_token);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
