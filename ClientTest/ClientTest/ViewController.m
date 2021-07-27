//
//  ViewController.m
//  ClientTest
//
//  Created by 王鹏飞 on 16/7/1.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "ViewController.h"
#import "fishhook.h"
//#import "BasicViewController.h"
//#import "NetWorkInfoManager.h"
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
@interface ViewController ()

@end
NSMutableArray *testArray;
@implementation ViewController

int  (*orig_stat)(const char *path ,struct stat *info);
static  int replaced_stat(const char *path ,struct stat *info){
    NSLog(@"GGGGGGGGGGGGGfff orig_stat %s",path);
    [testArray addObject:[NSString stringWithFormat:@"orig_stat %s",path]];
    return orig_stat(path,info);
}


int (*orig_lstat)(const char *pathname,struct stat buf);
static  int replaced_lstat(const char *path ,struct stat *info){
    NSLog(@"GGGGGGGGGGGGGfff orig_lstat %s",path);
    [testArray addObject:[NSString stringWithFormat:@"orig_lstat %s",path]];
    return orig_stat(path,info);
}

FILE    (*orig_fopen)(const char *filename, const char * mode);

static  FILE replaced_fopen(const char *path ,struct stat *info){
    NSLog(@"GGGGGGGGGGGGGfff replaced_fopen %s",path);
    [testArray addObject:[NSString stringWithFormat:@"replaced_fopen %s",path]];

    return orig_fopen(path,(char *)info);
}

int  (*orig_fgetc)(FILE *);
static  int replaced_fgetc(FILE *name){
    NSLog(@"GGGGGGGGGGGGGfff replaced_fgetc %@",name);
//    [testArray addObject:[NSString stringWithFormat:@"replaced_fgetc %s",path]];

    return orig_fgetc(name);
}


int  (*orig_fgets)(char * , int, FILE *);
static  int replaced_fgets(char * st , int t , FILE *name){
    NSLog(@"GGGGGGGGGGGGGfff replaced_fgets %@",name);
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
    NSLog(@"GGGGGGGGGGGGGfff replaced_open %s",filename);
    [testArray addObject:[NSString stringWithFormat:@"replaced_open %s",filename]];

    return orig_open(filename,le);
}

int    (*orig_chown)(const char *, uid_t, gid_t);
static  int replaced_chown(const char *path, uid_t uid, gid_t gid){
    NSLog(@"GGGGGGGGGGGGGfff replaced_open %s",path);
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
    [testArray addObject:[NSString stringWithFormat:@"replaced_memmove %zu",len]];
    return orig_memmove(dst,src,len);
}

ssize_t     (*orig_read)(int, void *, size_t) ;
static  ssize_t replaced_read(int t, void * v, size_t le){
    [testArray addObject:[NSString stringWithFormat:@"replaced_read %zu",le]];
    return orig_read(t,v,le);
}

void    *(*orig_realloc)(void *__ptr, size_t __size);
static  void *replaced_realloc(void *ptr, size_t le){
    [testArray addObject:[NSString stringWithFormat:@"replaced_realloc %zu",le]];
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


//mac 无力地址相关
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












+(void)load{
    rebind_symbols((struct rebinding[1]){{"stat",  (void *)replaced_stat, (void **)&orig_stat}}, 1);
    rebind_symbols((struct rebinding[1]){{"lstat",  (void *)replaced_lstat, (void **)&orig_lstat}}, 1);
    rebind_symbols((struct rebinding[1]){{"fopen",  (void *)replaced_fopen, (void **)&orig_fopen}}, 1);
    rebind_symbols((struct rebinding[1]){{"fgets",  (void *)replaced_fgetc, (void **)&orig_fgetc}}, 1);
    rebind_symbols((struct rebinding[1]){{"fgetc",  (void *)replaced_fgets, (void **)&orig_fgets}}, 1);
    testArray = [NSMutableArray new];
}



- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Event Response
- (IBAction)hardWareInfoButtonTapped:(id)sender {
//    [self _pushVCWithType:BasicInfoTypeHardWare sender:sender];
}

- (IBAction)batteryInfoButtonTapped:(id)sender {
//    [self _pushVCWithType:BasicInfoTypeBattery sender:sender];
}

- (IBAction)addressInfoButtonTapped:(id)sender {
//    [self _pushVCWithType:BasicInfoTypeIpAddress sender:sender];
}

- (IBAction)CPUInfoButtonTapped:(id)sender {
//    [self _pushVCWithType:BasicInfoTypeCPU sender:sender];
}

- (IBAction)diskInfoButtonTapped:(id)sender {
//    [self _pushVCWithType:BasicInfoTypeDisk sender:sender];
}

- (IBAction)jsbrokenTap:(id)sender {
//    [self _pushVCWithType:BasicInfoTypeBroken sender:sender];
}


//- (void)_pushVCWithType:(BasicInfoType)type sender:(UIButton *)sender {
//    BasicViewController *basicVC = [[BasicViewController alloc] initWithType:type];
//    basicVC.navigationItem.title = sender.titleLabel.text;
//    [self.navigationController pushViewController:basicVC  animated:YES];
//}

@end
