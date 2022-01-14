//
//  BaiduMobStatManager.m
//  ClientTest
//
//  Created by apple on 2022/1/12.
//  Copyright © 2022 王鹏飞. All rights reserved.
//

#import "BaiduMobStatManager.h"
#import "BaiduMobStat.h"

@implementation BaiduMobStatManager
+ (instancetype)sharedManager {
    static id _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

-(void)loadBaiduData{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:@"e82d596e3e"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey

}
@end
