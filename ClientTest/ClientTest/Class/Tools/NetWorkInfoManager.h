//
//  NetWorkInfoManager.h
//  ClientTest
//
//  Created by Leon on 2017/8/23.
//  Copyright © 2017年 王鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NetWorkInfoManager : NSObject<CLLocationManagerDelegate>


+ (instancetype)sharedManager;

/** 获取ip */
- (NSString *)getDeviceIPAddresses;

- (NSString *)getIpAddressWIFI;
- (NSString *)getIpAddressCell;

- (NSString*)getIpMywifi;

- (NSString*)getmylocation;
-(NSString *)getCarrierInfo;

-(NSString *)getbrokenState;



-(NSString *)gethomeDirPath;
-(NSString *)getdocumentsDirPath;

-(NSString *)getpreferencesDirDirPath;


-(NSString *)getBoundPath;

-(NSString *)getNSProcessInfo;
-(NSString *)getOpenUdid;
-(NSString *)getBulidVersionName;
-(BOOL)getisStatNotSystemLib;
-(BOOL)getisDebugged;
-(BOOL)getisInjectedWithDynamicLibrary;
-(BOOL)getJCheckKuyt;
-(BOOL)getdyldEnvironmentVariables;



@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic)NSString *mylocation;



@end
