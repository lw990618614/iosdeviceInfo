//
//  BasicViewController.m
//  ClientTest
//
//  Created by Leon on 2017/5/18.
//  Copyright © 2017年 王鹏飞. All rights reserved.
//

#import "BasicViewController.h"
#import "DeviceInfoManager.h"
#import "NetWorkInfoManager.h"
#import "BatteryInfoManager.h"

@interface BasicInfo : NSObject

@property (nonatomic, copy) NSString *infoKey;
@property (nonatomic, strong) NSObject *infoValue;

@end

@implementation BasicInfo
@end

@interface BasicViewController ()<UITableViewDataSource, UITableViewDelegate, BatteryInfoDelegate>

@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation BasicViewController

#pragma mark - build
- (instancetype)initWithType:(BasicInfoType)type {
    self = [super init];
    if (self) {
        if (type == BasicInfoTypeHardWare) {
            [self _setupHardwareInfo];
        } else if (type == BasicInfoTypeBattery) {
            [self _setupBatteryInfo];
        } else if (type == BasicInfoTypeIpAddress) {
            [self _setupAddressInfo];
        } else if (type == BasicInfoTypeCPU){
            [self _setupCPUInfo];
        } else if (type == BasicInfoTypeDisk){
            [self _setupDiskInfo];
        } else if (type == BasicInfoTypeBroken){
            [self _setupBrokenInfo];
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 80;
    
    [self.view addSubview:self.myTableView];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationBar.largeTitleTextAttributes = @{      
                                                     NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:28],
                                          NSForegroundColorAttributeName:[UIColor blackColor],
                                                     };
    }
}

- (void)dealloc {
    [[BatteryInfoManager sharedManager] stopBatteryMonitoring];
}

#pragma mark - private Method

- (void)_setupHardwareInfo {
    const NSString *deviceName = [[DeviceInfoManager sharedManager] getDeviceName];
    [self _addInfoWithKey:@"设备型号" infoValue:[deviceName copy]];
    
    NSString *iPhoneName = [UIDevice currentDevice].name;
    [self _addInfoWithKey:@"设备名称" infoValue:iPhoneName];
    
    NSString *deviceColor = [[DeviceInfoManager sharedManager] getDeviceColor];
    [self _addInfoWithKey:@"设备颜色(Private API)" infoValue:deviceColor];
    
    NSString *deviceEnclosureColor = [[DeviceInfoManager sharedManager] getDeviceEnclosureColor];
    [self _addInfoWithKey:@"设备外壳颜色(Private API)" infoValue:deviceEnclosureColor];
    
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self _addInfoWithKey:@"app版本号" infoValue:appVerion];
    
    NSString *device_model = [[DeviceInfoManager sharedManager] getDeviceModel];
    [self _addInfoWithKey:@"device_model" infoValue:device_model];

    NSString *localizedModel = [UIDevice currentDevice].localizedModel;
    [self _addInfoWithKey:@"localizedModel" infoValue:localizedModel];
    
    NSString *systemName = [UIDevice currentDevice].systemName;
    [self _addInfoWithKey:@"当前系统名称" infoValue:systemName];
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    [self _addInfoWithKey:@"当前系统版本号" infoValue:systemVersion];
    
    const NSString *initialFirmware = [[DeviceInfoManager sharedManager] getInitialFirmware];
    [self _addInfoWithKey:@"设备支持最低系统版本" infoValue:[initialFirmware copy]];
    
    const NSString *latestFirmware = [[DeviceInfoManager sharedManager] getLatestFirmware];
    [self _addInfoWithKey:@"设备支持的最高系统版本" infoValue:[latestFirmware copy]];
    
    BOOL canMakePhoneCall = [DeviceInfoManager sharedManager].canMakePhoneCall;
    [self _addInfoWithKey:@"能否打电话" infoValue:@(canMakePhoneCall)];
    
    NSDate *systemUptime = [[DeviceInfoManager sharedManager] getSystemUptime];
    [self _addInfoWithKey:@"设备上次重启的时间" infoValue:systemUptime];
    
    NSUInteger busFrequency = [[DeviceInfoManager sharedManager] getBusFrequency];
    [self _addInfoWithKey:@"当前设备的总线频率Bus Frequency" infoValue:@(busFrequency)];
    
    NSUInteger ramSize = [[DeviceInfoManager sharedManager] getRamSize];
    [self _addInfoWithKey:@"当前设备的主存大小(随机存取存储器（Random Access Memory)）" infoValue:@(ramSize)];
}

- (void)_setupBatteryInfo {
    
    BatteryInfoManager *batteryManager = [BatteryInfoManager sharedManager];
    batteryManager.delegate = self;
    [batteryManager startBatteryMonitoring];
    
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    NSString *levelValue = [NSString stringWithFormat:@"%.2f", batteryLevel];
    [self _addInfoWithKey:@"电池电量" infoValue:levelValue];
    
    NSInteger batteryCapacity = batteryManager.capacity;
    NSString *capacityValue = [NSString stringWithFormat:@"%ld mA", batteryCapacity];
    [self _addInfoWithKey:@"电池容量" infoValue:capacityValue];
    
    CGFloat batteryMAH = batteryCapacity * batteryLevel;
    NSString *mahValue = [NSString stringWithFormat:@"%.2f mA", batteryMAH];
    [self _addInfoWithKey:@"当前电池剩余电量" infoValue:mahValue];
    
    CGFloat batteryVoltage = batteryManager.voltage;
    NSString *voltageValue = [NSString stringWithFormat:@"%.2f V", batteryVoltage];
    [self _addInfoWithKey:@"电池电压" infoValue:voltageValue];
    NSString *batterStatus = batteryManager.status ? : @"unkonwn";
    [self _addInfoWithKey:@"电池状态" infoValue:batterStatus];
}

- (void)_setupAddressInfo {
    
    // 广告位标识符：在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置|隐私|广告追踪里重置此id的值，或限制此id的使用，故此id有可能会取不到值，但好在Apple默认是允许追踪的，而且一般用户都不知道有这么个设置，所以基本上用来监测推广效果，是戳戳有余了
    NSString *idfa = [[DeviceInfoManager sharedManager] getIDFA];
    [self _addInfoWithKey:@"广告位标识符idfa" infoValue:idfa];
    
    //  UUID是Universally Unique Identifier的缩写，中文意思是通用唯一识别码。它是让分布式系统中的所有元素，都能有唯一的辨识资讯，而不需要透过中央控制端来做辨识资讯的指 定。这样，每个人都可以建立不与其它人冲突的 UUID。在此情况下，就不需考虑数据库建立时的名称重复问题。苹果公司建议使用UUID为应用生成唯一标识字符串。
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self _addInfoWithKey:@"唯一识别码uuid" infoValue:uuid];
    
    NSString *device_token_crc32 = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_token_crc32"] ? : @"";
    [self _addInfoWithKey:@"device_token_crc32真机测试才会显示" infoValue:device_token_crc32];

    NSString *macAddress = [[DeviceInfoManager sharedManager] getMacAddress];
    [self _addInfoWithKey:@"macAddress" infoValue:macAddress];
    
    NSString *deviceIP = [[NetWorkInfoManager sharedManager] getDeviceIPAddresses];
    [self _addInfoWithKey:@"deviceIP" infoValue:deviceIP];
    
    NSString *cellIP = [[NetWorkInfoManager sharedManager] getIpAddressCell];
    [self _addInfoWithKey:@"蜂窝地址" infoValue:cellIP];
    
//    NSString *wifiIP = [[NetWorkInfoManager sharedManager] getIpAddressWIFI];
//    [self _addInfoWithKey:@"WIFI IP地址" infoValue:wifiIP];
    
    
//    NSString *wifiIP1 = [[NetWorkInfoManager sharedManager] getIpMywifi];
//    [self _addInfoWithKey:@"my IP地址" infoValue:wifiIP1];
//
    NSString *locaion = [[NetWorkInfoManager sharedManager] getmylocation];
    [self _addInfoWithKey:@"坐标地址地址" infoValue:locaion];

    NSString *carrieer = [[NetWorkInfoManager sharedManager] getCarrierInfo];
    [self _addInfoWithKey:@"运营商:" infoValue:carrieer];
    
    
    NSString *  getBulidVersionName = [[NetWorkInfoManager sharedManager] getBulidVersionName];
    [self _addInfoWithKey:@"文件路劲的值" infoValue:getBulidVersionName];
    
    
//    NSString *  metadataplist = [[NetWorkInfoManager sharedManager] metadataplist];
//    [self _addInfoWithKey:@"metadataplist的值" infoValue:metadataplist];

    NSString *cache = [[NSUserDefaults standardUserDefaults] objectForKey:@"ktest"];
    if (cache == nil) {
        cache = @"fist";
    }else{
      NSString *string =  [self random:3];
      cache = [NSString stringWithFormat:@"%@%@",cache,string] ;
    }

    [[NSUserDefaults standardUserDefaults ] setObject:cache forKey:@"ktest"];
    
    [self _addInfoWithKey:@"随机值" infoValue:cache];
    
    
    NSString *  getdyldName = [[NetWorkInfoManager sharedManager] getdyldName];

    
    [self _addInfoWithKey:@"getdyldName" infoValue:getdyldName];

    
    


}
-(NSString *) random: (int)len {
    char ch[len];
    for (int index = 0; index < len; index ++) {
        int num = arc4random_uniform(75) + 48;
        if (num>57 && num<65) {
            num = num%57+48;
        }
        else if (num>90 && num<97) {
            num = num%90+65;
        }
        ch[index] = num;
    }
    return [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
}
- (void)_setupCPUInfo {
    NSString *cpuName = [[DeviceInfoManager sharedManager] getCPUProcessor];
    [self _addInfoWithKey:@"CPU 处理器名称" infoValue:cpuName];
    
    NSUInteger cpuCount = [[DeviceInfoManager sharedManager] getCPUCount];
    [self _addInfoWithKey:@"CPU总数目" infoValue:@(cpuCount)];
    
    CGFloat cpuUsage = [[DeviceInfoManager sharedManager] getCPUUsage];
    [self _addInfoWithKey:@"CPU使用的总比例" infoValue:@(cpuUsage)];
    
    NSUInteger cpuFrequency = [[DeviceInfoManager sharedManager] getCPUFrequency];
    [self _addInfoWithKey:@"CPU 频率" infoValue:@(cpuFrequency)];
    
    NSArray *perCPUArr = [[DeviceInfoManager sharedManager] getPerCPUUsage];
    NSMutableString *perCPUUsage = [NSMutableString string];
    for (NSNumber *per in perCPUArr) {
        [perCPUUsage appendFormat:@"%.2f<-->", per.floatValue];
    }
    [self _addInfoWithKey:@"单个CPU使用比例" infoValue:perCPUUsage];
}

- (void)_setupDiskInfo {
    NSString *applicationSize = [[DeviceInfoManager sharedManager] getApplicationSize];
    [self _addInfoWithKey:@"当前 App 所占内存空间" infoValue:applicationSize];
    
    int64_t totalDisk = [[DeviceInfoManager sharedManager] getTotalDiskSpace];
    NSString *totalDiskInfo = [NSString stringWithFormat:@"== %.2f MB == %.2f GB", totalDisk/1024/1024.0, totalDisk/1024/1024/1024.0];
    [self _addInfoWithKey:@"磁盘总空间" infoValue:totalDiskInfo];
    
    int64_t usedDisk = [[DeviceInfoManager sharedManager] getUsedDiskSpace];
    NSString *usedDiskInfo = [NSString stringWithFormat:@" == %.2f MB == %.2f GB", usedDisk/1024/1024.0, usedDisk/1024/1024/1024.0];
    [self _addInfoWithKey:@"磁盘 已使用空间" infoValue:usedDiskInfo];
    
    int64_t freeDisk = [[DeviceInfoManager sharedManager] getFreeDiskSpace];
    NSString *freeDiskInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeDisk/1024/1024.0, freeDisk/1024/1024/1024.0];

    [self _addInfoWithKey:@"磁盘空闲空间" infoValue:freeDiskInfo];
    
    int64_t totalMemory = [[DeviceInfoManager sharedManager] getTotalMemory];
    NSString *totalMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", totalMemory/1024/1024.0, totalMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"系统总内存空间" infoValue:totalMemoryInfo];
    
    int64_t freeMemory = [[DeviceInfoManager sharedManager] getFreeMemory];
    NSString *freeMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeMemory/1024/1024.0, freeMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"空闲的内存空间" infoValue:freeMemoryInfo];
    
    int64_t usedMemory = [[DeviceInfoManager sharedManager] getFreeDiskSpace];
    NSString *usedMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", usedMemory/1024/1024.0, usedMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"已使用的内存空间" infoValue:usedMemoryInfo];
    
    int64_t activeMemory = [[DeviceInfoManager sharedManager] getActiveMemory];
    NSString *activeMemoryInfo = [NSString stringWithFormat:@"正在使用或者很短时间内被使用过 %.2f MB == %.2f GB", activeMemory/1024/1024.0, activeMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"活跃的内存" infoValue:activeMemoryInfo];
    
    int64_t inActiveMemory = [[DeviceInfoManager sharedManager] getInActiveMemory];
    NSString *inActiveMemoryInfo = [NSString stringWithFormat:@"但是目前处于不活跃状态的内存 %.2f MB == %.2f GB", inActiveMemory/1024/1024.0, inActiveMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"最近使用过" infoValue:inActiveMemoryInfo];
    
    int64_t wiredMemory = [[DeviceInfoManager sharedManager] getWiredMemory];
    NSString *wiredMemoryInfo = [NSString stringWithFormat:@"framework、用户级别的应用无法分配 %.2f MB == %.2f GB", wiredMemory/1024/1024.0, wiredMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"用来存放内核和数据结构的内存" infoValue:wiredMemoryInfo];
    
    int64_t purgableMemory = [[DeviceInfoManager sharedManager] getPurgableMemory];
    NSString *purgableMemoryInfo = [NSString stringWithFormat:@"大对象存放所需的大块内存空间 %.2f MB == %.2f GB", purgableMemory/1024/1024.0, purgableMemory/1024/1024/1024.0];
    [self _addInfoWithKey:@"可释放的内存空间：内存吃紧自动释放" infoValue:purgableMemoryInfo];
}

- (void)_setupBrokenInfo {
    
    NSString *gethomeDirPath = [[NetWorkInfoManager sharedManager] gethomeDirPath];
    [self _addInfoWithKey:@"homePath:" infoValue:gethomeDirPath];

    NSString *getdocumentsDirPath = [[NetWorkInfoManager sharedManager] getdocumentsDirPath];
    [self _addInfoWithKey:@"documentPath:" infoValue:getdocumentsDirPath];

    NSString *getpreferencesDirDirPath = [[NetWorkInfoManager sharedManager] getpreferencesDirDirPath];
    [self _addInfoWithKey:@"preferePath:" infoValue:getpreferencesDirDirPath];

    NSString *getBoundPath = [[NetWorkInfoManager sharedManager] getBoundPath];
    [self _addInfoWithKey:@"boundPath:" infoValue:getBoundPath];

//
//    NSString *getNSProcessInfo = [[NetWorkInfoManager sharedManager] getNSProcessInfo];
//    [self _addInfoWithKey:@"NSProcessInfo:" infoValue:getNSProcessInfo];
//

    NSString *getOpenUdid = [[NetWorkInfoManager sharedManager] getOpenUdid];
    [self _addInfoWithKey:@"getOpenUdid:" infoValue:getOpenUdid];
    
    NSString *breakstate = [[NetWorkInfoManager sharedManager] getbrokenState];
    [self _addInfoWithKey:@"越狱状态:" infoValue:breakstate];

    BOOL  getisStatNotSystemLib = [[NetWorkInfoManager sharedManager] getisStatNotSystemLib];
    [self _addInfoWithKey:@"检测stat:" infoValue:!getisStatNotSystemLib?@"检测到stat是来源系统库 正常":@"检测到stat 非系统库 异常"];
    
    BOOL  getisunameNotSystemLib = [[NetWorkInfoManager sharedManager] getisunameNotSystemLib];
    [self _addInfoWithKey:@"检测uname:" infoValue:!getisunameNotSystemLib?@"检测到uname是来源系统库 正常":@"检测到uname 非系统库 异常"];
    

    BOOL  getisfopenNotSystemLib = [[NetWorkInfoManager sharedManager] getisfopenNotSystemLib];
    [self _addInfoWithKey:@"检测fopen:" infoValue:!getisfopenNotSystemLib?@"检测到fopen是来源系统库 正常":@"检测到fopen 非系统库 异常"];
    
    BOOL  getisdlsymNotSystemLib = [[NetWorkInfoManager sharedManager] getisdlsymNotSystemLib];
    [self _addInfoWithKey:@"检测sdlsym:" infoValue:!getisdlsymNotSystemLib?@"检测到sdlsym是来源系统库 正常":@"检测到sdlsym 非系统库 异常"];
    
    
    BOOL  getisgetenvNotSystemLib = [[NetWorkInfoManager sharedManager] getisgetenvNotSystemLib];
    [self _addInfoWithKey:@"检测getenv:" infoValue:!getisgetenvNotSystemLib?@"检测到getenv是来源系统库 正常":@"检测到getenv 非系统库 异常"];

    
    BOOL  getisdyld_image_countNotSystemLib = [[NetWorkInfoManager sharedManager] getisdyld_image_countNotSystemLib];
    [self _addInfoWithKey:@"检测dyld_image_count:" infoValue:!getisdyld_image_countNotSystemLib?@"检测到dyld_image_count是来源系统库 正常":@"检测到dyld_image_count 非系统库 异常"];




    
    BOOL  getisDebugged = [[NetWorkInfoManager sharedManager] getisDebugged];
    [self _addInfoWithKey:@"调试状态:" infoValue:getisDebugged?@"调试中":@"未调试"];
    
    BOOL  getisInjectedWithDynamicLibrary = [[NetWorkInfoManager sharedManager] getisInjectedWithDynamicLibrary];
    
    [self _addInfoWithKey:@"检测的动态库" infoValue:getisInjectedWithDynamicLibrary?@"检测到了特定动态库":@"未检测到"];
    
    BOOL  getJCheckKuyt = [[NetWorkInfoManager sharedManager] getJCheckKuyt];
    [self _addInfoWithKey:@"检测越狱路劲" infoValue:getJCheckKuyt?@"检测到越狱路劲":@"未检测到越狱路劲"];
    
    BOOL  getdyldEnvironmentVariables = [[NetWorkInfoManager sharedManager] getdyldEnvironmentVariables];
    [self _addInfoWithKey:@"是否拦截检测环境变量DYLD_" infoValue:getdyldEnvironmentVariables?@"检测到变量":@"未检测到"];
    
    BOOL  getsUnspectClass = [[NetWorkInfoManager sharedManager] getsUnspectClass];
    [self _addInfoWithKey:@"是否有某一个异常类" infoValue:getsUnspectClass?@"是的":@"没有"];

    BOOL  checkCanwriteToprivatePath = [[NetWorkInfoManager sharedManager] checkCanwriteToprivatePath];
    [self _addInfoWithKey:@"是否可以写入私有领域" infoValue:checkCanwriteToprivatePath?@"是的":@"不可以"];
    
    BOOL  getstatIsfromSystem = [[NetWorkInfoManager sharedManager] getstatIsfromSystem];
    
    [self _addInfoWithKey:@"stat是否是系统库" infoValue:getstatIsfromSystem?@"是 正常":@"不是 非正常"];
    
    BOOL  checkIsEsixtJsBrokensym = [[NetWorkInfoManager sharedManager] checkIsEsixtJsBrokensym];
    [self _addInfoWithKey:@"是否存在越狱符号链接" infoValue:checkIsEsixtJsBrokensym?@"存在":@"不存在"];

    BOOL  checkIscangetAsubprogram = [[NetWorkInfoManager sharedManager] checkIscangetAsubprogram];
    [self _addInfoWithKey:@"是否能勾起一个子进程" infoValue:checkIscangetAsubprogram?@"可以":@"不可以"];

    NSString *  getjsBrokenData = [[NetWorkInfoManager sharedManager] getjsBrokenData];
    [self _addInfoWithKey:@"越狱data值" infoValue:getjsBrokenData];

    NSString *  CoreMaterialframeworkInfoplist = [[NetWorkInfoManager sharedManager] CoreMaterialframeworkInfoplist];
    [self _addInfoWithKey:@"越狱CoreMaterialframeworkInfoplist值" infoValue:CoreMaterialframeworkInfoplist];

    NSString *  platformChromeLightmaterialrecipe = [[NetWorkInfoManager sharedManager] platformChromeLightmaterialrecipe];
    [self _addInfoWithKey:@"越狱platformChromeLightmaterialrecipe值" infoValue:platformChromeLightmaterialrecipe];

    NSString *  brokepathTest = [[NetWorkInfoManager sharedManager] brokepathTest];

    [self _addInfoWithKey:@"越狱路劲" infoValue:brokepathTest];

    
    NSString *  brokegetecid = [[NetWorkInfoManager sharedManager] brokegetecid];
    [self _addInfoWithKey:@"brokegetecid" infoValue:brokegetecid];


    
    
}

- (void)_addInfoWithKey:(NSString *)infoKey infoValue:(NSObject *)infoValue {
    BasicInfo *info = [[BasicInfo alloc] init];
    info.infoKey = infoKey;
    info.infoValue = infoValue;
    NSLog(@"%@---%@", infoKey, infoValue);
    [self.infoArray addObject:info];
}

#pragma mark - BatteryInfoDelegate
- (void)batteryStatusUpdated {
#warning 当电池状态改变时，会调用该方法，应该在此处reload对应的cell，进行更新UI操作
}

#pragma mark - UITableViewDelegate && UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.infoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BasicInfo *infoModel = self.infoArray[indexPath.row];

    if ([infoModel.infoKey containsString:@"NSProcessInfo"]) {
        return 600;
    }else{
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 为cell设置标识符
    static NSString *idetifier = @"kIndentifier";
    
    //从缓存池中取出 对应标示符的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idetifier];
    }
    
    // 获取数据字典
    BasicInfo *infoModel = self.infoArray[indexPath.row];
    cell.textLabel.text = infoModel.infoKey;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"------>%@", infoModel.infoValue];
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - setters && getters
- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

@end
