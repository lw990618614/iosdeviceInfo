#import "UserCust.h"
#import <UIKit/UIKit.h>
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <TargetConditionals.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <stdio.h>
#import <dlfcn.h>
#import <sys/types.h>

#import "sys/utsname.h"
#include "AntiMSHookFunctionARM.h"
#include "MSHookFunctionARMCheck.h"
#include "fishhook.h"


static char *JbPaths[] = {"/Applications/Cydia.app",
    "/usr/sbin/sshd",
    "/bin/bash",
//    "/Library/MobileSubstrate",
//    "/User/Applications/"
    
};

static NSSet *sDylibSet ; // 需要检测的动态库
static BOOL SCHECK_USER = NO; /// 检测是否越狱


@implementation UserCust

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sDylibSet  = [NSSet setWithObjects:
                       @"/usr/lib/CepheiUI.framework/CepheiUI",
                       @"/usr/lib/libsubstitute.dylib",
                       @"/usr/lib/substitute-inserter.dylib",
                       @"/usr/lib/substitute-loader.dylib",
                       @"/usr/lib/substrate/SubstrateLoader.dylib",
                       @"/usr/lib/substrate/SubstrateInserter.dylib",
                       @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                  @"/Library/MobileSubstrate/DynamicLibraries/0Shadow.dylib",
                  @"/Library/MobileSubstrate/DynamicLibraries/CGDevice.dylib",
                  nil];
    _dyld_register_func_for_add_image(_check_image);
  });
}

+ (instancetype)sharedInstance {
    
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

// 监听image加载，从这里判断动态库是否加载，因为其他的检测动态库的方案会被hook
static void _check_image(const struct mach_header *header,
                                      intptr_t slide) {
  // hook Image load
//  if (SCHECK_USER) {
//    // 检测后就不在检测
//    return;
//  }

  // 检测的lib
  Dl_info info;
  // 0表示加载失败了，这里大概率是被hook导致的
  if (dladdr(header, &info) == 0) {
    char *dlerro = dlerror();
    // 获取失败了 但是返回了dli_fname, 说明被人hook了，目前看的方案都是直接返回0来绕过的
    if(dlerro == NULL && info.dli_fname != NULL) {
      NSString *libName = [NSString stringWithUTF8String:info.dli_fname];
      // 判断有没有在动态列表里面
      if ([sDylibSet containsObject:libName]) {
        SCHECK_USER = YES;
      }
    }
    return;
  }
}


// 越狱检测
- (BOOL)UVItinitseWithType:(NSString *)type{
  
//    if (SCHECK_USER) {
//      return YES;
//    }
    if (type.intValue == 1) {
        return isStatNotSystemLib();
    }else if (type.intValue == 2){
        return isDebugged();
    }else if (type.intValue == 3){
        return isInjectedWithDynamicLibrary();
    }else if (type.intValue == 4){
        return JCheckKuyt();
    }else if (type.intValue == 5){
        return dyldEnvironmentVariables();

    }else if (type.intValue == 6){
        return checkInject();

    }else if (type.intValue == 7){
        return checkIsExistUnspectClass();

    }else if (type.intValue == 8){
        return checkCanwriteToprivatePath();

    }else if (type.intValue == 9){
        return checkIsEsixtJsBrokensym();

    }else if (type.intValue == 10){
        return checkIscangetAsubprogram();
    }else if (type.intValue == 11){
        return isunameNotSystemLib();
    }else if (type.intValue == 12){
        return isfopenNotSystemLib();
    }else if (type.intValue == 13){
        return isdlsymNotSystemLib();
    }else if (type.intValue == 14){
        return isgetenvNotSystemLib();
    }else if (type.intValue == 15){
        return isdyld_image_countNotSystemLib();
    }





    return NO;
}

CFRunLoopSourceRef gSocketSource;
BOOL fileExist(NSString* path)
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if([fileManager fileExistsAtPath:path isDirectory:&isDirectory]){
        return YES;
    }
    return NO;
}

BOOL directoryExist(NSString* path)
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if([fileManager fileExistsAtPath:path isDirectory:&isDirectory]){
        return YES;
    }
    return NO;
}

BOOL canOpen(NSString* path)
{
    FILE *file = fopen([path UTF8String], "r");
    if(file==nil){
        return fileExist(path) || directoryExist(path);
    }
    fclose(file);
    return YES;
}

#pragma mark 使用NSFileManager通过检测一些越狱后的关键文件是否可以访问来判断是否越狱
// 检测越狱
BOOL JCheckKuyt()
{
    
    if(TARGET_IPHONE_SIMULATOR)return NO;

    //Check cydia URL hook canOpenURL 来绕过
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.avl.com"]])
    {
        return YES;
    }

    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]])
    {
        return YES;
    }

    NSArray* checks = [[NSArray alloc] initWithObjects:@"/Application/Cydia.app",
                       @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                       @"/bin/bash",
                       @"/usr/sbin/sshd",
//                       @"/etc/apt",
                       @"/usr/bin/ssh",
//                       @"/private/var/lib/apt",
//                       @"/private/var/lib/cydia",
//                       @"/private/var/tmp/cydia.log",
                       @"/Applications/WinterBoard.app",
//                       @"/var/lib/cydia",
                       @"/private/etc/dpkg/origins/debian",
                       @"/bin.sh",
//                       @"/private/etc/apt",
                       @"/etc/ssh/sshd_config",
                       @"/private/etc/ssh/sshd_config",
                       @"/Applications/SBSetttings.app",
                       @"/private/var/mobileLibrary/SBSettingsThemes/",
                       @"/private/var/stash",
                       @"/usr/libexec/sftp-server",
//                       @"/usr/libexec/cydia/",
                       @"/usr/sbin/frida-server",
                       @"/usr/bin/cycript",
                       @"/usr/local/bin/cycript",
                       @"/usr/lib/libcycript.dylib",
                       @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                       @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                       @"/Applications/FakeCarrier.app",
                       @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                       @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                       @"/usr/libexec/ssh-keysign",
                       @"/usr/libexec/sftp-server",
                       @"/Applications/blackra1n.app",
                       @"/Applications/IntelliScreen.app",
                       @"/Applications/Snoop-itConfig.app"
                       @"/var/lib/dpkg/info", nil];
    //Check installed app
    for(NSString* check in checks)
    {
        if(canOpen(check))
        {
            return YES;
        }
    }
    //symlink verification
    struct stat sym;
    // hook lstat可以绕过
    if(lstat("/Applications", &sym) || lstat("/var/stash/Library/Ringtones", &sym) ||
       lstat("/var/stash/Library/Wallpaper", &sym) ||
       lstat("/var/stash/usr/include", &sym) ||
       lstat("/var/stash/usr/libexec", &sym)  ||
       lstat("/var/stash/usr/share", &sym) ||
       lstat("/var/stash/usr/arm-apple-darwin9", &sym))
    {
        if(sym.st_mode & S_IFLNK)
        {
            return YES;
        }
    }
  

    //Check process forking
    // hook fork
    int pid = fork();
    if(!pid)
    {
        exit(1);
    }
    if(pid >= 0)
    {
        return YES;
    }

  
//     check has class only used in breakJail like HBPreferences. 越狱常用的类，这里无法绕过，只要多找一些特征类就可以，注意，很多反越狱插件会混淆，所以可能要通过查关键方法来识别
    NSArray *checksClass = [[NSArray alloc] initWithObjects:@"HBPreferences",nil];
    for(NSString *className in checksClass)
    {
      if (NSClassFromString(className) != NULL) {
        return YES;
      }
    }
  
//    Check permission to write to /private hook FileManager 和 writeToFile来绕过
    NSString *path = @"/private/avl.txt";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    @try {
        NSError* error;
        NSString *test = @"AVL was here";
        [test writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:&error];
        [fileManager removeItemAtPath:path error:nil];
        if(error==nil)
        {
            return YES;
        }

        return NO;
    } @catch (NSException *exception) {
        return NO;
    }
}

BOOL isInjectedWithDynamicLibrary()
{
  unsigned int outCount = 0;
  const char **images =  objc_copyImageNames(&outCount);
  for (int i = 0; i < outCount; i++) {
      printf("%s\n", images[i]);
  }
  
  
  int i=0;
    while(true){
        // hook _dyld_get_image_name方法可以绕过
        const char *name = _dyld_get_image_name(i++);
        if(name==NULL){
            break;
        }
        if (name != NULL) {
          NSString *libName = [NSString stringWithUTF8String:name];
          if ([sDylibSet containsObject:libName]) {
            return YES;
          }

        }
    }
    return NO;
}

#pragma mark 通过环境变量DYLD_INSERT_LIBRARIES检测是否越狱
BOOL dyldEnvironmentVariables ()
{
    if(TARGET_IPHONE_SIMULATOR)return NO;
    bool re = !(NULL == getenv("DYLD_INSERT_LIBRARIES"));
    return re;
}

//查看stat是否出自系统库
bool checkInject() {
    int ret ;
    Dl_info dylib_info;
    char *dylib_name = "/usr/lib/system/libsystem_kernel.dylib";
    int (*func_stat)(const char *, struct stat *) = stat;
    if ((ret = dladdr(func_stat, &dylib_info))) {
        printf("lib :%s", dylib_info.dli_fname);
        BOOL restr = strcmp(dylib_info.dli_fname, dylib_name) == 0;
        return restr;
    }
    return false;
}

//检测异常类
//     查看是否有注入异常的类,比如HBPreferences 是越狱常用的类，这里无法绕过，只要多找一些特征类就可以，注意，很多反越狱插件会混淆，所以可能要通过查关键方法来识别
BOOL checkIsExistUnspectClass()
{
    NSArray *checksClass = [[NSArray alloc] initWithObjects:@"HBPreferences",nil];
    for(NSString *className in checksClass)
    {
      if (NSClassFromString(className) != NULL) {
        return YES;
      }
    }
    return NO;
}


//是是否可以在私有领域写入
BOOL checkCanwriteToprivatePath()
{
    NSString *path = @"/var/mobile/test.plist";
        NSFileManager *fileManager = [NSFileManager defaultManager];
        @try {
            NSError* error;
            NSString *test = @"AVL was here";
            [test writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:&error];
            NSDictionary *di = [[NSDictionary alloc] init];
            bool re =  [di writeToFile:@"/var/mobile/test.plist" atomically:YES];
            [fileManager removeItemAtPath:path error:nil];
            if(re==YES)
            {
                return YES;
            }

            return NO;
        } @catch (NSException *exception) {
            return NO;
        }
}


//我们可以检测这些符号链接是否存在，
BOOL checkIsEsixtJsBrokensym()
{
    //symlink verification
    struct stat s;
        if(lstat("/Applications", &s) || lstat("/var/stash/Library/Ringtones", &s) || lstat("/var/stash/Library/Wallpaper", &s)
           || lstat("/var/stash/usr/include", &s) || lstat("/var/stash/usr/libexec", &s)  || lstat("/var/stash/usr/share", &s)
           || lstat("/var/stash/usr/arm-apple-darwin9", &s))
        {
            if(s.st_mode & S_IFLNK){
                return YES;
            }
        }
        
   
    return NO;

}


//我们可以检测这些符号链接是否存在，
BOOL checkIscangetAsubprogram()
{

    int pid = fork(); //返回值：子进程返回0，父进程中返回子进程ID，出错则返回-1
    if(!pid){
//        exit(0);
        return YES;

    }
    if(pid>=0)
    {
        return YES;
    }
    return NO;

}




#pragma mark 校验当前进程是否为调试模式，hook sysctl方法可以绕过
// Returns true if the current process is being debugged (either
// running under the debugger or has a debugger attached post facto).
// Thanks to https://developer.apple.com/library/archive/qa/qa1361/_index.html
BOOL isDebugged()
{
    int junk;
    int mib[4];
    struct kinfo_proc info;
    size_t size;
    info.kp_proc.p_flag = 0;
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}

#pragma mark 使用stat通过检测一些越狱后的关键文件是否可以访问来判断是否越狱，hook stat 方法和dladdr可以绕过
BOOL isStatNotSystemLib() {
    if(TARGET_IPHONE_SIMULATOR)return NO;
    int ret ;
    
    Dl_info dylib_info;
//    int (*func_stat)(const char *, struct stat *) = stat;
    int re = dladdr(stat, &dylib_info);
    NSString *fName = [NSString stringWithUTF8String: dylib_info.dli_fname];
    

    if(![fName isEqualToString:@"/usr/lib/system/libsystem_kernel.dylib"]){
        return YES;
    }

    
    return NO;
}

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);

#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif

// 禁止gdb调试
- (void) disable_gdb {
    if(TARGET_IPHONE_SIMULATOR)return;
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
}

BOOL isunameNotSystemLib() {
    int ret ;
    Dl_info dylib_info;
    int re = dladdr(uname, &dylib_info);
    NSString *fName = [NSString stringWithUTF8String: dylib_info.dli_fname];
    if(![fName isEqualToString:@"/usr/lib/system/libsystem_c.dylib"]){
        return YES;
    }
    return NO;


}

BOOL isfopenNotSystemLib() {
    int ret ;
    Dl_info dylib_info;
    int re = dladdr(fopen, &dylib_info);
    NSString *fName = [NSString stringWithUTF8String: dylib_info.dli_fname];
    if(![fName isEqualToString:@"/usr/lib/system/libsystem_c.dylib"]){
        return YES;
    }

    return NO;


}

BOOL isdlsymNotSystemLib(){
    int ret ;
    Dl_info dylib_info;
    int re = dladdr(dlsym, &dylib_info);
    NSString *fName = [NSString stringWithUTF8String: dylib_info.dli_fname];
    if(![fName isEqualToString:@"/usr/lib/system/libdyld.dylib"]){
        return YES;
    }

    return NO;

}
BOOL isgetenvNotSystemLib(){
    int ret ;
    Dl_info dylib_info;
    int re = dladdr(getenv, &dylib_info);
    NSString *fName = [NSString stringWithUTF8String: dylib_info.dli_fname];
    if(![fName isEqualToString:@"/usr/lib/system/libsystem_c.dylib"]){
        return YES;
    }
    return NO;
}

BOOL isdyld_image_countNotSystemLib(){
    int ret ;
    Dl_info dylib_info;
    int re = dladdr(_dyld_image_count, &dylib_info);
    NSString *fName = [NSString stringWithUTF8String: dylib_info.dli_fname];
    if(![fName isEqualToString:@"/usr/lib/system/libdyld.dylib"]){
        return YES;
    }
    return NO;

}
//
-(BOOL)antiMSHook{
//    if (orig_antiDebug == NULL) {
//        printf("[+++] Not MSHook");
//        antiDebug();
//    } else {
//        printf("[+++] AntiMSHook 🚀🚀🚀");
//        typedef void AntiDebug(void);
//        AntiDebug *_antiDebug = (AntiDebug *)orig_antiDebug;
//        _antiDebug();
//    }

    return NO;
}



@end

