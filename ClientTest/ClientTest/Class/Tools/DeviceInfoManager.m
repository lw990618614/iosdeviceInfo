//
//  DeviceInfoManager.m
//  ClientTest
//
//  Created by Leon on 2017/5/18.
//  Copyright © 2017年 王鹏飞. All rights reserved.
//

#import "DeviceInfoManager.h"
#import "sys/utsname.h"
#import "MGDatabase.h"
#import "WHCFileManager.h"

#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>

// 下面是获取mac地址需要导入的头文件
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <arpa/inet.h>

// 下面是获取ip需要的头文件
#include <ifaddrs.h>


#include <mach/mach.h> // 获取CPU信息所需要引入的头文件
//#include <arpa/inet.h>
//#include <ifaddrs.h>

#import "DeviceDataLibrery.h"

#import <iconv.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#include <ifaddrs.h>
#include <stdio.h>
#import <dlfcn.h>

#include <netinet/in.h>
#include <string.h>
#import <spawn.h>
#import <sys/stat.h>
#import "AntiDebugTest.h"
#import <mach-o/getsect.h>
//#import <Dobby/dobby.h>
#include <sys/syscall.h>

#include <dirent.h>


#include <unistd.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>

id (*MGCopyAnswer)(NSString *) = NULL;
typedef int     mystat(const char *, struct stat *);

#define COPYANSWERARRAY_NAME_KEY        @"key"
#define COPYANSWERARRAY_OBFUSCATED_KEY    @"obfuscated"
#define COPYANSWERARRAY_VALUE_KEY        @"value"

void findMGCopyAnswer()
{
    void *libMobileGestalt = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_LAZY);
    if(libMobileGestalt == NULL)
    {
        NSLog(@"Could not find libMobileGestalt!");
        return;
    }
    
    MGCopyAnswer = dlsym(libMobileGestalt, "MGCopyAnswer");
    if(MGCopyAnswer == NULL)
    {
        NSLog(@"Could not find MGCopyAnswer!");
        return;
    }
    
    NSLog(@"Found MGCopyAnswer %p", MGCopyAnswer);
}



//OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;

@implementation DeviceInfoManager

+ (instancetype)sharedManager {
    static DeviceInfoManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DeviceInfoManager alloc] init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        findMGCopyAnswer();
        [self recreateMGCopyAnswerArrays];
    }
    
    return self;
}

- (void)recreateMGCopyAnswerArrays
{
    NSString * filepath= @"/System/Library/CoreServices/SystemVersion.plist";

//    NSString *filepath = @"/var/mobile/UserData/YSInfo/deviceInfo1.plist";
//    NSString *filepath = @"/var/mobile/Media/";
    BOOL r = [WHCFileManager isExistsAtPath:filepath];
    struct stat stt = {0};
    struct stat lstt = {0};
    stat(filepath.UTF8String, &stt);
    lstat(filepath.UTF8String, &lstt);

    NSMutableArray *mgCopyAnswerArray = [[NSMutableArray alloc] init];
    NSMutableArray *mgCopyAnswerNullArray = [[NSMutableArray alloc] init];
    
    int keyIndex = 0;
    while(true)
    {
        struct tKeyMapping keyMapping = keyMappingTable[keyIndex];
        if(keyMapping.obfuscatedKey == NULL)
            break;
        
        NSString *obfuscatedKey = [NSString stringWithUTF8String:keyMapping.obfuscatedKey];
        id value = MGCopyAnswer(obfuscatedKey);
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:obfuscatedKey forKey:COPYANSWERARRAY_OBFUSCATED_KEY];
        
        if(value != nil)
        {
            [dict setObject:value forKey:COPYANSWERARRAY_VALUE_KEY];
        }
        
        if(keyMapping.key != nil)
        {
            NSString *key = [NSString stringWithUTF8String:keyMapping.key];
            [dict setObject:key forKey:COPYANSWERARRAY_NAME_KEY];
        }
        
        if(value != nil)
        {
            [mgCopyAnswerArray addObject:dict];
        }
        else
        {
            [mgCopyAnswerNullArray addObject:dict];
        }
        
        keyIndex++;
    }
    
    
    // Sort by name
    self.mgCopyAnswerArray = [self sortArrayByName:mgCopyAnswerArray];
    self.mgCopyAnswerNullArray = [self sortArrayByName:mgCopyAnswerNullArray];
}


- (NSArray *)sortArrayByName:(NSArray *)inArray
{
    return [inArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* dict1, NSDictionary* dict2)
    {
        NSString *key1 = [dict1 objectForKey:COPYANSWERARRAY_NAME_KEY];
        NSString *key2 = [dict2 objectForKey:COPYANSWERARRAY_NAME_KEY];
        
        if(key1 == nil && key2 != nil)
        {
            return NSOrderedDescending;
        }
        else if(key1 != nil && key2 == nil)
        {
            return NSOrderedAscending;
        }
        else if([key1 isEqualToString:key2] || (key1 == nil && key2 == nil))
        {
            NSString *obfuscatedKey1 = [dict1 objectForKey:COPYANSWERARRAY_OBFUSCATED_KEY];
            NSString *obfuscatedKey2 = [dict2 objectForKey:COPYANSWERARRAY_OBFUSCATED_KEY];
            return [obfuscatedKey1 compare:obfuscatedKey2 options:(NSCaseInsensitiveSearch | NSNumericSearch | NSDiacriticInsensitiveSearch)];
        }
        else
        {
            return [key1 compare:key2 options:(NSCaseInsensitiveSearch | NSNumericSearch | NSDiacriticInsensitiveSearch)];
        }
    }];
}



/**
 *  获取mac地址
 *
 *  @return mac地址  为了保护用户隐私，每次都不一样，苹果官方哄小孩玩的
 */
- (NSString *)getMacAddress {
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring1 = [NSString stringWithFormat:@"%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];

    free(buf);
    
    return [outstring uppercaseString];
}


// 获取设备型号
- (const NSString *)getDeviceName {
    return [[DeviceDataLibrery sharedLibrery] getDiviceName];
}

- (const NSString *)getInitialFirmware {
    return [[DeviceDataLibrery sharedLibrery] getInitialVersion];
}

- (const NSString *)getLatestFirmware {
    return [[DeviceDataLibrery sharedLibrery] getLatestVersion];
}

// 私有API，上线会被拒
- (NSString *)getDeviceColor {
    return [self _getDeviceColorWithKey:@"DeviceColor"];
}

// 私有API，上线会被拒
- (NSString *)getDeviceEnclosureColor {
    return [self _getDeviceColorWithKey:@"DeviceEnclosureColor"];
}


// 广告位标识符：在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置|隐私|广告追踪里重置此id的值，或限制此id的使用，故此id有可能会取不到值，但好在Apple默认是允许追踪的，而且一般用户都不知道有这么个设置，所以基本上用来监测推广效果，是戳戳有余了
- (NSString *)getIDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}



- (NSString *)getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceModel;
}

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
- (BOOL)canMakePhoneCall {
    __block BOOL can;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
        
    });
    return can;
}
#endif

- (NSDate *)getSystemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}

- (NSUInteger)getCPUFrequency {
    return [self _getSystemInfo:HW_CPU_FREQ];
}

- (NSUInteger)getBusFrequency {
    return [self _getSystemInfo:HW_BUS_FREQ];
}

- (NSUInteger)getRamSize {
    return [self _getSystemInfo:HW_MEMSIZE];
}

- (NSString *)getCPUProcessor {
    return [[DeviceDataLibrery sharedLibrery] getCPUProcessor] ? : @"unKnown";
}

#pragma mark - CPU
- (NSUInteger)getCPUCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

- (float)getCPUUsage {
    float cpu = 0;
    NSArray *cpus = [self getPerCPUUsage];
    if (cpus.count == 0) return -1;
    for (NSNumber *n in cpus) {
        cpu += n.floatValue;
    }
    return cpu;
}

- (NSArray *)getPerCPUUsage {
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        NSMutableArray *cpus = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if (_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            [cpus addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        if (_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        return cpus;
    } else {
        return nil;
    }
}

#pragma mark - Disk
- (NSString *)getApplicationSize {
    unsigned long long documentSize   =  [self _getSizeOfFolder:[self _getDocumentPath]];
    unsigned long long librarySize   =  [self _getSizeOfFolder:[self _getLibraryPath]];
    unsigned long long cacheSize =  [self _getSizeOfFolder:[self _getCachePath]];
    
    unsigned long long total = documentSize + librarySize + cacheSize;
    
    NSString *applicationSize = [NSByteCountFormatter stringFromByteCount:total countStyle:NSByteCountFormatterCountStyleFile];
    return applicationSize;
}

- (int64_t)getTotalDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)getFreeDiskSpace {
    
//    if (@available(iOS 11.0, *)) {
//        NSError *error = nil;
//        NSURL *testURL = [NSURL URLWithString:NSHomeDirectory()];
//
//        NSDictionary *dict = [testURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:&error];
//
//        return (int64_t)dict[NSURLVolumeAvailableCapacityForImportantUsageKey];
//
//
//    } else {
        NSError *error = nil;
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
        if (error) return -1;
        int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
        if (space < 0) space = -1;
        return space;
//    }
    
}

- (int64_t)getUsedDiskSpace {
    int64_t totalDisk = [self getTotalDiskSpace];
    int64_t freeDisk = [self getFreeDiskSpace];
    if (totalDisk < 0 || freeDisk < 0) return -1;
    int64_t usedDisk = totalDisk - freeDisk;
    if (usedDisk < 0) usedDisk = -1;
    return usedDisk;
}

#pragma mark - Memory
- (int64_t)getTotalMemory {
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1) totalMemory = -1;
    return totalMemory;
}

- (int64_t)getActiveMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

- (int64_t)getInActiveMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}

- (int64_t)getFreeMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

- (int64_t)getUsedMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

- (int64_t)getWiredMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}

- (int64_t)getPurgableMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}

#pragma mark - Private Method
- (NSString *)_getDeviceColorWithKey:(NSString *)key {
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector]) {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    if ([device respondsToSelector:selector]) {
        // 消除警告“performSelector may cause a leak because its selector is unknown”
        IMP imp = [device methodForSelector:selector];
        NSString * (*func)(id, SEL, NSString *) = (void *)imp;
        
        return func(device, selector, key);
    }
    return @"unKnown";
}

- (NSUInteger)_getSystemInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

- (NSString *)_getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

- (NSString *)_getLibraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

- (NSString *)_getCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths firstObject];
    return basePath;
}

-(unsigned long long)_getSizeOfFolder:(NSString *)folderPath {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long folderSize = 0;
    
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }
    return folderSize;
}


-(void)pathCheckForDT{
    
    NSString * path1= @"/var/db/timezone/icutz/icutz44l.dat";
    BOOL re1 = [WHCFileManager isExistsAtPath:path1];
    struct stat statinfo1 ={0};
    struct stat lstatinfo1 ={0};

    int  statresult1 =  stat(path1.UTF8String, &statinfo1);
    int  lstatresult1 = lstat(path1.UTF8String, &lstatinfo1);
    
    NSString * path2= @"/var/db/timezone/icutz";
    BOOL re2 = [WHCFileManager isExistsAtPath:path2];
    struct stat statinfo2 ={0};
    struct stat lstatinfo2 ={0};

    int  statresult2 =  stat(path2.UTF8String, &statinfo2);
    int  lstatresult2 = lstat(path2.UTF8String, &lstatinfo2);
    
    NSString * path3= @"/usr/lib/log";
    BOOL re3 = [WHCFileManager isExistsAtPath:path3];
    struct stat statinfo3 ={0};
    struct stat lstatinfo3 ={0};

    int  statresult3 =  stat(path3.UTF8String, &statinfo3);
    int  lstatresult3 = lstat(path3.UTF8String, &lstatinfo3);
    
    NSString * path4= @"/System/Library/CoreServices/SystemVersion.plist";
    BOOL re4 = [WHCFileManager isExistsAtPath:path4];
    struct stat statinfo4 ={0};
    struct stat lstatinfo4 ={0};

    int  statresult4 =  stat(path4.UTF8String, &statinfo4);
    int  lstatresult4 = lstat(path4.UTF8String, &lstatinfo4);

    NSString * path5= @"/System/Library/Caches/apticket.der";
    BOOL re5 = [WHCFileManager isExistsAtPath:path5];
    struct stat statinfo5 ={0};
    struct stat lstatinfo5 ={0};

    int  statresult5 =  stat(path5.UTF8String, &statinfo5);
    int  lstatresult5 = lstat(path5.UTF8String, &lstatinfo5);


    NSString * path6= @"/Library/Managed Preferences/mobile/.GlobalPreferences.plist";
    BOOL re6 = [WHCFileManager isExistsAtPath:path6];
    struct stat statinfo6 ={0};
    struct stat lstatinfo6 ={0};

    int  statresult6 =  stat(path6.UTF8String, &statinfo6);
    int  lstatresult6 = lstat(path6.UTF8String, &lstatinfo6);


    NSString * path7= @"/var/wireless";
    BOOL re7 = [WHCFileManager isExistsAtPath:path7];
    struct stat statinfo7 ={0};
    struct stat lstatinfo7 ={0};

    int  statresult7 =  stat(path7.UTF8String, &statinfo7);
    int  lstatresult7 = lstat(path7.UTF8String, &lstatinfo7);


    NSString * path8= @"/var/root/";
    BOOL re8 = [WHCFileManager isExistsAtPath:path8];
    struct stat statinfo8 ={0};
    struct stat lstatinfo8 ={0};

    int  statresult8 =  stat(path8.UTF8String, &statinfo8);
    int  lstatresult8 = lstat(path8.UTF8String, &lstatinfo8);


    NSString * path9= @"/var/mobile/Library/Caches/com.apple.keyboards/version";
    BOOL re9 = [WHCFileManager isExistsAtPath:path9];
    struct stat statinfo9 ={0};
    struct stat lstatinfo9 ={0};

    int  statresult9 =  stat(path9.UTF8String, &statinfo9);
    int  lstatresult9 = lstat(path9.UTF8String, &lstatinfo9);


    NSString * path10= @"/var/mobile/Library/Caches/GeoServices/SearchAttribution.pbd";
    BOOL re10 = [WHCFileManager isExistsAtPath:path10];
    struct stat statinfo10 ={0};
    struct stat lstatinfo10 ={0};

    int  statresult10 =  stat(path10.UTF8String, &statinfo10);
    int  lstatresult10 = lstat(path10.UTF8String, &lstatinfo10);


    NSString * path11= @"/var/mobile/Library/Caches/GeoServices/Resources/supportedCountriesDirections-12.plist";
    BOOL re11 = [WHCFileManager isExistsAtPath:path11];
    struct stat statinfo11 ={0};
    struct stat lstatinfo11 ={0};

    int  statresult11 =  stat(path11.UTF8String, &statinfo11);
    int  lstatresult11 = lstat(path11.UTF8String, &lstatinfo11);


    NSString * path12= @"/var/mobile/Library/Caches/GeoServices/Resources/supportedCountriesDirections-12.plist";
    BOOL re12 = [WHCFileManager isExistsAtPath:path12];
    struct stat statinfo12 ={0};
    struct stat lstatinfo12 ={0};

    int  statresult12 =  stat(path12.UTF8String, &statinfo12);
    int  lstatresult12 = lstat(path12.UTF8String, &lstatinfo12);


    NSString * path13= @"/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1@2x.png";
    BOOL re13 = [WHCFileManager isExistsAtPath:path13];
    struct stat statinfo13 ={0};
    struct stat lstatinfo13 ={0};

    int  statresult13 =  stat(path13.UTF8String, &statinfo13);
    int  lstatresult13 = lstat(path13.UTF8String, &lstatinfo13);


    NSString * path14= @"/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png";
    BOOL re14 = [WHCFileManager isExistsAtPath:path14];
    struct stat statinfo14 ={0};
    struct stat lstatinfo14 ={0};

    int  statresult14 =  stat(path14.UTF8String, &statinfo14);
    int  lstatresult14 = lstat(path14.UTF8String, &lstatinfo14);


    NSString * path15= @"/var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml";
    BOOL re15 = [WHCFileManager isExistsAtPath:path15];
    struct stat statinfo15 ={0};
    struct stat lstatinfo15 ={0};

    int  statresult15 =  stat(path15.UTF8String, &statinfo15);
    int  lstatresult15 = lstat(path15.UTF8String, &lstatinfo15);

    
    NSString * path16= @"/var/mobile/Library/Caches/DateFormats.plist";
    BOOL re16 = [WHCFileManager isExistsAtPath:path16];
    struct stat statinfo16 ={0};
    struct stat lstatinfo16 ={0};

    int  statresult16 =  stat(path16.UTF8String, &statinfo16);
    int  lstatresult16 = lstat(path16.UTF8String, &lstatinfo16);

    
    NSString * path17= @"/var/mobile/Library/Caches/Checkpoint.plist";
    BOOL re17 = [WHCFileManager isExistsAtPath:path17];
    struct stat statinfo17 ={0};
    struct stat lstatinfo17 ={0};

    int  statresult17 =  stat(path17.UTF8String, &statinfo17);
    int  lstatresult17 = lstat(path17.UTF8String, &lstatinfo17);

    
    NSString * path18= @"/var/db/timezone/localtime";
    BOOL re18 = [WHCFileManager isExistsAtPath:path18];
    struct stat statinfo18 ={0};
    struct stat lstatinfo18 ={0};

    int  statresult18 =  stat(path18.UTF8String, &statinfo18);
    int  lstatresult18 = lstat(path18.UTF8String, &lstatinfo18);

    
    NSString * path19= @"/var/mobile";
    BOOL re19 = [WHCFileManager isExistsAtPath:path19];
    struct stat statinfo19 ={0};
    struct stat lstatinfo19 ={0};

    int  statresult19 =  stat(path19.UTF8String, &statinfo19);
    int  lstatresult19 = lstat(path19.UTF8String, &lstatinfo19);

    
    NSString * path20= @"/usr/local";
    BOOL re20 = [WHCFileManager isExistsAtPath:path20];
    struct stat statinfo20 ={0};
    struct stat lstatinfo20 ={0};

    int  statresult20 =  stat(path20.UTF8String, &statinfo20);
    int  lstatresult20 = lstat(path20.UTF8String, &lstatinfo20);

    NSString * path21= @"/usr";
   NSArray *r = [path21 pathComponents];
    
    BOOL re21 = [WHCFileManager isExistsAtPath:path21];
    struct stat statinfo21 ={0};
    struct stat lstatinfo21 ={0};

    int  statresult21 =  stat(path21.UTF8String, &statinfo21);
    int  lstatresult21 = lstat(path21.UTF8String, &lstatinfo21);
//
//
    
    NSString * pat= @"/var/mobile/Library/LASD/lasdcdma.db";
    BOOL re = [WHCFileManager isExistsAtPath:pat];
    struct stat statinfo ={0};
    struct stat lstatinfo ={0};

    int  statresult =  stat(pat.UTF8String, &statinfo);
    int  lstatresult = lstat(pat.UTF8String, &lstatinfo);

    
    NSString * path22= @"/var/wireless/Library/LASD/lasdcdma.db";
    BOOL re22 = [WHCFileManager isExistsAtPath:path22];
    struct stat statinfo22 ={0};
    struct stat lstatinfo22 ={0};

    int  statresult22 =  stat(path22.UTF8String, &statinfo22);
    int  lstatresult22 = lstat(path22.UTF8String, &lstatinfo22);

    
    NSString * path23= @"/var/wireless/Library/LASD/lasdgsm.db";
    BOOL re23 = [WHCFileManager isExistsAtPath:path23];
    struct stat statinfo23 ={0};
    struct stat lstatinfo23 ={0};

    int  statresult23 =  stat(path23.UTF8String, &statinfo23);
    int  lstatresult23 = lstat(path23.UTF8String, &lstatinfo23);

    
    NSString * path24= @"/var/wireless/Library/LASD/lasdlte.db";
    BOOL re24 = [WHCFileManager isExistsAtPath:path24];
    struct stat statinfo24 ={0};
    struct stat lstatinfo24 ={0};

    int  statresult24 =  stat(path24.UTF8String, &statinfo24);
    int  lstatresult24 = lstat(path24.UTF8String, &lstatinfo24);

    
    NSString * path25= @"/var/wireless/Library/LASD/lasdscdma.db";
    BOOL re25 = [WHCFileManager isExistsAtPath:path25];
    struct stat statinfo25 ={0};
    struct stat lstatinfo25 ={0};

    int  statresult25 =  stat(path25.UTF8String, &statinfo25);
    int  lstatresult25 = lstat(path25.UTF8String, &lstatinfo25);

    
    NSString * path26= @"/var/wireless/Library/LASD/lasdumts.db";
    BOOL re26 = [WHCFileManager isExistsAtPath:path26];
    struct stat statinfo26 ={0};
    struct stat lstatinfo26 ={0};

    int  statresult26 =  stat(path26.UTF8String, &statinfo26);
    int  lstatresult26 = lstat(path26.UTF8String, &lstatinfo26);


    
    NSString * path27= @"/var/run/syslog";
    BOOL re27 = [WHCFileManager isExistsAtPath:path27];
    struct stat statinfo27 ={0};
    struct stat lstatinfo27 ={0};

    int  statresult27 =  stat(path27.UTF8String, &statinfo27);
    int  lstatresult27 = lstat(path27.UTF8String, &lstatinfo27);


    
    NSString * path28= @"/var/run/printd";
    BOOL re28 = [WHCFileManager isExistsAtPath:path28];
    struct stat statinfo28 ={0};
    struct stat lstatinfo28 ={0};

    int  statresult28 =  stat(path28.UTF8String, &statinfo28);
    int  lstatresult28 = lstat(path28.UTF8String, &lstatinfo28);


    
    NSString * path29= @"/var/mobile/Library/UserConfigurationProfiles/PublicInfo/MCMeta.plist";
    BOOL re29 = [WHCFileManager isExistsAtPath:path29];
    struct stat statinfo29 ={0};
    struct stat lstatinfo29 ={0};

    int  statresult29 =  stat(path29.UTF8String, &statinfo29);
    int  lstatresult29 = lstat(path29.UTF8String, &lstatinfo29);


    
    NSString * path30= @"/var/mobile/Library/Preferences";
    BOOL re30 = [WHCFileManager isExistsAtPath:path30];
    struct stat statinfo30 ={0};
    struct stat lstatinfo30 ={0};

    int  statresult30 =  stat(path30.UTF8String, &statinfo30);
    int  lstatresult30 = lstat(path30.UTF8String, &lstatinfo30);


    
    NSString * path31= @"/var/mobile/Library/Operator Bundle.bundle";
    BOOL re31 = [WHCFileManager isExistsAtPath:path31];
    struct stat statinfo31 ={0};
    struct stat lstatinfo31 ={0};

    int  statresult31 =  stat(path31.UTF8String, &statinfo31);
    int  lstatresult31 = lstat(path31.UTF8String, &lstatinfo31);


    
    NSString * path32= @"/var/mobile/Library/Carrier Bundles/Overlay";
    BOOL re32 = [WHCFileManager isExistsAtPath:path32];
    struct stat statinfo32 ={0};
    struct stat lstatinfo32 ={0};

    int  statresult32 =  stat(path32.UTF8String, &statinfo32);
    int  lstatresult32 = lstat(path32.UTF8String, &lstatinfo32);


    
    NSString * path33= @"/var/mobile/Library/Caches/GeoServices/Resources/night-DetailedLandCoverSand-1@2x.png";
    BOOL re33 = [WHCFileManager isExistsAtPath:path33];
    struct stat statinfo33 ={0};
    struct stat lstatinfo33 ={0};

    int  statresult33 =  stat(path33.UTF8String, &statinfo33);
    int  lstatresult33 = lstat(path33.UTF8String, &lstatinfo33);



    
    NSString * path35= @"/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png";
    BOOL re35 = [WHCFileManager isExistsAtPath:path35];
    struct stat statinfo35 ={0};
    struct stat lstatinfo35 ={0};

    int  statresult35 =  stat(path35.UTF8String, &statinfo35);
    int  lstatresult35 = lstat(path35.UTF8String, &lstatinfo35);


    
    NSString * path36= @"/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1@2x.png";
    BOOL re36 = [WHCFileManager isExistsAtPath:path36];
    struct stat statinfo36 ={0};
    struct stat lstatinfo36 ={0};

    int  statresult36 =  stat(path36.UTF8String, &statinfo36);
    int  lstatresult36 = lstat(path36.UTF8String, &lstatinfo36);


    
    NSString * path37= @"/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadLocalRoad-1@2x.png";
    BOOL re37 = [WHCFileManager isExistsAtPath:path37];
    struct stat statinfo37 ={0};
    struct stat lstatinfo37 ={0};

    int  statresult37 =  stat(path37.UTF8String, &statinfo37);
    int  lstatresult37 = lstat(path37.UTF8String, &lstatinfo37);

//    statinfo37.st_gid =304;
    
    
    NSString * path38= @"/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadHighway-1@2x.png";
    BOOL re38 = [WHCFileManager isExistsAtPath:path38];
    struct stat statinfo38 ={0};
    struct stat lstatinfo38 ={0};

    int  statresult38 =  stat(path38.UTF8String, &statinfo38);
    int  lstatresult38 = lstat(path38.UTF8String, &lstatinfo38);

    
    
    NSString * path39= @"/var/mobile/Library/Caches/GeoServices/Resources/LandCoverGradient16-1@2x.png";
    BOOL re39 = [WHCFileManager isExistsAtPath:path39];
    struct stat statinfo39 ={0};
    struct stat lstatinfo39 ={0};

    int  statresult39 =  stat(path39.UTF8String, &statinfo39);
    int  lstatresult39 = lstat(path39.UTF8String, &lstatinfo39);

    
    
    NSString * path40= @"/var/mobile/Library/Caches/GeoServices/Resources/DetailedLandCoverPavedArea-1@2x.png";
    BOOL re40 = [WHCFileManager isExistsAtPath:path40];
    struct stat statinfo40 ={0};
    struct stat lstatinfo40 ={0};

    int  statresult40 =  stat(path40.UTF8String, &statinfo40);
    int  lstatresult40 = lstat(path40.UTF8String, &lstatinfo40);

    
    
    NSString * path41= @"/var/mobile/Library";
    BOOL re41 = [WHCFileManager isExistsAtPath:path41];
    struct stat statinfo41 ={0};
    struct stat lstatinfo41 ={0};

    int  statresult41 =  stat(path41.UTF8String, &statinfo41);
    int  lstatresult41 = lstat(path41.UTF8String, &lstatinfo41);

    
    
    NSString * path43= @"/var/mobile/Library/Caches/GeoServices/ActiveTileGroup.pbd";
    BOOL re43 = [WHCFileManager isExistsAtPath:path43];
    struct stat statinfo43 ={0};
    struct stat lstatinfo43 ={0};

    int  statresult43 =  stat(path43.UTF8String, &statinfo43);
    int  lstatresult43 = lstat(path43.UTF8String, &lstatinfo43);

    
    
    NSString * path44= @"/var/mobile/Library/Caches/GeoServices/Experiments.pbd";
    BOOL re44 = [WHCFileManager isExistsAtPath:path44];
    struct stat statinfo44 ={0};
    struct stat lstatinfo44 ={0};

    int  statresult44 =  stat(path44.UTF8String, &statinfo44);
    int  lstatresult44 = lstat(path44.UTF8String, &lstatinfo44);

    
    
    NSString * path45= @"/private";
    BOOL re45 = [WHCFileManager isExistsAtPath:path45];
    struct stat statinfo45 ={0};
    struct stat lstatinfo45 ={0};

    int  statresult45 =  stat(path45.UTF8String, &statinfo45);
    int  lstatresult45 = lstat(path45.UTF8String, &lstatinfo45);

    
    
    NSString * path46= @"/var";
    BOOL re46 = [WHCFileManager isExistsAtPath:path46];
    struct stat statinfo46 ={0};
    struct stat lstatinfo46 ={0};
    int  statresult46 =  stat(path46.UTF8String, &statinfo46);
    int  lstatresult46 = lstat(path46.UTF8String, &lstatinfo46);

    
    NSString * path47= @"/var/Managed Preferences/mobile/.GlobalPreferences.plist";
    BOOL re47 = [WHCFileManager isExistsAtPath:path47];
    struct stat statinfo47 ={0};
    struct stat lstatinfo47 ={0};

    int  statresult47 =  stat(path47.UTF8String, &statinfo47);
    int  lstatresult47 = lstat(path47.UTF8String, &lstatinfo47);


    
    
    NSString * path48= @"/var/Managed Preferences/mobile/com.apple.webcontentfilter.plist";
    BOOL re48 = [WHCFileManager isExistsAtPath:path48];
    struct stat statinfo48 ={0};
    struct stat lstatinfo48 ={0};

    int  statresult48 =  stat(path48.UTF8String, &statinfo48);
    int  lstatresult48 = lstat(path48.UTF8String, &lstatinfo48);


    
    
    NSString * path49= @"/var/containers/Data/System/com.apple.geod/.com.apple.mobile_container_manager.metadata.plist";
    BOOL re49 = [WHCFileManager isExistsAtPath:path49];
    struct stat statinfo49 ={0};
    struct stat lstatinfo49 ={0};

    int  statresult49 =  stat(path49.UTF8String, &statinfo49);
    int  lstatresult49 = lstat(path49.UTF8String, &lstatinfo49);


    
    
    NSString * path50= @"/var/containers/Shared/SystemGroup/systemgroup.com.apple.lsd.iconscache/.com.apple.mobile_container_manager.metadata.plist";
    BOOL re50 = [WHCFileManager isExistsAtPath:path50];
    struct stat statinfo50 ={0};
    struct stat lstatinfo50 ={0};

    int  statresult50 =  stat(path50.UTF8String, &statinfo50);
    int  lstatresult50 = lstat(path50.UTF8String, &lstatinfo50);


    
    
    NSString * path51= @"/Library/Managed Preferences/mobile/com.apple.webcontentfilter.plist";
    BOOL re51 = [WHCFileManager isExistsAtPath:path51];
    struct stat statinfo51 ={0};
    struct stat lstatinfo51 ={0};

    int  statresult51 =  stat(path51.UTF8String, &statinfo51);
    int  lstatresult51 = lstat(path51.UTF8String, &lstatinfo51);


    
    
    NSString * path52= @"/System/Library/Backup/Domains.plist";
    BOOL re52 = [WHCFileManager isExistsAtPath:path52];
    struct stat statinfo52 ={0};
    struct stat lstatinfo52 ={0};

    int  statresult52 =  stat(path52.UTF8String, &statinfo52);
    int  lstatresult52 = lstat(path52.UTF8String, &lstatinfo52);


    
    
    NSString * path53= @"/System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64";
    BOOL re53 = [WHCFileManager isExistsAtPath:path53];
    struct stat statinfo53 ={0};
    struct stat lstatinfo53 ={0};

    int  statresult53 =  stat(path53.UTF8String, &statinfo53);
    int  lstatresult53 = lstat(path53.UTF8String, &lstatinfo53);


    
    
    NSString * path54= @"/System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64e";
    BOOL re54 = [WHCFileManager isExistsAtPath:path54];
    struct stat statinfo54 ={0};
    struct stat lstatinfo54 ={0};

    int  statresult54 =  stat(path54.UTF8String, &statinfo54);
    int  lstatresult54 = lstat(path54.UTF8String, &lstatinfo54);


    
    
    NSString * path55= @"/System/Library/Caches/com.apple.dyld/dyld_shared_cache_armv7s";
    BOOL re55 = [WHCFileManager isExistsAtPath:path55];
    struct stat statinfo55 ={0};
    struct stat lstatinfo55 ={0};

    int  statresult55 =  stat(path55.UTF8String, &statinfo55);
    int  lstatresult55 = lstat(path55.UTF8String, &lstatinfo55);


    
    
    NSString * path56= @"/System/Library/Caches/fps/lskd.rl";
    BOOL re56 = [WHCFileManager isExistsAtPath:path56];
    struct stat statinfo56 ={0};
    struct stat lstatinfo56 ={0};

    int  statresult56 =  stat(path56.UTF8String, &statinfo56);
    int  lstatresult56 = lstat(path56.UTF8String, &lstatinfo56);


    
    
    NSString * path57= @"/System/Library/CoreServices/powerd.bundle/Info.plist";
    BOOL re57 = [WHCFileManager isExistsAtPath:path57];
    struct stat statinfo57 ={0};
    struct stat lstatinfo57 ={0};

    int  statresult57 =  stat(path57.UTF8String, &statinfo57);
    int  lstatresult57 = lstat(path57.UTF8String, &lstatinfo57);


    
    
    NSString * path58= @"/System/Library/Filesystems/hfs.fs/Info.plist";
    BOOL re58 = [WHCFileManager isExistsAtPath:path58];
    struct stat statinfo58 ={0};
    struct stat lstatinfo58 ={0};

    int  statresult58 =  stat(path58.UTF8String, &statinfo58);
    int  lstatresult58 = lstat(path58.UTF8String, &lstatinfo58);

    
    
    NSString * path59= @"/System/Library/LaunchDaemons/bootps.plist";
    BOOL re59 = [WHCFileManager isExistsAtPath:path59];
    struct stat statinfo59 ={0};
    struct stat lstatinfo59 ={0};

    int  statresult59 =  stat(path59.UTF8String, &statinfo59);
    int  lstatresult59 = lstat(path59.UTF8String, &lstatinfo59);

    
    
    NSString * path60= @"/System/Library/LaunchDaemons/com.apple.powerd.plist";
    BOOL re60 = [WHCFileManager isExistsAtPath:path60];
    struct stat statinfo60 ={0};
    struct stat lstatinfo60 ={0};

    int  statresult60 =  stat(path60.UTF8String, &statinfo60);
    int  lstatresult60 = lstat(path60.UTF8String, &lstatinfo60);

    
    
    NSString * path61= @"/System/Library/Lockdown/iPhoneDebug.pem";
    BOOL re61 = [WHCFileManager isExistsAtPath:path61];
    struct stat statinfo61 ={0};
    struct stat lstatinfo61 ={0};

    int  statresult61 =  stat(path61.UTF8String, &statinfo61);
    int  lstatresult61 = lstat(path61.UTF8String, &lstatinfo61);

    
    
    NSString * path62= @"/System/Library/Lockdown/iPhoneDeviceCA.pem";
    BOOL re62 = [WHCFileManager isExistsAtPath:path62];
    struct stat statinfo62 ={0};
    struct stat lstatinfo62 ={0};

    int  statresult62 =  stat(path62.UTF8String, &statinfo62);
    int  lstatresult62 = lstat(path62.UTF8String, &lstatinfo62);

    
    
    NSString * path63= @"/System/Library/PrivateFrameworks/AppSupport.framework/Info.plist";
    BOOL re63 = [WHCFileManager isExistsAtPath:path63];
    struct stat statinfo63 ={0};
    struct stat lstatinfo63 ={0};

    int  statresult63 =  stat(path63.UTF8String, &statinfo63);
    int  lstatresult63 = lstat(path63.UTF8String, &lstatinfo63);

    
    
    NSString * path64= @"/System/Library/Spotlight/domains.plist";
    BOOL re64 = [WHCFileManager isExistsAtPath:path64];
    struct stat statinfo64 ={0};
    struct stat lstatinfo64 ={0};

    int  statresult64 =  stat(path64.UTF8String, &statinfo64);
    int  lstatresult64 = lstat(path64.UTF8String, &lstatinfo64);

    
    
    NSString * path65= @"/dev/random";
    BOOL re65 = [WHCFileManager isExistsAtPath:path65];
    struct stat statinfo65 ={0};
    struct stat lstatinfo65 ={0};

    int  statresult65 =  stat(path65.UTF8String, &statinfo65);
    int  lstatresult65= lstat(path65.UTF8String, &lstatinfo65);

    
    
    NSString * path66= @"/etc/group";
    BOOL re66 = [WHCFileManager isExistsAtPath:path66];
    struct stat statinfo66 ={0};
    struct stat lstatinfo66 ={0};

    int  statresult66 =  stat(path66.UTF8String, &statinfo66);
    int  lstatresult66 = lstat(path66.UTF8String, &lstatinfo66);

    
    
    NSString * path67= @"/etc/hosts";
    BOOL re67 = [WHCFileManager isExistsAtPath:path67];
    struct stat statinfo67 ={0};
    struct stat lstatinfo67 ={0};

    int  statresult67 =  stat(path67.UTF8String, &statinfo67);
    int  lstatresult67 = lstat(path67.UTF8String, &lstatinfo67);

    
    
    NSString * path68= @"/etc/passwd";
    BOOL re68 = [WHCFileManager isExistsAtPath:path68];
    struct stat statinfo68 ={0};
    struct stat lstatinfo68 ={0};

    int  statresult68 =  stat(path68.UTF8String, &statinfo68);
    int  lstatresult68 = lstat(path68.UTF8String, &lstatinfo68);


    
    NSString * path69= @"/var/db/timezone/zoneinfo/Antarctica/Macquarie";
    BOOL re69 = [WHCFileManager isExistsAtPath:path69];
    struct stat statinfo69 ={0};
    struct stat lstatinfo69 ={0};

    int  statresult69 =  stat(path69.UTF8String, &statinfo69);
    int  lstatresult69 = lstat(path69.UTF8String, &lstatinfo69);
    
    NSString * path70= @"/System/Library/Fonts/CoreUI/SFUI.ttf";
    BOOL re70= [WHCFileManager isExistsAtPath:path70];
    struct stat statinfo70 ={0};
    struct stat lstatinfo70 ={0};

    int  statresult70 =  stat(path70.UTF8String, &statinfo70);
    int  lstatresult70 = lstat(path70.UTF8String, &lstatinfo70);


    NSString * path71= @"/var/stash";
    BOOL re71= [WHCFileManager isExistsAtPath:path71];
    struct stat statinfo71 ={0};
    struct stat lstatinfo71 ={0};

    int  statresult71 =  stat(path71.UTF8String, &statinfo71);
    int  lstatresult71 = lstat(path71.UTF8String, &lstatinfo71);
    
    
    NSString * path72= @"/var/db/stash";
    BOOL re72= [WHCFileManager isExistsAtPath:path72];
    struct stat statinfo72 ={0};
    struct stat lstatinfo72 ={0};

    int  statresult72 =  stat(path72.UTF8String, &statinfo72);
    int  lstatresult72 = lstat(path72.UTF8String, &lstatinfo72);

    
    NSString * path73= @"/Applications";
    BOOL re73= [WHCFileManager isExistsAtPath:path73];
    struct stat statinfo73 ={0};
    struct stat lstatinfo73 ={0};

    int  statresult73 =  stat(path73.UTF8String, &statinfo73);
    int  lstatresult73 = lstat(path73.UTF8String, &lstatinfo73);

    
    NSString * path74= @"/Library/Managed Preferences/mobile/com.apple.SystemConfiguration.plist";
    BOOL re74= [WHCFileManager isExistsAtPath:path74];
    struct stat statinfo74 ={0};
    struct stat lstatinfo74 ={0};

    int  statresult74 =  stat(path74.UTF8String, &statinfo74);
    int  lstatresult74 = lstat(path74.UTF8String, &lstatinfo74);

    
    NSString * path75= @"/System/Library/Frameworks/CFNetwork.framework/en.lproj/Localizable.strings";
    BOOL re75= [WHCFileManager isExistsAtPath:path75];
    struct stat statinfo75 ={0};
    struct stat lstatinfo75 ={0};

    int  statresult75 =  stat(path75.UTF8String, &statinfo75);
    int  lstatresult75 = lstat(path75.UTF8String, &lstatinfo75);
    
    NSString * path76= @"/System/Library/Frameworks/CFNetwork.framework//en.lproj";
    BOOL re76= [WHCFileManager isExistsAtPath:path76];
    struct stat statinfo76 ={0};
    struct stat lstatinfo76 ={0};

    int  statresult76 =  stat(path76.UTF8String, &statinfo76);
    int  lstatresult76 = lstat(path76.UTF8String, &lstatinfo76);

    NSString * path77= @"/System";
    BOOL re77= [WHCFileManager isExistsAtPath:path77];
    struct stat statinfo77 ={0};
    struct stat lstatinfo77 ={0};

    int  statresult77 =  stat(path77.UTF8String, &statinfo77);
    int  lstatresult77 = lstat(path77.UTF8String, &lstatinfo77);
    
    
    
    NSString * path78= @"/System/Library/CoreServices/CoreGlyphs.bundle";
    BOOL re78= [WHCFileManager isExistsAtPath:path78];
    struct stat statinfo78 ={0};
    struct stat lstatinfo78 ={0};

    int  statresult78 =  stat(path78.UTF8String, &statinfo78);
    int  lstatresult78 = lstat(path78.UTF8String, &lstatinfo78);
    
    
    NSString * path79= @"/System/Library/Frameworks/UIKit.framework/UIKit";
    BOOL re79= [WHCFileManager isExistsAtPath:path79];
    struct stat statinfo79 ={0};
    struct stat lstatinfo79 ={0};

    int  statresult79 =  stat(path79.UTF8String, &statinfo79);
    int  lstatresult79 = lstat(path79.UTF8String, &lstatinfo79);

    
    
    
    NSString * path80= @"/System/Library/Frameworks/CoreMedia.framework/CoreMedia";
    BOOL re80= [WHCFileManager isExistsAtPath:path80];
    struct stat statinfo80 ={0};
    struct stat lstatinfo80 ={0};

    int  statresult80 =  stat(path80.UTF8String, &statinfo80);
    int  lstatresult80 = lstat(path80.UTF8String, &lstatinfo80);

//    NSString * path81= @"/System/Library/Frameworks/QuartzCore.framework";
//    BOOL re81 = [WHCFileManager isExistsAtPath:path81];
//    struct stat statinfo81 ={0};
//    struct stat lstatinfo81 ={0};
//
//    int  statresult81 =  stat(path81.UTF8String, &statinfo81);
//    int  lstatresult81 = lstat(path81.UTF8String, &lstatinfo81);
   
    

//    NSString * path81= @"/var/mobile/UserData/YSInfo/deviceInfo.plist";
//    NSString * path81= @"/var/mobile/Media/deviceInfo.plist";
    NSString * path81 =  @"/System/Library/Frameworks/QuartzCore.framework/Info.plist";
   NSString *topath = [NSHomeDirectory() stringByAppendingPathComponent:@"ttt"];
    NSError *erro;
//    [WHCFileManager isExistsAtPath:path81];
    NSData *data =[NSData dataWithContentsOfFile:path81];
    BOOL re81= [WHCFileManager isExistsAtPath:path81];
    struct stat statinfo81 ={0};
    struct stat lstatinfo81 ={0};

    int  statresult81 =  stat(path81.UTF8String, &statinfo81);
    int  lstatresult81 = lstat(path81.UTF8String, &lstatinfo81);


//
//    NSString * path= @"";
//    BOOL re= [WHCFileManager isExistsAtPath:path];
//    struct stat statinfo ={0};
//    struct stat lstatinfo ={0};
//
//    int  statresult =  stat(path.UTF8String, &statinfo);
//    int  lstatresult = lstat(path.UTF8String, &lstatinfo);

}


@end
