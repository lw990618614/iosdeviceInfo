//
//  AppsFlyerLibManager.m
//  ClientTest
//
//  Created by apple on 2022/1/13.
//  Copyright © 2022 王鹏飞. All rights reserved.
//
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "AppsFlyerLibManager.h"

@implementation AppsFlyerLibManager
+ (instancetype)sharedManager {
    static id _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}


-(void)loadAppsFlyerLibData{
    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"YQFWYffb26QWfyQZPtEi2Y"];
    [[AppsFlyerLib shared] setAppleAppID:@"1604765516"];
    [AppsFlyerLib shared].delegate = self;
    [[AppsFlyerLib shared] start];
}

- (void)onConversionDataFail:(nonnull NSError *)error {
    
}

- (void)onConversionDataSuccess:(nonnull NSDictionary *)conversionInfo {
    
}

@end
