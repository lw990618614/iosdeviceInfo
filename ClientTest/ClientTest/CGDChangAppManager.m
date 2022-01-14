//
//  CGDChangAppManager.m
//  
//
//  Created by  on 2021/12/18.
//

#import "CGDChangAppManager.h"
#import "FMDB.h"
#import "Log.h"

#import <dlfcn.h>

@interface CGDChangAppManager ()

@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, copy) NSString *databasePath;
@end

static NSString *DatabasePath = @"";

@implementation CGDChangAppManager

+ (instancetype)shared {
    
    static CGDChangAppManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CGDChangAppManager alloc] init];
    });
    
    return _instance;
}


#pragma mark - Database

- (NSDictionary *)queryAppWithBundleID:(NSString *)bundleID {
    
    if (bundleID.length == 0)
        return nil;
    
    if (![self.database open])
        return nil;
    
    FMResultSet *rs = [_database executeQuery:[NSString stringWithFormat:@"select application_identifier_tab.[application_identifier], kvs.[id], kvs.[value] from kvs, key_tab,application_identifier_tab where key_tab.[key]='compatibilityInfo' and application_identifier_tab.[application_identifier] = '%@' and kvs.[key] = key_tab.[id] and application_identifier_tab.[id] = kvs.[application_identifier] order by application_identifier_tab.[id]", bundleID]];
    
    void *lib  =  dlopen("/System/Library/PrivateFrameworks/SplashBoard.framework/SplashBoard", RTLD_NOW);
    Log(@"queryApp start lib : %p", lib);
    NSMutableDictionary *ret = @{}.mutableCopy;
    
    if ([rs next]) {
        NSString *_bundleID = [rs stringForColumn:@"application_identifier"];
        NSData *appData = [rs dataForColumn:@"value"];
        int _id = [rs intForColumn:@"id"];
        NSPropertyListFormat format = -1;
        NSError *error = nil;
        NSData *newData = [NSPropertyListSerialization propertyListWithData:appData options:NSPropertyListReadStreamError format:&format error:&error];
        Log(@"bundleID : %@ ; format : %lu ; error : %@", bundleID, format, error);
        Log(@"newData : %@", newData);
        if (newData.length) {
            //XBApplicationLaunchCompatibilityInfo
            id result = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[
                NSClassFromString(@"XBApplicationLaunchCompatibilityInfo"),
                NSClassFromString(@"XBLaunchInterface"),
                NSArray.class
            ]] fromData:newData error:&error];
//            [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:newData error:&error];
            
            if (error) {
                Log(@"unarchiveTopLevelObjectWithData error: %@", error);
            }
            else {
                Log(@"result : %@", result);
                [ret setObject:_bundleID forKey:@"application_identifier"];
                [ret setObject:@(_id) forKey:@"id"];
                [ret setObject:result forKey:@"value"];
            }
        }
    }
    
    [_database close];
    
    return ret.copy;
}

- (BOOL)saveAppInfo:(NSDictionary *)appInfo {

    if (appInfo.count == 0)
        return nil;
    
    if (![_database open])
        return nil;
    
    void *lib = dlopen("/System/Library/PrivateFrameworks/SplashBoard.framework/SplashBoard", RTLD_NOW);
    Log(@"updateApp start lib : %p", lib);
    
    id object = appInfo[@"value"];
    
    NSString *bundlePath = [object valueForKey:@"bundlePath"];
    NSString *bundleContainerPath = [object valueForKey:@"bundleContainerPath"];
    NSString *sandboxPath = [object valueForKey:@"sandboxPath"];
    
    static NSString *startTag = @"/Application/";
    static NSString *metaUUIDStr = @"7AB31422-3C05-4EA7-9997-DD66457B6264";
    static NSString *sandboxUUIDStr = @"1C46729B-274A-4DDD-BF69-5D77EEC81944";
    
    NSRange range = [bundlePath rangeOfString:startTag];
    [object setValue:[bundlePath stringByReplacingCharactersInRange:NSMakeRange(range.location + range.length, metaUUIDStr.length) withString:metaUUIDStr] forKey:@"bundlePath"];
    
    range = [bundleContainerPath rangeOfString:startTag];
    [object setValue:[bundleContainerPath stringByReplacingCharactersInRange:NSMakeRange(range.location + range.length, metaUUIDStr.length) withString:metaUUIDStr] forKey:@"bundleContainerPath"];
    
    range = [sandboxPath rangeOfString:startTag];
    [object setValue:[sandboxPath stringByReplacingCharactersInRange:NSMakeRange(range.location + range.length, sandboxUUIDStr.length) withString:sandboxUUIDStr] forKey:@"sandboxPath"];
    Log(@"change info : %@", object);
    
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:NO error:&error];
    // 生成二进制data
    NSData *outData = [NSPropertyListSerialization dataWithPropertyList:data
                                                          format:NSPropertyListBinaryFormat_v1_0
                                                         options:0 error:&error];
    
    NSString *sql = [NSString stringWithFormat:@"update kvs set value = ? where id = %@", appInfo[@"id"]];
    
    NSPropertyListFormat format = -1;
    NSData *newData = [NSPropertyListSerialization propertyListWithData:outData options:NSPropertyListReadStreamError format:&format error:&error];
    
    id result = [NSKeyedUnarchiver unarchivedObjectOfClass:NSClassFromString(@"XBApplicationLaunchCompatibilityInfo") fromData:newData error:&error];
    Log(@"read result : %@",result);
    BOOL ret = [_database executeUpdate:sql values:@[outData] error:&error];
    if (!ret) {
        Log(@"db update error : %@", error);
    }
    [_database close];
    
    return ret;
}

#pragma mark - Property r/w

- (FMDatabase *)database {
    
    if (!_database)
        _database = [FMDatabase databaseWithPath:self.databasePath];
    
    return _database;
}

- (NSString *)databasePath {
    
    return @"/private/var/mobile/Library/FrontBoard/applicationState.db";
}

@end
