//
//  MYHelper.h
//  MYTongDunTest
//
//  Created by apple on 2021/10/19.
//

#import <Foundation/Foundation.h>
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <TargetConditionals.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <stdio.h>
#import <dlfcn.h>
#import <sys/types.h>
#include <sys/param.h>
#include <sys/ucred.h>
#include <sys/mount.h>
#include <netdb.h>
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <TargetConditionals.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <stdio.h>
#import <dlfcn.h>
#import <sys/types.h>
#include <sys/param.h>
#include <sys/ucred.h>
#include <sys/mount.h>
#include <netdb.h>
#include <dirent.h>
#include <sys/mount.h>


NS_ASSUME_NONNULL_BEGIN

@interface MYHelper : NSObject
+ (instancetype)sharedManager;
-(NSString *)lstatresultWith:(struct stat) buf;
-(NSString *)opendirresultWith:(struct dirent * ) buf;
-(void)makestatTozero:(struct stat) buf;
-(NSString *)fstatfsresultWith:(struct statfs *)buf;


@end

NS_ASSUME_NONNULL_END
