#import <Foundation/Foundation.h>
#import <sys/stat.h>
#import <UIKit/UIKit.h>
#include <mach-o/dyld.h>
#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/sysctl.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <dlfcn.h>
#include "TargetConditionals.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCust : NSObject

+ (instancetype)sharedInstance;

- (BOOL)UVItinitseWithType:(NSString *)type;


- (void)disable_gdb;

BOOL  isStatNotSystemLib();
BOOL isDebugged();
BOOL isInjectedWithDynamicLibrary();
BOOL JCheckKuyt();
BOOL dyldEnvironmentVariables();
BOOL checkCanwriteToprivatePath();
BOOL checkIsEsixtJsBrokensym();
BOOL checkIscangetAsubprogram();

@end

NS_ASSUME_NONNULL_END
