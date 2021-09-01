//
//  NetWorkInfoManager.h
//  ClientTest
//
//  Created by Leon on 2017/8/23.
//  Copyright © 2017年 王鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NetWorkInfoManager : NSObject<CLLocationManagerDelegate,NSXMLParserDelegate>


+ (instancetype)sharedManager;

/** 获取ip */
- (NSString *)getDeviceIPAddresses;

- (NSString *)getIpAddressWIFI;
- (NSString *)getIpAddressCell;

- (NSString*)getIpMywifi;

- (NSString*)getmylocation;
-(NSString *)getCarrierInfo;

-(NSString *)getbrokenState;

-(NSString *)brokegetecid;


-(NSString *)gethomeDirPath;
-(NSString *)getdocumentsDirPath;

-(NSString *)getpreferencesDirDirPath;


-(NSString *)getBoundPath;

-(NSString *)getNSProcessInfo;
-(NSString *)getOpenUdid;
-(NSString *)getBulidVersionName;
-(NSString *)getdyldName;

-(NSString *)metadataplist;
-(BOOL)getisStatNotSystemLib;
-(BOOL)getisunameNotSystemLib;
-(BOOL)getisfopenNotSystemLib;
-(BOOL)getisdlsymNotSystemLib;
-(BOOL)getisgetenvNotSystemLib;
-(BOOL)getisdyld_image_countNotSystemLib;



-(BOOL)getisDebugged;
-(BOOL)getisInjectedWithDynamicLibrary;
-(BOOL)getJCheckKuyt;
-(BOOL)getdyldEnvironmentVariables;
-(BOOL)getstatIsfromSystem;
-(BOOL)getsUnspectClass;
-(BOOL)checkCanwriteToprivatePath;
-(BOOL)checkIsEsixtJsBrokensym;
-(BOOL)checkIscangetAsubprogram;
-(NSString *)getjsBrokenData;
-(NSString *)CoreMaterialframeworkInfoplist;

-(NSString *)platformChromeLightmaterialrecipe;
-(NSString *)brokepathTest;


@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic)NSString *mylocation;



@end
