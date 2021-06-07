//
//  NetWorkInfoManager.m
//  ClientTest
//
//  Created by Leon on 2017/8/23.
//  Copyright © 2017年 王鹏飞. All rights reserved.
//

#import "NetWorkInfoManager.h"
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

//2021-05-26 16:28:43.002425+0800 ClientTest[1532:26990] macAddress---020000000000
//2021-05-26 16:28:43.005012+0800 ClientTest[1532:26990] Get UniqueDeviceID IsSimulator 0
//2021-05-26 16:28:43.006968+0800 ClientTest[1532:26990] deviceIP---169.254.128.255
//2021-05-26 16:28:43.007102+0800 ClientTest[1532:26990] new new_inet_ntop8888 (null)
//2021-05-26 16:28:43.007198+0800 ClientTest[1532:26990] new new_inet_ntop7777 lo0
//2021-05-26 16:28:43.007300+0800 ClientTest[1532:26990] new new_inet_ntop7777 lo0
//2021-05-26 16:28:43.007412+0800 ClientTest[1532:26990] new new_inet_ntop7777 lo0
//2021-05-26 16:28:43.007518+0800 ClientTest[1532:26990] new new_inet_ntop7777 lo0
//2021-05-26 16:28:43.019217+0800 ClientTest[1532:26990] new new_inet_ntop7777 pdp_ip2
//2021-05-26 16:28:43.019314+0800 ClientTest[1532:26990] new new_inet_ntop7777 pdp_ip4
//2021-05-26 16:28:43.019378+0800 ClientTest[1532:26990] new new_inet_ntop7777 pdp_ip3
//2021-05-26 16:28:43.019450+0800 ClientTest[1532:26990] new new_inet_ntop7777 pdp_ip0
//2021-05-26 16:28:43.019525+0800 ClientTest[1532:26990] new new_inet_ntop7777 pdp_ip1
//2021-05-26 16:28:43.019638+0800 ClientTest[1532:26990] new new_inet_ntop7777 ap1
//2021-05-26 16:28:43.019743+0800 ClientTest[1532:26990] new new_inet_ntop7777 en0
//2021-05-26 16:28:43.019843+0800 ClientTest[1532:26990] new new_inet_ntop6666 (null)
//2021-05-26 16:28:43.019939+0800 ClientTest[1532:26990] new new_inet_ntop7777 en0
//2021-05-26 16:28:43.019980+0800 ClientTest[1532:26990] new new_inet_ntop6666 (null)
//2021-05-26 16:28:43.020164+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::103e:7cb4:bed2:b49
//2021-05-26 16:28:43.020263+0800 ClientTest[1532:26990] new new_inet_ntop5555 (null) lo0
//2021-05-26 16:28:43.047009+0800 ClientTest[1532:26990] new new_inet_ntop5555 127.0.0.1 lo0
//2021-05-26 16:28:43.047098+0800 ClientTest[1532:26990] new new_inet_ntop5555 ::1 lo0
//2021-05-26 16:28:43.047158+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 lo0
//2021-05-26 16:28:43.047286+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 pdp_ip2
//2021-05-26 16:28:43.047361+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 pdp_ip4
//2021-05-26 16:28:43.047419+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 pdp_ip3
//2021-05-26 16:28:43.047826+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 pdp_ip0
//2021-05-26 16:28:43.047891+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 pdp_ip1
//2021-05-26 16:28:43.047996+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 ap1
//2021-05-26 16:28:43.048052+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 en0
//2021-05-26 16:28:43.048130+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::103e:7cb4:bed2:b49 en0
//2021-05-26 16:28:43.049142+0800 ClientTest[1532:26990] new new_inet_ntop5555 192.168.10.117 en0
//2021-05-26 16:28:43.049231+0800 ClientTest[1532:26990] new new_inet_ntop5555 192.168.10.117 awdl0
//2021-05-26 16:28:43.049354+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::c4d2:40ff:fee3:761f awdl0
//2021-05-26 16:28:43.049476+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::c4d2:40ff:fee3:761f en1
//2021-05-26 16:28:43.049524+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::c4d2:40ff:fee3:761f en2
//2021-05-26 16:28:43.049644+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::18f6:4251:22fc:b1d9 en2
//2021-05-26 16:28:43.049694+0800 ClientTest[1532:26990] new new_inet_ntop5555 169.254.128.255 en2
//2021-05-26 16:28:43.049809+0800 ClientTest[1532:26990] new new_inet_ntop5555 169.254.128.255 utun0
//2021-05-26 16:28:43.049915+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::591f:9c9a:c342:af1e utun0
//
//2021-05-26 16:28:43.055996+0800 ClientTest[1532:26990] 蜂窝地址---fe80::591f:9c9a:c342:af1e
//2021-05-26 16:28:43.056330+0800 ClientTest[1532:26990] new new_inet_ntop8888 (null)
//2021-05-26 16:28:43.056431+0800 ClientTest[1532:26990] new new_inet_ntop7777 lo0
//2021-05-26 16:28:43.056489+0800 ClientTest[1532:26990] new new_inet_ntop7777 lo0
//2021-05-26 16:28:43.056541+0800 ClientTest[1532:26990] new new_inet_ntop7777 lo0
//2021-05-26 16:28:43.056593+0800 ClientTest[1532:26990] new new_inet_ntop7777 lo0
//2021-05-26 16:28:43.057099+0800 ClientTest[1532:26990] new new_inet_ntop7777 pdp_ip2
//2021-05-26 16:28:43.057157+0800 ClientTest[1532:26990] new new_inet_ntop7777 pdp_ip4
//2021-05-26 16:28:43.057207+0800 ClientTest[1532:26990] new new_inet_ntop7777 pdp_ip3
//2021-05-26 16:28:43.057258+0800 ClientTest[1532:26990] new new_inet_ntop7777 pdp_ip0
//2021-05-26 16:28:43.057308+0800 ClientTest[1532:26990] new new_inet_ntop7777 pdp_ip1
//2021-05-26 16:28:43.057358+0800 ClientTest[1532:26990] new new_inet_ntop7777 ap1
//
//2021-05-26 16:28:43.061081+0800 ClientTest[1532:26990] new new_inet_ntop7777 en0
//2021-05-26 16:28:43.061135+0800 ClientTest[1532:26990] new new_inet_ntop6666 (null)
//2021-05-26 16:28:43.061186+0800 ClientTest[1532:26990] new new_inet_ntop7777 en0
//2021-05-26 16:28:43.061225+0800 ClientTest[1532:26990] new new_inet_ntop6666 (null)
//2021-05-26 16:28:43.061269+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::103e:7cb4:bed2:b49
//2021-05-26 16:28:43.061320+0800 ClientTest[1532:26990] new new_inet_ntop5555 (null) lo0
//2021-05-26 16:28:43.061382+0800 ClientTest[1532:26990] new new_inet_ntop5555 127.0.0.1 lo0
//2021-05-26 16:28:43.061436+0800 ClientTest[1532:26990] new new_inet_ntop5555 ::1 lo0
//2021-05-26 16:28:43.061491+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 lo0
//2021-05-26 16:28:43.061621+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 pdp_ip2
//2021-05-26 16:28:43.062096+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 pdp_ip4
//2021-05-26 16:28:43.062179+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 pdp_ip3
//2021-05-26 16:28:43.063234+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 pdp_ip0
//2021-05-26 16:28:43.063300+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 pdp_ip1
//2021-05-26 16:28:43.063377+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 ap1
//2021-05-26 16:28:43.063433+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::1 en0
//2021-05-26 16:28:43.063483+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::103e:7cb4:bed2:b49 en0
//2021-05-26 16:28:43.063534+0800 ClientTest[1532:26990] new new_inet_ntop5555 192.168.10.117 en0
//2021-05-26 16:28:43.063893+0800 ClientTest[1532:26990] new new_inet_ntop5555 192.168.10.117 awdl0
//2021-05-26 16:28:43.063989+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::c4d2:40ff:fee3:761f awdl0
//2021-05-26 16:28:43.064034+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::c4d2:40ff:fee3:761f en1
//2021-05-26 16:28:43.064111+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::c4d2:40ff:fee3:761f en2
//2021-05-26 16:28:43.065714+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::18f6:4251:22fc:b1d9 en2
//2021-05-26 16:28:43.065770+0800 ClientTest[1532:26990] new new_inet_ntop5555 169.254.128.255 en2
//2021-05-26 16:28:43.065815+0800 ClientTest[1532:26990] new new_inet_ntop5555 169.254.128.255 utun0
//2021-05-26 16:28:43.065860+0800 ClientTest[1532:26990] new new_inet_ntop5555 fe80::591f:9c9a:c342:af1e utun0
//2021-05-26 16:28:43.065912+0800 ClientTest[1532:26990] WIFI IP地址---fe80::591f:9c9a:c342:af1e

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

-(NSString *)getSysInfoByName{
    return @"";
}


@end
