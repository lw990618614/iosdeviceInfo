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
#include <sys/mount.h>
#include <stdio.h>
#include <stdlib.h>
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
#include <net/if_dl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
void mystatTest( char *path);
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
        Dl_info dylib_info;
        char *dylib_name = "/usr/lib/system/libsystem_kernel.dylib";
        dladdr(CFReadStreamCreateWithFile, &dylib_info);
        
//        __libc_do_cyscall
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

    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
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
-(NSString *)borkenSigleName{
//    struct statfs buf1= {0};
//   int fd =  open("/", O_RDONLY);
//    DIR * resss = opendir("/");
//   void *p = dlopen("/", O_RDONLY);
//    struct dirent *readd1 =readdir(resss);
//    fstatfs(1, &buf1);

//    {
//      f_bsize = 4096
//      f_iosize = 1048576
//      f_blocks = 7809929
//      f_bfree = 7488373
//      f_bavail = 6214183
//      f_files = 312397160
//      f_ffree = 312372381
//      f_fsid = {
//        val = ([0] = 16777218, [1] = 22)
//      }
//      f_owner = 0
//      f_type = 22
//      f_flags = 343969944
//      f_fssubtype = 0
//      f_fstypename = "apfs"
//      f_mntonname = "/private/var"
//      f_mntfromname = "/dev/disk0s1s2"
//      f_flags_ext = 0
//      f_reserved = ([0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0)
//    }
    
//    {
//      f_bsize = 4096
//      f_iosize = 1048576
//      f_blocks = 7809929
//      f_bfree = 5144461
//      f_bavail = 3724750
//      f_files = 312397160
//      f_ffree = 312314052
//      f_fsid = {
//        val = ([0] = 16777219, [1] = 22)
//      }
//      f_owner = 0
//      f_type = 22
//      f_flags = 343969944
//      f_fssubtype = 0
//      f_fstypename = "apfs"
//      f_mntonname = "/private/var"
//      f_mntfromname = "/dev/disk0s1s2"
//      f_flags_ext = 0
//      f_reserved = ([0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0)
//    }
    struct statfs buf;
      statfs("/", &buf);
    NSLog(@"%s", buf.f_mntfromname); //"/dev/disk0s1s1
    char* prefix = "com.apple.os.update-";
    if(strstr(buf.f_mntfromname, prefix)) {
        NSLog(@"未越狱, 设备唯一识别码=%s", buf.f_mntfromname);//com.apple.os.update-C27401D58B296783DD1FF1F51F394AD23A31748B@/dev/disk0s1s1
        return [NSString stringWithFormat:@"未越狱, 设备唯一识别码 %s",buf.f_mntfromname];
    } else {
        return  @"已越狱, 没有设备唯一识别码";
    }

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



- (NSArray *)getAllProcess
{
    int         myPid = [[NSProcessInfo processInfo] processIdentifier];
    const char* myProcessName = [[[NSProcessInfo processInfo] processName] UTF8String];
    int mib[4] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 };
    struct kinfo_proc* info;
    size_t length;
    int count, i;
    
    // KERN_PROC_ALL has 3 elements, all others have 4
    unsigned level = 4;
    
    if (sysctl(mib, level, NULL, &length, NULL, 0) < 0)
//        return nil;
    
    // Allocate memory for info structure:
    if (!(info = NSZoneMalloc(NULL, length))) return nil;
    if (sysctl(mib, level, info, &length, NULL, 0) < 0) {
//        NSZoneFree(NULL, info);
//        return nil;
    }
    
    // Calculate number of processes:
    count = length / sizeof(struct kinfo_proc);
    for (i = 0; i < count; i++) {
        char* command = info[i].kp_proc.p_comm;
        pid_t pid = info[i].kp_proc.p_pid;
        //NSLog(@"Found running command: '%s'", command);
        // Test, if this command is called like us:
        if (pid!=myPid && strncmp(myProcessName, command, MAXCOMLEN)==0) {
            // Actually kill it:
            if (kill(pid, SIGTERM) !=0) {
                NSLog(@"Error while killing process: Error was '%s'", strerror(errno));
            }
        }
    }
    return nil;
}
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

-(void)getkerinfo{
    NSUInteger sysinfo =   [self getSysInfo:HW_CPU_FREQ];
    NSUInteger sysinfo1 =  [self getSysInfo:HW_BUS_FREQ];
    NSUInteger sysinfo2 =  [self getSysInfo:HW_NCPU];
    NSUInteger sysinfo3 =  [self getSysInfo:HW_PHYSMEM];
    NSUInteger sysinfo4 =  [self getSysInfo:HW_USERMEM];
    NSUInteger sysinfo5=  [self getSysInfo:KIPC_MAXSOCKBUF];
    NSUInteger sysinfo6=  [self getSysInfo:HW_PAGESIZE];

    

}

-(void)getreplaced_sysctlbyname{
//    [self getkerinfo];

    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model];//iphone9.1
    
    size_t size1;
    sysctlbyname("kern.osproductversion", NULL, &size1, NULL, 0);
    char *model1 = malloc(size1);
    sysctlbyname("kern.osproductversion", model1, &size1, NULL, 0);
    NSString *deviceModel1 = [NSString stringWithCString:model1];//13.51 重启没变
   
    
    sysctlbyname("hw.model", NULL, &size, NULL, 0);
    char* name1 = (char*)malloc(size);//N71mAP
    sysctlbyname("hw.model", name1, &size, NULL, 0);
    NSString* machine1 = [NSString stringWithCString:name1];//n71map 重启没变

    
    sysctlbyname("kern.osrelease", NULL, &size, NULL, 0);
    char* name2 = (char*)malloc(size);
    sysctlbyname("kern.osrelease", name2, &size, NULL, 0);
    NSString* machine2 = [NSString stringWithCString:name2];//18.2.0 重启没变
    
    sysctlbyname("kern.bootsessionuuid", NULL, &size, NULL, 0);
    char* name3 = (char*)malloc(size);//FB2336C5-57A0-4037-AAD7-C5C7EBA04D5E 重启变了
    sysctlbyname("kern.bootsessionuuid", name3, &size, NULL, 0);
    NSString* machine3 = [NSString stringWithCString:name3];//类似 uuid
    
    sysctlbyname("kern.hostname", NULL, &size, NULL, 0);
    char* name4 = (char*)malloc(size);//iphoneww 手机名字
    sysctlbyname("kern.hostname", name4, &size, NULL, 0);
    NSString* machine4 = [NSString stringWithCString:name4];//iphone1111

    
    sysctlbyname("kern.ostype", NULL, &size, NULL, 0);
    char* name5 = (char*)malloc(size);
    sysctlbyname("kern.ostype", name5, &size, NULL, 0);
    NSString* machine5 = [NSString stringWithCString:name5];//Darwin

    
    sysctlbyname("kern.version", NULL, &size, NULL, 0);
    char* name6 = (char*)malloc(size);//Darwin Kernel Version 18.2.0: Tue Oct 16 21:02:23 PDT 2018; root:xnu-4903.222.5~1/RELEASE_ARM64_S8000
    sysctlbyname("kern.version", name6, &size, NULL, 0);
    NSString* machine6 = [NSString stringWithCString:name6];//Darwin ker>>>

    
    sysctlbyname("security.mac.sandbox.sentinel", NULL, &size, NULL, 0);
    char* name7 = (char*)malloc(size);
    sysctlbyname("security.mac.sandbox.sentinel", name7, &size, NULL, 0);
    NSString* machine7 = [NSString stringWithCString:name7];//.sb-a91f51c6
   
    sysctlbyname("kern.osrevision", NULL, &size, NULL, 0);
    char* name8 = (char*)malloc(size);
    sysctlbyname("kern.osrevision", name8, &size, NULL, 0);
    NSString* machine8 = [NSString stringWithCString:name8];//.sb-107cf39d

    
    sysctlbyname("kern.uuid", NULL, &size, NULL, 0);
    char* name9 = (char*)malloc(size);
    sysctlbyname("kern.uuid", name9, &size, NULL, 0);
    NSString* machine9 = [NSString stringWithCString:name9];//.sb-107cf39d 重启变了
    
    sysctlbyname("hw.cpufamily", NULL, &size, NULL, 0);
    char* name10 = (char*)malloc(size);
    sysctlbyname("hw.cpufamily", name10, &size, NULL, 0);
    NSString* machine10 = [NSString stringWithCString:name10];//
    
    sysctlbyname("machdep.wake_conttime", NULL, &size, NULL, 0);
    char* name11 = (char*)malloc(size);
    sysctlbyname("machdep.wake_conttime", name11, &size, NULL, 0);
    NSString* machine11 = [NSString stringWithCString:name11];//

    sysctlbyname("machdep.cpu.brand_string", NULL, &size, NULL, 0);
    char* name12 = (char*)malloc(size);
    sysctlbyname("machdep.cpu.brand_string", name12, &size, NULL, 0);
    NSString* machine12 = [NSString stringWithCString:name12];//

    
    struct timeval bootTime;//
    size_t size2 = sizeof(bootTime); // tv_sec = 1640163282, tv_usec = 509155,
    sysctlbyname("kern.boottime", &bootTime, &size2, NULL, 0);
    
    struct timeval waketime;// // tvsec:5436456  tvuse :235455675663536534
    size_t size3 = sizeof(waketime);
    sysctlbyname("kern.waketime", &waketime, &size3, NULL, 0);

    
    struct timeval monotonicclock_usecs;// // tvsec:5436456  tvuse :235455676534
    size_t size4 = sizeof(monotonicclock_usecs);
    sysctlbyname("kern.monotonicclock_usecs", &monotonicclock_usecs, &size4, NULL, 0);
    
    
    unsigned int ncpu;//2
    size_t len = sizeof(ncpu);
    sysctlbyname("hw.activecpu", &ncpu, &len, NULL, 0);
    
    unsigned int ncpucout;//2
    size_t len1 = sizeof(ncpucout);
    sysctlbyname("hw.ncpu", &ncpucout, &len1, NULL, 0);
    
    
    unsigned int memsize;//2105016320 重启没变 2099249152
    size_t len2 = sizeof(memsize);
    sysctlbyname("hw.memsize", &memsize, &len2, NULL, 0);

    unsigned int logicalcpu_max;//2
    size_t len3 = sizeof(logicalcpu_max);
    sysctlbyname("hw.logicalcpu_max", &logicalcpu_max, &len3, NULL, 0);
    
    unsigned int secure_kernel;//1
    size_t len4 = sizeof(secure_kernel);
    sysctlbyname("kern.secure_kernel", &secure_kernel, &len4, NULL, 0);
    
    unsigned int availcpu;//1
    size_t len5 = sizeof(availcpu);
    sysctlbyname("hw.availcpu", &availcpu, &len5, NULL, 0);
    
    unsigned int physmem;//2105016320  重启没变  2105016320
    size_t len6 = sizeof(physmem);
    sysctlbyname("hw.physmem", &physmem, &len6, NULL, 0);
    
    unsigned int cachelinesize;//1441792 重启没变
    size_t len7 = sizeof(cachelinesize);
    sysctlbyname("hw.cachelinesize", &cachelinesize, &len7, NULL, 0);


    unsigned int hwcpufamily;//246593735  2465937352 2465937352  2465937352 2465937352 重启没变
    size_t len8 = sizeof(hwcpufamily);
    sysctlbyname("hw.cpufamily", &hwcpufamily, &len8, NULL, 0);
    
    
    unsigned int machdepwake_conttime;
    size_t len9 = sizeof(machdepwake_conttime);
    sysctlbyname("machdep.wake_conttime", &machdepwake_conttime, &len9, NULL, 0);

    unsigned int l1icachesize;//1441792 1441792
    size_t len10 = sizeof(l1icachesize);
    sysctlbyname("hw.l1icachesize", &l1icachesize, &len10, NULL, 0);

    unsigned int kextlog;//1
    size_t len11 = sizeof(kextlog);
    sysctlbyname("debug.kextlog", &kextlog, &len11, NULL, 0);

    unsigned int argmax;//1
    size_t len12 = sizeof(argmax);
    sysctlbyname("kern.argmax", &kextlog, &len12, NULL, 0);


    unsigned int l2cachesize;//1
    size_t len13 = sizeof(l2cachesize);
    sysctlbyname("hw.l2cachesize", &kextlog, &len13, NULL, 0);

    
    
    
    cpu_subtype_t subtype;//1
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
}

-(NSString *)getSysctlResult{
    
    [self getreplaced_sysctlbyname];
////
//  NSArray *reuslt  =  [self  getAllProcess];
//    struct kinfo_proc *proc;

    mystatTest("/vayr");
    
    char sysversion[128]={0} ;//DarWin
    int mib1[2] = {CTL_KERN,KERN_OSTYPE};
    size_t size1 = sizeof(sysversion);
    if (sysctl(mib1, 2, &sysversion, &size1, NULL, 0) != -1) {
        
    };
    
    struct timeval bootTime;
    int mib2[2] = {CTL_KERN,KERN_BOOTTIME};
    size_t size2 = sizeof(bootTime);
    int result =  sysctl(mib2, 2, &bootTime, &size2, NULL, 0);
    if (sysctl(mib2, 2, &bootTime, &size2, NULL, 0) != -1) {
         bootTime.tv_sec;///秒
    };

    char kerninfo[128];////DarWin dddd
    int mib3[2] = {CTL_KERN,KERN_VERSION};
    size_t size3 = sizeof(kerninfo);
    if (sysctl(mib3, 2, &kerninfo, &size3, NULL, 0) != -1) {
        
    };
    
    char kernhostName[128]={0} ;//iphone
    int mib4[4] = {CTL_KERN, KERN_HOSTNAME};
    size_t size4 = sizeof(kernhostName);
    if (sysctl(mib4, 2, &kernhostName, &size4, NULL, 0) != -1) {

    };
    
    char kernosrelse[128]={0} ;//18.20
    int min[4] = {CTL_KERN, KERN_OSRELEASE};
    if (sysctl(min, 2, &kernosrelse, &size4, NULL, 0) != -1) {

    };

    int  kernmaxpoc=0 ;//10240
    int min6[4] = {CTL_KERN, KERN_MAXFILESPERPROC};
    if (sysctl(min6, 2, &kernmaxpoc, &size4, NULL, 0) != -1) {

    };
    
    int KERN_MAXVNODE ;//70864896
    int mib7[2] = {CTL_KERN,KERN_MAXVNODES};
    size_t size7;//4
    if (sysctl(mib7, 2, &KERN_MAXVNODE, &size7, NULL, 0) != -1) {
        
    };
    
    int KERN_MAXPR ;//1000
    int mib8[2] = {CTL_KERN,KERN_MAXPROC};
    size_t size;//4
    if (sysctl(mib8, 2, &KERN_MAXPR, &size, NULL, 0) != -1) {
        
    };
    
    int KERN_MAXFILE ;//1
    int mib9[2] = {CTL_KERN,KERN_MAXFILES};
    size_t size9;
    if (sysctl(mib9, 2, &KERN_MAXFILE, &size9, NULL, 0) != -1) {
        
    };
    
    int KERN_ARGMA ;//1
    int mib10[2] = {CTL_KERN,KERN_ARGMAX};
    size_t size10;
    if (sysctl(mib10, 2, &KERN_ARGMA, &size10, NULL, 0) != -1) {
        
    };

    int KERN_SECURELV ;//1
    int mib11[2] = {CTL_KERN,KERN_SECURELVL};
    size_t size11;
    if (sysctl(mib11, 2, &KERN_SECURELV, &size11, NULL, 0) != -1) {
        
    };

    char KERN_HOSTNA[128]={0} ;//Administratorteki-iPhone
    int mib12[2] = {CTL_KERN,KERN_HOSTNAME};
    size_t size12 = sizeof(KERN_HOSTNA);
    if (sysctl(mib12, 2, &KERN_HOSTNA, &size12, NULL, 0) != -1) {
        
    };

    int KERN_HOSTI ;//0
    int mib13[2] = {CTL_KERN,KERN_HOSTID};
    size_t size13;
    if (sysctl(mib13, 2, &KERN_HOSTI, &size13, NULL, 0) != -1) {
        
    };
    
    int KERN_POSIsss ;//1
    int mib14[2] = {CTL_KERN,KERN_POSIX1};
    size_t size14;
    if (sysctl(mib14, 2, &KERN_POSIsss, &size14, NULL, 0) != -1) {
        
    };
    
    int HW_MEMSI ;//1
    int mib15[2] = {CTL_VM,HW_MEMSIZE};
    size_t size15;
    if (sysctl(mib15, 2, &HW_MEMSI, &size15, NULL, 0) != -1) {
        
    };
    
    //调试检测
    struct kinfo_proc Info;
    int mib16[] = { CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid() };
    size_t Size = sizeof(Info);
    sysctl( mib16, sizeof( mib16 ) / sizeof( *mib16 ), &Info, &Size, NULL, 0 );
    int re =   ( Info.kp_proc.p_flag & P_TRACED ) != 0; //1 调试中 0 不是
    
    size_t size17 = 128;
    char *hw_machine = malloc(size);
    int name[] = {CTL_HW, HW_MACHINE};
    sysctl(name, 2, hw_machine, &size17, NULL, 0);

    
    int HW_AVAILCP ;//1
    int mib18[2] = {CTL_HW,HW_AVAILCPU};
    size_t size18;
    if (sysctl(mib18, 2, &HW_AVAILCP, &size18, NULL, 0) != -1) {
        
    };
    
    int HW_NCP ;//1
    int mib19[2] = {CTL_HW,HW_NCPU};
    size_t size19;
    if (sysctl(mib19, 2, &HW_NCP, &size19, NULL, 0) != -1) {
        
    };

    
    int mib20[2] = {CTL_KERN,KERN_MAXFILESPERPROC};
    int maxFilesPerProc = 0;
    size_t size20 = sizeof(maxFilesPerProc);
    if (sysctl(mib20, 2, &maxFilesPerProc, &size20, NULL, 0) != -1) {
        
    };
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
         ;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
//    2021-12-27 17:34:36.908564+0800 ClientTest[18571:713295] replaced_sysctlreplaced_sysctl  2 = -- 4 -- 17
//    2021-12-27 17:34:36.908955+0800 ClientTest[18571:713295] replaced_sysctlreplaced_sysctl  2 = -- 4 -- 17
//    2021-12-27 17:34:36.909334+0800 ClientTest[18571:713295] replaced_sysctlreplaced_sysctl  2 = -- 4 -- 17
//    2021-12-27 17:34:36.909586+0800 ClientTest[18571:713295] replaced_sysctlreplaced_sysctl  2 = -- 4 -- 17

    
    
    
    

    
    

//    sysctl kern.clockrate { hz = 100, tick = 10000, tickadj = 0, profhz = 100, stathz = 100 }
//    KERN_CLOCKRATE
    


    [self macAddr];
    

    return @"";
}
- (NSString *)macAddr{
    int mib[6];
    size_t len;
    char *buffer;
    unsigned char *addr_ptr;
    struct if_msghdr *msghdr;
    struct sockaddr_dl *sockaddr;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = 0;
    mib[4] = NET_RT_IFLIST;
    mib[5] = 0;

    if((mib[5] = if_nametoindex("en0")) == 0) {
        return @"";
    }
    
    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return @"";
    }
    
    if((buffer = (char *)malloc(len)) == NULL){
        return @"";
    }
    
    if(sysctl(mib, 6, buffer, &len, NULL, 0) < 0){
        free(buffer);
        return @"";
    }
    
    msghdr = (struct if_msghdr *)buffer;
    sockaddr = (struct sockaddr_dl *)(msghdr + 1);
    addr_ptr = (unsigned char *)LLADDR(sockaddr);
    
    NSMutableString *addr = [NSMutableString string];
    [addr appendFormat:@"%02x", *addr_ptr];
    for(int i = 1; i < 6; i ++){
        [addr appendFormat:@":%02x", *(addr_ptr + i)];
    }

    
    free(buffer);
    
    return [addr copy];
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
    
    int                 mib[6];
      size_t              len;
      char                *buf;
      unsigned char       *ptr;
      struct if_msghdr    *ifm;
      struct sockaddr_dl  *sdl;

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
      NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];

      //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];

      NSLog(@"outString:%@", outstring);

      free(buf);

      return [outstring uppercaseString];
    
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
#define DPKG_INFO_PATH      @"/var/lib/dpkg/info"

- (NSArray *)generateSchemeArray {
    // Generate URL scheme set from installed packages.
    NSMutableArray *blacklist = [NSMutableArray new];

    NSString *dpkg_info_path =  DPKG_INFO_PATH;
    NSArray *dpkg_info = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dpkg_info_path error:nil];

    if(dpkg_info) {
        for(NSString *dpkg_info_file in dpkg_info) {
            // Read only .list files.
            if([[dpkg_info_file pathExtension] isEqualToString:@"list"]) {
                // Skip some packages.
                if([dpkg_info_file isEqualToString:@"firmware-sbin.list"]
                || [dpkg_info_file hasPrefix:@"gsc."]
                || [dpkg_info_file hasPrefix:@"cy+"]) {
                    continue;
                }
                
                NSString *dpkg_info_file_a = [dpkg_info_path stringByAppendingPathComponent:dpkg_info_file];
                NSString *dpkg_info_contents = [NSString stringWithContentsOfFile:dpkg_info_file_a encoding:NSUTF8StringEncoding error:NULL];

                // Read file paths line by line.
                if(dpkg_info_contents) {
                    NSArray *dpkg_info_contents_files = [dpkg_info_contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

                    for(NSString *dpkg_file in dpkg_info_contents_files) {
                        if([dpkg_file hasPrefix:@"/Applications"]) {
                            BOOL isDir;

                            if([[NSFileManager defaultManager] fileExistsAtPath:dpkg_file isDirectory:&isDir]) {
                                if(isDir && [[dpkg_file pathExtension] isEqualToString:@"app"]) {
                                    // Open Info.plist
                                    NSMutableDictionary *plist_info = [NSMutableDictionary dictionaryWithContentsOfFile:[dpkg_file stringByAppendingPathComponent:@"Info.plist"]];

                                    if(plist_info) {
                                        for(NSDictionary *type in plist_info[@"CFBundleURLTypes"]) {
                                            for(NSString *scheme in type[@"CFBundleURLSchemes"]) {
                                                [blacklist addObject:scheme];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return [blacklist copy];
}

void test()
{
//    NSArray *tt = [NSArray new];
//   NSString *resuy =  tt[1];
//    [tt componentsJoinedByString:@""];
//    NSMutableDictionary *mydn = [NSMutableDictionary new];
//    [mydn setValue:resuy forKey:@"df"];
    return;;
//    printf("www.dllhook.com\nDyld image count is: %d.\n", _dyld_image_count());
//    long b = 0;
//
//    for (int i =0 ; i < 5000000; i ++) {
//     int a =   arc4random()%20;
//        b = b + a;
//    }
    
    struct mach_header_64 *header = (struct mach_header_64*) _dyld_get_image_header(0);
    const struct section_64 *executable_section = getsectbynamefromheader_64(header, "__TEXT", "__text");
    uint8_t *start_address = (uint8_t *) ((intptr_t) header + executable_section->offset);
    uint8_t *end_address = (uint8_t *) (start_address + executable_section->size);
    uint8_t *current = start_address;
    uint32_t index = 0;
    uint8_t current_target = 0;
    printf("www.dllhook.com\nDyld image count is: %d.\n", _dyld_image_count());

    while (current < end_address) {

        // Allow 0xFF as wildcard.
        if (current_target == *current || current_target == 0xFF) {

            index++;
        }
        else {

            index = 0;
        }

        // Check if match.
//        if (index == target_len) {
//            index = 0;
//        }
    }


    printf("www.dllhook.com\nDyld image count is: %d.\n", _dyld_image_count());

    for (int i = 0; i < _dyld_image_count(); i++) {
        char *image_name = (char *)_dyld_get_image_name(i);
        const struct mach_header *mh = _dyld_get_image_header(i);
        intptr_t vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
        
        printf("Image name %s at address 0x%llx and ASLR slide 0x%lx.\n",
               image_name, (mach_vm_address_t)mh, vmaddr_slide);
    }
}

+ (NSError *)generateFileNotFoundError {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Object does not exist.", nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Don't access this again :)", nil)
    };

    NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:userInfo];
    return error;
}


-(NSString *)getbrokenState{
    test();
    struct stat buf;     //文件属性存放缓冲区
    char *ptr;
   NSString *homestring = [NSHomeDirectory() stringByAppendingString:@"/teere"];
//    [WHCFileManager removeItemAtPath:homestring];
//    [@"fdsafgdsg" writeToFile:homestring atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
   BOOL reee = [WHCFileManager isExistsAtPath:homestring];
    
   lstat(homestring.UTF8String, &buf);

   if (S_ISREG(buf.st_mode))
   {
      ptr = "普通文件";     //普通文件
   }
   else if (S_ISDIR(buf.st_mode))
   {
   ptr = "目录文件";  //目录文件
   }
   else if (S_ISCHR(buf.st_mode))
   {
   ptr = "字符设备文件";  //字符设备文件
   }
   else if (S_ISBLK(buf.st_mode))
   {
       ptr = "块设备文件";   //块设备文件
   }
   else if (S_ISFIFO(buf.st_mode))
   {
   ptr = "FIFO";       //先进先出文件
   }
   else if (S_ISLNK(buf.st_mode))
   {
   ptr = "符号链接";   //符号链接文件
   }
   else if (S_ISSOCK(buf.st_mode))
   {
   ptr = "套接字文件";  //套接字文件
   }
   else   //如果不在以上文件类型则表明为未知文件类型
   {
     ptr = "未知文件类型";
   }
   printf("%s\n", ptr);      //输出文件类型


    [self generateSchemeArray];
   BOOL re =  NO;
//    if (re == YES) {
//        return re?@"已经越狱":@"未越狱";
//    }
    
//    re = [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"];
//
//    if (re == NO) {
//        NSData  *data =  [[NSData alloc] initWithContentsOfFile:@"/Applications/Cydia.app/Cydia"];
//        re = data?YES:NO;
//    }
//
//    if (re == NO) {
//        struct  stat  info;
//        if (stat("/Applications/Cydia.app", &info) == 0) {
//            re = YES;
//        }
//
//    }
    
    NSArray *bypassList = [[NSArray alloc] initWithObjects:
//                           @"
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
//                           @"/private/var/mobile/Library/Operator Bundle.bundle",
//                           @"/private/var/mobile/Library",
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
//                           @"/private/var/lib/apt/",
//                           @"Applications/Cydia.app",
                   nil];

    
    for (NSString *list in bypassList) {
        re =   [[NSFileManager defaultManager] fileExistsAtPath:list];
        if (re == YES) {
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

//void scan_executable_memory(const uint8_t *target, const uint32_t target_len, void (*callback)(uint8_t *)) {
//    const struct mach_header_64 *header = (const struct mach_header_64*) _dyld_get_image_header(0);
//    const struct section_64 *executable_section = getsectbynamefromheader_64(header, "__TEXT", "__text");
//
//    uint8_t *start_address = (uint8_t *) ((intptr_t) header + executable_section->offset);
//    uint8_t *end_address = (uint8_t *) (start_address + executable_section->size);
//
//    uint8_t *current = start_address;
//    uint32_t index = 0;
//
//    uint8_t current_target = 0;
//
//    while (current < end_address) {
//        current_target = target[index];
//
//        // Allow 0xFF as wildcard.
//        if (current_target == *current++ || current_target == 0xFF) {
//            index++;
//        } else {
//            index = 0;
//        }
//
//        // Check if match.
//        if (index == target_len) {
//            index = 0;
//            callback(current - target_len);
//        }
//    }
//}
//
//// ====== PATCH CODE ====== //
//void SVC80_handler(RegisterContext *reg_ctx, const HookEntryInfo *info) {
//#if defined __arm64__ || defined __arm64e__
//    int syscall_num = (int)(uint64_t)reg_ctx->general.regs.x16;
//    //monitoring ptrace
//    NSLog(@"dsgfdsgdfg SYS_ptrace");
//
//    if (syscall_num == SYS_ptrace) {
//
//        *(unsigned long *)(&reg_ctx->general.regs.x0) = (unsigned long long)0;
//    }
//
//#endif
//}
//
//void startHookTarget_SVC80(uint8_t* match) {
//#if defined __arm64__ || defined __arm64e__
////    dobby_enable_near_branch_trampoline();
////    DobbyInstrument((void *)(match), (DBICallTy)SVC80_handler);
////    dobby_disable_near_branch_trampoline();
//#endif
//}
//

-(NSString *)getSysInfoByName{
//    startHookTarget_SVC80(nil);
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


-(BOOL)getstatIsfromSystem{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"6"];
}


-(BOOL)getsUnspectClass{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"7"];
}

-(BOOL)checkCanwriteToprivatePath{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"8"];
}
-(BOOL)checkIsEsixtJsBrokensym{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"9"];
}

-(BOOL)checkIscangetAsubprogram{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"10"];
}

-(BOOL)getisunameNotSystemLib{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"11"];
}
-(BOOL)getisfopenNotSystemLib{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"12"];
}

-(BOOL)getisdlsymNotSystemLib{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"13"];
}

-(BOOL)getisgetenvNotSystemLib{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"14"];
}

-(BOOL)getisdyld_image_countNotSystemLib{
    return  [[UserCust sharedInstance] UVItinitseWithType:@"15"];
}


-(NSString *)getBulidVersionName{
    NSString *result = @"";
    struct stat sta = {0};
    struct stat lsta = {0};
    stat("/var/db/diagnostics/Persis", &sta);
    lstat("/var/db/diagnostics/Persis", &lsta);

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
    //非越狱 直接打不开

    return  result;
}

-(NSString *)metadataplist{
   NSString *filepath= [[WHCFileManager homeDir] stringByAppendingString:@"/.com.apple.mobile_container_manager.metadata.plist"];
    if ([WHCFileManager isExistsAtPath:filepath]) {//非越狱状态无法获取
       NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filepath];
        return  [NSString stringWithFormat:@"%@",dic];
    }
    
        return @"";
}

-(NSString *)getdyldName{
    uint32_t i;
    uint32_t count = _dyld_image_count();

    for(i = 0; i < count; i++) {
        const char *image_name = _dyld_get_image_name(i);

        if(image_name) {
            char *image_name = (char *)_dyld_get_image_name(i);
                    const struct mach_header *mh = _dyld_get_image_header(i);
                    intptr_t vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
                    
                    printf("DFDFDFD Image name %s at address 0x%llx and ASLR slide 0x%lx.\n",
                           image_name, (mach_vm_address_t)mh, vmaddr_slide);
            
            
        }
    }
    
    return [NSString stringWithFormat:@"image_count %d",count];

}

-(NSString *)getjsBrokenData{
    NSString *filePath = @"/System/Library/PrivateFrameworks/CoreMaterial.framework";
    
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    if (fileData) {
        return @"存在越狱CoreMaterial.framework特定值";
    }else{
        return @"不存在越狱CoreMaterial.framework特定值";
    }
}


-(NSString *)CoreMaterialframeworkInfoplist{
    NSString *filePath = @"/System/Library/PrivateFrameworks/CoreMaterial.framework/Info.plist";
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    if (dic) {
        return @"存在CoreMaterialframeworkInfoplist";
    }else{
        return @"不存在CoreMaterialframeworkInfoplist";
    }
}


-(NSString *)platformChromeLightmaterialrecipe{
    NSString *filePath = @"/System/Library/PrivateFrameworks/CoreMaterial.framework/platformChromeLight.materialrecipe";
    
    NSData *dic = [[NSData alloc] initWithContentsOfFile:filePath];
    if (dic) {
        return @"存在platformChromeLightmaterialrecipe";
    }else{
        return @"不存在platformChromeLightmaterialrecipe";
    }
}

//-(NSString *)ecidecid{
//
//}


//2021-08-02 17:32:42.265348+0800 ClientTest[595:231842] mhytestBrokenPath : /var/mobile/Library/Caches/com.apple.keyboards/version
//st[595:231842] mhytestBrokenPath : /var/mobile/Library/Caches/com.apple.itunesstored/url-resolution.plist
//2021-08-02 17:32:42.266253+0800 ClientTest[595:231842] mhytestBrokenPath : /var/mobile/Library/Caches/com.apple.keyboards/version
//2.267665+0800 ClientTest[595:231842] mhytestBrokenPath : /var/mobile/Library/Caches/GeoServices/SearchAttribution.pbd
//2021-08-02 17:32:42.269097+0800 ClientTest[595:231842] mhytestBrokenPath : /var/mobile/Library/Caches/Checkpoint.plist
//42.269391+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/Managed Preferences/mobile/.GlobalPreferences.plist
//2021-08-02 17:32:42.269951+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/Managed Preferences/mobile/com.apple.webcontentfilter.plist
//2021-08-02 17:32:42.270552+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64
//2021-08-02 17:32:42.271774+0800 ClientTest[595:231842] mhytestBrokenPath : /var/mobile/Library/Caches/DateFormats.plist
//2021-08-02 17:32:42.272998+0800 ClientTest[595:231842] mhytestBrokenPath : /var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml
//2021-08-02 17:32:42.274086+0800 ClientTest[595:231842] mhytestBrokenPath : /etc/group
//-02 17:32:42.274759+0800 ClientTest[595:231842] mhytestBrokenPath : /etc/hosts
//2021-08-02 17:32:42.275350+0800 ClientTest[595:231842] mhytestBrokenPath : /etc/passwd
//2021-08-02 17:32:42.276425+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/Backup/Domains.plist
//2021-08-02 17:32:42.277425+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/Spotlight/domains.plist
//2021-08-02 17:32:42.277641+0800 ClientTest[595:231842] mhytestBrokenPath : /Library/Managed Preferences/mobile/.GlobalPreferences.plist
//2021-08-02 17:32:42.278695+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/PrivateFrameworks/AppSupport.framework/Info.plist
//2021-08-02 17:32:42.280307+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/Filesystems/hfs.fs/Info.plist
//2021-08-02 17:32:42.280928+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/Caches/apticket.der
//2021-08-02 17:32:42.281449+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/CoreServices/SystemVersion.plist
//2021-08-02 17:32:42.281965+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/CoreServices/powerd.bundle/Info.plist
//2021-08-02 17:32:42.283492+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/Lockdown/iPhoneDeviceCA.pem
//2021-08-02 17:32:42.284224+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/Lockdown/iPhoneDebug.pem
//2021-08-02 17:32:42.288995+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/LaunchDaemons/com.apple.powerd.plist
//08-02 17:32:42.289884+0800 ClientTest[595:231842] mhytestBrokenPath : /System/Library/LaunchDaemons/bootps.plist
//2021-08-02 17:32:42.292463+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/mobile/Library/UserConfigurationProfiles/PublicInfo/MCMeta.plist
//2021-08-02 17:32:42.292807+0800 ClientTest[595:231842] mhytestBrokenPath : /Library/Managed Preferences/mobile/.GlobalPreferences.plist
//2021-08-02 17:32:42.292941+0800 ClientTest[595:231842] mhytestBrokenPath : /Library/Managed Preferences/mobile/com.apple.webcontentfilter.plist
//2021-08-02 17:32:42.293545+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/containers/Data/System/com.apple.geod/.com.apple.mobile_container_manager.metadata.plist
//st[595:231842] mhytestBrokenPath : /private/var/containers/Shared/SystemGroup/systemgroup.com.apple.lsd.iconscache/.com.apple.mobile_container_manager.metadata.plist
//2021-08-02 17:32:42.295481+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/mobile/Library/Caches/DateFormats.plist
//2021-08-02 17:32:42.295900+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/mobile/Library/Caches/DateFormats.plist
//2021-08-02 17:32:42.296572+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/mobile/Library/Caches/GeoServices/ActiveTileGroup.pbd
//2021-08-02 17:32:42.297518+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/mobile/Library/Caches/GeoServices/Experiments.pbd
//2021-08-02 17:32:42.299185+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/mobile/Library/Caches/GeoServices/Resources/LandCoverGradient16-1@2x.png
//2021-08-02 17:32:42.300013+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadHighway-1@2x.png
//2021-08-02 17:32:42.300553+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadLocalRoad-1@2x.png
//2021-08-02 17:32:42.300996+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml
//2021-08-02 17:32:42.301814+0800 ClientTest[595:231842] mhytestBrokenPath : /private/var/mobile/Library/Caches/GeoServices/Resources/night-DetailedLandCoverSand-1@2x.png


-(NSString *)brokegetecid{
    char buf_ps[1024];
        char ps[1024]={0};
        FILE *ptr;
        strcpy(ps, "ecidecid");
        if((ptr=popen(ps, "r"))!=NULL)
        {
            char *le = fgets(buf_ps, 1023, ptr);
//            printf("ecidecidecidecid buf = %s\n",le);
            NSLog(@"ecidecidecidecid buf%s",le);


//            while(le!=NULL)
//            {
////               strcat(result, buf_ps);
//               if(strlen(result)>1024)
//                   break;
//            }
//            exit(0);
            pclose(ptr);
            ptr = NULL;
        }
//    if (le) {
//        return [NSString stringWithCString:le encoding:NSUTF8StringEncoding];
//
//    }else{
//        return @"没有获取到";
//    }
    return @"没有获取到";

}

-(NSString *)brokepathTest{
//    return @"";
  NSArray *cacheArray =  [[NSArray alloc]initWithObjects:
    @"/var/mobile/Library/Caches/com.apple.itunesstored/url-resolution.plist",//1  //1
    @"/var/mobile/Library/Caches/com.apple.keyboards/version",//0   //1
     @"/System/Library/CoreServices/SystemVersion.bundle",//0    //0
     @"/var/mobile/Library/Fonts/AddedFontCache.plist",//0   //0
     @"/System/Library",//1   //1
     @"/System/Library/PrivateFrameworks/UIKitCore.framework",//0    //1
     @"/System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore",//0     //0
     @"/System/Library/PrivateFrameworks/CoreMaterial.framework/CoreMaterial",//0   //0
     @"/System/Library/PrivateFrameworks/CoreMaterial.framework",//0   //1
     @"/var/mobile/Library/Caches/com.apple.itunesstored/url-resolution.plist",//1   //1
     @"/var/mobile/Library/Caches/GeoServices/SearchAttribution.pbd",//1    //1
     @"/var/mobile/Library/Caches/Checkpoint.plist",//1    //1
     @"/private/var/Managed Preferences/mobile/.GlobalPreferences.plist",//1    //1
     @"/private/var/Managed Preferences/mobile/com.apple.webcontentfilter.plist",//1      //1
     @"/private/var/mobile",//1   //1
     @"/System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64",//1      //1
     @"/System/Library/Caches/com.apple.dyld/dyld_shared_cache_armv7s",//0    //0
     @"/System/Library/Caches/fps/lskd.rl",//0  //0
     @"/var/mobile/Library/Caches/DateFormats.plist",//1   //1
     @"/var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml",//1     //1
     @"/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png",//0   //0
     @"/var/mobile/Library/Caches/GeoServices/Resources/supportedCountriesDirections-12.plist",//0   //0
     @"/etc/group",//1   //1
     @"/etc/hosts",//1   //1
     @"/etc/passwd",//1   //1
     @"/System/Library/Backup/Domains.plist",//1   //1
     @"/System/Library/Spotlight/domains.plist",//1   //1
     @"/Library/Managed Preferences/mobile/.GlobalPreferences.plist",//1   //1
     @"/System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64e", //0  //0
     @"/System/Library/PrivateFrameworks/AppSupport.framework/Info.plist",//1    //1
     @"/System/Library/Filesystems/hfs.fs/Info.plist",//1
     @"/System/Library/Caches/apticket.der",//1
     @"/System/Library/CoreServices/SystemVersion.plist",//1
     @"/System/Library/CoreServices/powerd.bundle/Info.plist",//1
     @"/System/Library/Lockdown/iPhoneDeviceCA.pem",//1
     @"/System/Library/Lockdown/iPhoneDebug.pem",//1
     @"/System/Library/LaunchDaemons/com.apple.powerd.plist",//1
     @"/System/Library/LaunchDaemons/bootps.plist",//1
     @"/private/var/wireless/Library/LASD/lasdcdma.db",//0
     @"/private/var/wireless/Library/LASD/lasdgsm.db",//0
     @"/private/var/wireless/Library/LASD/lasdlte.db",//0
     @"/private/var/wireless/Library/LASD/lasdscdma.db",//0
     @"/private/var/wireless/Library/LASD/lasdumts.db",//0
     @"/private/var/run/printd",//1
     @"/private/var/run/syslog",//1
     @"/private/var/mobile/Library/UserConfigurationProfiles/PublicInfo/MCMeta.plist",//1
     @"/private/var/mobile/Library/Preferences",//1
     @"/Library/Managed Preferences/mobile/.GlobalPreferences.plist",//1
     @"/Library/Managed Preferences/mobile/com.apple.webcontentfilter.plist",//1
     @"/private/var/containers/Data/System/com.apple.geod/.com.apple.mobile_container_manager.metadata.plist",//1
     @"/private/var/containers/Shared/SystemGroup/systemgroup.com.apple.lsd.iconscache/.com.apple.mobile_container_manager.metadata.plist",//1
     @"/var/mobile/Library/Caches/com.apple.Pasteboard",//1
     @"/private/var/mobile/Library/Caches/DateFormats.plist",//1
     @"/private/var/mobile/Library/Caches/GeoServices/ActiveTileGroup.pbd",//1
     @"/private/var/mobile/Library/Caches/GeoServices/Experiments.pbd",//1
     @"/private/var/mobile/Library/Caches/GeoServices/Resources/DetailedLandCoverPavedArea-1@2x.png",//1
     @"/private/var/mobile/Library/Caches/GeoServices/Resources/LandCoverGradient16-1@2x.png",//1
     @"/private/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadHighway-1@2x.png",//1
     @"/private/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadLocalRoad-1@2x.png",//1
     @"/private/var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml",//1
     @"/private/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png",//0
     @"/private/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1@2x.png",//0
     @"/private/var/mobile/Library/Caches/GeoServices/Resources/night-DetailedLandCoverSand-1@2x.png",//1
     @"/private/var/mobile/Library/Carrier Bundles/Overlay",//1
     @"/private/var/mobile/Library/Operator Bundle.bundle",//1
     @"/private/var/mobile/Library",//1
     @"/System/Library/TextInput/TextInput_emoji.bundle",//1
     @"/System/Library/SystemConfiguration/CaptiveNetworkSupport.bundle",//1
     @"/usr/lib/libAXSpeechManager.dylib",//0
     @"System/Library/CoreServices/CoreGlyphs.bundle/Assets.car",//0
     @"/var/db/timezone/icutz",//1
     @"/var/db/timezone/icutz/icutz44l.dat",//1
     @"/var/db/timezone/icutz/icutz44l.dat",//1
                        @"/var/db/timezone/localtime",//1
                        @"/dev/random",//1
                          @"/usr/local/",//1
                          @"/usr/local",//1
                          @"/System/Library/Frameworks/CFNetwork.framework/Resources/CFNETWORK_DIAGNOSTICS",//0
                          @"/Library/Preferences/com.apple.security.plist",//1
     nil];
    
    NSString * tt= @"/System/Library/Caches/apticket.der";
    BOOL re = [WHCFileManager isExistsAtPath:tt];
    struct stat info1 ={0};
    struct stat info2 ={0};

    int  a =  stat(tt.UTF8String, &info1);
    int  b = lstat(tt.UTF8String, &info2);
    AntiCracker();


//
    NSMutableArray *dataArray = [NSMutableArray new];
    for (NSString *syspath in cacheArray) {
        BOOL re = [WHCFileManager isExistsAtPath:syspath];
        struct stat info ={0};
        struct stat info1 ={0};
        int  b = lstat(syspath.UTF8String, &info1);
        int  a =  stat(syspath.UTF8String, &info);
        if ([syspath isEqualToString:@"/System/Library/Caches/apticket.der"]) {
            NSLog(@"syspath isEqualToString %@ %d",syspath ,re);
            
            
        }
        NSString *mysting = [NSString stringWithFormat:@"%@  %d/%llu      %d/%llu",syspath,re,info.st_ino,re,info1.st_ino];
        [dataArray addObject:mysting];
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
/*
 /var/mobile/Library/Caches/com.apple.itunesstored/url-resolution.plist  1/35433,
 /var/mobile/Library/Caches/com.apple.keyboards/version  1/2276677,
 /System/Library/CoreServices/SystemVersion.bundle  0/0,
 /var/mobile/Library/Fonts/AddedFontCache.plist  0/0,
 /System/Library  0/24,
 /System/Library/PrivateFrameworks/UIKitCore.framework  0/4295286751,
 /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore  0/0,
 /System/Library/PrivateFrameworks/CoreMaterial.framework/CoreMaterial  0/0,
 /System/Library/PrivateFrameworks/CoreMaterial.framework  0/4295540841,
 /var/mobile/Library/Caches/com.apple.itunesstored/url-resolution.plist  1/35433,
 /var/mobile/Library/Caches/GeoServices/SearchAttribution.pbd  1/2271858,
 /var/mobile/Library/Caches/Checkpoint.plist  1/2235242,
 /private/var/Managed Preferences/mobile/.GlobalPreferences.plist  1/395,
 /private/var/Managed Preferences/mobile/com.apple.webcontentfilter.plist  1/16958,
 /private/var/mobile  0/17,
 /System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64  1/4295706018,
 /System/Library/Caches/com.apple.dyld/dyld_shared_cache_armv7s  0/0,
 /System/Library/Caches/fps/lskd.rl  0/0,
 /var/mobile/Library/Caches/DateFormats.plist  1/87982,
 /var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml  1/37049,
 /var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png  0/0,
 /var/mobile/Library/Caches/GeoServices/Resources/supportedCountriesDirections-12.plist  0/0,
 /etc/group  1/4295736118,
 /etc/hosts  1/138752,
 /etc/passwd  1/4295736120,
 /System/Library/Backup/Domains.plist  1/4295706777,
 /System/Library/Spotlight/domains.plist  1/118820,
 /Library/Managed Preferences/mobile/.GlobalPreferences.plist  1/395,
 /System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64e  0/0,
 /System/Library/PrivateFrameworks/AppSupport.framework/Info.plist  1/4295727310,
 /System/Library/Filesystems/hfs.fs/Info.plist  1/4295720132,
 /System/Library/Caches/apticket.der  1/4295110139,
 /System/Library/CoreServices/SystemVersion.plist  1/4295719971,
 /System/Library/CoreServices/powerd.bundle/Info.plist  1/4295719985,
 /System/Library/Lockdown/iPhoneDeviceCA.pem  1/85316,
 /System/Library/Lockdown/iPhoneDebug.pem  1/89417,
 /System/Library/LaunchDaemons/com.apple.powerd.plist  1/4295317869,
 /System/Library/LaunchDaemons/bootps.plist  1/4295519973,
 /private/var/wireless/Library/LASD/lasdcdma.db  0/318765,
 /private/var/wireless/Library/LASD/lasdgsm.db  0/318731,
 /private/var/wireless/Library/LASD/lasdlte.db  0/318774,
 /private/var/wireless/Library/LASD/lasdscdma.db  0/318804,
 /private/var/wireless/Library/LASD/lasdumts.db  0/318757,
 /private/var/run/printd  0/2276116,
 /private/var/run/syslog  0/2276105,
 /private/var/mobile/Library/UserConfigurationProfiles/PublicInfo/MCMeta.plist  1/827,
 /private/var/mobile/Library/Preferences  0/53,
 /Library/Managed Preferences/mobile/.GlobalPreferences.plist  1/395,
 /Library/Managed Preferences/mobile/com.apple.webcontentfilter.plist  1/16958,
 /private/var/containers/Data/System/com.apple.geod/.com.apple.mobile_container_manager.metadata.plist  1/944,
 /private/var/containers/Shared/SystemGroup/systemgroup.com.apple.lsd.iconscache/.com.apple.mobile_container_manager.metadata.plist  1/470,
 /var/mobile/Library/Caches/com.apple.Pasteboard  0/22379,
 /private/var/mobile/Library/Caches/DateFormats.plist  1/87982,
 /private/var/mobile/Library/Caches/GeoServices/ActiveTileGroup.pbd  1/2272604,
 /private/var/mobile/Library/Caches/GeoServices/Experiments.pbd  1/2131928,
 /private/var/mobile/Library/Caches/GeoServices/Resources/DetailedLandCoverPavedArea-1@2x.png  1/36979,
 /private/var/mobile/Library/Caches/GeoServices/Resources/LandCoverGradient16-1@2x.png  1/36985,
 /private/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadHighway-1@2x.png  1/37029,
 /private/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadLocalRoad-1@2x.png  1/37023,
 /private/var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml  1/37049,
 /private/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png  0/0,
 /private/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1@2x.png  0/0,
 /private/var/mobile/Library/Caches/GeoServices/Resources/night-DetailedLandCoverSand-1@2x.png  1/37001,
 /private/var/mobile/Library/Carrier Bundles/Overlay  0/824,
 /private/var/mobile/Library/Operator Bundle.bundle  0/34418,
 /private/var/mobile/Library  0/45,
 /System/Library/TextInput/TextInput_emoji.bundle  0/127280,
 /System/Library/SystemConfiguration/CaptiveNetworkSupport.bundle  0/32339,
 /usr/lib/libAXSpeechManager.dylib  0/0,
 System/Library/CoreServices/CoreGlyphs.bundle/Assets.car  1/4295694021,
 /var/db/timezone/icutz  0/126811,
 /var/db/timezone/icutz/icutz44l.dat  1/126812,
 /var/db/timezone/icutz/icutz44l.dat  1/126812,
 /var/db/timezone/localtime  0/126578,
 /dev/random  0/236,
 /usr/local/  0/4295110161,
 /usr/local  0/4295110161,
 /System/Library/Frameworks/CFNetwork.framework/Resources/CFNETWORK_DIAGNOSTICS  0/0,
 /Library/Preferences/com.apple.security.plist  0/0

 
 /var/mobile/Library/Caches/com.apple.itunesstored/url-resolution.plist  1/79829,
 /var/mobile/Library/Caches/com.apple.keyboards/version  0/0,
 /System/Library/CoreServices/SystemVersion.bundle  0/0,
 /var/mobile/Library/Fonts/AddedFontCache.plist  0/0,
 /System/Library  0/24,
 /System/Library/PrivateFrameworks/UIKitCore.framework  0/0,
 /System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore  0/0,
 /System/Library/PrivateFrameworks/CoreMaterial.framework/CoreMaterial  0/0,
 /System/Library/PrivateFrameworks/CoreMaterial.framework  0/0,
 /var/mobile/Library/Caches/com.apple.itunesstored/url-resolution.plist  1/79829,
 /var/mobile/Library/Caches/GeoServices/SearchAttribution.pbd  1/114817499,
 /var/mobile/Library/Caches/Checkpoint.plist  1/246504,
 /private/var/Managed Preferences/mobile/.GlobalPreferences.plist  1/572,
 /private/var/Managed Preferences/mobile/com.apple.webcontentfilter.plist  1/107517918,
 /private/var/mobile  0/45,
 /System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64  1/4295234317,
 /System/Library/Caches/com.apple.dyld/dyld_shared_cache_armv7s  0/0,
 /System/Library/Caches/fps/lskd.rl  0/0,
 /var/mobile/Library/Caches/DateFormats.plist  1/44103567,
 /var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml  1/79816,
 /var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png  0/0,
 /var/mobile/Library/Caches/GeoServices/Resources/supportedCountriesDirections-12.plist  0/0,
 /etc/group  1/4295185095,
 /etc/hosts  1/138934,
 /etc/passwd  1/4295185098,
 /System/Library/Backup/Domains.plist  1/4295227543,
 /System/Library/Spotlight/domains.plist  1/118972,
 /Library/Managed Preferences/mobile/.GlobalPreferences.plist  1/572,
 /System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64e  0/0,
 /System/Library/PrivateFrameworks/AppSupport.framework/Info.plist  1/4295257991,
 /System/Library/Filesystems/hfs.fs/Info.plist  1/4295247527,
 /System/Library/Caches/apticket.der  1/4295110311,
 /System/Library/CoreServices/SystemVersion.plist  1/4295247288,
 /System/Library/CoreServices/powerd.bundle/Info.plist  1/4295247303,
 /System/Library/Lockdown/iPhoneDeviceCA.pem  1/85460,
 /System/Library/Lockdown/iPhoneDebug.pem  1/89561,
 /System/Library/LaunchDaemons/com.apple.powerd.plist  1/4295158333,
 /System/Library/LaunchDaemons/bootps.plist  1/4295158168,
 /private/var/wireless/Library/LASD/lasdcdma.db  0/0,
 /private/var/wireless/Library/LASD/lasdgsm.db  0/0,
 /private/var/wireless/Library/LASD/lasdlte.db  0/0,
 /private/var/wireless/Library/LASD/lasdscdma.db  0/0,
 /private/var/wireless/Library/LASD/lasdumts.db  0/0,
 /private/var/run/printd  0/114716827,
 /private/var/run/syslog  0/114716825,
 /private/var/mobile/Library/UserConfigurationProfiles/PublicInfo/MCMeta.plist  1/18618954,
 /private/var/mobile/Library/Preferences  0/59,
 /Library/Managed Preferences/mobile/.GlobalPreferences.plist  1/572,
 /Library/Managed Preferences/mobile/com.apple.webcontentfilter.plist  1/107517918,
 /private/var/containers/Data/System/com.apple.geod/.com.apple.mobile_container_manager.metadata.plist  1/529,
 /private/var/containers/Shared/SystemGroup/systemgroup.com.apple.lsd.iconscache/.com.apple.mobile_container_manager.metadata.plist  1/2447210,
 /var/mobile/Library/Caches/com.apple.Pasteboard  0/6337,
 /private/var/mobile/Library/Caches/DateFormats.plist  1/44103567,
 /private/var/mobile/Library/Caches/GeoServices/ActiveTileGroup.pbd  1/114817518,
 /private/var/mobile/Library/Caches/GeoServices/Experiments.pbd  1/114789428,
 /private/var/mobile/Library/Caches/GeoServices/Resources/DetailedLandCoverPavedArea-1@2x.png  1/79572,
 /private/var/mobile/Library/Caches/GeoServices/Resources/LandCoverGradient16-1@2x.png  1/79576,
 /private/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadHighway-1@2x.png  1/79594,
 /private/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadLocalRoad-1@2x.png  1/79595,
 /private/var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml  1/79816,
 /private/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png  0/0,
 /private/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1@2x.png  0/0,
 /private/var/mobile/Library/Caches/GeoServices/Resources/night-DetailedLandCoverSand-1@2x.png  1/79584,
 /private/var/mobile/Library/Carrier Bundles/Overlay  0/2990,
 /private/var/mobile/Library/Operator Bundle.bundle  0/35247,
 /private/var/mobile/Library  0/47,
 /System/Library/TextInput/TextInput_emoji.bundle  0/127463,
 /System/Library/SystemConfiguration/CaptiveNetworkSupport.bundle  0/32377,
 /usr/lib/libAXSpeechManager.dylib  0/0,
 System/Library/CoreServices/CoreGlyphs.bundle/Assets.car  0/0,
 /var/db/timezone/icutz  0/113873376,
 /var/db/timezone/icutz/icutz44l.dat  1/113873377,
 /var/db/timezone/icutz/icutz44l.dat  1/113873377,
 /var/db/timezone/localtime  0/113873799,
 /dev/random  0/133,
 /usr/local/  0/4295110333,
 /usr/local  0/4295110333,
 /System/Library/Frameworks/CFNetwork.framework/Resources/CFNETWORK_DIAGNOSTICS  0/0,
 /Library/Preferences/com.apple.security.plist  0/0
 */
    NSMutableDictionary *fee = [self mutableDeepCopywith:dic];
//
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fee options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    for (NSString *path in cacheArray) {
      bool re =   [WHCFileManager isFileAtPath:path];
        if (re) {
//            tt=@"存在Broken filePath";
            NSLog(@"mhytestBrokenPath : %@",path);
            if ([path isEqualToString:@"/var/mobile/Library/Caches/com.apple.keyboards/version"]) {
                NSString *versoin = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];//1629152458 完成  重定向  非越狱不存在
                NSLog(@"mhytestBrokenPath valu: %@",versoin);

                
            }else if ([path isEqualToString:@"/var/mobile/Library/Caches/com.apple.itunesstored/url-resolution.plist"]){
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPath dic: %@",dic);//重定向  已完成  非越狱存在

            }else if ([path isEqualToString:@"/var/mobile/Library/Caches/GeoServices/SearchAttribution.pbd"]){  //重定向  已完成   非越狱存在
                //在越狱状态是  没有这个SearchAttribution.pbd
                
            }else if ([path isEqualToString:@"/var/mobile/Library/Caches/Checkpoint.plist"]){  //重定向  已完成   非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
//                NSLog(@"mhytestBrokenPath dic: %@",dic);
                
            }else if ([path isEqualToString:@"/private/var/Managed Preferences/mobile/.GlobalPreferences.plist"]){//完成  重定向 非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPath11 dic: %@",dic);
                
            }else if ([path isEqualToString:@"/private/var/Managed Preferences/mobile/com.apple.webcontentfilter.plist"]){//已完成  重定向 非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathwebcontentfilter dic: %@",dic);
                
            }else if ([path isEqualToString:@"/System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64"]){ //需要做Inode处理  无法重定向
                
            }else if ([path isEqualToString:@"/var/mobile/Library/Caches/DateFormats.plist"]){//重定向已完成  非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats dic: %@",dic);

            }else if ([path isEqualToString:@"/var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml"]){  //重定向 已完成 非越狱存在
                NSURL *url = [NSURL fileURLWithPath:path];
                NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
                parser.delegate = self;
                [parser parse];

            }else if ([path isEqualToString:@"/etc/hosts"]){   //重定向 已完成 非越狱存在
                
            }else if ([path isEqualToString:@"/etc/passwd"]){ //重定向 已完成 非越狱存在
                
            }else if ([path isEqualToString:@"/System/Library/Spotlight/domains.plist"]){//重定向 已完成 非越狱存在
                
            }else if ([path isEqualToString:@"/Library/Managed Preferences/mobile/.GlobalPreferences.plist"]){////重定向 已完成 非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats dic: %@",dic);

            }else if ([path isEqualToString:@"/System/Library/PrivateFrameworks/AppSupport.framework/Info.plist"]){////重定向 已完成 非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats dic: %@",dic);

            }else if ([path isEqualToString:@"/System/Library/Filesystems/hfs.fs/Info.plist"]){//完成  重定向 非越狱存在

                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats dic: %@",dic);

            }else if ([path isEqualToString:@"/System/Library/Caches/apticket.der"]){//重定向 已完成 非越狱存在
                
            }else if ([path isEqualToString:@"/System/Library/CoreServices/SystemVersion.plist"]){//重定向 已完成 非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats dic: %@",dic);

            }else if ([path isEqualToString:@"/System/Library/CoreServices/powerd.bundle/Info.plist"]){////重定向 已完成 非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats dic: %@",dic);

            }else if ([path isEqualToString:@"/System/Library/Lockdown/iPhoneDeviceCA.pem"]){///重定向 已完成 非越狱存在

                
            }else if ([path isEqualToString:@"/System/Library/Lockdown/iPhoneDebug.pem"]){///重定向 已完成 非越狱存在

                
            }else if ([path isEqualToString:@"/System/Library/LaunchDaemons/com.apple.powerd.plist"]){/////重定向 已完成 非越狱存在

                struct stat file_stat;

                stat("/System/Library/LaunchDaemons/com.apple.powerd.plist", &file_stat);
                printf("%ld", file_stat.st_ino);
                
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats dic: %@",dic);

            }else if ([path isEqualToString:@"/System/Library/LaunchDaemons/bootps.plist"]){////重定向 已完成 非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats dic: %@",dic);
                
            }else if ([path isEqualToString:@"/Library/Managed Preferences/mobile/com.apple.webcontentfilter.plist"]){////重定向 已完成 非越狱存在
                                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats dic: %@",dic);

            }else if ([path isEqualToString:@"/private/var/containers/Data/System/com.apple.geod/.com.apple.mobile_container_manager.metadata.plist"]){/////重定向 已完成 非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats222 dic: %@",dic);

            }else if ([path isEqualToString:@"/private/var/containers/Shared/SystemGroup/systemgroup.com.apple.lsd.iconscache/.com.apple.mobile_container_manager.metadata.plist"]){//重定向 已完成 非越狱存在
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                NSLog(@"mhytestBrokenPathDateFormats dic: %@",dic);

            }else if ([path isEqualToString:@"/private/var/mobile/Library/Caches/GeoServices/ActiveTileGroup.pbd"]){ //重定向 已完成 非越狱存在
                
            }else if ([path isEqualToString:@"/private/var/mobile/Library/Caches/GeoServices/Experiments.pbd"]){  //已完成 非越狱存在
                                
            }else if ([path isEqualToString:@"/System/Library/PrivateFrameworks/UIKitCore.framework/Info.plist"]){//非越狱  不能访问
                
            }else if ([path isEqualToString:@"/Library/Preferences/com.apple.security.plist"]){ //非越狱 不能访问
                
            }else if ([path isEqualToString:@"/System/Library/CoreServices/CoreGlyphs.bundle/Info.plist"]){  //非越狱不能访问
                
            }else if ([path isEqualToString:@"/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png"]){ // 非越狱不存在
                
            }else if ([path isEqualToString:@"/var/mobile/Library/Caches/GeoServices/Resources"]){//这个目录就获取不到
                
            }else if ([path isEqualToString:@"/var/root"]){//非越狱存在
                
            }else if ([path isEqualToString:@"/var/stash"]){//非越狱存在
                
            }else if ([path isEqualToString:@"/var/db/stash"]){//非越狱不存在
                
            }else if ([path isEqualToString:@"/usr/sbin/sshd"]){//非越狱不存在
                
            }else if ([path isEqualToString:@"/etc/apt"]){//非越狱不存在
                
            }else if ([path isEqualToString:@"/var/lib/apt"]){//非越狱不存在
                
            }else if ([path isEqualToString:@"/var/cache/apt"]){//非越狱不存在
                
            }else if ([path isEqualToString:@"/etc/apt/sources.list.d/saurik.list"]){//非越狱不存在
                
            }else if ([path isEqualToString:@"/usr/libexec/cydia/startup"]){//非越狱不存在
                
            }else if ([path isEqualToString:@"/System/Library/TextInput/TextInput_emoji.bundle"]){//非越狱 不存在
                
            }else if ([path isEqualToString:@"/System/Library/SystemConfiguration/CaptiveNetworkSupport.bundle"]){//非越狱 不存在
                
            }else if ([path isEqualToString:@"/usr/lib/libAXSpeechManager.dylib"]){//非越狱 不存在
                
            }else if ([path isEqualToString:@"/System/Library/CoreServices/CoreGlyphs.bundle/Assets.car"]){//非越狱 不存在
                
            }else if ([path isEqualToString:@"/var/db/timezone/icutz"]){//非越狱 存在
                
            }else if ([path isEqualToString:@"/var/db/timezone/icutz/icutz44l.dat"]){//非越狱存在
                
            }else if ([path isEqualToString:@"/var/db/timezone/localtime"]){//非越狱存在
                
            }else if ([path isEqualToString:@"/dev/random"]){//非越狱存在
                
            }else if ([path isEqualToString:@"/usr/local/"]){//非越狱 存在
                
            }else if ([path isEqualToString:@"/usr/local"]){//非越狱 存在
                
            }else if ([path isEqualToString:@"/System/Library/Frameworks/CFNetwork.framework/Resources/CFNETWORK_DIAGNOSTICS"]){//非越狱 不存在
                
            }else if ([path isEqualToString:@"/Library/Preferences/com.apple.security.plist"]){//非越狱存在
           
            }


        }
    }
    
    
    return @"";
}

-(NSMutableDictionary *)mutableDeepCopywith:(NSDictionary *)dic{
    
    NSMutableDictionary *copyDict = [[NSMutableDictionary alloc]initWithCapacity:dic.count];
    
    for (id key in dic.allKeys) {
        
        id oneCopy = nil;
        
        id oneValue = [dic valueForKey:key];
        
        if ([oneValue isKindOfClass:[NSData class]]) {
            NSString *dataStr = [[NSString alloc] initWithData:oneValue encoding:NSUTF8StringEncoding];
            [copyDict setValue:dataStr forKey:key];
        }else if ([oneValue isKindOfClass:[NSDictionary class]]){
            oneCopy = [self mutableDeepCopywith:oneValue];
            [copyDict setValue:oneCopy forKey:key];
        }else if([oneValue isKindOfClass:[NSString class]]){
            [copyDict setValue:oneValue forKey:key];
        }else if([oneValue isKindOfClass:[NSNumber class]]){
            [copyDict setValue:oneValue forKey:key];
        }else{
            [copyDict setValue:oneValue forKey:key];
        }

    }
    
    return copyDict;
    
}

@end
