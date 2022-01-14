//
//  AppsFlyerLibManager.h
//  ClientTest
//
//  Created by apple on 2022/1/13.
//  Copyright © 2022 王鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppsFlyerLib/AppsFlyerLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppsFlyerLibManager : NSObject < AppsFlyerLibDelegate>


+ (instancetype)sharedManager ;


-(void)loadAppsFlyerLibData ;
@end

NS_ASSUME_NONNULL_END
