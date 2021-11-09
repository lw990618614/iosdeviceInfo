//
//  AppDelegate.m
//  ClientTest
//
//  Created by 王鹏飞 on 16/7/1.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "WHCFileManager.h"
#import "DeviceInfoManager.h"
#import "MYDTManager.h"

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

//    [NetWorkInfoManager sharedManager];

//    [UMConfigure initWithAppkey:@"60bd82994d0228352bbdbaaf" channel:@"App Store"];
//    [UMConfigure initWithAppkey:@"60c31214e044530ff0a1cc2f" channel:@"App Store"];
//    [UMConfigure initWithAppkey:@"60d00bff8a102159db7183ba" channel:@"App Store"];

// 值测试路劲而已 11 点55 大量启动
//    [UMConfigure initWithAppkey:@"60bb27a14d0228352bbcd731" channel:@"App Store"];
    //测试 所有的
//    [UMConfigure initWithAppkey:@"60d013a126a57f10182f3cbe" channel:@"App Store"];
//
//    [[MYDTManager sha redManager] checkMyTD];

    [[DeviceInfoManager sharedManager] pathCheckForDT];
    
    return YES;
}
-(void)test{
    
   NSString *homePaht =  [[WHCFileManager homeDir] stringByAppendingFormat:@"/tesss"];
    BOOL  is = [WHCFileManager  isExistsAtPath:homePaht];
    if (is) {
        [WHCFileManager removeItemAtPath:homePaht];
    }
    NSError *err;
  BOOL re =   [@"dsfsdfsdf" writeToFile:homePaht atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (re) {
        NSLog(@"____________chengo_______________");

    }else{
        NSLog(@"____________shibai______________");

    }
    
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
