//
//  JiGuangManager.m
//  ClientTest
//
//  Created by apple on 2022/1/12.
//  Copyright © 2022 王鹏飞. All rights reserved.
//

#import "JiGuangManager.h"
#import "JANALYTICSService.h"

@implementation JiGuangManager
+ (instancetype)sharedManager {
    static id _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

-(void)loadJiGuangData{
    JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
    config.appKey = @"4f677b8e72fda422507e55aa";
//    config.channel = @"YStest";
    config.channel = @"App Store";
    [JANALYTICSService setupWithConfig:config];
    [JANALYTICSService setDebug:YES];

}
@end
