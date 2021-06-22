//
//  NetWorkInfoManager.m
//  ClientTest
//
//  Created by Leon on 2017/8/23.
//  Copyright © 2017年 王鹏飞. All rights reserved.
//

#import "NetWorkInfoManager.h"
#import "WHCFileManager.h"
#import "OpenUDID.h"
#import "UserCust.h"
#import <SystemConfiguration/CaptiveNetwork.h>
// 下面是获取ip需要的头文件
#include <ifaddrs.h>
#include <sys/socket.h> // Per msqr
#import <sys/ioctl.h>
#include <net/if.h>
#import <arpa/inet.h>
#include <sys/socket.h> // Per msqr
#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#import <sys/utsname.h>
#include <net/if.h>
#import <UIKit/UIKit.h>
#include <net/if_dl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <sys/sysctl.h>

#include <stdio.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#import <spawn.h>
#import <sys/stat.h>

@implementation NetWorkInfoManager

+ (instancetype)sharedManager {
    static NetWorkInfoManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NetWorkInfoManager alloc] init];
    });
    return _manager;
    
}

-(instancetype)init{
    if (self = [super init]) {
        
//        CLLocationManager *locationManager;//定义Manager
        // 判断定位操作是否被允许
        if([CLLocationManager locationServicesEnabled]) {
          _locationManager = [[CLLocationManager alloc] init];
           
           self.locationManager.delegate = self;
        }else {
           //提示用户无法进行定位操作
        }
        
        [self.locationManager requestWhenInUseAuthorization];
         
        // 开始定位
        [_locationManager startUpdatingLocation];

    }
    return self;
}
// 获取ip
- (NSString *)getDeviceIPAddresses {
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}

- (NSString *)ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
//                if ([NSString stringWithUTF8String:addr->ifa_name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                      char *tt=  inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));//
                        if (strlen(str) > 0) {
                            
                            address = [NSString stringWithUTF8String:str];
                            
                        }
                        NSLog(@"new new_inet_ntop5555 %@ %@",address,[NSString stringWithUTF8String:addr->ifa_name]);

                    }
                        

                    default: break;
                }

                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address ? address : @"该设备不存在该ip地址";
}

//const char *iinet_ntop(int family, const void *addrptr, char *strptr, size_t len)
//{
//    const u_char *p = (const u_char*)addrptr;
//    if (family == AF_INET) {
//        char temp[INET_ADDRSTRLEN];
//        snprintf(temp, sizeof(temp), "%d.%d.%d.%d", p[0], p[1], p[2], p[3]);
//        if (strlen(temp) >= len) {
//            errno = ENOSPC;
//            return  (NULL);
//        }
////        strcpy(temp, "ddsf::323:234:@3423");
//
//        strcpy(strptr, temp);
//        return (strptr);
//    }
//    return (NULL);
//}

const char* simplified_inet_ntop(int family, const void *addrptr, char *strptr, int len)
{
    unsigned char temp_str[200] = "1110::bc:f91d:7df4:2ff3";
    int lengg = strlen(temp_str);
    
    strcpy(strptr, temp_str);
    
    len = lengg;
    memset(temp_str, 0,200);
    if (family == AF_INET6) {
        
    }
    return  temp_str;
}

- (NSString *)getIpAddressWIFI {
    return [self ipAddressWithIfaName:@"en0"];
}

- (NSString *)getIpAddressCell {
    return [self ipAddressWithIfaName:@"pdp_ip0"];
}


- (NSString*)getIpMywifi
{
//    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
//
//        id info = nil;
//        for (NSString *ifnam in ifs) {
//            info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//            if (info && [info count]) {
//                break;
//            }
//        }
//        NSDictionary *dctySSID = (NSDictionary *)info;
//
//        NSString *ssid = [NSString stringWithFormat:@"%@ %@",[dctySSID objectForKey:@"SSID"],[dctySSID objectForKey:@"BSSID"]] ;
//
//
//        return ssid;
    
//    int                 mib[6];
//      size_t              len;
//      char                *buf;
//      unsigned char       *ptr;
//      struct if_msghdr    *ifm;
//      struct sockaddr_dl  *sdl;
//
//      mib[0] = CTL_NET;
//      mib[1] = AF_ROUTE;
//      mib[2] = 0;
//      mib[3] = AF_LINK;
//      mib[4] = NET_RT_IFLIST;
//
//      if ((mib[5] = if_nametoindex("en0")) == 0) {
//          printf("Error: if_nametoindex error/n");
//          return NULL;
//      }
//
//      if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//          printf("Error: sysctl, take 1/n");
//          return NULL;
//      }
//
//      if ((buf = malloc(len)) == NULL) {
//          printf("Could not allocate memory. error!/n");
//          return NULL;
//      }
//
//      if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//          printf("Error: sysctl, take 2");
//          return NULL;
//      }
//
//      ifm = (struct if_msghdr *)buf;
//      sdl = (struct sockaddr_dl *)(ifm + 1);
//      ptr = (unsigned char *)LLADDR(sdl);
//      NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//
//      //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//
//      NSLog(@"outString:%@", outstring);
//
//      free(buf);
//
//      return [outstring uppercaseString];
    
    int                 mgmtInfoBase[6];
        char                *msgBuffer = NULL;
        size_t              length;
        unsigned char       macAddress[6];
        struct if_msghdr    *interfaceMsgStruct;
        struct sockaddr_dl  *socketStruct;
        NSString            *errorFlag = NULL;
        
        // Setup the management Information Base (mib)
        mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
        mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
        mgmtInfoBase[2] = 0;
        mgmtInfoBase[3] = AF_LINK;        // Request link layer information
        mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
        
        // With all configured interfaces requested, get handle index
        if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
            errorFlag = @"if_nametoindex failure";
        else
        {
            // Get the size of the data available (store in len)
            if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
                errorFlag = @"sysctl mgmtInfoBase failure";
            else
            {
                // Alloc memory based on above call
                if ((msgBuffer = malloc(length)) == NULL)
                    errorFlag = @"buffer allocation failure";
                else
                {
                    // Get system information, store in buffer
                    if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                        errorFlag = @"sysctl msgBuffer failure";
                }
            }
        }
        
        // Befor going any further...
        if (errorFlag != NULL)
        {
            NSLog(@"Error: %@", errorFlag);
            return errorFlag;
        }
        
        // Map msgbuffer to interface message structure
        interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                      macAddress[0], macAddress[1], macAddress[2],
                                      macAddress[3], macAddress[4], macAddress[5]];
        NSLog(@"Mac Address: %@", macAddressString);
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;

}

- (NSString*)getmylocation{
    if (_mylocation) {

    }else{
        [_locationManager startUpdatingLocation];

    }
    return _mylocation;

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    NSLog(@"%lu",(unsigned long)locations.count);
    CLLocation * location = locations.lastObject;
    // 纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    // 经度
    CLLocationDegrees longitude = location.coordinate.longitude;
    self.mylocation  = [NSString stringWithFormat:@"%lf %f ",latitude,longitude];
//    NSLog(@"%@",);
//    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f", location.coordinate.longitude, location.coordinate.latitude,location.altitude,location.course,location.speed);
//    30.510920 104.078651
    
    [manager stopUpdatingLocation];
}
                  
                  
-(NSString *)getCarrierInfo{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    
//    carrier.carrierName = @"123";
//    [carrier setValue:@"中国联通" forKey:@"carrierName"];
//
//    [carrier setValue:@"1" forKey:NSStringFromSelector(@selector(mobileCountryCode))];
//    [carrier setValu 
    
    NSString *carrierName=[carrier carrierName];
    NSString *mobileCountryCode=[carrier mobileCountryCode];
    NSString *isoCountryCode=[carrier isoCountryCode];
    NSString *mobileNetworkCode=[carrier mobileNetworkCode];

    return [carrierName stringByAppendingFormat:@"---%@  --%@ --- %@",mobileCountryCode,isoCountryCode,mobileNetworkCode];
};

-(NSString *)getbrokenState{
   BOOL re =  NO;
    if (re == YES) {
        return re?@"已经越狱":@"未越狱";
    }
    
    re = [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"];
   
    if (re == NO) {
        NSData  *data =  [[NSData alloc] initWithContentsOfFile:@"/Applications/Cydia.app/Cydia"];
        re = data?YES:NO;
    }
    
    if (re == NO) {
        struct  stat  info;
        if (stat("/Applications/Cydia.app", &info) == 0) {
            re = YES;
        }
        
    }
    
    NSArray *bypassList = [[NSArray alloc] initWithObjects:
//                           @"/dev/random",
//                           @"/private/var/run/printd",
//                           @"/private/var/run/syslog",
//                           @"/private/var/mobile/Library/UserConfigurationProfiles/PublicInfo/MCMeta.plist",
//                           @"/private/var/mobile/Library/Preferences",
//                           @"/Library/Managed Preferences/mobile/.GlobalPreferences.plist",
//                           @"/Library/Managed Preferences/mobile/com.apple.webcontentfilter.plist",
//                           @"/private/var/containers/Data/System/com.apple.geod/.com.apple.mobile_container_manager.metadata.plist",
//                           @"/private/var/containers/Shared/SystemGroup/systemgroup.com.apple.lsd.iconscache/.com.apple.mobile_container_manager.metadata.plist",
//                           @"/private/var/mobile/Library/Caches/DateFormats.plist",
//                           @"/var/mobile/Library/Caches/com.apple.Pasteboard",
//                           @"/private/var/mobile/Library/Caches/DateFormats.plist",
//                           @"/private/var/mobile/Library/Caches/GeoServices/ActiveTileGroup.pbd",
//                           @"/private/var/mobile/Library/Caches/GeoServices/Experiments.pbd",
//                           @"/private/var/mobile/Library/Caches/GeoServices/Resources/DetailedLandCoverPavedArea-1@2x.png",
//                           @"/private/var/mobile/Library/Caches/GeoServices/Resources/LandCoverGradient16-1@2x.png",
//                           @"/private/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadHighway-1@2x.png",
//                           @"/private/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadLocalRoad-1@2x.png",
//                           @"/private/var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml",
//                           @"/private/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png",
//                           @"/private/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1@2x.png",
//                           @"/private/var/mobile/Library/Caches/GeoServices/Resources/night-DetailedLandCoverSand-1@2x.png",
//                           @"/private/var/mobile/Library/Carrier Bundles/Overlay",
                           @"/private/var/mobile/Library/Operator Bundle.bundle",
                           @"/private/var/mobile/Library",
                           @"/Applications/AWZ.app",
                           @"/Applications/NZT.app",
                           @"/Applications/igvx.app",
                           @"/Applications/TouchElf.app",
                           @"/Applications/TouchSprite.app",
                           @"/Applications/WujiVPN.app",
                           @"/Applications/RST.app",
                           @"/Applications/Forge9.app",
                           @"/Applications/Forge.app",
                           @"/Applications/GFaker.app",
                           @"/Applications/hdfakerset.app",
                           @"/Applications/Pranava.app",
                           @"/Applications/iG.app",
                           @"/Applications/HiddenApi.app",
                           @"/Applications/Xgen.app",
                           @"/Applications/BirdFaker9.app",
                           @"/Applications/VPNMasterPro.app",
                           @"/Applications/GuizmOVPN.app",
                           @"/Applications/OTRLocation.app",
                           @"/Applications/rwx.app",
                           @"/Applications/FakeMyLocation.app",
                           @"/Applications/anylocation.app",
                           @"/Applications/location360pro.app",
                           @"/Applications/xGPS.app",
                           @"/Applications/007gaiji.app",
                           @"/Applications/ALS.app",
                           @"/Applications/AXJ.app",
                           @"/Applications/serialudid.app",
                           @"/Applications/BirdFaker.app",
                           @"/Applications/zorro.app",
                           @"/Applications/YOY.app",
                           @"/Applications/Cydia.app",
                           @"/private/var/lib/apt/",
                           @"Applications/Cydia.app",
                   nil];

    
    for (NSString *list in bypassList) {
        re =   [[NSFileManager defaultManager] fileExistsAtPath:list];
        if (re == YES) {
            NSLog(@"HHHHHHH %@",list);
//            break;
            
        }
    }
    
    
    if (re == NO) {
        struct  stat stat_info;
        for (NSString *list in bypassList) {
            if (0 == stat(list.UTF8String, &stat_info)) {
                re = YES;

                break;
            }
        }
        
        
    }
    
    
    return  re?@"已经越狱":@"未越狱";
}

-(NSString *)gethomeDirPath{
    return   [WHCFileManager homeDir];
    
}

-(NSString *)getdocumentsDirPath{
    return   [WHCFileManager documentsDir];
    
}

-(NSString *)getpreferencesDirDirPath{
    return   [WHCFileManager preferencesDir];
    
}


-(NSString *)getBoundPath{
    return  [NSBundle mainBundle].bundlePath;
    
}

-(NSString *)getNSProcessInfo{
    NSProcessInfo* processInfo=[NSProcessInfo processInfo];
    // 返回进程标识符
    NSDictionary* environmentDict=[processInfo environment];
        int processId=[processInfo processIdentifier];


        // 返回进程数量

        NSUInteger count=[processInfo processorCount];

        

        // 返回活动的进程数量

        NSUInteger activeCount=[processInfo activeProcessorCount];

        

        // 返回正在执行的进程名称

        NSString* name=[processInfo processName];

        

        // 生成单值临时文件名

        NSString* uniqueStr=[processInfo globallyUniqueString];

        

        // 返回主机系统的名称

        NSString* hostName=[processInfo hostName];

        

        // 返回操作系统的版本号

        NSOperatingSystemVersion osVersion=[processInfo operatingSystemVersion];

        

        // 返回操作系统名称

        NSString* osName=[processInfo operatingSystemVersionString];
        

//        // 设置当前进程名称
//
//        [processInfo setProcessName:@"Testing"];

        

         // 判断系统版本是否高于某个版本

        NSOperatingSystemVersion osVersion1={10, 10, 4};

        BOOL isFirst=[processInfo isOperatingSystemAtLeastVersion:osVersion1];
    
     NSString *re =  [NSString stringWithFormat:@"%@,%d,%d,%d,%@,%@,%@,%@",environmentDict,processId,count,activeCount,name,uniqueStr,hostName,osName];
    NSLog(@"GGGGGGG,re = %@",re);
    return re;
    
}



-(NSString *)getSysInfoByName{
    return @"";
}
-(NSString *)getOpenUdid{
  NSString *openudid =  [OpenUDID value];
    
    return openudid;
}



-(BOOL)getisStatNotSystemLib{
    return [[UserCust sharedInstance] UVItinitseWithType:@"1"];
}

-(BOOL)getisDebugged{
    return [[UserCust sharedInstance] UVItinitseWithType:@"2"];
}

-(BOOL)getisInjectedWithDynamicLibrary{
    return [[UserCust sharedInstance] UVItinitseWithType:@"3"];
}

-(BOOL)getJCheckKuyt{
    return [[UserCust sharedInstance] UVItinitseWithType:@"4"];
}

-(BOOL)getdyldEnvironmentVariables{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"5"];
}

-(NSString *)getBulidVersionName{
    NSString *result = @"";
    if ([WHCFileManager isExistsAtPath:@"/private/var/db/systemstats/last_boot_uuid"]) {
        NSString *re =[NSString stringWithContentsOfFile:@"/private/var/db/systemstats/last_boot_uuid" encoding:NSUTF8StringEncoding error:nil];
      result=   [result stringByAppendingFormat:@"%@",re];
    }
    
    if ([WHCFileManager isExistsAtPath:@"/private/var/db/systemstats/current_boot_uuid"]) {
        NSString *re =[NSString stringWithContentsOfFile:@"/private/var/db/systemstats/last_boot_uuid" encoding:NSUTF8StringEncoding error:nil];
        result=   [result stringByAppendingFormat:@"%@",re];

    }
    
    if ([WHCFileManager isExistsAtPath:@"/private/var/tmp/fseventsd-uuid"]) {
        NSString *re =[NSString stringWithContentsOfFile:@"/private/var/db/systemstats/last_boot_uuid" encoding:NSUTF8StringEncoding error:nil];
        result=   [result stringByAppendingFormat:@"%@",re];


    }
    

    return  result;
}

@end
