//
//  CGDDeviceModel.h
//  CGDeviceRoot
//
//  Created by apple on 2022/6/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CGDDeviceIPModel : NSObject

@property (nonatomic, readonly) NSString *awdl0ipv6;
@property (nonatomic, readonly) NSString *en0ipv4;
@property (nonatomic, readonly) NSString *en0ipv6;
@property (nonatomic, readonly) NSString *en2ipv4;
@property (nonatomic, readonly) NSString *en2ipv6;
@property (nonatomic, readonly) NSString *lo0ipv4;
@property (nonatomic, readonly) NSString *lo0ipv6;

@property (nonatomic, readonly) NSString *pdp_ip0ipv4;
@property (nonatomic, readonly) NSString *pdp_ip0ipv6;
@property (nonatomic, readonly) NSString *utun0ipv6;
@property (nonatomic, readonly) NSString *utun1ipv6;
@property (nonatomic, readonly) NSString *utun2ipv6;
@property (nonatomic, readonly) NSString *utun3ipv6;
@property (nonatomic, readonly) NSString *utun4ipv6;
@property (nonatomic, readonly) NSString *utun5ipv6;
@property (nonatomic, readonly) NSString *utun6ipv6;
@property (nonatomic, readonly) NSString *utun7ipv6;

@property (nonatomic, readonly) NSString *pdp_ip1ipv6;
@property (nonatomic, readonly) NSString *llw0ipv6;
@property (nonatomic, readonly) NSString *ipsec0ipv6;
@property (nonatomic, readonly) NSString *ipsec1ipv6;

@end

@interface CGDDeviceAppMsgModel : NSObject

/// 只越狱
@property (nonatomic, readonly) NSString *onlyJB;
/// 禁用重定向
@property (nonatomic, readonly) NSString *reDirectionDisable;
/// 使用原系统
@property (nonatomic, readonly) NSString *useOriginSystem;
/// 是否修改分辨率
@property (nonatomic, readonly) NSString *pixEditable;
/// 是否修改osproductversion
@property (nonatomic, readonly) NSString *disductversion;
/// 使用原机型
@property (nonatomic, readonly) NSString *useOriginModel;
/// 禁用重装app
@property (nonatomic, readonly) NSString *reInstallDisable;
/// 禁用cycript
@property (nonatomic, readonly) NSString *cycriptDisable;
/// 原identifier标识
@property (nonatomic, readonly) NSString *oriIdentifier;
/// 原系统版本号
@property (nonatomic, readonly) NSString *oriSystemVersion;
/// 使用rootfs
@property (nonatomic, readonly) NSString *rootfsEnable;
/// 日志打印
@property (nonatomic, readonly) NSString *logEnable;
/// 内核禁用
@property (nonatomic, readonly) NSString *svcDisable;
/// 内核所有
@property (nonatomic, readonly) NSString *svcAllEnable;

///禁用网络拦截
@property (nonatomic, readonly) NSString *afCatchDisable;




@end

@interface CGDDeviceInputModel : NSObject

@property (nonatomic, readonly) NSString *applewebkit;
@property (nonatomic, readonly) NSString *cacheVersion;
@property (nonatomic, readonly) NSString *cfnetwork;
@property (nonatomic, readonly) NSString *generation;
@property (nonatomic, readonly) NSString *iosVersion;

@end

@interface CGDDeviceSimInfo : NSObject

@property (nonatomic, readonly) NSString *mcc;
@property (nonatomic, readonly) NSString *mnc;
@property (nonatomic, readonly) NSString *phoneNumber;
@property (nonatomic, readonly) NSString *simSerial;
@property (nonatomic, readonly) NSString *iosVersion;
@property (nonatomic, readonly) NSString *countryCode;
@property (nonatomic, readonly) NSString *carrierCode;
@property (nonatomic, readonly) NSString *carrierName;

@end



@interface CGDDeviceModel : NSObject
@property (nonatomic, readonly) NSString *anumber;
@property (nonatomic, readonly) NSString *appleWebKit;
@property (nonatomic, readonly) NSString *bluetoothAddress;
@property (nonatomic, readonly) NSString *bootTimeTvSec;
@property (nonatomic, readonly) NSString *bootTimeTvUsec;
@property (nonatomic, readonly) NSString *bssid;
@property (nonatomic, readonly) NSString *cacheUuid;
@property (nonatomic, readonly) NSString *cacheVersion;
@property (nonatomic, readonly) NSString *cfNetwork;
@property (nonatomic, readonly) NSString *color;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *cpu64bits;
@property (nonatomic, readonly) NSString *cpuCount;
@property (nonatomic, readonly) NSString *cpuType;
@property (nonatomic, readonly) NSString *currentCountryCode;
@property (nonatomic, readonly) NSString *currentLanguage;

@property (nonatomic, readonly) NSString *brightness;
@property (nonatomic, readonly) NSString *outputVolume;
@property (nonatomic, readonly) NSString *batteryState;
@property (nonatomic, readonly) NSString *batteryLevel;

@property (nonatomic, readonly) NSString *fileSystemFreeSize ;
@property (nonatomic, readonly) NSString *fileSystemFreeNodes;
@property (nonatomic, readonly) NSString *fileSystemNodes;
@property (nonatomic, readonly) NSString *fileSystemNumber;
@property (nonatomic, readonly) NSString *fileSystemSize;

@property (nonatomic, readonly) NSString *physicalMemory;
@property (nonatomic, readonly) NSString *orientation;

@property (nonatomic, readonly) NSString *darwin;
@property (nonatomic, readonly) NSString *deviceInfoId;
@property (nonatomic, readonly) NSString *disk;
@property (nonatomic, readonly) NSString *fileMd5;
@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *filePath;
@property (nonatomic, readonly) NSString *fileRemark;
@property (nonatomic, readonly) NSString *fileSize;
@property (nonatomic, readonly) NSString *fileStoreType;
@property (nonatomic, readonly) NSString *generation;
@property (nonatomic, readonly) NSString *globalNumber;
@property (nonatomic, readonly) NSString *height;
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *idfa;
@property (nonatomic, readonly) NSString *idfv;
@property (nonatomic, readonly) NSString *boundPath;
@property (nonatomic, readonly) NSString *sandPath;
@property (nonatomic, readonly) NSString *imei;
@property (nonatomic, strong) CGDDeviceInputModel *inputInfo;
@property (nonatomic, readonly) NSString *internalName;
@property (nonatomic, readonly) NSString *iphoneVersion;
@property (nonatomic, readonly) NSString *kernMemsize;
@property (nonatomic, readonly) NSString *kernName;
@property (nonatomic, readonly) NSString *kernOstype;
@property (nonatomic, readonly) NSString *langCode;
@property (nonatomic, readonly) NSString *localizedModel;
@property (nonatomic, readonly) NSString *macAddress;
@property (nonatomic, readonly) NSString *machdepWakeConttime;
@property (nonatomic, readonly) NSString *mcc;
@property (nonatomic, readonly) NSString *mcmMetadataUuid;
@property (nonatomic, readonly) NSString *mnc;
@property (nonatomic, readonly) NSString *model;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *osVersion;
@property (nonatomic, readonly) NSString *personaUniqueString;
@property (nonatomic, readonly) NSString *physicalHeight;
@property (nonatomic, readonly) NSString *physicalWidth;
@property (nonatomic, readonly) NSString *ramSize;
@property (nonatomic, readonly) NSString *remark;
@property (nonatomic, readonly) NSString *serialNumber;
@property (nonatomic, readonly) NSString *ssid;
@property (nonatomic, readonly) NSString *storage;
@property (nonatomic, readonly) NSString *systemBuildId;
@property (nonatomic, readonly) NSString *systemImageId;
@property (nonatomic, readonly) NSString *systemName;
@property (nonatomic, readonly) NSString *systemUptime;
@property (nonatomic, readonly) NSString *systemVersion;
@property (nonatomic, readonly) NSString *timeZone;
@property (nonatomic, readonly) NSString *uiScale;
@property (nonatomic, readonly) NSString *uuid;
@property (nonatomic, readonly) NSString *var_passwd;
@property (nonatomic, readonly) NSString *var_hosts;
@property (nonatomic, readonly) NSString *var_group;
@property (nonatomic, readonly) NSString *width;
@property (nonatomic, readonly) NSString *wifiChipset;
@property (nonatomic, readonly) NSDictionary *pathTimename;
@property (nonatomic, readonly) NSString *kernKernelcacheuuid;
@property (nonatomic, readonly) NSString *kernBootsessionuuid;
@property (nonatomic, readonly) CGDDeviceAppMsgModel *appMsg;
@property (nonatomic, readonly) NSDictionary *scriptMsg;

@property (nonatomic, readonly) NSString *kitPath;
@property (nonatomic, readonly) NSString *corePath;

@property (nonatomic, readonly) NSDictionary *refileGroupDic;

@property (nonatomic, readonly) CGDDeviceIPModel *network;

@property (nonatomic, readonly) NSString *latitude;
@property (nonatomic, readonly) NSString *longitude;
@property (nonatomic, strong) NSDictionary  *deviceInfo;
@property (nonatomic, readonly) CGDDeviceSimInfo *simInfo;

- (cpu_type_t)cputypeValue;

- (cpu_subtype_t)cpusubtypeValue;

- (NSString *)languageCode;

- (NSString *)localeIdentifier;

@end

