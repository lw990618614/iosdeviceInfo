//
//  AppDelegate.m
//  ClientTest
//
//  Created by 王鹏飞 on 16/7/1.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "AppDelegate.h"
#import "NSData+CRC32.h"
#import "NetWorkInfoManager.h"
#import "AFNetworking.h"
#import "WHCFileManager.h"

#import <UMCommon/UMCommon.h>
#import "ANYMethodLog.h"
#import "MYDTCheckManager.h"
#import "FMDeviceManager.h"

#import "fishhook.h"
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

@interface UMUtils : NSObject


@end

@interface UMConfigureCache : NSObject


@end

@interface AppDelegate ()

@end
NSMutableArray *testArray;

@implementation AppDelegate
int  (*orig_stat)(const char *path ,struct stat *info);
static  int replaced_stat(const char *path ,struct stat *info){
    [testArray addObject:[NSString stringWithFormat:@"orig_stat %s",path]];
    return orig_stat(path,info);
}


int (*orig_lstat)(const char *pathname,struct stat buf);
static  int replaced_lstat(const char *path ,struct stat *info){
    [testArray addObject:[NSString stringWithFormat:@"orig_lstat %s",path]];
    return orig_stat(path,info);
}

FILE    (*orig_fopen)(const char *filename, const char * mode);

static  FILE replaced_fopen(const char *path ,struct stat *info){
    [testArray addObject:[NSString stringWithFormat:@"replaced_fopen %s",path]];

    return orig_fopen(path,(char *)info);
}

int  (*orig_fgetc)(FILE *);
static  int replaced_fgetc(FILE *name){
    [testArray addObject:[NSString stringWithFormat:@"replaced_fgetc %@",name]];

    return orig_fgetc(name);
}


int  (*orig_fgets)(char * , int, FILE *);
static  int replaced_fgets(char * st , int t , FILE *name){
    [testArray addObject:[NSString stringWithFormat:@"replaced_fgets %s",st]];

    return orig_fgets(st,t,name);
}

ssize_t     (*orig_write)(int , const void * , size_t );
static  ssize_t replaced_write(int wir , const void * v , size_t  le){
    [testArray addObject:[NSString stringWithFormat:@"replaced_write %zu",le]];
    return orig_write(wir,v,le);
}

int     (*orig_open)(const char *, int);
static  int replaced_open(const char * filename, int le){
    [testArray addObject:[NSString stringWithFormat:@"replaced_open %s",filename]];

    return orig_open(filename,le);
}

int    (*orig_chown)(const char *, uid_t, gid_t);
static  int replaced_chown(const char *path, uid_t uid, gid_t gid){
    [testArray addObject:[NSString stringWithFormat:@"replaced_chown %s",path]];
    return orig_chown(path,uid,gid);
}

int     (*orig_link)(const char *, const char *);
static  int replaced_link(const char *oldpath , const char *newpath){
    [testArray addObject:[NSString stringWithFormat:@"replaced_link %s %s",oldpath,oldpath]];
    return orig_link(oldpath,newpath);
}

int     (*orig_unlink)(const char *);
static  int replaced_unlink(const char *path){
    [testArray addObject:[NSString stringWithFormat:@"replaced_unlink %s",path]];
    return orig_unlink(path);
}

int     (*orig_chdir)(const char *);
static  int replaced_chdir(const char *path){
    [testArray addObject:[NSString stringWithFormat:@"replaced_chdir %s",path]];
    return orig_chdir(path);
}

int     (*orig_chroot)(const char *);
static  int replaced_chroot(const char *path){
    [testArray addObject:[NSString stringWithFormat:@"replaced_chroot %s",path]];
    return orig_chroot(path);
}

pid_t     (*orig_fork)(void);
static  pid_t replaced_fork(){
    [testArray addObject:[NSString stringWithFormat:@"replaced_fork %s","fork"]];
    return orig_fork();
}

int     (*orig_fchdir)(int);
static  int replaced_fchdir(int t){
    [testArray addObject:[NSString stringWithFormat:@"replaced_fchdir %d",t]];
    return orig_fchdir(t);
}

int     (*orig_mknod)(const char *, mode_t, dev_t);
static  int replaced_mknod(const char *path , mode_t t, dev_t dt){
    [testArray addObject:[NSString stringWithFormat:@"orig_mknod %s",path]];
    return orig_mknod(path,t,dt);
}

int     (*orig_getfsstat)(struct statfs *, int, int) ;
static  int replaced_getfsstat(struct statfs * fs, int bufsize, int mode){
    [testArray addObject:[NSString stringWithFormat:@"replaced_getfsstat %d",bufsize]];
    return orig_getfsstat(fs,bufsize,mode);
}

//函数说明：wait()会暂时停止目前进程的执行,直到有信号来到或子进程结束. 如果在调用wait()时子进程已经结束,则wait()会立即返回子进程结束状态值. 子进程的结束状态值会由参数status 返回,而子进程的进程识别码也会一快返回. 如果不在意结束状态值,则参数 status 可以设成NULL. 子进程的结束状态值请参考waitpid().
pid_t   (*orig_wait3)(int *, int, struct rusage *);
static  pid_t replaced_wait3(int * t, int l , struct rusage * ge){
    [testArray addObject:[NSString stringWithFormat:@"replaced_wait3 %d",l]];
    return orig_wait3(t,l,ge);
}


pid_t   (*orig_wait4)(pid_t, int *, int, struct rusage *);
static  int replaced_wait4(pid_t t, int * buf, int l, struct rusage *ge){
    [testArray addObject:[NSString stringWithFormat:@"replaced_wait4 %d",l]];
    return orig_wait4(t,buf,l,ge);
}

int     (*orig_chmod)(const char *, mode_t);
static  int replaced_chmod(const char * path, mode_t t){
    [testArray addObject:[NSString stringWithFormat:@"replaced_chmod %s",path]];
    return orig_chmod(path,t);
}


int     (*orig_fchmod)(int, mode_t) ;
static  int replaced_fchmod(int t, mode_t mt){
    [testArray addObject:[NSString stringWithFormat:@"replaced_fchmod %d",t]];
    return orig_fchmod(t,mt);
}
int     (*orig_fstat)(int, struct stat *);
static  int replaced_fstat(int t, struct stat * st){
    [testArray addObject:[NSString stringWithFormat:@"replaced_fstat %d",t]];
    return orig_fstat(t,st);
}

int     (*orig_mkdir)(const char *, mode_t);
static  int replaced_mkdir(const char *path, mode_t t){
    [testArray addObject:[NSString stringWithFormat:@"replaced_mkdir %s",path]];
    return orig_mkdir(path,t);
}

int     (*orig_mkfifo)(const char *, mode_t);
static  int replaced_mkfifo(const char *path, mode_t t){
    [testArray addObject:[NSString stringWithFormat:@"replaced_mkfifo %s",path]];
    return orig_mkfifo(path,t);
}

//该函数在或头文件中定义。exp2()函数用于计算二进制指数函数，该二进制指数函数是给定数字的以2为底的指数函数
double (*orig_exp2)(double);
static  double replaced_exp2(double d){
    [testArray addObject:[NSString stringWithFormat:@"replaced_exp2 %f",d]];
    return orig_exp2(d);
}

int     (*orig_sprintf)(char * , const char *);
static  int replaced_sprintf(char *str , const char * r){
    [testArray addObject:[NSString stringWithFormat:@"replaced_sprintf %s",str]];
    return orig_sprintf(str,r);
}

gid_t    (*orig_getegid)(void);
static  gid_t replaced_getegid(void){
    gid_t t =  orig_getegid();
    [testArray addObject:[NSString stringWithFormat:@"replaced_getegid %d",t]];
    return t;
}

uid_t     (*orig_geteuid)(void);
static  gid_t replaced_geteuid(void){
    gid_t t =  orig_geteuid();
    [testArray addObject:[NSString stringWithFormat:@"replaced_geteuid %d",t]];
    return t;
}

gid_t     (*orig_getgid)(void);
static  gid_t replaced_getgid(void){
    gid_t t =  orig_getgid();
    [testArray addObject:[NSString stringWithFormat:@"replaced_getgid %d",t]];
    return t;
}

gid_t     (*orig_getppid)(void);
static  gid_t replaced_getppid(void){
    gid_t t =  orig_getppid();
    [testArray addObject:[NSString stringWithFormat:@"replaced_getppid %d",t]];
    return t;
}
//位于：<netdb.h>;
//功能：根据给定端口号与协议查询服务;
//返回：成功返回非空指针，出错返回错1。
//sptr = getservbyport(htons(53), "udp"); // DNS using UDP
//sptr = getservbyport(htons(21), "tcp");//FTP using TCP
//sptr = getservbyport(htons(21), NULL);//FTP using TCP
//sptr = getservbyport(htons(21), "udp");// this
struct servent    (*orig_getservbyport)(int, const char *);
static  struct servent replaced_getservbyport(int t, const char * str){
    [testArray addObject:[NSString stringWithFormat:@"replaced_getservbyport %s",str]];
    return orig_getservbyport(t,str);
}

kern_return_t (*orig_host_processor_info)
(
    host_t host,
    processor_flavor_t flavor,
    natural_t *out_processor_count,
    processor_info_array_t *out_processor_info,
    mach_msg_type_number_t *out_processor_infoCnt
);

static  kern_return_t replaced_host_processor_info(
                                                   host_t host,
                                                   processor_flavor_t flavor,
                                                   natural_t *out_processor_count,
                                                   processor_info_array_t *out_processor_info,
                                                   mach_msg_type_number_t *out_processor_infoCnt
                                               ){
    [testArray addObject:[NSString stringWithFormat:@"replaced_host_processor_info %s","t"]];
    return orig_host_processor_info(host,flavor,out_processor_count,out_processor_info,out_processor_infoCnt);
}

kern_return_t (*orig_host_statistics)
(
    host_t host_priv,
    host_flavor_t flavor,
    host_info_t host_info_out,
    mach_msg_type_number_t *host_info_outCnt
);
static  kern_return_t replaced_host_statistics(
                                               host_t host_priv,
                                               host_flavor_t flavor,
                                               host_info_t host_info_out,
                                               mach_msg_type_number_t *host_info_outCnt
                                           ){
    [testArray addObject:[NSString stringWithFormat:@"replaced_host_statistics %s","t"]];
    return orig_host_statistics(host_priv,flavor,host_info_out,host_info_outCnt);
}

const char * (*orig_hstrerror)(int);
static  const char * replaced_hstrerror(int t){
    [testArray addObject:[NSString stringWithFormat:@"replaced_hstrerror %d",t]];
    return orig_hstrerror(t);
}

const char * (*orig_if_indextoname)(unsigned int, char *);
static  const char * replaced_if_indextoname(unsigned int t, char * c){
    [testArray addObject:[NSString stringWithFormat:@"replaced_if_indextoname %d",t]];
    return orig_if_indextoname(t,c);
}

in_addr_t     (*orig_inet_addr)(const char *);
static  int replaced_inet_addr(const char *path){
    [testArray addObject:[NSString stringWithFormat:@"replaced_inet_addr %s",path]];
    return orig_inet_addr(path);
}

char        *(*orig_inet_ntoa)(struct in_addr);
static   char * replaced_inet_ntoa(struct in_addr addr){
    [testArray addObject:[NSString stringWithFormat:@"replaced_inet_ntoa "]];
    return orig_inet_ntoa(addr);
}

const char    *(*orig_inet_ntop)(int, const void *, char *, socklen_t);
static  const char * replaced_inet_ntop(int t, const void *v, char * c, socklen_t le){
    [testArray addObject:[NSString stringWithFormat:@"replaced_inet_ntop %d",t]];
    return orig_inet_ntop(t,v,c,le);
}

int         (*orig_inet_pton)(int, const char *, void *);
static  int replaced_inet_pton(int t, const char * c, void * v){
    [testArray addObject:[NSString stringWithFormat:@"replaced_inet_pton %s",c]];
    return orig_inet_pton(t,c,v);
}

//ioctl是设备驱动程序中对设备的I/O通道进行管理的函数。所谓对I/O通道进行管理，就是对设备的一些特性进行控制，例如串口的传输波特率、马达的转速等等。
int     (*orig_ioctl)(int, unsigned long, ...);
static  int replaced_ioctl(int tt, unsigned long l, ...){
    [testArray addObject:[NSString stringWithFormat:@"replaced_inet_pton %d",tt]];
    return orig_ioctl(tt,l);
}
//判断文件描述词是否是为终端机
int     (*orig_isatty)(int);
static  int replaced_isatty(int tt){
    [testArray addObject:[NSString stringWithFormat:@"replaced_isatty %d",tt]];
    return orig_isatty(tt);
}

int    (*orig_kill)(pid_t, int);
static  int replaced_kill(pid_t pd, int tt){
    [testArray addObject:[NSString stringWithFormat:@"replaced_kill %d",tt]];
    return orig_kill(pd,tt);
}

//memmove() 与 memcpy() 类似都是用来复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上。不同的是，memmove() 更为灵活，当src 和 dest 所指的内存区域重叠时，memmove() 仍然可以正确的处理，不过执行效率上会比使用 memcpy() 略慢些。
void    *(*orig_memmove)(void *__dst, const void *__src, size_t __len);
static  const char * replaced_memmove(void * dst, const void * src, size_t len){
//    [testArray addObject:[NSString stringWithFormat:@"replaced_memmove"]];死循环
    return orig_memmove(dst,src,len);
}

ssize_t     (*orig_read)(int, void *, size_t) ;
static  ssize_t replaced_read(int t, void * v, size_t le){
    [testArray addObject:[NSString stringWithFormat:@"replaced_read %zu",le]];
    return orig_read(t,v,le);
}

void    *(*orig_realloc)(void *__ptr, size_t __size);
static  void *replaced_realloc(void *ptr, size_t le){
//    [testArray addObject:[NSString stringWithFormat:@"replaced_realloc %zu",le]];
    return orig_realloc(ptr,le);
}

ssize_t (*orig_sendto)(int, const void *, size_t,
    int, const struct sockaddr *, socklen_t) ;
static  ssize_t replaced_sendto(int t, const void *v, size_t le,
                                int t1, const struct sockaddr * addr, socklen_t solen){
    [testArray addObject:[NSString stringWithFormat:@"replaced_sendto %zu",le]];
    return orig_sendto(t,v,le,t1,addr,solen);
}

int (*orig_sigaction)(int, const struct sigaction * ,
                           struct sigaction * );
static int  replaced_sigaction(int t, const struct sigaction *sig ,
                                           struct sigaction * sigt){
    [testArray addObject:[NSString stringWithFormat:@"replaced_sigaction %d",t]];
    return orig_sigaction(t,sig,sigt);
};

int     (*orig_socket)(int, int, int);
static int  replaced_socket(int t1, int t2, int t3){
    [testArray addObject:[NSString stringWithFormat:@"replaced_socket %d",t1]];
    return orig_socket(t1,t2,t3);
};

//从一个字符串中读进与指定格式相符的数据的函数
int     (*orig_sscanf)(const char * __restrict, const char * __restrict, ...);
static int  replaced_sscanf(const char * str, const char * str1, ...){
    [testArray addObject:[NSString stringWithFormat:@"replaced_sscanf %s %s",str ,str1]];
    return orig_sscanf(str,str1);
};


char    *(*orig_strchr)(const char *__s, int __c);
static  const char * replaced_strchr(const char * s, int c){
    [testArray addObject:[NSString stringWithFormat:@"replaced_strchr %s",s]];
    return orig_strchr(s,c);
}


//mac 地址相关
size_t     (*orig_strcspn)(const char *__s, const char *__charset);
static  ssize_t replaced_strcspn(const char * s, const char * charset){
    [testArray addObject:[NSString stringWithFormat:@"replaced_strcspn %s",charset]];
    return orig_strcspn(s,charset);
}

char    *(*orig_strstr)(const char *__big, const char *__little);
static  const char * replaced_strstr(const char * big, const char * little){
    [testArray addObject:[NSString stringWithFormat:@"replaced_strstr %s %s",big, little]];
    return orig_strstr(big,little);
}
//+(void)load{
//    testArray = [NSMutableArray new];
//
//    rebind_symbols((struct rebinding[1]){{"stat",  (void *)replaced_stat, (void **)&orig_stat}}, 1);
//    rebind_symbols((struct rebinding[1]){{"lstat",  (void *)replaced_lstat, (void **)&orig_lstat}}, 1);
//    rebind_symbols((struct rebinding[1]){{"fopen",  (void *)replaced_fopen, (void **)&orig_fopen}}, 1);
//    rebind_symbols((struct rebinding[1]){{"fgets",  (void *)replaced_fgetc, (void **)&orig_fgetc}}, 1);
//    rebind_symbols((struct rebinding[1]){{"fgetc",  (void *)replaced_fgets, (void **)&orig_fgets}}, 1);
//
//
//    rebind_symbols((struct rebinding[1]){{"write",  (void *)replaced_write, (void **)&orig_write}}, 1);
//    rebind_symbols((struct rebinding[1]){{"open",  (void *)replaced_open, (void **)&orig_open}}, 1);
//    rebind_symbols((struct rebinding[1]){{"chown",  (void *)replaced_chown, (void **)&orig_chown}}, 1);
//    rebind_symbols((struct rebinding[1]){{"link",  (void *)replaced_link, (void **)&orig_link}}, 1);
//    rebind_symbols((struct rebinding[1]){{"unlink",  (void *)replaced_unlink, (void **)&orig_unlink}}, 1);
//
//
//    rebind_symbols((struct rebinding[1]){{"chdir",  (void *)replaced_chdir, (void **)&orig_chdir}}, 1);
//    rebind_symbols((struct rebinding[1]){{"chroot",  (void *)replaced_chroot, (void **)&orig_chroot}}, 1);
//    rebind_symbols((struct rebinding[1]){{"fork",  (void *)replaced_fork, (void **)&orig_fork}}, 1);
//    rebind_symbols((struct rebinding[1]){{"fchdir",  (void *)replaced_fchdir, (void **)&orig_fchdir}}, 1);
//    rebind_symbols((struct rebinding[1]){{"mknod",  (void *)replaced_mknod, (void **)&orig_mknod}}, 1);
//
//
//
//    rebind_symbols((struct rebinding[1]){{"fstat",  (void *)replaced_fstat, (void **)&orig_fstat}}, 1);
//    rebind_symbols((struct rebinding[1]){{"mkdir",  (void *)replaced_mkdir, (void **)&orig_mkdir}}, 1);
//    rebind_symbols((struct rebinding[1]){{"mkfifo",  (void *)replaced_mkfifo, (void **)&orig_mkfifo}}, 1);
//    rebind_symbols((struct rebinding[1]){{"exp2",  (void *)replaced_exp2, (void **)&orig_exp2}}, 1);
//    rebind_symbols((struct rebinding[1]){{"sprintf",  (void *)replaced_sprintf, (void **)&orig_sprintf}}, 1);
//
//
//
//    rebind_symbols((struct rebinding[1]){{"getegid",  (void *)replaced_getegid, (void **)&orig_getegid}}, 1);
//    rebind_symbols((struct rebinding[1]){{"geteuid",  (void *)replaced_geteuid, (void **)&orig_geteuid}}, 1);
//    rebind_symbols((struct rebinding[1]){{"getgid",  (void *)replaced_getgid, (void **)&orig_getgid}}, 1);
//    rebind_symbols((struct rebinding[1]){{"getppid",  (void *)replaced_getppid, (void **)&orig_getppid}}, 1);
//    rebind_symbols((struct rebinding[1]){{"getservbyport",  (void *)replaced_getservbyport, (void **)&orig_getservbyport}}, 1);
//
//
//
//    rebind_symbols((struct rebinding[1]){{"host_processor_info",  (void *)replaced_host_processor_info, (void **)&orig_host_processor_info}}, 1);
//    rebind_symbols((struct rebinding[1]){{"host_statistics",  (void *)replaced_host_statistics, (void **)&orig_host_statistics}}, 1);
//    rebind_symbols((struct rebinding[1]){{"hstrerror",  (void *)replaced_hstrerror, (void **)&orig_hstrerror}}, 1);
//    rebind_symbols((struct rebinding[1]){{"if_indextoname",  (void *)replaced_if_indextoname, (void **)&orig_if_indextoname}}, 1);
//    rebind_symbols((struct rebinding[1]){{"inet_addr",  (void *)replaced_inet_addr, (void **)&orig_inet_addr}}, 1);
//
//
//    rebind_symbols((struct rebinding[1]){{"inet_ntoa",  (void *)replaced_inet_ntoa, (void **)&orig_inet_ntoa}}, 1);
//    rebind_symbols((struct rebinding[1]){{"inet_ntop",  (void *)replaced_inet_ntop, (void **)&orig_inet_ntop}}, 1);
//    rebind_symbols((struct rebinding[1]){{"inet_pton",  (void *)replaced_inet_pton, (void **)&orig_inet_pton}}, 1);
//    rebind_symbols((struct rebinding[1]){{"ioctl",  (void *)replaced_ioctl, (void **)&orig_ioctl}}, 1);
//    rebind_symbols((struct rebinding[1]){{"isatty",  (void *)replaced_isatty, (void **)&orig_isatty}}, 1);
//
//
//    rebind_symbols((struct rebinding[1]){{"isatty",  (void *)replaced_isatty, (void **)&orig_isatty}}, 1);
//    rebind_symbols((struct rebinding[1]){{"kill",  (void *)replaced_kill, (void **)&orig_kill}}, 1);
//    rebind_symbols((struct rebinding[1]){{"memmove",  (void *)replaced_memmove, (void **)&orig_memmove}}, 1);
//    rebind_symbols((struct rebinding[1]){{"read",  (void *)replaced_read, (void **)&orig_read}}, 1);
//    rebind_symbols((struct rebinding[1]){{"realloc",  (void *)replaced_realloc, (void **)&orig_realloc}}, 1);
//
//
//    rebind_symbols((struct rebinding[1]){{"sendto",  (void *)replaced_sendto, (void **)&orig_sendto}}, 1);
//    rebind_symbols((struct rebinding[1]){{"sigaction",  (void *)replaced_sigaction, (void **)&orig_sigaction}}, 1);
//    rebind_symbols((struct rebinding[1]){{"socket",  (void *)replaced_socket, (void **)&orig_socket}}, 1);
//    rebind_symbols((struct rebinding[1]){{"sscanf",  (void *)replaced_sscanf, (void **)&orig_sscanf}}, 1);
//    rebind_symbols((struct rebinding[1]){{"strchr",  (void *)replaced_strchr, (void **)&orig_strchr}}, 1);
//
//
//    rebind_symbols((struct rebinding[1]){{"strcspn",  (void *)replaced_strcspn, (void **)&orig_strcspn}}, 1);
//    rebind_symbols((struct rebinding[1]){{"strstr",  (void *)replaced_strstr, (void **)&orig_strstr}}, 1);
//
//}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.

//    [ANYMethodLog logMethodWithClass:[NSFileManager class] condition:^BOOL(SEL sel) {
//        return YES;
//    } before:^(id target, SEL sel, NSArray *args, int deep) {
//        NSLog(@"UMConfigureCachetarget:%@ sel:%@", target, NSStringFromSelector(sel));
//    } after:nil];

//    [NetWorkInfoManager sharedManager];

//    [UMConfigure initWithAppkey:@"60bd82994d0228352bbdbaaf" channel:@"App Store"];
//    [UMConfigure initWithAppkey:@"60c31214e044530ff0a1cc2f" channel:@"App Store"];
//    [UMConfigure initWithAppkey:@"60d00bff8a102159db7183ba" channel:@"App Store"];

// 值测试路劲而已 11 点55 大量启动
//    [UMConfigure initWithAppkey:@"60bb27a14d0228352bbcd731" channel:@"App Store"];
    //测试 所有的
//    [UMConfigure initWithAppkey:@"60d013a126a57f10182f3cbe" channel:@"App Store"];

    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    NSMutableDictionary *options = [NSMutableDictionary dictionary];

    /*
     * SDK具有防调试功能，当使用xcode运行时(开发测试阶段),请取消下面代码注释，
     * 开启调试模式,否则使用xcode运行会闪退。上架打包的时候需要删除或者注释掉这
     * 行代码,如果检测到调试行为就会触发crash,起到对APP的保护作用
     */

    [options setValue:@"allowd" forKey:@"allowd"];  // TODO
//    [options setValue:@"sandbox" forKey:@"env"];
    [options setValue:@"sandbox" forKey:@"product"];

    [options setValue:@"noLocation" forKey:@"noLocation"]; //
    [options setValue:@"youju" forKey:@"partner"];

    [options setObject:^(NSString *blackBox){
        //添加你的回调逻辑
        printf("同盾设备指纹,回调函数获取到的blackBox:%s\n",[blackBox UTF8String]);
//        [self getDeviceInfoWithblackBox:blackBox];

    } forKey:@"callback"];
    //设置超时时间(单位:秒)
    [options setValue:@"6" forKey:@"timeLimit"];
    // 使用上述参数进行SDK初始化
    manager->initWithOptions(options);
    return YES;
}
-(void)test{
   NSString *homePaht =  [[WHCFileManager homeDir] stringByAppendingFormat:@"tesss"];
    [testArray writeToFile:homePaht atomically:YES];

}

-(void)getDeviceInfoWithblackBox:(NSString *)info{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];   // 请求JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // 响应JSON格式

    [manager.requestSerializer setValue:@"application/json;UTF-8" forHTTPHeaderField:@"Content-Type"];

//    NSString *url = [NSString stringWithFormat:@"http://114.116.231.177:8091/no/fraudApiInvoker/checkFraud?blackBox=%@&type=2",info];
    NSString *url = [NSString stringWithFormat:@"http://114.116.231.177:8091/no/fraudApiInvoker/checkFraud?"];
    NSDictionary *parameters = @{@"blackBox":info,
                                 @"type": @"2"};
    [manager GET:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功：%@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    // 获取各种数据
    NSMutableData *sendData = [[NSMutableData alloc] initWithData:deviceToken];
    int32_t checksum = [deviceToken crc32];
    int32_t swapped = CFSwapInt32LittleToHost(checksum);
    char *a = (char*) &swapped;
    [sendData appendBytes:a length:sizeof(4)];

    //检验
    //    Byte *b1 = (Byte *)[sendData bytes];
    //    for (int i = 0; i < sendData.length; i++) {
    //        NSLog(@"b1[%d] == %d",i,b1[i]);
    //    }
    NSString *device_token_crc32 = [sendData base64EncodedStringWithOptions:0];
    //    NSLog(@"b1:%@",[sendData base64EncodedStringWithOptions:0]);
    //保存获取到的数据
    NSString *device_token = [NSString stringWithFormat:@"%@",deviceToken];
    [[NSUserDefaults standardUserDefaults]setObject:device_token forKey:@"device_token"];
    [[NSUserDefaults standardUserDefaults]setObject:device_token_crc32 forKey:@"device_token_crc32"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    //    NSLog(@"deviceToken---------------》%@", deviceToken);
    //    NSLog(@"device_token--------------》%@", device_token);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
