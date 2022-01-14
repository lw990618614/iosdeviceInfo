//
//  TinTalkingManager.m
//  ClientTest
//
//  Created by apple on 2022/1/12.
//  Copyright © 2022 王鹏飞. All rights reserved.
//

#import "TinTalkingManager.h"
#import "TalkingDataSDK.h"

@implementation TinTalkingManager
+ (instancetype)sharedManager {
    static id _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

-(void)loadTalkingData{
    
    
    NSString *appId = @"0EF03B2D5DB8492DAE09B65A7312F890";
//    NSString *channelId = @"AppStore";
    NSString *channelId = @"";
    [TalkingDataSDK backgroundSessionEnabled];
    [TalkingDataSDK init:appId channelId:channelId custom:@""];


}
@end
