//
//  JiGuangManager.h
//  ClientTest
//
//  Created by apple on 2022/1/12.
//  Copyright © 2022 王鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JiGuangManager : NSObject
+ (instancetype)sharedManager ;
-(void)loadJiGuangData;
@end

NS_ASSUME_NONNULL_END
