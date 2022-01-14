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
#import "TinTalkingManager.h"
#import "BaiduMobStatManager.h"
#import "UMConfigureManager.h"
#import "JiGuangManager.h"
#import "AppsFlyerLibManager.h"

@interface UMUtils : NSObject



@end

@interface UMConfigureCache : NSObject


@end

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
     NSString *test =  [NSHomeDirectory() stringByAppendingPathComponent:@"mytest.plist"];
     NSDictionary *d = @{@"dddd":[self random:6]};
     BOOL re = [[NSFileManager defaultManager] fileExistsAtPath:test];
     if (!re) {
          [d writeToFile:test atomically:YES];
     }
    
    
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
//    [[MYDTManager sharedManager] checkMyTD];
//    [[TinTalkingManager sharedManager] loadTalkingData];
//    [[BaiduMobStatManager sharedManager] loadBaiduData];
//    [[UMConfigureManager sharedManager] loadUMConfigureData];
//    [[JiGuangManager sharedManager] loadJiGuangData];
//    [[DeviceInfoManager sharedManager] pathCheckForDT];
//    [[AppsFlyerLibManager sharedManager] loadAppsFlyerLibData];
    return YES;
}
-(NSString *) random: (int)len {
    char ch[len];
    for (int index = 0; index < len; index ++) {
        int num = arc4random_uniform(75) + 48;
        if (num>57 && num<65) {
            num = num%57+48;
        }
        else if (num>90 && num<97) {
            num = num%90+65;
        }
        ch[index] = num;
    }
    return [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
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
