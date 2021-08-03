//
//  MYDTCheckManager.m
//  ClientTest
//
//  Created by apple on 2021/7/27.
//  Copyright © 2021 王鹏飞. All rights reserved.
//

#import "MYDTCheckManager.h"

@implementation MYDTCheckManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        NSMutableArray *tt;
        ;
        
    });
    return sharedInstance;
}







@end
