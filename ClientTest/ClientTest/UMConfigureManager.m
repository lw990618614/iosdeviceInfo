//
//  UMConfigureManager.m
//  ClientTest
//
//  Created by apple on 2022/1/12.
//  Copyright © 2022 王鹏飞. All rights reserved.
//

#import "UMConfigureManager.h"
#import <UMCommon/UMCommon.h>

@implementation UMConfigureManager
+ (instancetype)sharedManager {
    static id _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

-(void)loadUMConfigureData{
//    NSString *channel = @"App Store";
    NSString *channel = @"YSTest";
    [UMConfigure initWithAppkey:@"60d00bff8a102159db7183ba" channel:channel];
}
@end
