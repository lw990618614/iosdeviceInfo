//
//  MYDTManager.h
//  MYTongDunTest
//
//  Created by apple on 2021/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYDTManager : NSObject
@property (nonatomic,strong)NSMutableArray *testArray;
+ (instancetype)sharedManager ;
-(void)checkMyTD;

@end

NS_ASSUME_NONNULL_END
