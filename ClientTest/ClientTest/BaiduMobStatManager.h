//
//  BaiduMobStatManager.h
//  ClientTest
//
//  Created by apple on 2022/1/12.
//  Copyright © 2022 王鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaiduMobStatManager : NSObject
+ (instancetype)sharedManager ;
-(void)loadBaiduData;

@end

NS_ASSUME_NONNULL_END
