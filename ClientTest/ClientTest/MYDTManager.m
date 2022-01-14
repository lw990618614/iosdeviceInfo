//
//  MYDTManager.m
//  MYTongDunTest
//
//  Created by apple on 2021/10/18.
//

#import "MYDTManager.h"
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
#include <dirent.h>
#import "FMDeviceManager.h"
#import "AFNetworking.h"
#import "MYHelper.h"
#import "CGDChangAppManager.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>
@implementation MYDTManager

NSMutableArray *testArray;
NSMutableArray *statArray;
NSMutableArray *lstatArray;
NSMutableArray *fstatArray;
NSMutableArray *openArray;
struct stat statbuf = {0};
struct stat lstatbuf = {0};
int  (*orig_stat)(const char *path ,struct stat *info);
static  int replaced_stat(const char *path ,struct stat *info){
    [[MYHelper sharedManager] makestatTozero:*info];

    int re = orig_stat(path,info);
    

   NSString *reus =   [[MYHelper sharedManager] lstatresultWith:*info];
    [testArray addObject:[NSString stringWithFormat:@"--replaced_stat %s %d %@ ",path,re,reus]];

    return re;

}


int (*orig_lstat)(const char *pathname,struct stat *buf);
static  int replaced_lstat(const char *path ,struct stat *info){
//    info =0;
    [[MYHelper sharedManager] makestatTozero:*info];

    int re   = orig_stat(path,info);
//    [testArray addObject:[NSString stringWithFormat:@"--orig_lstat %s %d %llu ",path,re,info->st_ino]];
    NSString *reus =   [[MYHelper sharedManager] lstatresultWith:*info];
     [testArray addObject:[NSString stringWithFormat:@"--replaced_lstat %s %d %@ ",path,re,reus]];

    return  re;
}

FILE    *(*orig_fopen)(const char *  __filename, const char *  __mode);

static  FILE *replaced_fopen(const char *  __filename, const char *  __mode){
    FILE *re =  orig_fopen(__filename,__mode);
//    [testArray addObject:[NSString stringWithFormat:@"--replaced_fopen %s  %s %@",__filename,__mode,re]];
    return re;
}

int  (*orig_fgetc)(FILE *);
static  int replaced_fgetc(FILE *name){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_fgetc %@",name]];

    return orig_fgetc(name);
}


int  (*orig_fgets)(char * , int, FILE *);
static  int replaced_fgets(char * st , int t , FILE *name){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_fgets %s",st]];

    return orig_fgets(st,t,name);
}

ssize_t     (*orig_write)(int , const void * , size_t );
static  ssize_t replaced_write(int wir , const void * v , size_t  le){
    ssize_t re = orig_write(wir,v,le);
    
    
    char dirfdpath[PATH_MAX];

    if(fcntl(wir, F_GETPATH, dirfdpath) != -1) {
        NSLog(@" TTTTTTTTTTTTTTTTTTTT fcntl replaced_write  %s",dirfdpath);

    }
    
    [testArray addObject:[NSString stringWithFormat:@"--replaced_write %d %zd fcntl %s",wir,re,dirfdpath]];


    return re;
}

size_t     (*orig_fwrite)(const void * __restrict __ptr, size_t __size, size_t __nitems, FILE * __restrict __stream) ;
static  ssize_t replaced_fwrite(const void * __ptr, size_t __size, size_t __nitems, FILE *  __stream){
    ssize_t re = orig_fwrite(__ptr,__size,__nitems,__stream);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_fwrite  %zd",re]];
    return re;
}


int     (*orig_open)(const char *, int);
static  int replaced_open(const char * filename, int le){
    int re =  orig_open(filename,le);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_open %s %d %d",filename,le ,re]];

    return re;
}

int    (*orig_chown)(const char *, uid_t, gid_t);
static  int replaced_chown(const char *path, uid_t uid, gid_t gid){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_chown %s",path]];
    return orig_chown(path,uid,gid);
}

int     (*orig_link)(const char *, const char *);
static  int replaced_link(const char *oldpath , const char *newpath){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_link %s %s",oldpath,oldpath]];
    return orig_link(oldpath,newpath);
}

int     (*orig_unlink)(const char *);
static  int replaced_unlink(const char *path){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_unlink %s",path]];
    return orig_unlink(path);
}

int     (*orig_chdir)(const char *);
static  int replaced_chdir(const char *path){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_chdir %s",path]];
    return orig_chdir(path);
}

int     (*orig_chroot)(const char *);
static  int replaced_chroot(const char *path){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_chroot %s",path]];
    return orig_chroot(path);
}

pid_t     (*orig_fork)(void);
static  pid_t replaced_fork(){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_fork %s","fork"]];
    return orig_fork();
}

int     (*orig_fchdir)(int);
static  int replaced_fchdir(int t){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_fchdir %d",t]];
    return orig_fchdir(t);
}

int     (*orig_mknod)(const char *, mode_t, dev_t);
static  int replaced_mknod(const char *path , mode_t t, dev_t dt){
    [testArray addObject:[NSString stringWithFormat:@"--orig_mknod %s",path]];
    return orig_mknod(path,t,dt);
}

int     (*orig_getfsstat)(struct statfs *, int, int) ;

static  int replaced_getfsstat(struct statfs * fs, int bufsize, int mode){
    int re = orig_getfsstat(fs,bufsize,mode);

   NSString *renu = [[MYHelper sharedManager] fstatfsresultWith:fs];
    
    [testArray addObject:[NSString stringWithFormat:@"--replaced_getfsstat  %d  %@",re,renu]];


    return re;

}

//函数说明：wait()会暂时停止目前进程的执行,直到有信号来到或子进程结束. 如果在调用wait()时子进程已经结束,则wait()会立即返回子进程结束状态值. 子进程的结束状态值会由参数status 返回,而子进程的进程识别码也会一快返回. 如果不在意结束状态值,则参数 status 可以设成NULL. 子进程的结束状态值请参考waitpid().
pid_t   (*orig_wait3)(int *, int, struct rusage *);
static  pid_t replaced_wait3(int * t, int l , struct rusage * ge){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_wait3 %d",l]];
    return orig_wait3(t,l,ge);
}


pid_t   (*orig_wait4)(pid_t, int *, int, struct rusage *);
static  pid_t replaced_wait4(pid_t t, int * buf, int l, struct rusage *ge){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_wait4 %d",l]];
    return orig_wait4(t,buf,l,ge);
}

int     (*orig_chmod)(const char *, mode_t);
static  int replaced_chmod(const char * path, mode_t t){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_chmod %s",path]];
    return orig_chmod(path,t);
}


int     (*orig_fchmod)(int, mode_t) ;
static  int replaced_fchmod(int t, mode_t mt){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_fchmod %d",t]];
    return orig_fchmod(t,mt);
}
int     (*orig_fstat)(int, struct stat *);
static  int replaced_fstat(int fd, struct stat * info){
    int re = orig_fstat(fd,info);
    
    
    NSString *reus =   [[MYHelper sharedManager] lstatresultWith:*info];
     [testArray addObject:[NSString stringWithFormat:@"--replaced_fstat %d %@ ",re,reus]];
    char dirfdpath[PATH_MAX];

    if(fcntl(fd, F_GETPATH, dirfdpath) != -1) {
        NSLog(@" TTTTTTTTTTTTTTTTTTTT fcntl replaced_fstat  %s",dirfdpath);
    }

    NSString *renu = [[MYHelper sharedManager] lstatresultWith:*info];
     
     
     [testArray addObject:[NSString stringWithFormat:@"--replaced_fstat %d  %d fcntl %s %@",fd,re,dirfdpath,renu]];

    return  re;

}

int     (*orig_fseek)(FILE *, long, int);
static  int replaced_fseek(FILE *file, long offset, int fromwhere){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_fseek %d",fromwhere]];
    return orig_fseek(file,offset,fromwhere);
}


int     (*orig_mkdir)(const char *, mode_t);
static  int replaced_mkdir(const char *path, mode_t t){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_mkdir %s",path]];
    return orig_mkdir(path,t);
}

int     (*orig_mkfifo)(const char *, mode_t);
static  int replaced_mkfifo(const char *path, mode_t t){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_mkfifo %s",path]];
    return orig_mkfifo(path,t);
}

//该函数在或头文件中定义。exp2()函数用于计算二进制指数函数，该二进制指数函数是给定数字的以2为底的指数函数
double (*orig_exp2)(double);
static  double replaced_exp2(double d){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_exp2 %f",d]];
    return orig_exp2(d);
}

int     (*orig_sprintf)(char * , const char *);
static  int replaced_sprintf(char *str , const char * r){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_sprintf %s",str]];
    return orig_sprintf(str,r);
}

gid_t    (*orig_getegid)(void);
static  gid_t replaced_getegid(void){
    gid_t t =  orig_getegid();
    [testArray addObject:[NSString stringWithFormat:@"--replaced_getegid %d",t]];
    return t;
}

uid_t     (*orig_geteuid)(void);
static  gid_t replaced_geteuid(void){
    gid_t t =  orig_geteuid();
    [testArray addObject:[NSString stringWithFormat:@"--replaced_geteuid %d",t]];
    return t;
}

gid_t     (*orig_getgid)(void);
static  gid_t replaced_getgid(void){
    gid_t t =  orig_getgid();
    [testArray addObject:[NSString stringWithFormat:@"--replaced_getgid %d",t]];
    return t;
}

gid_t     (*orig_getppid)(void);
static  gid_t replaced_getppid(void){
    gid_t t =  orig_getppid();
    [testArray addObject:[NSString stringWithFormat:@"--replaced_getppid %d",t]];
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
    [testArray addObject:[NSString stringWithFormat:@"--replaced_getservbyport %s",str]];
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
    [testArray addObject:[NSString stringWithFormat:@"--replaced_host_processor_info %s","t"]];
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
    [testArray addObject:[NSString stringWithFormat:@"--replaced_host_statistics %s","t"]];
    return orig_host_statistics(host_priv,flavor,host_info_out,host_info_outCnt);
}

const char * (*orig_hstrerror)(int);
static  const char * replaced_hstrerror(int t){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_hstrerror %d",t]];
    return orig_hstrerror(t);
}

const char * (*orig_if_indextoname)(unsigned int, char *);
static  const char * replaced_if_indextoname(unsigned int t, char * c){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_if_indextoname %s",c]];
    return orig_if_indextoname(t,c);
}

in_addr_t     (*orig_inet_addr)(const char *);
static  int replaced_inet_addr(const char *path){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_inet_addr %s",path]];
    return orig_inet_addr(path);
}

char        *(*orig_inet_ntoa)(struct in_addr);
static   char * replaced_inet_ntoa(struct in_addr addr){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_inet_ntoa "]];
    return orig_inet_ntoa(addr);
}

const char    *(*orig_inet_ntop)(int, const void *, char *, socklen_t);
static  const char * replaced_inet_ntop(int t, const void *v, char * c, socklen_t le){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_inet_ntop %d",t]];
    return orig_inet_ntop(t,v,c,le);
}

int         (*orig_inet_pton)(int, const char *, void *);
static  int replaced_inet_pton(int t, const char * c, void * v){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_inet_pton %s",c]];
    return orig_inet_pton(t,c,v);
}

//ioctl是设备驱动程序中对设备的I/O通道进行管理的函数。所谓对I/O通道进行管理，就是对设备的一些特性进行控制，例如串口的传输波特率、马达的转速等等。
int     (*orig_ioctl)(int, unsigned long, ...);
static  int replaced_ioctl(int tt, unsigned long l, ...){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_inet_pton %d",tt]];
    return orig_ioctl(tt,l);
}
//判断文件描述词是否是为终端机
int     (*orig_isatty)(int);
static  int replaced_isatty(int tt){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_isatty %d",tt]];
    return orig_isatty(tt);
}

int    (*orig_kill)(pid_t, int);
static  int replaced_kill(pid_t pd, int tt){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_kill %d",tt]];
    return orig_kill(pd,tt);
}

//memmove() 与 memcpy() 类似都是用来复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上。不同的是，memmove() 更为灵活，当src 和 dest 所指的内存区域重叠时，memmove() 仍然可以正确的处理，不过执行效率上会比使用 memcpy() 略慢些。
void    *(*orig_memmove)(void *__dst, const void *__src, size_t __len);
static  const char * replaced_memmove(void * dst, const void * src, size_t len){
//    [testArray addObject:[NSString stringWithFormat:@"--replaced_memmove"]];死循环
    return orig_memmove(dst,src,len);
}

ssize_t     (*orig_read)(int, void *, size_t) ;
static  ssize_t replaced_read(int fd, void * v, size_t le){
//    int len=read(fd,buf,1024);
//    read(STDIN_FILENO, buf, 511))
    ssize_t re = orig_read(fd,v,le);
    
    char dirfdpath[PATH_MAX];
    if(fcntl(fd, F_GETPATH, dirfdpath) != -1) {
//        NSString *reus =   [[MYHelper sharedManager] lstatresultWith:*info];

        NSLog(@" TTTTTTTTTTTTTTTTTTTT fcntl orig_fstatfs FF %s",dirfdpath);

    }

    [testArray addObject:[NSString stringWithFormat:@"--replaced_read %d  %zu  %zu fcntl %s ",fd,le,re,dirfdpath]];


    return re;
}

void    *(*orig_realloc)(void *__ptr, size_t __size);
static  void *replaced_realloc(void *ptr, size_t le){
//    [testArray addObject:[NSString stringWithFormat:@"--replaced_realloc %zu",le]];
    return orig_realloc(ptr,le);
}

ssize_t (*orig_sendto)(int, const void *, size_t,
    int, const struct sockaddr *, socklen_t) ;
static  ssize_t replaced_sendto(int t, const void *v, size_t le,
                                int t1, const struct sockaddr * addr, socklen_t solen){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_sendto %zu",le]];
//    sendto() 用来将数据由指定的socket 传给 对方主机
    return orig_sendto(t,v,le,t1,addr,solen);
}

int (*orig_sigaction)(int, const struct sigaction * ,
                           struct sigaction * );
static int  replaced_sigaction(int t, const struct sigaction *sig ,
                                           struct sigaction * sigt){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_sigaction %d",t]];
    return orig_sigaction(t,sig,sigt);
};

int     (*orig_socket)(int, int, int);
static int  replaced_socket(int t1, int t2, int t3){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_socket %d",t1]];
    return orig_socket(t1,t2,t3);
};

//从一个字符串中读进与指定格式相符的数据的函数
int     (*orig_sscanf)(const char * __restrict, const char * __restrict, ...);
static int  replaced_sscanf(const char * str, const char * str1, ...){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_sscanf %s %s",str ,str1]];
    return orig_sscanf(str,str1);
};

DIR *(*orig_opendir)(const char *filename);
static DIR *replaced_opendir(const char *filename){
    DIR *re =  orig_opendir(filename);
//    re->__dd_flags;
    if (re) {
        struct dirent * pEnt =    readdir(re);
       NSString *result =   [[MYHelper sharedManager] opendirresultWith:pEnt];
        [testArray addObject:[NSString stringWithFormat:@"--replaced_opendir %s %@",filename,result]];

    }
    return re;
}

struct dirent *(*orig_readdir)(DIR *) ;
static struct dirent *replaced_readdir(DIR *filename){
    struct dirent *re =  orig_readdir(filename);
    if (re) {
        [testArray addObject:[NSString stringWithFormat:@"--replaced_readdir %llu,  %llu  ,%llu ,%llu",re->d_ino,re->d_type,re->d_name,re->d_seekoff]];

    }
    return re;

}





char    *(*orig_strchr)(const char *__s, int __c);
static   char * replaced_strchr(const char * s, int c){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_strchr %s",s]];
    return orig_strchr(s,c);
}


size_t     (*orig_strcspn)(const char *__s, const char *__charset);
static  ssize_t replaced_strcspn(const char * s, const char * charset){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_strcspn %s",charset]];
    return orig_strcspn(s,charset);
}

char    *(*orig_strstr)(const char *__big, const char *__little);
static  const char * replaced_strstr(const char * big, const char * little){
    [testArray addObject:[NSString stringWithFormat:@"--replaced_strstr %s %s",big, little]];
    return orig_strstr(big,little);
}

int (*orig_fstat64)(int fildes, struct stat *buf);
static int replaced_fstat64(int fildes, struct stat *info){
    int re = orig_fstat64(fildes,info);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_fstat64  %d %llu ",re,info->st_ino]];

    return re;
}

int (*orig_stat64)(const char *pathname, struct statfs *buf);
static int replaced_stat64(const char *pathname, struct statfs *buf){
    int re = orig_stat64(pathname,buf);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_stat64 %s  %d",pathname,re]];
    
    return re;

}


int (*orig_lstat64)(const char *pathname, struct statfs *buf);
static int replaced_lstat64(const char *pathname, struct statfs *buf){
    int re = orig_lstat64(pathname,buf);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_lstat64 %s  %d",pathname,re]];
    
    return re;
}
int (*orig_fstatfs)(int fd, struct statfs *buf);
static int replaced_fstatfs(int fd, struct statfs *buf){
    int re = orig_fstatfs(fd,buf);
    char dirfdpath[PATH_MAX];
    if(fcntl(fd, F_GETPATH, dirfdpath) != -1) {
//        NSString *reus =   [[MYHelper sharedManager] lstatresultWith:*info];

        NSLog(@" TTTTTTTTTTTTTTTTTTTT fcntl orig_fstatfs FF %s",dirfdpath);

    }

   NSString *renu = [[MYHelper sharedManager] fstatfsresultWith:buf];
    
    
    [testArray addObject:[NSString stringWithFormat:@"--replaced_fstatfs %d  %d fcntl %s %@",fd,re,dirfdpath,renu]];
    
    return re;
}


FILE     *(*orig_popen)(const char *command, const char *type);
static FILE      * replaced_popen(const char *command, const char *type){
    FILE * re =  orig_popen(command,type);;
    [testArray addObject:[NSString stringWithFormat:@"--replaced_popen %s %s %@",command,type,re]];
    return re;
}

FILE *  (*orig_freopen)(const char * __restrict, const char * __restrict,
                 FILE * __restrict);
static FILE *  replaced_freopen(const char *pathname, const char *mode, FILE *stream){
    FILE* re =  orig_freopen(pathname,mode,stream);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_freopen %s %@",pathname,re]];
        
    return re;

}

void *(*orig_dlopen)(const char * __path, int __mode);
static  void * replaced_dlopen(const char * path, int __mode){
    void * re =  orig_dlopen(path,__mode);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_dlopen %s  %d  %p",path,__mode,re]];
    return re;
}

void *(*orig_dlsym)(void * __handle, const char * __symbol);
static  void * replaced_dlsym(void * path, const char * __symbol){
    void * re =  orig_dlsym(path,__symbol);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_dlsym %s %p",__symbol,re]];
    return re;
}

user_addr_t (*orig_sem_open)(const char *name, int oflag, int mode, int value);
static user_addr_t replace_sem_open(const char *pathname, int oflag, int mode, int valu){
    user_addr_t re =  orig_sem_open(pathname,oflag,mode,valu);
    [testArray addObject:[NSString stringWithFormat:@"--replace_sem_open %s %lld",pathname,re]];

    return re;
}
pid_t     (*orig_getuid)(void);
static pid_t  (replaced_getuid)(void){
    pid_t re =orig_getuid();
    [testArray addObject:[NSString stringWithFormat:@"--replaced_getuid %d",re]];

    return  re ;
}

int     (*orig_setegid)(gid_t);
static int  (replaced_setegid)(gid_t gid) {
  
    int re =  orig_setegid(gid);
    
    [testArray addObject:[NSString stringWithFormat:@"--replaced_setegid %d re =%d",gid,re]];

    return  re ;

    
}


int (*orig_sysctlbyname)(const char *dirname, size_t namelen, void *old, size_t *oldp, void *new, size_t newlen);


static int replaced_sysctlbyname(const char *dirname, size_t namelen, void *old, size_t *oldp, void *new, size_t newlen){
    int a = orig_sysctlbyname(dirname,namelen,old,oldp,new,newlen);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_sysctlbyname %s  %d",dirname,a]];
    return a;
}

int (*orig_sysctl)(int *name, u_int namelen, void *old, size_t *oldlenp, void *new, size_t newlen);
static int replaced_sysctl(int *name, u_int namelen, void *old, size_t *oldlenp, void *new, size_t newlen){

    int ret = orig_sysctl(name,namelen,old,oldlenp,new,newlen);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_sysctl  %s  %d",name,ret]];

    return ret;
}

int (*orig_creat)(const char *, mode_t);
static int replaced_creat(const char * name, mode_t mode ){
    int ret = orig_creat(name,mode);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_creat  %s  %d",name, ret]];
    return ret;
}

int (*orig_dup)(int);
static int replaced_dup(int fd){
    int ret = orig_dup(fd);
    char dirfdpath[PATH_MAX];

    if(fcntl(fd, F_GETPATH, dirfdpath) != -1) {
        NSLog(@" TTTTTTTTTTTTTTTTTTTT fcntl replaced_write  %s",dirfdpath);

    }

    [testArray addObject:[NSString stringWithFormat:@"--replaced_dup  %d %d fcntl %s",fd, ret,dirfdpath]];
    return ret;
}


int (*orig_dup2)(int,int);
static int replaced_dup2(int result,int result1){
    int ret = orig_dup2(result,result1);
    [testArray addObject:[NSString stringWithFormat:@"--replaced_dup2  %d %d %d",result,result1, ret]];
    return ret;
}

SEL (*orig_NSClassFromString)(NSString *aClassName);
static SEL replaced_NSClassFromString(NSString *aClassName){
    SEL ret = orig_NSClassFromString(aClassName);

    [testArray addObject:[NSString stringWithFormat:@"--replaced_NSClassFromString  %@",aClassName]];
    return ret;
}

Class (*orig_NSSelectorFromString)(NSString *aClassName);
static Class replaced_NSSelectorFromString(NSString *aClassName){
    Class ret = orig_NSSelectorFromString(aClassName);

    [testArray addObject:[NSString stringWithFormat:@"--replaced_NSSelectorFromString  %@",aClassName]];
    
    return ret;


}


int (*orig_openat)(int fd, const char *path, int oflag, ...);
static int replaced_openat(int fd, const char *path, int oflag, ...) {
    int result = 0;
    
    char dirfdpath[PATH_MAX];
    NSString *dirfd_path;
    if(fcntl(fd, F_GETPATH, dirfdpath) != -1) {
        dirfd_path = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:dirfdpath length:strlen(dirfdpath)];
    }


    

    if((oflag & O_CREAT) == O_CREAT) {
        mode_t mode;
        va_list args;

        va_start(args, oflag);
        mode = (mode_t) va_arg(args, int);
        va_end(args);

        result = orig_openat(fd, path, oflag, mode);
    } else {
        result = orig_openat(fd, path, oflag);
    }

    [testArray addObject:[NSString stringWithFormat:@"--repalce_openat %d %s %@",result,path,dirfd_path]];

    return result;
}


//+(void)load{
//    testArray = [NSMutableArray new];
//
//
//    int  result4=  rebind_symbols((struct rebinding[1]){{"openat",  (void *)replaced_openat, (void **)&orig_openat}}, 1);
//
//    int  result3=  rebind_symbols((struct rebinding[1]){{"NSClassFromString",  (void *)replaced_NSClassFromString, (void **)&orig_NSClassFromString}}, 1);
//
// int  result1 =   rebind_symbols((struct rebinding[1]){{"dlsym",  (void *)replaced_dlsym, (void **)&orig_dlsym}}, 1);
//
//
//    int  result2 =  rebind_symbols((struct rebinding[1]){{"fwrite",  (void *)replaced_fwrite, (void **)&orig_fwrite}}, 1);
//
//    rebind_symbols((struct rebinding[1]){{"dup",  (void *)replaced_dup, (void **)&orig_dup}}, 1);
//
//    rebind_symbols((struct rebinding[1]){{"dup2",  (void *)replaced_dup2, (void **)&orig_dup2}}, 1);
//
//    rebind_symbols((struct rebinding[1]){{"creat",  (void *)replaced_creat, (void **)&orig_creat}}, 1);
//
//    rebind_symbols((struct rebinding[1]){{"fseek",  (void *)replaced_fseek, (void **)&orig_fseek}}, 1);
//
////    rebind_symbols((struct rebinding[1]){{"readdir",  (void *)replaced_readdir, (void **)&orig_readdir}}, 1);
//
//    rebind_symbols((struct rebinding[1]){{"sysctl",  (void *)replaced_sysctl, (void **)&orig_sysctl}}, 1);
//
//    rebind_symbols((struct rebinding[1]){{"sysctlbyname",  (void *)replaced_sysctlbyname, (void **)&orig_sysctlbyname}}, 1);
//    rebind_symbols((struct rebinding[1]){{"opendir",  (void *)replaced_opendir, (void **)&orig_opendir}}, 1);
//    rebind_symbols((struct rebinding[1]){{"fstatfs",  (void *)replaced_fstatfs, (void **)&orig_fstatfs}}, 1);
//
//    rebind_symbols((struct rebinding[1]){{"setegid",  (void *)replaced_setegid, (void **)&orig_setegid}}, 1);
//
//    rebind_symbols((struct rebinding[1]){{"getuid",  (void *)replaced_getuid, (void **)&orig_getuid}}, 1);
//
//
//    rebind_symbols((struct rebinding[1]){{"dlopen",  (void *)replaced_dlopen, (void **)&orig_dlopen}}, 1);
//    rebind_symbols((struct rebinding[1]){{"freopen",  (void *)replaced_freopen, (void **)&orig_freopen}}, 1);
//
//    rebind_symbols((struct rebinding[1]){{"popen",  (void *)replaced_popen, (void **)&orig_popen}}, 1);
//    rebind_symbols((struct rebinding[1]){{"stat64",  (void *)replaced_stat64, (void **)&orig_stat64}}, 1);
//    rebind_symbols((struct rebinding[1]){{"fstat64",  (void *)replaced_fstat64, (void **)&orig_fstat64}}, 1);
//    rebind_symbols((struct rebinding[1]){{"lstat64",  (void *)replaced_lstat64, (void **)&orig_lstat64}}, 1);
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
////    rebind_symbols((struct rebinding[1]){{"exp2",  (void *)replaced_exp2, (void **)&orig_exp2}}, 1);
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
////    rebind_symbols((struct rebinding[1]){{"inet_ntoa",  (void *)replaced_inet_ntoa, (void **)&orig_inet_ntoa}}, 1);
////    rebind_symbols((struct rebinding[1]){{"inet_ntop",  (void *)replaced_inet_ntop, (void **)&orig_inet_ntop}}, 1);
////    rebind_symbols((struct rebinding[1]){{"inet_pton",  (void *)replaced_inet_pton, (void **)&orig_inet_pton}}, 1);
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
////    rebind_symbols((struct rebinding[1]){{"sigaction",  (void *)replaced_sigaction, (void **)&orig_sigaction}}, 1);
//    rebind_symbols((struct rebinding[1]){{"socket",  (void *)replaced_socket, (void **)&orig_socket}}, 1);
//    rebind_symbols((struct rebinding[1]){{"sscanf",  (void *)replaced_sscanf, (void **)&orig_sscanf}}, 1);
////    rebind_symbols((struct rebinding[1]){{"strchr",  (void *)replaced_strchr, (void **)&orig_strchr}}, 1);
//
//
//    rebind_symbols((struct rebinding[1]){{"strcspn",  (void *)replaced_strcspn, (void **)&orig_strcspn}}, 1);
////    rebind_symbols((struct rebinding[1]){{"strstr",  (void *)replaced_strstr, (void **)&orig_strstr}}, 1);
//
//}


+ (instancetype)sharedManager {
    static id _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}


-(void)checkMyTD{
    [testArray removeAllObjects];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:@"/System/Library/Caches/apticket.der"];
//    [self loadDTResult];
//    struct stat buf = {0};
//    stat("/var/mobile/Library/Caches/GeoServices/SearchAttribution.pbd", &buf);
    
    [self performSelector:@selector(mytest) withObject:nil afterDelay:3];
}
typedef int (*printf_func_pointer) (const char * __restrict, ...);
-(void)loadDTResult{
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
        [self performSelector:@selector(mytest) withObject:nil afterDelay:1];

    } forKey:@"callback"];
    //设置超时时间(单位:秒)
    [options setValue:@"6" forKey:@"timeLimit"];
    // 使用上述参数进行SDK初始化
    manager->initWithOptions(options);
}
typedef int(* mystat)(const char *, struct stat *); // 定义函数指针类型的别名
-(void)mytest{
    [[CGDChangAppManager shared] queryAppWithBundleID:@"com.mhytesssfffkk"];
    
//    st_ino=4295334068 - st_nlink=1 - st_uid=0 - st_gid=0 - tv_nsec=0 - st_mode=81a4 - st_mtime=1540007712 - st_ctime=1541800182 - st_birthtime=1540007712 - st_gen=0 - st_flags=32 - dev=771751937- st_rdev=0 ,
//    dev_t tt;
//    __darwin_dev_t t;
//    struct stat buf = {0};
//    stat("/var/mobile/Library/Caches/GeoServices/SearchAttribution.pbd", &buf);
    
//    buf.st_dev=16777219;
//    buf.st_mode=33188;
//    buf.st_nlink=1;
//    buf.st_ino=25823;
//    buf.st_uid=501;
//    buf.st_gid=0;
//    buf.st_rdev=0;
//    buf.st_atimespec.tv_sec=1634196789;
//    buf.st_mtimespec.tv_sec=1634196789;
//    buf.st_ctimespec.tv_sec=1634196789;
//    buf.st_birthtimespec.tv_sec=1634196789;
//    buf.st_mtimespec.tv_nsec=71388586;
//    buf.st_atimespec.tv_nsec=506670984;
//    buf.st_ctimespec.tv_nsec=562604728;
//    buf.st_birthtimespec.tv_nsec=71388586;
//    buf.st_gen=0;
//    buf.st_size=54948;
//    buf.st_flags=0;
//    buf.st_blocks=112;
//    buf.st_blksize=4194304;
//   BOOL ress =  [my writeToFile:filename atomically:YES];
   int re = open("/", 0);
    struct statfs hh = {0};
    fstatfs(re, &hh);
    
//    NSArray *sortArray =[testArray sortedArrayUsingComparator:^(id obj1,id obj2){
//        return [obj1 compare:obj2]; //升序
//    }];


//    [self tdtestArray];
    
}

-(void)tdtestArray{
    NSString *notdstr = @"/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/MYTongDunTest,/Developer/usr/lib/libBacktraceRecording.dylib,/Developer/usr/lib/libMainThreadChecker.dylib,/Developer/Library/PrivateFrameworks/DTDDISupport.framework/libViewDebuggerSupport.dylib,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/Frameworks/AFNetworking.framework/AFNetworking,/usr/lib/libresolv.9.dylib,/System/Library/Frameworks/SystemConfiguration.framework/SystemConfiguration,/System/Library/Frameworks/Foundation.framework/Foundation,/usr/lib/libobjc.A.dylib,/usr/lib/libSystem.B.dylib,/System/Library/Frameworks/AdSupport.framework/AdSupport,/System/Library/Frameworks/CFNetwork.framework/CFNetwork,/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation,/System/Library/Frameworks/CoreLocation.framework/CoreLocation,/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony,/System/Library/Frameworks/QuartzCore.framework/QuartzCore,/System/Library/Frameworks/Security.framework/Security,/System/Library/Frameworks/UIKit.framework/UIKit,/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics,/System/Library/Frameworks/MobileCoreServices.framework/MobileCoreServices,/System/Library/Frameworks/WebKit.framework/WebKit,/usr/lib/libcompression.dylib,/usr/lib/libarchive.2.dylib,/usr/lib/libicucore.A.dylib,/usr/lib/libxml2.2.dylib,/usr/lib/libz.1.dylib,/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit,/usr/lib/libCRFSuite.dylib,/usr/lib/liblangid.dylib,/usr/lib/libc++abi.dylib,/usr/lib/libc++.1.dylib,/usr/lib/system/libcache.dylib,/usr/lib/system/libcommonCrypto.dylib,/usr/lib/system/libcompiler_rt.dylib,/usr/lib/system/libcopyfile.dylib,/usr/lib/system/libcorecrypto.dylib,/usr/lib/system/introspection/libdispatch.dylib,/usr/lib/system/libdyld.dylib,/usr/lib/system/liblaunch.dylib,/usr/lib/system/libmacho.dylib,/usr/lib/system/libremovefile.dylib,/usr/lib/system/libsystem_asl.dylib,/usr/lib/system/libsystem_blocks.dylib,/usr/lib/system/libsystem_c.dylib,/usr/lib/system/libsystem_configuration.dylib,/usr/lib/system/libsystem_containermanager.dylib,/usr/lib/system/libsystem_coreservices.dylib,/usr/lib/system/libsystem_darwin.dylib,/usr/lib/system/libsystem_dnssd.dylib,/usr/lib/system/libsystem_featureflags.dylib,/usr/lib/system/libsystem_info.dylib,/usr/lib/system/libsystem_m.dylib,/usr/lib/system/libsystem_malloc.dylib,/usr/lib/system/libsystem_networkextension.dylib,/usr/lib/system/libsystem_notify.dylib,/usr/lib/system/libsystem_sandbox.dylib,/usr/lib/system/libsystem_kernel.dylib,/usr/lib/system/libsystem_platform.dylib,/usr/lib/system/libsystem_pthread.dylib,/usr/lib/system/libsystem_symptoms.dylib,/usr/lib/system/libsystem_trace.dylib,/usr/lib/system/libunwind.dylib,/usr/lib/system/libxpc.dylib,/usr/lib/liblzma.5.dylib,/usr/lib/libMobileGestalt.dylib,/usr/lib/libsqlite3.dylib,/usr/lib/libnetwork.dylib,/usr/lib/libapple_nghttp2.dylib,/System/Library/PrivateFrameworks/IOMobileFramebuffer.framework/IOMobileFramebuffer,/usr/lib/libbsm.0.dylib,/usr/lib/libpcap.A.dylib,/usr/lib/libcoretls.dylib,/usr/lib/libcoretls_cfhelpers.dylib,/usr/lib/libenergytrace.dylib,/System/Library/Frameworks/IOSurface.framework/IOSurface,/usr/lib/libbz2.1.0.dylib,/usr/lib/libiconv.2.dylib,/usr/lib/libcharset.1.dylib,/System/Library/PrivateFrameworks/FontServices.framework/libFontParser.dylib,/System/Library/Frameworks/Accelerate.framework/Accelerate,/System/Library/PrivateFrameworks/FontServices.framework/libhvf.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vImage.framework/vImage,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/vecLib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libvMisc.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libvDSP.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libBLAS.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libLAPACK.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libLinearAlgebra.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libSparseBLAS.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libQuadrature.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libBNNS.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libSparse.dylib,/System/Library/Frameworks/CoreServices.framework/CoreServices,/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation,/System/Library/PrivateFrameworks/CoreServicesStore.framework/CoreServicesStore,/System/Library/PrivateFrameworks/MobileSystemServices.framework/MobileSystemServices,/System/Library/PrivateFrameworks/DocumentManager.framework/DocumentManager,/System/Library/Frameworks/FileProvider.framework/FileProvider,/System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore,/System/Library/PrivateFrameworks/ShareSheet.framework/ShareSheet,/System/Library/PrivateFrameworks/MobileIcons.framework/MobileIcons,/System/Library/Frameworks/Network.framework/Network,/System/Library/PrivateFrameworks/DocumentManagerCore.framework/DocumentManagerCore,/System/Library/PrivateFrameworks/PlugInKit.framework/PlugInKit,/System/Library/PrivateFrameworks/IOSurfaceAccelerator.framework/IOSurfaceAccelerator,/System/Library/Frameworks/CoreImage.framework/CoreImage,/System/Library/PrivateFrameworks/CoreUI.framework/CoreUI,/System/Library/Frameworks/ImageIO.framework/ImageIO,/System/Library/PrivateFrameworks/AggregateDictionary.framework/AggregateDictionary,/usr/lib/libFosl_dynamic.dylib,/System/Library/PrivateFrameworks/ColorSync.framework/ColorSync,/System/Library/Frameworks/CoreMedia.framework/CoreMedia,/System/Library/Frameworks/VideoToolbox.framework/VideoToolbox,/System/Library/PrivateFrameworks/GraphVisualizer.framework/GraphVisualizer,/System/Library/Frameworks/CoreText.framework/CoreText,/System/Library/Frameworks/Metal.framework/Metal,/System/Library/Frameworks/MetalPerformanceShaders.framework/MetalPerformanceShaders,/System/Library/Frameworks/OpenGLES.framework/OpenGLES,/System/Library/Frameworks/CoreVideo.framework/CoreVideo,/System/Library/PrivateFrameworks/FaceCore.framework/FaceCore,/usr/lib/libncurses.5.4.dylib,/System/Library/PrivateFrameworks/WatchdogClient.framework/WatchdogClient,/System/Library/PrivateFrameworks/CrashReporterSupport.framework/CrashReporterSupport,/System/Library/Frameworks/CoreAudio.framework/CoreAudio,/System/Library/PrivateFrameworks/AppSupport.framework/AppSupport,/System/Library/PrivateFrameworks/AssertionServices.framework/AssertionServices,/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices,/System/Library/PrivateFrameworks/PowerLog.framework/PowerLog,/usr/lib/libCTGreenTeaLogger.dylib,/System/Library/PrivateFrameworks/ASEProcessing.framework/ASEProcessing,/usr/lib/libtailspin.dylib,/System/Library/PrivateFrameworks/libEDR.framework/libEDR,/System/Library/PrivateFrameworks/BaseBoard.framework/BaseBoard,/System/Library/PrivateFrameworks/RunningBoardServices.framework/RunningBoardServices,/System/Library/PrivateFrameworks/PersistentConnection.framework/PersistentConnection,/System/Library/PrivateFrameworks/ProtocolBuffer.framework/ProtocolBuffer,/System/Library/PrivateFrameworks/CommonUtilities.framework/CommonUtilities,/usr/lib/libcupolicy.dylib,/usr/lib/libTelephonyUtilDynamic.dylib,/System/Library/PrivateFrameworks/MobileWiFi.framework/MobileWiFi,/System/Library/PrivateFrameworks/Bom.framework/Bom,/System/Library/PrivateFrameworks/MobileKeyBag.framework/MobileKeyBag,/System/Library/PrivateFrameworks/CaptiveNetwork.framework/CaptiveNetwork,/System/Library/PrivateFrameworks/EAP8021X.framework/EAP8021X,/System/Library/PrivateFrameworks/CoreAnalytics.framework/CoreAnalytics,/System/Library/PrivateFrameworks/APFS.framework/APFS,/System/Library/PrivateFrameworks/AppleSauce.framework/AppleSauce,/usr/lib/libutil.dylib,/usr/lib/libate.dylib,/System/Library/PrivateFrameworks/AppleJPEG.framework/AppleJPEG,/System/Library/PrivateFrameworks/IOAccelerator.framework/IOAccelerator,/System/Library/Frameworks/OpenGLES.framework/libCoreFSCache.dylib,/System/Library/PrivateFrameworks/SignpostCollection.framework/SignpostCollection,/System/Library/PrivateFrameworks/ktrace.framework/ktrace,/System/Library/PrivateFrameworks/SampleAnalysis.framework/SampleAnalysis,/System/Library/PrivateFrameworks/kperfdata.framework/kperfdata,/System/Library/PrivateFrameworks/CoreSymbolication.framework/CoreSymbolication,/usr/lib/libdscsym.dylib,/System/Library/PrivateFrameworks/SignpostSupport.framework/SignpostSupport,/System/Library/PrivateFrameworks/LoggingSupport.framework/LoggingSupport,/System/Library/PrivateFrameworks/kperf.framework/kperf,/System/Library/PrivateFrameworks/OSAnalytics.framework/OSAnalytics,/System/Library/PrivateFrameworks/Symbolication.framework/Symbolication,/System/Library/PrivateFrameworks/OSAServicesClient.framework/OSAServicesClient,/System/Library/PrivateFrameworks/MallocStackLogging.framework/MallocStackLogging,/System/Library/PrivateFrameworks/CoreBrightness.framework/CoreBrightness,/usr/lib/libAccessibility.dylib,/usr/lib/libIOReport.dylib,/System/Library/PrivateFrameworks/CPMS.framework/CPMS,/System/Library/PrivateFrameworks/HID.framework/HID,/System/Library/PrivateFrameworks/IdleTimerServices.framework/IdleTimerServices,/System/Library/PrivateFrameworks/BoardServices.framework/BoardServices,/System/Library/PrivateFrameworks/FrontBoardServices.framework/FrontBoardServices,/System/Library/PrivateFrameworks/BackBoardServices.framework/BackBoardServices,/System/Library/PrivateFrameworks/GraphicsServices.framework/GraphicsServices,/System/Library/PrivateFrameworks/FontServices.framework/libGSFont.dylib,/System/Library/PrivateFrameworks/FontServices.framework/FontServices,/System/Library/PrivateFrameworks/FontServices.framework/libGSFontCache.dylib,/System/Library/PrivateFrameworks/OTSVG.framework/OTSVG,/System/Library/PrivateFrameworks/ConstantClasses.framework/ConstantClasses,/System/Library/PrivateFrameworks/AXCoreUtilities.framework/AXCoreUtilities,/System/Library/Frameworks/MediaAccessibility.framework/MediaAccessibility,/System/Library/Frameworks/OpenGLES.framework/libGFXShared.dylib,/System/Library/Frameworks/OpenGLES.framework/libGLImage.dylib,/System/Library/Frameworks/OpenGLES.framework/libCVMSPluginSupport.dylib,/System/Library/Frameworks/OpenGLES.framework/libCoreVMClient.dylib,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSCore.framework/MPSCore,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSImage.framework/MPSImage,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSNeuralNetwork.framework/MPSNeuralNetwork,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSMatrix.framework/MPSMatrix,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSRayIntersector.framework/MPSRayIntersector,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSNDArray.framework/MPSNDArray,/System/Library/PrivateFrameworks/AudioToolboxCore.framework/AudioToolboxCore,/System/Library/PrivateFrameworks/caulk.framework/caulk,/usr/lib/libAudioToolboxUtility.dylib,/System/Library/PrivateFrameworks/CorePhoneNumbers.framework/CorePhoneNumbers,/System/Library/PrivateFrameworks/MediaExperience.framework/MediaExperience,/System/Library/PrivateFrameworks/TextureIO.framework/TextureIO,/System/Library/PrivateFrameworks/CoreSVG.framework/CoreSVG,/System/Library/PrivateFrameworks/InternationalSupport.framework/InternationalSupport,/System/Library/PrivateFrameworks/CoreUtils.framework/CoreUtils,/System/Library/PrivateFrameworks/IconServices.framework/IconServices,/System/Library/PrivateFrameworks/UIFoundation.framework/UIFoundation,/System/Library/Frameworks/PushKit.framework/PushKit,/System/Library/PrivateFrameworks/XCTTargetBootstrap.framework/XCTTargetBootstrap,/System/Library/PrivateFrameworks/WebKitLegacy.framework/WebKitLegacy,/System/Library/PrivateFrameworks/SAObjects.framework/SAObjects,/System/Library/PrivateFrameworks/HangTracer.framework/HangTracer,/System/Library/PrivateFrameworks/SignpostMetrics.framework/SignpostMetrics,/System/Library/PrivateFrameworks/PointerUIServices.framework/PointerUIServices,/System/Library/PrivateFrameworks/StudyLog.framework/StudyLog,/System/Library/PrivateFrameworks/CoreMaterial.framework/CoreMaterial,/usr/lib/libapp_launch_measurement.dylib,/System/Library/Frameworks/UserNotifications.framework/UserNotifications,/System/Library/PrivateFrameworks/MobileAsset.framework/MobileAsset,/System/Library/PrivateFrameworks/PhysicsKit.framework/PhysicsKit,/System/Library/PrivateFrameworks/PrototypeTools.framework/PrototypeTools,/System/Library/PrivateFrameworks/TextInput.framework/TextInput,/System/Library/PrivateFrameworks/UIKitServices.framework/UIKitServices,/System/Library/Frameworks/JavaScriptCore.framework/JavaScriptCore,/System/Library/PrivateFrameworks/WebCore.framework/WebCore,/System/Library/PrivateFrameworks/WebCore.framework/Frameworks/libwebrtc.dylib,/System/Library/PrivateFrameworks/URLFormatting.framework/URLFormatting,/System/Library/Frameworks/AudioToolbox.framework/AudioToolbox,/System/Library/PrivateFrameworks/TCC.framework/TCC,/usr/lib/libAudioStatistics.dylib,/System/Library/PrivateFrameworks/perfdata.framework/perfdata,/usr/lib/libperfcheck.dylib,/System/Library/PrivateFrameworks/StreamingZip.framework/StreamingZip,/System/Library/Frameworks/Accounts.framework/Accounts,/System/Library/PrivateFrameworks/GenerationalStorage.framework/GenerationalStorage,/System/Library/PrivateFrameworks/SymptomDiagnosticReporter.framework/SymptomDiagnosticReporter,/System/Library/PrivateFrameworks/UserManagement.framework/UserManagement,/System/Library/Frameworks/CoreData.framework/CoreData,/System/Library/PrivateFrameworks/ChunkingLibrary.framework/ChunkingLibrary,/System/Library/PrivateFrameworks/ManagedConfiguration.framework/ManagedConfiguration,/System/Library/PrivateFrameworks/AppleAccount.framework/AppleAccount,/usr/lib/liblockdown.dylib,/usr/lib/libmis.dylib,/System/Library/PrivateFrameworks/Netrb.framework/Netrb,/System/Library/PrivateFrameworks/DataMigration.framework/DataMigration,/System/Library/PrivateFrameworks/DeviceIdentity.framework/DeviceIdentity,/System/Library/PrivateFrameworks/SetupAssistant.framework/SetupAssistant,/System/Library/PrivateFrameworks/AppleIDSSOAuthentication.framework/AppleIDSSOAuthentication,/System/Library/PrivateFrameworks/AccountSettings.framework/AccountSettings,/System/Library/PrivateFrameworks/ApplePushService.framework/ApplePushService,/System/Library/PrivateFrameworks/AuthKit.framework/AuthKit,/System/Library/PrivateFrameworks/CoreFollowUp.framework/CoreFollowUp,/System/Library/PrivateFrameworks/SetupAssistantSupport.framework/SetupAssistantSupport,/System/Library/PrivateFrameworks/MobileBackup.framework/MobileBackup,/System/Library/PrivateFrameworks/CoreTime.framework/CoreTime,/System/Library/PrivateFrameworks/IntlPreferences.framework/IntlPreferences,/System/Library/PrivateFrameworks/NanoPreferencesSync.framework/NanoPreferencesSync,/System/Library/PrivateFrameworks/NanoRegistry.framework/NanoRegistry,/System/Library/PrivateFrameworks/AppConduit.framework/AppConduit,/System/Library/Frameworks/LocalAuthentication.framework/LocalAuthentication,/System/Library/PrivateFrameworks/AppleIDAuthSupport.framework/AppleIDAuthSupport,/System/Library/PrivateFrameworks/PhoneNumbers.framework/PhoneNumbers,/System/Library/Frameworks/LocalAuthentication.framework/Support/SharedUtils.framework/SharedUtils,/System/Library/PrivateFrameworks/Rapport.framework/Rapport,/System/Library/PrivateFrameworks/MobileDeviceLink.framework/MobileDeviceLink,/System/Library/PrivateFrameworks/AccountsDaemon.framework/AccountsDaemon,/System/Library/Frameworks/GSS.framework/GSS,/System/Library/PrivateFrameworks/IDS.framework/IDS,/System/Library/PrivateFrameworks/WirelessDiagnostics.framework/WirelessDiagnostics,/System/Library/PrivateFrameworks/OAuth.framework/OAuth,/usr/lib/libheimdal-asn1.dylib,/System/Library/PrivateFrameworks/Heimdal.framework/Heimdal,/System/Library/PrivateFrameworks/CommonAuth.framework/CommonAuth,/System/Library/PrivateFrameworks/Marco.framework/Marco,/System/Library/PrivateFrameworks/IMFoundation.framework/IMFoundation,/System/Library/PrivateFrameworks/IDSFoundation.framework/IDSFoundation,/System/Library/PrivateFrameworks/Engram.framework/Engram,/usr/lib/libtidy.A.dylib,/System/Library/Frameworks/CoreBluetooth.framework/CoreBluetooth,/usr/lib/libAWDSupportFramework.dylib,/usr/lib/libAWDSupport.dylib,/usr/lib/libprotobuf-lite.dylib,/usr/lib/libprotobuf.dylib,/System/Library/PrivateFrameworks/CorePrediction.framework/CorePrediction,/System/Library/Frameworks/PDFKit.framework/PDFKit,/System/Library/PrivateFrameworks/SafariSafeBrowsing.framework/SafariSafeBrowsing,/System/Library/PrivateFrameworks/CoreOptimization.framework/CoreOptimization,/System/Library/PrivateFrameworks/DataDetectorsCore.framework/DataDetectorsCore,/System/Library/PrivateFrameworks/CorePDF.framework/CorePDF,/System/Library/PrivateFrameworks/RevealCore.framework/RevealCore,/System/Library/PrivateFrameworks/CoreNLP.framework/CoreNLP,/System/Library/PrivateFrameworks/AppleFSCompression.framework/AppleFSCompression,/usr/lib/libmecab.dylib,/usr/lib/libgermantok.dylib,/usr/lib/libThaiTokenizer.dylib,/usr/lib/libChineseTokenizer.dylib,/System/Library/PrivateFrameworks/LanguageModeling.framework/LanguageModeling,/System/Library/PrivateFrameworks/CoreEmoji.framework/CoreEmoji,/System/Library/PrivateFrameworks/LinguisticData.framework/LinguisticData,/System/Library/PrivateFrameworks/Lexicon.framework/Lexicon,/usr/lib/libcmph.dylib,/System/Library/Frameworks/NaturalLanguage.framework/NaturalLanguage,/System/Library/Frameworks/CoreML.framework/CoreML,/System/Library/PrivateFrameworks/Montreal.framework/Montreal,/System/Library/PrivateFrameworks/DuetActivityScheduler.framework/DuetActivityScheduler,/System/Library/PrivateFrameworks/Espresso.framework/Espresso,/System/Library/PrivateFrameworks/CoreDuet.framework/CoreDuet,/System/Library/PrivateFrameworks/CoreDuetContext.framework/CoreDuetContext,/System/Library/PrivateFrameworks/CoreDuetDebugLogging.framework/CoreDuetDebugLogging,/System/Library/Frameworks/CloudKit.framework/CloudKit,/System/Library/Frameworks/Intents.framework/Intents,/System/Library/PrivateFrameworks/CoreDuetDaemonProtocol.framework/CoreDuetDaemonProtocol,/System/Library/PrivateFrameworks/C2.framework/C2,/System/Library/PrivateFrameworks/ProtectedCloudStorage.framework/ProtectedCloudStorage,/System/Library/Frameworks/NetworkExtension.framework/NetworkExtension,/usr/lib/libnetworkextension.dylib,/System/Library/PrivateFrameworks/GeoServices.framework/GeoServices,/System/Library/PrivateFrameworks/LocationSupport.framework/LocationSupport,/System/Library/PrivateFrameworks/CoreLocationProtobuf.framework/CoreLocationProtobuf,/System/Library/PrivateFrameworks/IntentsFoundation.framework/IntentsFoundation,/System/Library/PrivateFrameworks/AppleNeuralEngine.framework/AppleNeuralEngine,/System/Library/PrivateFrameworks/ANECompiler.framework/ANECompiler,/System/Library/Frameworks/MediaToolbox.framework/MediaToolbox,/System/Library/PrivateFrameworks/ANEServices.framework/ANEServices,/usr/lib/libsandbox.1.dylib,/usr/lib/libMatch.1.dylib,/System/Library/PrivateFrameworks/CoreAUC.framework/CoreAUC,/System/Library/Frameworks/CoreHaptics.framework/CoreHaptics,/System/Library/PrivateFrameworks/NetworkStatistics.framework/NetworkStatistics,/System/Library/PrivateFrameworks/CTCarrierSpace.framework/CTCarrierSpace,/Developer/Library/PrivateFrameworks/DebugHierarchyFoundation.framework/DebugHierarchyFoundation,/System/Library/Frameworks/GLKit.framework/GLKit,/System/Library/Frameworks/SceneKit.framework/SceneKit,/System/Library/Frameworks/MapKit.framework/MapKit,/System/Library/Frameworks/ModelIO.framework/ModelIO,/System/Library/Frameworks/AVFoundation.framework/AVFoundation,/System/Library/Frameworks/MetalKit.framework/MetalKit,/System/Library/Frameworks/AVFoundation.framework/Frameworks/AVFAudio.framework/AVFAudio,/System/Library/PrivateFrameworks/Celestial.framework/Celestial,/System/Library/PrivateFrameworks/Quagga.framework/Quagga,/System/Library/Frameworks/CoreMotion.framework/CoreMotion,/System/Library/Frameworks/ContactsUI.framework/ContactsUI,/System/Library/Frameworks/Contacts.framework/Contacts,/System/Library/PrivateFrameworks/SearchFoundation.framework/SearchFoundation,/System/Library/PrivateFrameworks/Navigation.framework/Navigation,/System/Library/PrivateFrameworks/VectorKit.framework/VectorKit,/System/Library/PrivateFrameworks/AddressBookLegacy.framework/AddressBookLegacy,/System/Library/PrivateFrameworks/AppSupportUI.framework/AppSupportUI,/System/Library/PrivateFrameworks/DataAccessExpress.framework/DataAccessExpress,/System/Library/PrivateFrameworks/PersonaKit.framework/PersonaKit,/System/Library/PrivateFrameworks/PersonaUI.framework/PersonaUI,/System/Library/Frameworks/CoreSpotlight.framework/CoreSpotlight,/System/Library/PrivateFrameworks/CommunicationsFilter.framework/CommunicationsFilter,/System/Library/PrivateFrameworks/ContactsDonation.framework/ContactsDonation,/System/Library/PrivateFrameworks/ContactsFoundation.framework/ContactsFoundation,/System/Library/PrivateFrameworks/ContactsUICore.framework/ContactsUICore,/System/Library/PrivateFrameworks/FamilyCircle.framework/FamilyCircle,/System/Library/PrivateFrameworks/OnBoardingKit.framework/OnBoardingKit,/System/Library/PrivateFrameworks/TelephonyUtilities.framework/TelephonyUtilities,/System/Library/PrivateFrameworks/vCard.framework/vCard,/System/Library/PrivateFrameworks/MetadataUtilities.framework/MetadataUtilities,/System/Library/PrivateFrameworks/CellularPlanManager.framework/CellularPlanManager,/System/Library/Frameworks/ClassKit.framework/ClassKit,/System/Library/PrivateFrameworks/CoreSuggestions.framework/CoreSuggestions,/System/Library/PrivateFrameworks/CloudDocs.framework/CloudDocs,/System/Library/Frameworks/QuickLookThumbnailing.framework/QuickLookThumbnailing,/System/Library/PrivateFrameworks/MobileSpotlightIndex.framework/MobileSpotlightIndex,/usr/lib/libprequelite.dylib,/System/Library/PrivateFrameworks/ProactiveEventTracker.framework/ProactiveEventTracker,/System/Library/PrivateFrameworks/ProactiveSupport.framework/ProactiveSupport,/System/Library/PrivateFrameworks/DataDetectorsNaturalLanguage.framework/DataDetectorsNaturalLanguage,/System/Library/PrivateFrameworks/InternationalTextSearch.framework/InternationalTextSearch,/System/Library/Frameworks/EventKit.framework/EventKit,/System/Library/PrivateFrameworks/ResponseKit.framework/ResponseKit,/System/Library/PrivateFrameworks/CalendarDaemon.framework/CalendarDaemon,/System/Library/PrivateFrameworks/CalendarDatabase.framework/CalendarDatabase,/System/Library/PrivateFrameworks/CalendarFoundation.framework/CalendarFoundation,/System/Library/PrivateFrameworks/iCalendar.framework/iCalendar,/System/Library/PrivateFrameworks/BackgroundTaskAgent.framework/BackgroundTaskAgent,/System/Library/PrivateFrameworks/CoreDAV.framework/CoreDAV,/System/Library/PrivateFrameworks/NLP.framework/NLP,/System/Library/PrivateFrameworks/CoreRecents.framework/CoreRecents,/System/Library/PrivateFrameworks/StoreServices.framework/StoreServices,/System/Library/PrivateFrameworks/AppleMediaServices.framework/AppleMediaServices,/System/Library/Frameworks/CryptoTokenKit.framework/CryptoTokenKit,/System/Library/PrivateFrameworks/IncomingCallFilter.framework/IncomingCallFilter,/System/Library/PrivateFrameworks/Pasteboard.framework/Pasteboard,/Library/MobileSubstrate/DynamicLibraries/CGDevice_BACKUP_13488.dylib,/Library/MobileSubstrate/DynamicLibraries/CGDevice_BASE_13488.dylib,/Library/MobileSubstrate/DynamicLibraries/CGDevice_LOCAL_13488.dylib,/Library/MobileSubstrate/DynamicLibraries/CGDevice_REMOTE_13488.dylib,/Library/MobileSubstrate/DynamicLibraries/MobileSafety.dylib,/Library/MobileSubstrate/DynamicLibraries/afc2dService.dylib,/Library/MobileSubstrate/DynamicLibraries/afc2dSupport.dylib,/System/Library/PrivateFrameworks/AppSSOCore.framework/AppSSOCore,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app,/usr/share/icu/icudt64l.dat,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/en.lproj,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/Base.lproj,/Library/Preferences/com.apple.networkd.plist,/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist,/System/Library/CoreServices/SystemVersion.plist,/System/Library/CoreServices/SystemVersion.bundle,/System/Library/Frameworks/CFNetwork.framework,/usr/lib/libUIKit.dylib,/usr/lib/libobjc-trampolines.dylib,/System/Library/Frameworks/CFNetwork.framework/Info.plist,/var/mobile/Containers/Data/Application/28986ADB-A387-437B-B40B-A68DB8DA336E/Library/Cookies/Cookies.binarycookies,/System/Library/Frameworks/CFNetwork.framework/,/var/mobile/Containers/Data/Application/28986ADB-A387-437B-B40B-A68DB8DA336E,/var/mobile/Containers/Data/Application/28986ADB-A387-437B-B40B-A68DB8DA336E/Library,/var/mobile/Containers/Data/Application/28986ADB-A387-437B-B40B-A68DB8DA336E/Library/Saved Application State/com.devicetool.MYTong.savedState/KnownSceneSessions/data.data,/System/Library/Frameworks/CFNetwork.framework//en.lproj,/var/mobile/Containers/Data/Application/28986ADB-A387-437B-B40B-A68DB8DA336E/Library/Saved Application State/com.devicetool.MYTong.savedState/KnownCanvasDefinitions/data.data,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/Base.lproj/Main.storyboardc/Info-8.0+.plist,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/Base.lproj/Main.storyboardc/Info.plist,/System/Library/Frameworks/CFNetwork.framework//Base.lproj,/System/Library/Frameworks/CFNetwork.framework/en.lproj/Localizable.strings,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/Main.storyboardc,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/en.lproj/Main.storyboardc,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/Base.lproj/Main.storyboardc,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/Base.lproj/Main.storyboardc/UIViewController-BYZ-38-t0r.nib,/System,/System/Library,/System/Library/CoreServices,/System/Library/CoreServices/CoreGlyphs.bundle,/System/Library/CoreServices/CoreGlyphs.bundle/Info.plist,/System/Library/PrivateFrameworks,/System/Library/PrivateFrameworks/UIKitCore.framework,/System/Library/PrivateFrameworks/UIKitCore.framework/Info.plist,/System/Library/CoreServices/CoreGlyphs.bundle/,/System/Library/CoreServices/CoreGlyphs.bundle//en.lproj,/System/Library/CoreServices/CoreGlyphs.bundle//Base.lproj,/System/Library/CoreServices/CoreGlyphs.bundle/name_aliases.strings,/System/Library/CoreServices/CoreGlyphs.bundle/Assets.car,/var/mobile/Library/Fonts/AddedFontCache.plist,/var/containers/Bundle/Application/A4E9004E-C662-4BD5-AFA8-3B0046659E6F/MYTongDunTest.app/Base.lproj/Main.storyboardc/BYZ-38-t0r-view-8bC-Xf-vdC.nib,/System/Library/Fonts/CoreUI/SFUI.ttf,/var/mobile/Containers/Data/Application/28986ADB-A387-437B-B40B-A68DB8DA336E/Library/Saved Application State/com.devicetool.MYTong.savedState/KnownSceneSessions,/var/mobile/Containers/Data/Application/28986ADB-A387-437B-B40B-A68DB8DA336E/Library/Saved Application State/com.devicetool.MYTong.savedState,/var/mobile/Containers/Data/Application/28986ADB-A387-437B-B40B-A68DB8DA336E/Library/Saved Application State,/System/Library/PrivateFrameworks/CoreServicesInternal.framework/CoreServicesInternal";
    NSArray *notdArray=  [notdstr componentsSeparatedByString:@","];
    
    
    NSString *tdstr = @"/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/MYTongDunTest,/Developer/usr/lib/libBacktraceRecording.dylib,/Developer/usr/lib/libMainThreadChecker.dylib,/Developer/Library/PrivateFrameworks/DTDDISupport.framework/libViewDebuggerSupport.dylib,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/Frameworks/AFNetworking.framework/AFNetworking,/usr/lib/libresolv.9.dylib,/System/Library/Frameworks/SystemConfiguration.framework/SystemConfiguration,/System/Library/Frameworks/Foundation.framework/Foundation,/usr/lib/libobjc.A.dylib,/usr/lib/libSystem.B.dylib,/System/Library/Frameworks/AdSupport.framework/AdSupport,/System/Library/Frameworks/CFNetwork.framework/CFNetwork,/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation,/System/Library/Frameworks/CoreLocation.framework/CoreLocation,/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony,/System/Library/Frameworks/QuartzCore.framework/QuartzCore,/System/Library/Frameworks/Security.framework/Security,/System/Library/Frameworks/UIKit.framework/UIKit,/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics,/System/Library/Frameworks/MobileCoreServices.framework/MobileCoreServices,/System/Library/Frameworks/WebKit.framework/WebKit,/usr/lib/libcompression.dylib,/usr/lib/libarchive.2.dylib,/usr/lib/libicucore.A.dylib,/usr/lib/libxml2.2.dylib,/usr/lib/libz.1.dylib,/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit,/usr/lib/libCRFSuite.dylib,/usr/lib/liblangid.dylib,/usr/lib/libc++abi.dylib,/usr/lib/libc++.1.dylib,/usr/lib/system/libcache.dylib,/usr/lib/system/libcommonCrypto.dylib,/usr/lib/system/libcompiler_rt.dylib,/usr/lib/system/libcopyfile.dylib,/usr/lib/system/libcorecrypto.dylib,/usr/lib/system/introspection/libdispatch.dylib,/usr/lib/system/libdyld.dylib,/usr/lib/system/liblaunch.dylib,/usr/lib/system/libmacho.dylib,/usr/lib/system/libremovefile.dylib,/usr/lib/system/libsystem_asl.dylib,/usr/lib/system/libsystem_blocks.dylib,/usr/lib/system/libsystem_c.dylib,/usr/lib/system/libsystem_configuration.dylib,/usr/lib/system/libsystem_containermanager.dylib,/usr/lib/system/libsystem_coreservices.dylib,/usr/lib/system/libsystem_darwin.dylib,/usr/lib/system/libsystem_dnssd.dylib,/usr/lib/system/libsystem_featureflags.dylib,/usr/lib/system/libsystem_info.dylib,/usr/lib/system/libsystem_m.dylib,/usr/lib/system/libsystem_malloc.dylib,/usr/lib/system/libsystem_networkextension.dylib,/usr/lib/system/libsystem_notify.dylib,/usr/lib/system/libsystem_sandbox.dylib,/usr/lib/system/libsystem_kernel.dylib,/usr/lib/system/libsystem_platform.dylib,/usr/lib/system/libsystem_pthread.dylib,/usr/lib/system/libsystem_symptoms.dylib,/usr/lib/system/libsystem_trace.dylib,/usr/lib/system/libunwind.dylib,/usr/lib/system/libxpc.dylib,/usr/lib/liblzma.5.dylib,/usr/lib/libMobileGestalt.dylib,/usr/lib/libsqlite3.dylib,/usr/lib/libnetwork.dylib,/usr/lib/libapple_nghttp2.dylib,/System/Library/PrivateFrameworks/IOMobileFramebuffer.framework/IOMobileFramebuffer,/usr/lib/libbsm.0.dylib,/usr/lib/libpcap.A.dylib,/usr/lib/libcoretls.dylib,/usr/lib/libcoretls_cfhelpers.dylib,/usr/lib/libenergytrace.dylib,/System/Library/Frameworks/IOSurface.framework/IOSurface,/usr/lib/libbz2.1.0.dylib,/usr/lib/libiconv.2.dylib,/usr/lib/libcharset.1.dylib,/System/Library/PrivateFrameworks/FontServices.framework/libFontParser.dylib,/System/Library/Frameworks/Accelerate.framework/Accelerate,/System/Library/PrivateFrameworks/FontServices.framework/libhvf.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vImage.framework/vImage,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/vecLib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libvMisc.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libvDSP.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libBLAS.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libLAPACK.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libLinearAlgebra.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libSparseBLAS.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libQuadrature.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libBNNS.dylib,/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libSparse.dylib,/System/Library/Frameworks/CoreServices.framework/CoreServices,/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation,/System/Library/PrivateFrameworks/CoreServicesStore.framework/CoreServicesStore,/System/Library/PrivateFrameworks/MobileSystemServices.framework/MobileSystemServices,/System/Library/PrivateFrameworks/DocumentManager.framework/DocumentManager,/System/Library/Frameworks/FileProvider.framework/FileProvider,/System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore,/System/Library/PrivateFrameworks/ShareSheet.framework/ShareSheet,/System/Library/PrivateFrameworks/MobileIcons.framework/MobileIcons,/System/Library/Frameworks/Network.framework/Network,/System/Library/PrivateFrameworks/DocumentManagerCore.framework/DocumentManagerCore,/System/Library/PrivateFrameworks/PlugInKit.framework/PlugInKit,/System/Library/PrivateFrameworks/IOSurfaceAccelerator.framework/IOSurfaceAccelerator,/System/Library/Frameworks/CoreImage.framework/CoreImage,/System/Library/PrivateFrameworks/CoreUI.framework/CoreUI,/System/Library/Frameworks/ImageIO.framework/ImageIO,/System/Library/PrivateFrameworks/AggregateDictionary.framework/AggregateDictionary,/usr/lib/libFosl_dynamic.dylib,/System/Library/PrivateFrameworks/ColorSync.framework/ColorSync,/System/Library/Frameworks/CoreMedia.framework/CoreMedia,/System/Library/Frameworks/VideoToolbox.framework/VideoToolbox,/System/Library/PrivateFrameworks/GraphVisualizer.framework/GraphVisualizer,/System/Library/Frameworks/CoreText.framework/CoreText,/System/Library/Frameworks/Metal.framework/Metal,/System/Library/Frameworks/MetalPerformanceShaders.framework/MetalPerformanceShaders,/System/Library/Frameworks/OpenGLES.framework/OpenGLES,/System/Library/Frameworks/CoreVideo.framework/CoreVideo,/System/Library/PrivateFrameworks/FaceCore.framework/FaceCore,/usr/lib/libncurses.5.4.dylib,/System/Library/PrivateFrameworks/WatchdogClient.framework/WatchdogClient,/System/Library/PrivateFrameworks/CrashReporterSupport.framework/CrashReporterSupport,/System/Library/Frameworks/CoreAudio.framework/CoreAudio,/System/Library/PrivateFrameworks/AppSupport.framework/AppSupport,/System/Library/PrivateFrameworks/AssertionServices.framework/AssertionServices,/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices,/System/Library/PrivateFrameworks/PowerLog.framework/PowerLog,/usr/lib/libCTGreenTeaLogger.dylib,/System/Library/PrivateFrameworks/ASEProcessing.framework/ASEProcessing,/usr/lib/libtailspin.dylib,/System/Library/PrivateFrameworks/libEDR.framework/libEDR,/System/Library/PrivateFrameworks/BaseBoard.framework/BaseBoard,/System/Library/PrivateFrameworks/RunningBoardServices.framework/RunningBoardServices,/System/Library/PrivateFrameworks/PersistentConnection.framework/PersistentConnection,/System/Library/PrivateFrameworks/ProtocolBuffer.framework/ProtocolBuffer,/System/Library/PrivateFrameworks/CommonUtilities.framework/CommonUtilities,/usr/lib/libcupolicy.dylib,/usr/lib/libTelephonyUtilDynamic.dylib,/System/Library/PrivateFrameworks/MobileWiFi.framework/MobileWiFi,/System/Library/PrivateFrameworks/Bom.framework/Bom,/System/Library/PrivateFrameworks/MobileKeyBag.framework/MobileKeyBag,/System/Library/PrivateFrameworks/CaptiveNetwork.framework/CaptiveNetwork,/System/Library/PrivateFrameworks/EAP8021X.framework/EAP8021X,/System/Library/PrivateFrameworks/CoreAnalytics.framework/CoreAnalytics,/System/Library/PrivateFrameworks/APFS.framework/APFS,/System/Library/PrivateFrameworks/AppleSauce.framework/AppleSauce,/usr/lib/libutil.dylib,/usr/lib/libate.dylib,/System/Library/PrivateFrameworks/AppleJPEG.framework/AppleJPEG,/System/Library/PrivateFrameworks/IOAccelerator.framework/IOAccelerator,/System/Library/Frameworks/OpenGLES.framework/libCoreFSCache.dylib,/System/Library/PrivateFrameworks/SignpostCollection.framework/SignpostCollection,/System/Library/PrivateFrameworks/ktrace.framework/ktrace,/System/Library/PrivateFrameworks/SampleAnalysis.framework/SampleAnalysis,/System/Library/PrivateFrameworks/kperfdata.framework/kperfdata,/System/Library/PrivateFrameworks/CoreSymbolication.framework/CoreSymbolication,/usr/lib/libdscsym.dylib,/System/Library/PrivateFrameworks/SignpostSupport.framework/SignpostSupport,/System/Library/PrivateFrameworks/LoggingSupport.framework/LoggingSupport,/System/Library/PrivateFrameworks/kperf.framework/kperf,/System/Library/PrivateFrameworks/OSAnalytics.framework/OSAnalytics,/System/Library/PrivateFrameworks/Symbolication.framework/Symbolication,/System/Library/PrivateFrameworks/OSAServicesClient.framework/OSAServicesClient,/System/Library/PrivateFrameworks/MallocStackLogging.framework/MallocStackLogging,/System/Library/PrivateFrameworks/CoreBrightness.framework/CoreBrightness,/usr/lib/libAccessibility.dylib,/usr/lib/libIOReport.dylib,/System/Library/PrivateFrameworks/CPMS.framework/CPMS,/System/Library/PrivateFrameworks/HID.framework/HID,/System/Library/PrivateFrameworks/IdleTimerServices.framework/IdleTimerServices,/System/Library/PrivateFrameworks/BoardServices.framework/BoardServices,/System/Library/PrivateFrameworks/FrontBoardServices.framework/FrontBoardServices,/System/Library/PrivateFrameworks/BackBoardServices.framework/BackBoardServices,/System/Library/PrivateFrameworks/GraphicsServices.framework/GraphicsServices,/System/Library/PrivateFrameworks/FontServices.framework/libGSFont.dylib,/System/Library/PrivateFrameworks/FontServices.framework/FontServices,/System/Library/PrivateFrameworks/FontServices.framework/libGSFontCache.dylib,/System/Library/PrivateFrameworks/OTSVG.framework/OTSVG,/System/Library/PrivateFrameworks/ConstantClasses.framework/ConstantClasses,/System/Library/PrivateFrameworks/AXCoreUtilities.framework/AXCoreUtilities,/System/Library/Frameworks/MediaAccessibility.framework/MediaAccessibility,/System/Library/Frameworks/OpenGLES.framework/libGFXShared.dylib,/System/Library/Frameworks/OpenGLES.framework/libGLImage.dylib,/System/Library/Frameworks/OpenGLES.framework/libCVMSPluginSupport.dylib,/System/Library/Frameworks/OpenGLES.framework/libCoreVMClient.dylib,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSCore.framework/MPSCore,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSImage.framework/MPSImage,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSNeuralNetwork.framework/MPSNeuralNetwork,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSMatrix.framework/MPSMatrix,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSRayIntersector.framework/MPSRayIntersector,/System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSNDArray.framework/MPSNDArray,/System/Library/PrivateFrameworks/AudioToolboxCore.framework/AudioToolboxCore,/System/Library/PrivateFrameworks/caulk.framework/caulk,/usr/lib/libAudioToolboxUtility.dylib,/System/Library/PrivateFrameworks/CorePhoneNumbers.framework/CorePhoneNumbers,/System/Library/PrivateFrameworks/MediaExperience.framework/MediaExperience,/System/Library/PrivateFrameworks/TextureIO.framework/TextureIO,/System/Library/PrivateFrameworks/CoreSVG.framework/CoreSVG,/System/Library/PrivateFrameworks/InternationalSupport.framework/InternationalSupport,/System/Library/PrivateFrameworks/CoreUtils.framework/CoreUtils,/System/Library/PrivateFrameworks/IconServices.framework/IconServices,/System/Library/PrivateFrameworks/UIFoundation.framework/UIFoundation,/System/Library/Frameworks/PushKit.framework/PushKit,/System/Library/PrivateFrameworks/XCTTargetBootstrap.framework/XCTTargetBootstrap,/System/Library/PrivateFrameworks/WebKitLegacy.framework/WebKitLegacy,/System/Library/PrivateFrameworks/SAObjects.framework/SAObjects,/System/Library/PrivateFrameworks/HangTracer.framework/HangTracer,/System/Library/PrivateFrameworks/SignpostMetrics.framework/SignpostMetrics,/System/Library/PrivateFrameworks/PointerUIServices.framework/PointerUIServices,/System/Library/PrivateFrameworks/StudyLog.framework/StudyLog,/System/Library/PrivateFrameworks/CoreMaterial.framework/CoreMaterial,/usr/lib/libapp_launch_measurement.dylib,/System/Library/Frameworks/UserNotifications.framework/UserNotifications,/System/Library/PrivateFrameworks/MobileAsset.framework/MobileAsset,/System/Library/PrivateFrameworks/PhysicsKit.framework/PhysicsKit,/System/Library/PrivateFrameworks/PrototypeTools.framework/PrototypeTools,/System/Library/PrivateFrameworks/TextInput.framework/TextInput,/System/Library/PrivateFrameworks/UIKitServices.framework/UIKitServices,/System/Library/Frameworks/JavaScriptCore.framework/JavaScriptCore,/System/Library/PrivateFrameworks/WebCore.framework/WebCore,/System/Library/PrivateFrameworks/WebCore.framework/Frameworks/libwebrtc.dylib,/System/Library/PrivateFrameworks/URLFormatting.framework/URLFormatting,/System/Library/Frameworks/AudioToolbox.framework/AudioToolbox,/System/Library/PrivateFrameworks/TCC.framework/TCC,/usr/lib/libAudioStatistics.dylib,/System/Library/PrivateFrameworks/perfdata.framework/perfdata,/usr/lib/libperfcheck.dylib,/System/Library/PrivateFrameworks/StreamingZip.framework/StreamingZip,/System/Library/Frameworks/Accounts.framework/Accounts,/System/Library/PrivateFrameworks/GenerationalStorage.framework/GenerationalStorage,/System/Library/PrivateFrameworks/SymptomDiagnosticReporter.framework/SymptomDiagnosticReporter,/System/Library/PrivateFrameworks/UserManagement.framework/UserManagement,/System/Library/Frameworks/CoreData.framework/CoreData,/System/Library/PrivateFrameworks/ChunkingLibrary.framework/ChunkingLibrary,/System/Library/PrivateFrameworks/ManagedConfiguration.framework/ManagedConfiguration,/System/Library/PrivateFrameworks/AppleAccount.framework/AppleAccount,/usr/lib/liblockdown.dylib,/usr/lib/libmis.dylib,/System/Library/PrivateFrameworks/Netrb.framework/Netrb,/System/Library/PrivateFrameworks/DataMigration.framework/DataMigration,/System/Library/PrivateFrameworks/DeviceIdentity.framework/DeviceIdentity,/System/Library/PrivateFrameworks/SetupAssistant.framework/SetupAssistant,/System/Library/PrivateFrameworks/AppleIDSSOAuthentication.framework/AppleIDSSOAuthentication,/System/Library/PrivateFrameworks/AccountSettings.framework/AccountSettings,/System/Library/PrivateFrameworks/ApplePushService.framework/ApplePushService,/System/Library/PrivateFrameworks/AuthKit.framework/AuthKit,/System/Library/PrivateFrameworks/CoreFollowUp.framework/CoreFollowUp,/System/Library/PrivateFrameworks/SetupAssistantSupport.framework/SetupAssistantSupport,/System/Library/PrivateFrameworks/MobileBackup.framework/MobileBackup,/System/Library/PrivateFrameworks/CoreTime.framework/CoreTime,/System/Library/PrivateFrameworks/IntlPreferences.framework/IntlPreferences,/System/Library/PrivateFrameworks/NanoPreferencesSync.framework/NanoPreferencesSync,/System/Library/PrivateFrameworks/NanoRegistry.framework/NanoRegistry,/System/Library/PrivateFrameworks/AppConduit.framework/AppConduit,/System/Library/Frameworks/LocalAuthentication.framework/LocalAuthentication,/System/Library/PrivateFrameworks/AppleIDAuthSupport.framework/AppleIDAuthSupport,/System/Library/PrivateFrameworks/PhoneNumbers.framework/PhoneNumbers,/System/Library/Frameworks/LocalAuthentication.framework/Support/SharedUtils.framework/SharedUtils,/System/Library/PrivateFrameworks/Rapport.framework/Rapport,/System/Library/PrivateFrameworks/MobileDeviceLink.framework/MobileDeviceLink,/System/Library/PrivateFrameworks/AccountsDaemon.framework/AccountsDaemon,/System/Library/Frameworks/GSS.framework/GSS,/System/Library/PrivateFrameworks/IDS.framework/IDS,/System/Library/PrivateFrameworks/WirelessDiagnostics.framework/WirelessDiagnostics,/System/Library/PrivateFrameworks/OAuth.framework/OAuth,/usr/lib/libheimdal-asn1.dylib,/System/Library/PrivateFrameworks/Heimdal.framework/Heimdal,/System/Library/PrivateFrameworks/CommonAuth.framework/CommonAuth,/System/Library/PrivateFrameworks/Marco.framework/Marco,/System/Library/PrivateFrameworks/IMFoundation.framework/IMFoundation,/System/Library/PrivateFrameworks/IDSFoundation.framework/IDSFoundation,/System/Library/PrivateFrameworks/Engram.framework/Engram,/usr/lib/libtidy.A.dylib,/System/Library/Frameworks/CoreBluetooth.framework/CoreBluetooth,/usr/lib/libAWDSupportFramework.dylib,/usr/lib/libAWDSupport.dylib,/usr/lib/libprotobuf-lite.dylib,/usr/lib/libprotobuf.dylib,/System/Library/PrivateFrameworks/CorePrediction.framework/CorePrediction,/System/Library/Frameworks/PDFKit.framework/PDFKit,/System/Library/PrivateFrameworks/SafariSafeBrowsing.framework/SafariSafeBrowsing,/System/Library/PrivateFrameworks/CoreOptimization.framework/CoreOptimization,/System/Library/PrivateFrameworks/DataDetectorsCore.framework/DataDetectorsCore,/System/Library/PrivateFrameworks/CorePDF.framework/CorePDF,/System/Library/PrivateFrameworks/RevealCore.framework/RevealCore,/System/Library/PrivateFrameworks/CoreNLP.framework/CoreNLP,/System/Library/PrivateFrameworks/AppleFSCompression.framework/AppleFSCompression,/usr/lib/libmecab.dylib,/usr/lib/libgermantok.dylib,/usr/lib/libThaiTokenizer.dylib,/usr/lib/libChineseTokenizer.dylib,/System/Library/PrivateFrameworks/LanguageModeling.framework/LanguageModeling,/System/Library/PrivateFrameworks/CoreEmoji.framework/CoreEmoji,/System/Library/PrivateFrameworks/LinguisticData.framework/LinguisticData,/System/Library/PrivateFrameworks/Lexicon.framework/Lexicon,/usr/lib/libcmph.dylib,/System/Library/Frameworks/NaturalLanguage.framework/NaturalLanguage,/System/Library/Frameworks/CoreML.framework/CoreML,/System/Library/PrivateFrameworks/Montreal.framework/Montreal,/System/Library/PrivateFrameworks/DuetActivityScheduler.framework/DuetActivityScheduler,/System/Library/PrivateFrameworks/Espresso.framework/Espresso,/System/Library/PrivateFrameworks/CoreDuet.framework/CoreDuet,/System/Library/PrivateFrameworks/CoreDuetContext.framework/CoreDuetContext,/System/Library/PrivateFrameworks/CoreDuetDebugLogging.framework/CoreDuetDebugLogging,/System/Library/Frameworks/CloudKit.framework/CloudKit,/System/Library/Frameworks/Intents.framework/Intents,/System/Library/PrivateFrameworks/CoreDuetDaemonProtocol.framework/CoreDuetDaemonProtocol,/System/Library/PrivateFrameworks/C2.framework/C2,/System/Library/PrivateFrameworks/ProtectedCloudStorage.framework/ProtectedCloudStorage,/System/Library/Frameworks/NetworkExtension.framework/NetworkExtension,/usr/lib/libnetworkextension.dylib,/System/Library/PrivateFrameworks/GeoServices.framework/GeoServices,/System/Library/PrivateFrameworks/LocationSupport.framework/LocationSupport,/System/Library/PrivateFrameworks/CoreLocationProtobuf.framework/CoreLocationProtobuf,/System/Library/PrivateFrameworks/IntentsFoundation.framework/IntentsFoundation,/System/Library/PrivateFrameworks/AppleNeuralEngine.framework/AppleNeuralEngine,/System/Library/PrivateFrameworks/ANECompiler.framework/ANECompiler,/System/Library/Frameworks/MediaToolbox.framework/MediaToolbox,/System/Library/PrivateFrameworks/ANEServices.framework/ANEServices,/usr/lib/libsandbox.1.dylib,/usr/lib/libMatch.1.dylib,/System/Library/PrivateFrameworks/CoreAUC.framework/CoreAUC,/System/Library/Frameworks/CoreHaptics.framework/CoreHaptics,/System/Library/PrivateFrameworks/NetworkStatistics.framework/NetworkStatistics,/System/Library/PrivateFrameworks/CTCarrierSpace.framework/CTCarrierSpace,/Developer/Library/PrivateFrameworks/DebugHierarchyFoundation.framework/DebugHierarchyFoundation,/System/Library/Frameworks/GLKit.framework/GLKit,/System/Library/Frameworks/SceneKit.framework/SceneKit,/System/Library/Frameworks/MapKit.framework/MapKit,/System/Library/Frameworks/ModelIO.framework/ModelIO,/System/Library/Frameworks/AVFoundation.framework/AVFoundation,/System/Library/Frameworks/MetalKit.framework/MetalKit,/System/Library/Frameworks/AVFoundation.framework/Frameworks/AVFAudio.framework/AVFAudio,/System/Library/PrivateFrameworks/Celestial.framework/Celestial,/System/Library/PrivateFrameworks/Quagga.framework/Quagga,/System/Library/Frameworks/CoreMotion.framework/CoreMotion,/System/Library/Frameworks/ContactsUI.framework/ContactsUI,/System/Library/Frameworks/Contacts.framework/Contacts,/System/Library/PrivateFrameworks/SearchFoundation.framework/SearchFoundation,/System/Library/PrivateFrameworks/Navigation.framework/Navigation,/System/Library/PrivateFrameworks/VectorKit.framework/VectorKit,/System/Library/PrivateFrameworks/AddressBookLegacy.framework/AddressBookLegacy,/System/Library/PrivateFrameworks/AppSupportUI.framework/AppSupportUI,/System/Library/PrivateFrameworks/DataAccessExpress.framework/DataAccessExpress,/System/Library/PrivateFrameworks/PersonaKit.framework/PersonaKit,/System/Library/PrivateFrameworks/PersonaUI.framework/PersonaUI,/System/Library/Frameworks/CoreSpotlight.framework/CoreSpotlight,/System/Library/PrivateFrameworks/CommunicationsFilter.framework/CommunicationsFilter,/System/Library/PrivateFrameworks/ContactsDonation.framework/ContactsDonation,/System/Library/PrivateFrameworks/ContactsFoundation.framework/ContactsFoundation,/System/Library/PrivateFrameworks/ContactsUICore.framework/ContactsUICore,/System/Library/PrivateFrameworks/FamilyCircle.framework/FamilyCircle,/System/Library/PrivateFrameworks/OnBoardingKit.framework/OnBoardingKit,/System/Library/PrivateFrameworks/TelephonyUtilities.framework/TelephonyUtilities,/System/Library/PrivateFrameworks/vCard.framework/vCard,/System/Library/PrivateFrameworks/MetadataUtilities.framework/MetadataUtilities,/System/Library/PrivateFrameworks/CellularPlanManager.framework/CellularPlanManager,/System/Library/Frameworks/ClassKit.framework/ClassKit,/System/Library/PrivateFrameworks/CoreSuggestions.framework/CoreSuggestions,/System/Library/PrivateFrameworks/CloudDocs.framework/CloudDocs,/System/Library/Frameworks/QuickLookThumbnailing.framework/QuickLookThumbnailing,/System/Library/PrivateFrameworks/MobileSpotlightIndex.framework/MobileSpotlightIndex,/usr/lib/libprequelite.dylib,/System/Library/PrivateFrameworks/ProactiveEventTracker.framework/ProactiveEventTracker,/System/Library/PrivateFrameworks/ProactiveSupport.framework/ProactiveSupport,/System/Library/PrivateFrameworks/DataDetectorsNaturalLanguage.framework/DataDetectorsNaturalLanguage,/System/Library/PrivateFrameworks/InternationalTextSearch.framework/InternationalTextSearch,/System/Library/Frameworks/EventKit.framework/EventKit,/System/Library/PrivateFrameworks/ResponseKit.framework/ResponseKit,/System/Library/PrivateFrameworks/CalendarDaemon.framework/CalendarDaemon,/System/Library/PrivateFrameworks/CalendarDatabase.framework/CalendarDatabase,/System/Library/PrivateFrameworks/CalendarFoundation.framework/CalendarFoundation,/System/Library/PrivateFrameworks/iCalendar.framework/iCalendar,/System/Library/PrivateFrameworks/BackgroundTaskAgent.framework/BackgroundTaskAgent,/System/Library/PrivateFrameworks/CoreDAV.framework/CoreDAV,/System/Library/PrivateFrameworks/NLP.framework/NLP,/System/Library/PrivateFrameworks/CoreRecents.framework/CoreRecents,/System/Library/PrivateFrameworks/StoreServices.framework/StoreServices,/System/Library/PrivateFrameworks/AppleMediaServices.framework/AppleMediaServices,/System/Library/Frameworks/CryptoTokenKit.framework/CryptoTokenKit,/System/Library/PrivateFrameworks/IncomingCallFilter.framework/IncomingCallFilter,/System/Library/PrivateFrameworks/Pasteboard.framework/Pasteboard,/var/mobile/Containers/Data/Application/5F973204-98B2-4E37-BB59-ECF4BB01D3CF/Library/Cookies/Cookies.binarycookies,/Library/MobileSubstrate/DynamicLibraries/CGDevice_BACKUP_13488.dylib,/Library/MobileSubstrate/DynamicLibraries/CGDevice_BASE_13488.dylib,/Library/MobileSubstrate/DynamicLibraries/CGDevice_LOCAL_13488.dylib,/Library/MobileSubstrate/DynamicLibraries/CGDevice_REMOTE_13488.dylib,/Library/MobileSubstrate/DynamicLibraries/MobileSafety.dylib,/Library/MobileSubstrate/DynamicLibraries/afc2dService.dylib,/Library/MobileSubstrate/DynamicLibraries/afc2dSupport.dylib,/System/Library/PrivateFrameworks/AppSSOCore.framework/AppSSOCore,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app,/usr/share/icu/icudt64l.dat,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/en.lproj,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/Base.lproj,/Library/Preferences/com.apple.networkd.plist,/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist,/System/Library/CoreServices/SystemVersion.plist,/System/Library/CoreServices/SystemVersion.bundle,/usr/lib/libUIKit.dylib,/System/Library/Frameworks/CFNetwork.framework,/usr/lib/libobjc-trampolines.dylib,/System/Library/Frameworks/CFNetwork.framework/Info.plist,/System/Library/Frameworks/CFNetwork.framework/,/var/mobile/Containers/Data/Application/5F973204-98B2-4E37-BB59-ECF4BB01D3CF,/var/mobile/Containers/Data/Application/5F973204-98B2-4E37-BB59-ECF4BB01D3CF/Documents/FMDeviceCrashCatch_Exception_v1.txt,/System/Library/Frameworks/CFNetwork.framework//en.lproj,/System/Library/Frameworks/CFNetwork.framework//Base.lproj,/System/Library/Frameworks/CFNetwork.framework/en.lproj/Localizable.strings,/var/mobile/Containers/Data/Application/5F973204-98B2-4E37-BB59-ECF4BB01D3CF/Library,/var/mobile/Containers/Data/Application/5F973204-98B2-4E37-BB59-ECF4BB01D3CF/Library/Saved Application State/com.devicetool.MYTong.savedState/KnownSceneSessions/data.data,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/Base.lproj/Main.storyboardc/Info-8.0+.plist,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/Base.lproj/Main.storyboardc/Info.plist,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/Main.storyboardc,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/en.lproj/Main.storyboardc,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/Base.lproj/Main.storyboardc,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/Base.lproj/Main.storyboardc/UIViewController-BYZ-38-t0r.nib,/var/mobile/Containers/Data/Application/5F973204-98B2-4E37-BB59-ECF4BB01D3CF/Documents/.cache1,/System,/System/Library,/System/Library/CoreServices,/System/Library/CoreServices/CoreGlyphs.bundle,/System/Library/CoreServices/CoreGlyphs.bundle/Info.plist,/System/Library/PrivateFrameworks,/System/Library/PrivateFrameworks/UIKitCore.framework,/System/Library/PrivateFrameworks/UIKitCore.framework/Info.plist,/System/Library/CoreServices/CoreGlyphs.bundle/,/System/Library/CoreServices/CoreGlyphs.bundle//en.lproj,/System/Library/CoreServices/CoreGlyphs.bundle//Base.lproj,/System/Library/CoreServices/CoreGlyphs.bundle/name_aliases.strings,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/.meta,/System/Library/CoreServices/CoreGlyphs.bundle/Assets.car,/var/mobile/Library/Fonts/AddedFontCache.plist,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/Base.lproj/Main.storyboardc/BYZ-38-t0r-view-8bC-Xf-vdC.nib,/System/Library/Fonts/CoreUI/SFUI.ttf,/var/mobile/Containers/Data/Application/5F973204-98B2-4E37-BB59-ECF4BB01D3CF/Documents,/System/Library/Caches/apticket.der,/Library/Managed Preferences/mobile/com.apple.SystemConfiguration.plist,/var/db/timezone/localtime,,/var,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/embedded.mobileprovision,/var/containers/Bundle/Application/B1E33F00-3AF4-488A-BDEF-0DF90EB84744/MYTongDunTest.app/_CodeSignature/CodeResources,/var/mobile/Library/Caches/com.apple.itunesstored/url-resolution.plist,/System/Library/PrivateFrameworks/CoreServicesInternal.framework/CoreServicesInternal,/var/mobile/Library/Caches/com.apple.keyboards/version,/var/mobile/Library/Caches/GeoServices/SearchAttribution.pbd,/var/db/timezone/zoneinfo/,/var/db/timezone/zoneinfo/+VERSION,/var/db/timezone/zoneinfo/Africa,/var/db/timezone/zoneinfo/Africa/,/var/db/timezone/zoneinfo/Africa/Abidjan,/var/db/timezone/zoneinfo/Africa/Accra,/var/db/timezone/zoneinfo/Africa/Addis_Ababa,/var/db/timezone/zoneinfo/Africa/Algiers,/var/db/timezone/zoneinfo/Africa/Asmara,/var/db/timezone/zoneinfo/Africa/Asmera,/var/db/timezone/zoneinfo/Africa/Bamako,/var/db/timezone/zoneinfo/Africa/Bangui,/var/db/timezone/zoneinfo/Africa/Banjul,/var/db/timezone/zoneinfo/Africa/Bissau,/var/db/timezone/zoneinfo/Africa/Blantyre,/var/db/timezone/zoneinfo/Africa/Brazzaville,/var/db/timezone/zoneinfo/Africa/Bujumbura,/var/db/timezone/zoneinfo/Africa/Cairo,/var/db/timezone/zoneinfo/Africa/Casablanca,/var/db/timezone/zoneinfo/Africa/Ceuta,/var/db/timezone/zoneinfo/Africa/Conakry,/var/db/timezone/zoneinfo/Africa/Dakar,/var/db/timezone/zoneinfo/Africa/Dar_es_Salaam,/var/db/timezone/zoneinfo/Africa/Djibouti,/var/db/timezone/zoneinfo/Africa/Douala,/var/db/timezone/zoneinfo/Africa/El_Aaiun,/var/db/timezone/zoneinfo/Africa/Freetown,/var/db/timezone/zoneinfo/Africa/Gaborone,/var/db/timezone/zoneinfo/Africa/Harare,/var/db/timezone/zoneinfo/Africa/Johannesburg,/var/db/timezone/zoneinfo/Africa/Juba,/var/db/timezone/zoneinfo/Africa/Kampala,/var/db/timezone/zoneinfo/Africa/Khartoum,/var/db/timezone/zoneinfo/Africa/Kigali,/var/db/timezone/zoneinfo/Africa/Kinshasa,/var/db/timezone/zoneinfo/Africa/Lagos,/var/db/timezone/zoneinfo/Africa/Libreville,/var/db/timezone/zoneinfo/Africa/Lome,/var/db/timezone/zoneinfo/Africa/Luanda,/var/db/timezone/zoneinfo/Africa/Lubumbashi,/var/db/timezone/zoneinfo/Africa/Lusaka,/var/db/timezone/zoneinfo/Africa/Malabo,/var/db/timezone/zoneinfo/Africa/Maputo,/var/db/timezone/zoneinfo/Africa/Maseru,/var/db/timezone/zoneinfo/Africa/Mbabane,/var/db/timezone/zoneinfo/Africa/Mogadishu,/var/db/timezone/zoneinfo/Africa/Monrovia,/var/db/timezone/zoneinfo/Africa/Nairobi,/var/db/timezone/zoneinfo/Africa/Ndjamena,/var/db/timezone/zoneinfo/Africa/Niamey,/var/db/timezone/zoneinfo/Africa/Nouakchott,/var/db/timezone/zoneinfo/Africa/Ouagadougou,/var/db/timezone/zoneinfo/Africa/Porto-Novo,/var/db/timezone/zoneinfo/Africa/Sao_Tome,/var/db/timezone/zoneinfo/Africa/Timbuktu,/var/db/timezone/zoneinfo/Africa/Tripoli,/var/db/timezone/zoneinfo/Africa/Tunis,/var/db/timezone/zoneinfo/Africa/Windhoek,/var/db/timezone/zoneinfo/America,/var/db/timezone/zoneinfo/America/,/var/db/timezone/zoneinfo/America/Adak,/var/db/timezone/zoneinfo/America/Anchorage,/var/db/timezone/zoneinfo/America/Anguilla,/var/db/timezone/zoneinfo/America/Antigua,/var/db/timezone/zoneinfo/America/Araguaina,/var/db/timezone/zoneinfo/America/Argentina,/var/db/timezone/zoneinfo/America/Argentina/,/var/db/timezone/zoneinfo/America/Argentina/Buenos_Aires,/var/db/timezone/zoneinfo/America/Argentina/Catamarca,/var/db/timezone/zoneinfo/America/Argentina/ComodRivadavia,/var/db/timezone/zoneinfo/America/Argentina/Cordoba,/var/db/timezone/zoneinfo/America/Argentina/Jujuy,/var/db/timezone/zoneinfo/America/Argentina/La_Rioja,/var/db/timezone/zoneinfo/America/Argentina/Mendoza,/var/db/timezone/zoneinfo/America/Argentina/Rio_Gallegos,/var/db/timezone/zoneinfo/America/Argentina/Salta,/var/db/timezone/zoneinfo/America/Argentina/San_Juan,/var/db/timezone/zoneinfo/America/Argentina/San_Luis,/var/db/timezone/zoneinfo/America/Argentina/Tucuman,/var/db/timezone/zoneinfo/America/Argentina/Ushuaia,/var/db/timezone/zoneinfo/America/Aruba,/var/db/timezone/zoneinfo/America/Asuncion,/var/db/timezone/zoneinfo/America/Atikokan,/var/db/timezone/zoneinfo/America/Atka,/var/db/timezone/zoneinfo/America/Bahia,/var/db/timezone/zoneinfo/America/Bahia_Banderas,/var/db/timezone/zoneinfo/America/Barbados,/var/db/timezone/zoneinfo/America/Belem,/var/db/timezone/zoneinfo/America/Belize,/var/db/timezone/zoneinfo/America/Blanc-Sablon,/var/db/timezone/zoneinfo/America/Boa_Vista,/var/db/timezone/zoneinfo/America/Bogota,/var/db/timezone/zoneinfo/America/Boise,/var/db/timezone/zoneinfo/America/Buenos_Aires,/var/db/timezone/zoneinfo/America/Cambridge_Bay,/var/db/timezone/zoneinfo/America/Campo_Grande,/var/db/timezone/zoneinfo/America/Cancun,/var/db/timezone/zoneinfo/America/Caracas,/var/db/timezone/zoneinfo/America/Catamarca,/var/db/timezone/zoneinfo/America/Cayenne,/var/db/timezone/zoneinfo/America/Cayman,/var/db/timezone/zoneinfo/America/Chicago,/var/db/timezone/zoneinfo/America/Chihuahua,/var/db/timezone/zoneinfo/America/Coral_Harbour,/var/db/timezone/zoneinfo/America/Cordoba,/var/db/timezone/zoneinfo/America/Costa_Rica,/var/db/timezone/zoneinfo/America/Creston,/var/db/timezone/zoneinfo/America/Cuiaba,/var/db/timezone/zoneinfo/America/Curacao,/var/db/timezone/zoneinfo/America/Danmarkshavn,/var/db/timezone/zoneinfo/America/Dawson,/var/db/timezone/zoneinfo/America/Dawson_Creek,/var/db/timezone/zoneinfo/America/Denver,/var/db/timezone/zoneinfo/America/Detroit,/var/db/timezone/zoneinfo/America/Dominica,/var/db/timezone/zoneinfo/America/Edmonton,/var/db/timezone/zoneinfo/America/Eirunepe,/var/db/timezone/zoneinfo/America/El_Salvador,/var/db/timezone/zoneinfo/America/Ensenada,/var/db/timezone/zoneinfo/America/Fort_Nelson,/var/db/timezone/zoneinfo/America/Fort_Wayne,/var/db/timezone/zoneinfo/America/Fortaleza,/var/db/timezone/zoneinfo/America/Glace_Bay,/var/db/timezone/zoneinfo/America/Godthab,/var/db/timezone/zoneinfo/America/Goose_Bay,/var/db/timezone/zoneinfo/America/Grand_Turk,/var/db/timezone/zoneinfo/America/Grenada,/var/db/timezone/zoneinfo/America/Guadeloupe,/var/db/timezone/zoneinfo/America/Guatemala,/var/db/timezone/zoneinfo/America/Guayaquil,/var/db/timezone/zoneinfo/America/Guyana,/var/db/timezone/zoneinfo/America/Halifax,/var/db/timezone/zoneinfo/America/Havana,/var/db/timezone/zoneinfo/America/Hermosillo,/var/db/timezone/zoneinfo/America/Indiana,/var/db/timezone/zoneinfo/America/Indiana/,/var/db/timezone/zoneinfo/America/Indiana/Indianapolis,/var/db/timezone/zoneinfo/America/Indiana/Knox,/var/db/timezone/zoneinfo/America/Indiana/Marengo,/var/db/timezone/zoneinfo/America/Indiana/Petersburg,/var/db/timezone/zoneinfo/America/Indiana/Tell_City,/var/db/timezone/zoneinfo/America/Indiana/Vevay,/var/db/timezone/zoneinfo/America/Indiana/Vincennes,/var/db/timezone/zoneinfo/America/Indiana/Winamac,/var/db/timezone/zoneinfo/America/Indianapolis,/var/db/timezone/zoneinfo/America/Inuvik,/var/db/timezone/zoneinfo/America/Iqaluit,/var/db/timezone/zoneinfo/America/Jamaica,/var/db/timezone/zoneinfo/America/Jujuy,/var/db/timezone/zoneinfo/America/Juneau,/var/db/timezone/zoneinfo/America/Kentucky,/var/db/timezone/zoneinfo/America/Kentucky/,/var/db/timezone/zoneinfo/America/Kentucky/Louisville,/var/db/timezone/zoneinfo/America/Kentucky/Monticello,/var/db/timezone/zoneinfo/America/Knox_IN,/var/db/timezone/zoneinfo/America/Kralendijk,/var/db/timezone/zoneinfo/America/La_Paz,/var/db/timezone/zoneinfo/America/Lima,/var/db/timezone/zoneinfo/America/Los_Angeles,/var/db/timezone/zoneinfo/America/Louisville,/var/db/timezone/zoneinfo/America/Lower_Princes,/var/db/timezone/zoneinfo/America/Maceio,/var/db/timezone/zoneinfo/America/Managua,/var/db/timezone/zoneinfo/America/Manaus,/var/db/timezone/zoneinfo/America/Marigot,/var/db/timezone/zoneinfo/America/Martinique,/var/db/timezone/zoneinfo/America/Matamoros,/var/db/timezone/zoneinfo/America/Mazatlan,/var/db/timezone/zoneinfo/America/Mendoza,/var/db/timezone/zoneinfo/America/Menominee,/var/db/timezone/zoneinfo/America/Merida,/var/db/timezone/zoneinfo/America/Metlakatla,/var/db/timezone/zoneinfo/America/Mexico_City,/var/db/timezone/zoneinfo/America/Miquelon,/var/db/timezone/zoneinfo/America/Moncton,/var/db/timezone/zoneinfo/America/Monterrey,/var/db/timezone/zoneinfo/America/Montevideo,/var/db/timezone/zoneinfo/America/Montreal,/var/db/timezone/zoneinfo/America/Montserrat,/var/db/timezone/zoneinfo/America/Nassau,/var/db/timezone/zoneinfo/America/New_York,/var/db/timezone/zoneinfo/America/Nipigon,/var/db/timezone/zoneinfo/America/Nome,/var/db/timezone/zoneinfo/America/Noronha,/var/db/timezone/zoneinfo/America/North_Dakota,/var/db/timezone/zoneinfo/America/North_Dakota/,/var/db/timezone/zoneinfo/America/North_Dakota/Beulah,/var/db/timezone/zoneinfo/America/North_Dakota/Center,/var/db/timezone/zoneinfo/America/North_Dakota/New_Salem,/var/db/timezone/zoneinfo/America/Ojinaga,/var/db/timezone/zoneinfo/America/Panama,/var/db/timezone/zoneinfo/America/Pangnirtung,/var/db/timezone/zoneinfo/America/Paramaribo,/var/db/timezone/zoneinfo/America/Phoenix,/var/db/timezone/zoneinfo/America/Port-au-Prince,/var/db/timezone/zoneinfo/America/Port_of_Spain,/var/db/timezone/zoneinfo/America/Porto_Acre,/var/db/timezone/zoneinfo/America/Porto_Velho,/var/db/timezone/zoneinfo/America/Puerto_Rico,/var/db/timezone/zoneinfo/America/Punta_Arenas,/var/db/timezone/zoneinfo/America/Rainy_River,/var/db/timezone/zoneinfo/America/Rankin_Inlet,/var/db/timezone/zoneinfo/America/Recife,/var/db/timezone/zoneinfo/America/Regina,/var/db/timezone/zoneinfo/America/Resolute,/var/db/timezone/zoneinfo/America/Rio_Branco,/var/db/timezone/zoneinfo/America/Rosario,/var/db/timezone/zoneinfo/America/Santa_Isabel,/var/db/timezone/zoneinfo/America/Santarem,/var/db/timezone/zoneinfo/America/Santiago,/var/db/timezone/zoneinfo/America/Santo_Domingo,/var/db/timezone/zoneinfo/America/Sao_Paulo,/var/db/timezone/zoneinfo/America/Scoresbysund,/var/db/timezone/zoneinfo/America/Shiprock,/var/db/timezone/zoneinfo/America/Sitka,/var/db/timezone/zoneinfo/America/St_Barthelemy,/var/db/timezone/zoneinfo/America/St_Johns,/var/db/timezone/zoneinfo/America/St_Kitts,/var/db/timezone/zoneinfo/America/St_Lucia,/var/db/timezone/zoneinfo/America/St_Thomas,/var/db/timezone/zoneinfo/America/St_Vincent,/var/db/timezone/zoneinfo/America/Swift_Current,/var/db/timezone/zoneinfo/America/Tegucigalpa,/var/db/timezone/zoneinfo/America/Thule,/var/db/timezone/zoneinfo/America/Thunder_Bay,/var/db/timezone/zoneinfo/America/Tijuana,/var/db/timezone/zoneinfo/America/Toronto,/var/db/timezone/zoneinfo/America/Tortola,/var/db/timezone/zoneinfo/America/Vancouver,/var/db/timezone/zoneinfo/America/Virgin,/var/db/timezone/zoneinfo/America/Whitehorse,/var/db/timezone/zoneinfo/America/Winnipeg,/var/db/timezone/zoneinfo/America/Yakutat,/var/db/timezone/zoneinfo/America/Yellowknife,/var/db/timezone/zoneinfo/Antarctica,/var/db/timezone/zoneinfo/Antarctica/,/var/db/timezone/zoneinfo/Antarctica/Casey,/var/db/timezone/zoneinfo/Antarctica/Davis,/var/db/timezone/zoneinfo/Antarctica/DumontDUrville,/var/db/timezone/zoneinfo/Antarctica/Macquarie,/var/db/timezone/zoneinfo/Antarctica/Mawson,/var/db/timezone/zoneinfo/Antarctica/McMurdo,/var/db/timezone/zoneinfo/Antarctica/Palmer,/var/db/timezone/zoneinfo/Antarctica/Rothera,/var/db/timezone/zoneinfo/Antarctica/South_Pole,/var/db/timezone/zoneinfo/Antarctica/Syowa,/var/db/timezone/zoneinfo/Antarctica/Troll,/var/db/timezone/zoneinfo/Antarctica/Vostok,/var/db/timezone/zoneinfo/Arctic,/var/db/timezone/zoneinfo/Arctic/,/var/db/timezone/zoneinfo/Arctic/Longyearbyen,/var/db/timezone/zoneinfo/Asia,/var/db/timezone/zoneinfo/Asia/,/var/db/timezone/zoneinfo/Asia/Aden,/var/db/timezone/zoneinfo/Asia/Almaty,/var/db/timezone/zoneinfo/Asia/Amman,/var/db/timezone/zoneinfo/Asia/Anadyr,/var/db/timezone/zoneinfo/Asia/Aqtau,/var/db/timezone/zoneinfo/Asia/Aqtobe,/var/db/timezone/zoneinfo/Asia/Ashgabat,/var/db/timezone/zoneinfo/Asia/Ashkhabad,/var/db/timezone/zoneinfo/Asia/Atyrau,/var/db/timezone/zoneinfo/Asia/Baghdad,/var/db/timezone/zoneinfo/Asia/Bahrain,/var/db/timezone/zoneinfo/Asia/Baku,/var/db/timezone/zoneinfo/Asia/Bangkok,/var/db/timezone/zoneinfo/Asia/Barnaul,/var/db/timezone/zoneinfo/Asia/Beirut,/var/db/timezone/zoneinfo/Asia/Bishkek,/var/db/timezone/zoneinfo/Asia/Brunei,/var/db/timezone/zoneinfo/Asia/Calcutta,/var/db/timezone/zoneinfo/Asia/Chita,/var/db/timezone/zoneinfo/Asia/Choibalsan,/var/db/timezone/zoneinfo/Asia/Chongqing,/var/db/timezone/icutz,/var/mobile/Library/Caches/Checkpoint.plist,/var/Managed Preferences/mobile/.GlobalPreferences.plist,/var/Managed Preferences/mobile/com.apple.webcontentfilter.plist,/var/mobile,/System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64,/System/Library/Caches/com.apple.dyld/dyld_shared_cache_armv7s,/System/Library/Caches/fps/lskd.rl,/var/mobile/Library/Caches/DateFormats.plist,/var/mobile/Library/Caches/GeoServices/Resources/altitude-551.xml,/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1.png,/var/mobile/Library/Caches/GeoServices/Resources/autonavi-1@2x.png,/var/mobile/Library/Caches/GeoServices/Resources/supportedCountriesDirections-12.plist,/etc/group,/etc/hosts,/etc/passwd,/System/Library/Backup/Domains.plist,/System/Library/Spotlight/domains.plist,/Library/Managed Preferences/mobile/.GlobalPreferences.plist,/System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm64e,/System/Library/PrivateFrameworks/AppSupport.framework/Info.plist,/System/Library/Filesystems/hfs.fs/Info.plist,/System/Library/CoreServices/powerd.bundle/Info.plist,/System/Library/Lockdown/iPhoneDeviceCA.pem,/System/Library/Lockdown/iPhoneDebug.pem,/System/Library/LaunchDaemons/com.apple.powerd.plist,/System/Library/LaunchDaemons/bootps.plist,/var/wireless/Library/LASD/lasdcdma.db,/var/wireless/Library/LASD/lasdgsm.db,/var/wireless/Library/LASD/lasdlte.db,/var/wireless/Library/LASD/lasdscdma.db,/var/wireless/Library/LASD/lasdumts.db,/var/run/printd,/var/run/syslog,/dev/random,/var/mobile/Library/UserConfigurationProfiles/PublicInfo/MCMeta.plist,/var/mobile/Library/Preferences,/Library/Managed Preferences/mobile/com.apple.webcontentfilter.plist,/var/containers/Data/System/com.apple.geod/.com.apple.mobile_container_manager.metadata.plist,/var/containers/Shared/SystemGroup/systemgroup.com.apple.lsd.iconscache/.com.apple.mobile_container_manager.metadata.plist,/var/mobile/Library/Caches/GeoServices/ActiveTileGroup.pbd,/var/mobile/Library/Caches/GeoServices/Experiments.pbd,/var/mobile/Library/Caches/GeoServices/Resources/DetailedLandCoverPavedArea-1@2x.png,/var/mobile/Library/Caches/GeoServices/Resources/LandCoverGradient16-1@2x.png,/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadHighway-1@2x.png,/var/mobile/Library/Caches/GeoServices/Resources/RealisticRoadLocalRoad-1@2x.png,/var/mobile/Library/Caches/GeoServices/Resources/night-DetailedLandCoverSand-1@2x.png,/var/mobile/Library/Carrier Bundles/Overlay,/var/mobile/Library/Operator Bundle.bundle,/var/mobile/Library,/var/stash,/var/db/stash,/usr/local,/usr,/usr/local/,/private,/var/root,/var/root/,/var/wireless,/Applications/Cydia.app,/Applications,/var/mobile/Library/Caches/com.xxtouch.XXTExplorer,/Applications/AWZ.app,/Applications/NZT.app,/Applications/igvx.app,/Applications/TouchElf.app,/Applications/TouchSprite.app,/Applications/WujiVPN.app,/Applications/RST.app,/Applications/Forge9.app,/Applications/Forge.app,/Applications/GFaker.app,/Applications/hdfakerset.app,/Applications/Pranava.app,/Applications/iG.app,/Applications/HiddenApi.app,/Applications/Xgen.app,/Applications/BirdFaker9.app,/Applications/VPNMasterPro.app,/Applications/GuizmOVPN.app,/Applications/OTRLocation.app,/Applications/rwx.app,/Applications/FakeMyLocation.app,/Applications/anylocation.app,/Applications/location360pro.app,/Applications/xGPS.app,/Applications/007gaiji.app,/Applications/ALS.app,/Applications/AXJ.app,/Applications/serialudid.app,/Applications/BirdFaker.app,/Applications/zorro.app,/Applications/YOY.app,/usr/lib/libusrtcp.dylib,/usr/lib/libboringssl.dylib,/usr/local/lib/log/,/usr/lib/log/,/usr/lib/log/liblog_network.dylib,/Library/Preferences/com.apple.security.plist";
    NSArray *tdArray=  [tdstr componentsSeparatedByString:@","];

    
    NSMutableArray *checkArray = [NSMutableArray new];

    for (NSString *tdstring in tdArray) {
        bool isesit = NO;
        for (NSString *notdstring in notdArray) {
            if ([notdstring isEqualToString:tdstring]) {
                isesit = YES;
                break;
            }
        }
        if (!isesit) {
            [checkArray addObject:tdstring];
        }

    }

        

}
-(void)getDeviceInfoWithblackBox:(NSString *)info{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];   // 请求JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // 响应JSON格式

    [manager.requestSerializer setValue:@"application/json;UTF-8" forHTTPHeaderField:@"Content-Type"];

//    NSString *url = [NSString stringWithFormat:@"--http://114.116.231.177:8091/no/fraudApiInvoker/checkFraud?blackBox=%@&type=2",info];
    NSString *url = [NSString stringWithFormat:@"http://114.116.231.177:8091/no/fraudApiInvoker/checkFraud?"];
    NSDictionary *parameters = @{@"blackBox":info,
                                 @"type": @"2"};
    [manager GET:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功：%@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

@end

