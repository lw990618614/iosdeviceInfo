//
//  CGDChangAppManager.h
//  
//
//  Created by  on 2021/12/18.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface CGDChangAppManager : NSObject

+ (instancetype)shared;

- (NSDictionary *)queryAppWithBundleID:(NSString *)bundleID;
- (BOOL)saveAppInfo:(NSDictionary *)appInfo;

@end

NS_ASSUME_NONNULL_END
