//
//  MYNetManager.m
//  ClientTest
//
//  Created by 陈鑫 on 2023/4/26.
//  Copyright © 2023 王鹏飞. All rights reserved.
//

#import "MYNetManager.h"
#import "CGDDeviceModel.h"
#import "MJExtension.h"
#import <AFNetworking/AFNetworking.h>
#import <AdSupport/ASIdentifierManager.h>
//#define BaseURL @"http://s5.s100.vip:4512/api/"
//#define BaseURL @"http://47.115.208.84:9019/api/"
//#define BaseURL @"https://pub-test-mota-ccs.zhizh.com/"
//#define BaseURL @"http://127.0.0.l:8989"

#define BaseURL @"http://localhost:8989"
//#define BaseURL @"https://pub-test-mota-ccs.zhizh.com"
//#define BaseURL @"https://pub-test-mota-ccs.zhizh.com/api/v1/ios/bind"
//#define BaseURL @"http://158.247.202.46/"


//http://47.115.208.84:9019/api/ios/terminal?iosId=asdasz2121321231321&mtVersion=1.0.0
@implementation MYNetManager
+ (AFHTTPSessionManager *)afmanager {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = AFJSONRequestSerializer.serializer;
    manager.requestSerializer.timeoutInterval = 3600;
    manager.responseSerializer = AFJSONResponseSerializer.serializer;
    return manager;
}



+(void)getnet{
    
//    NSString *homePath = @"/var/mobile/Documents/MyData/YSDeviceInfo";
//    NSString*filePatch = [homePath stringByAppendingPathComponent:@"deviceInfo.plist"];//
//
//    NSMutableDictionary *my = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
//    my[@"orientation"] =  [NSString stringWithFormat:@"%d",(int)arc4random() %2+1];
//
//    NSString *URL=  [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//
//    CGDDeviceModel *deviceInfo = [CGDDeviceModel mj_objectWithKeyValues:my];
    

    
    NSString *url = @"/refreshApplist";
//    NSString *url = @"/getTerminalID";
//    NSString *url = @"/getDeviceInfo";
//    NSString *url = @"/api/v1/ios/device/mod";
//
    NSDictionary *re  =  @{@"appMsg":@"{\"oriSystemVersion\":\"14.1\",\"oriIdentifier\":\"iPhone13,2\",\"bundleUUID\":\"86BF7ED8-CA72-49DF-90DA-EEDB971BA9C8\",\"dataContainerUUID\":\"1EF59BFE-6910-4AD4-9ACA-DCC5C1DCAF31\"}",@"currentCountryCode":@"US",@"currentLanguage":@"zh-Hans-US",@"iosId":@"71b4b72e67c9fcffabb8d4dd962dfa2bcaddace6",@"mtVersion":@"1.0",@"remark":@"com.mianyang.device",@"terminalId":@"c0972d81-f761-4b2d-aa1d-97c2f7efaeb7"};
    [[MYNetManager afmanager] POST:url parameters:re headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
    
//    NSString *url = @"getAppDeviceInfo";
//
//    NSDictionary *re  =  @{@"security":@"##YS$$GCD##"};
//    [[MYNetManager afmanager] POST:url parameters:re headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
//    NSString *url = @"getAppDeviceInfo";
//
//    NSDictionary *re  =  @{@"security":@"##YS$$GCD##",@"defaultDevice":@{@"appMsg":@"{}",@"currentCountryCode":@"CN",@"currentLanguage":@"zh-Hans-CN",@"remark":@"com.at.stool"}};
//    [[MYNetManager afmanager] POST:url parameters:re headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];


//    [self updateDevice];
//    [self upreceip];
    
//    NSDictionary *dic = @{@"username":@"admin",@"password":@"admin",@"version":@"1.0",@"device_id":@"abcdefghijklmnopqrstuvwxyz"};
//    NSString *url = @"index.php/port/Login/mobile";
//    [[MYNetManager afmanager] POST:url parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
//
//    manager.requestSerializer = AFJSONRequestSerializer.serializer;
//    manager.requestSerializer.timeoutInterval = 3600;
//    manager.responseSerializer = AFJSONResponseSerializer.serializer;
//
////    NSString *url = @"http://127.0.0.1:4455/getDeviceParams";
////    NSDictionary *dic = @{@"username":@"admin",@"password":@"admin",@"version":@"1.0",@"device_id":@"abcdefghijklmnopqrstuvwxyz"};
////    privateSelectApp
//    [manager POST:@"getDeviceParams" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
}

+(void)updateDevice{
    NSDictionary *dic = @{@"iosId":@"71b4b72e67c9fcffabb8d4dd962dfa2bcaddace7",@"mtVersion":@"1.0"};
//    NSString *url = [BaseURL stringByAppendingPathComponent:@"%@ios/terminal",BaseURL];
    NSString *url = [NSString stringWithFormat:@"/api/v1/ios/bind"];
    [[MYNetManager afmanager] GET:url parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+(void)upreceip{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = AFJSONRequestSerializer.serializer;
    manager.requestSerializer.timeoutInterval = 3600;
    manager.responseSerializer = AFJSONResponseSerializer.serializer;
//    NSDictionary *dic = @{@"receipt-data":@"MIIUagYJKoZIhvcNAQcCoIIUWzCCFFcCAQExCzAJBgUrDgMCGgUAMIIDqAYJKoZIhvcNAQcBoIIDmQSCA5UxggORMAoCARQCAQEEAgwAMAsCARkCAQEEAwIBAzAMAgEOAgEBBAQCAgDlMA0CAQMCAQEEBQwDMS43MA0CAQoCAQEEBRYDMTcrMA0CAQsCAQEEBQIDANftMA0CAQ0CAQEEBQIDAiNEMA4CAQECAQEEBgIEViCnUzAOAgEJAgEBBAYCBFAyNjAwDgIBEAIBAQQGAgQzGeIjMA8CARMCAQEEBwwFMC4yMTQwEgIBDwIBAQQKAggG+H5fKs05FTAUAgEAAgEBBAwMClByb2R1Y3Rpb24wGAIBBAIBAgQQPVq4sh5T7ijYwdmVg0y0ETAcAgEFAgEBBBQTVgnLqu1g7zI2AdObKIJImbrcEjAdAgECAgEBBBUME2NvbS5uY3NvZnQubGluZWFnZXcwHgIBCAIBAQQWFhQyMDIzLTA2LTEwVDE0OjM2OjMyWjAeAgEMAgEBBBYWFDIwMjMtMDYtMTBUMTQ6MzY6MzJaMB4CARICAQEEFhYUMjAyMy0wMy0yNVQwNDoxMDowOVowSAIBBgIBAQRAfsN3QOWedUglbRzVzRE\/hNpbnWbSIdBpjuHJStTbvKi7pwWX4fdbfCv7C2G\/eKTviSofGJBb17agJCzL3sAlQDBRAgEHAgEBBEk7FSTgzB6Q\/sPGtdeACwif0uebAbilfjz9yIP7f2U+t\/fj5EQH1UETClZuVRrRVUheKN9lZtXbYfvq5BaHMRWloFu++XHsxDWTMIIBawIBEQIBAQSCAWExggFdMAsCAgasAgEBBAIWADALAgIGrQIBAQQCDAAwCwICBrACAQEEAhYAMAsCAgayAgEBBAIMADALAgIGswIBAQQCDAAwCwICBrQCAQEEAgwAMAsCAga1AgEBBAIMADALAgIGtgIBAQQCDAAwDAICBqUCAQEEAwIBATAMAgIGqwIBAQQDAgEBMAwCAgavAgEBBAMCAQAwDAICBrECAQEEAwIBADAMAgIGugIBAQQDAgEAMA8CAgauAgEBBAYCBF56cwUwGgICBqcCAQEEEQwPNDgwMDAxNTM1Njc1NzYyMBoCAgapAgEBBBEMDzQ4MDAwMTUzNTY3NTc2MjAfAgIGqAIBAQQWFhQyMDIzLTA2LTEwVDE0OjM2OjMxWjAfAgIGqgIBAQQWFhQyMDIzLTA2LTEwVDE0OjM2OjMxWjAiAgIGpgIBAQQZDBdjb20ubmNzb2Z0LmxpbmVhZ2V3X2ExM6CCDuIwggXGMIIErqADAgECAhAtqwMbvdZlc9IHKXk8RJfEMA0GCSqGSIb3DQEBBQUAMHUxCzAJBgNVBAYTAlVTMRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQLDAJHNzFEMEIGA1UEAww7QXBwbGUgV29ybGR3aWRlIERldmVsb3BlciBSZWxhdGlvbnMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMjIxMjAyMjE0NjA0WhcNMjMxMTE3MjA0MDUyWjCBiTE3MDUGA1UEAwwuTWFjIEFwcCBTdG9yZSBhbmQgaVR1bmVzIFN0b3JlIFJlY2VpcHQgU2lnbmluZzEsMCoGA1UECwwjQXBwbGUgV29ybGR3aWRlIERldmVsb3BlciBSZWxhdGlvbnMxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwN3GrrTovG3rwX21zphZ9lBYtkLcleMaxfXPZKp\/0sxhTNYU43eBxFkxtxnHTUurnSemHD5UclAiHj0wHUoORuXYJikVS+MgnK7V8yVj0JjUcfhulvOOoArFBDXpOPer+DuU2gflWzmF\/515QPQaCq6VWZjTHFyKbAV9mh80RcEEzdXJkqVGFwaspIXzd1wfhfejQebbExBvbfAh6qwmpmY9XoIVx1ybKZZNfopOjni7V8k1lHu2AM4YCot1lZvpwxQ+wRA0BG23PDcz380UPmIMwN8vcrvtSr\/jyGkNfpZtHU8QN27T\/D0aBn1sARTIxF8xalLxMwXIYOPGA80mgQIDAQABo4ICOzCCAjcwDAYDVR0TAQH\/BAIwADAfBgNVHSMEGDAWgBRdQhBsG7vHUpdORL0TJ7k6EneDKzBwBggrBgEFBQcBAQRkMGIwLQYIKwYBBQUHMAKGIWh0dHA6Ly9jZXJ0cy5hcHBsZS5jb20vd3dkcmc3LmRlcjAxBggrBgEFBQcwAYYlaHR0cDovL29jc3AuYXBwbGUuY29tL29jc3AwMy13d2RyZzcwMTCCAR8GA1UdIASCARYwggESMIIBDgYKKoZIhvdjZAUGATCB\/zA3BggrBgEFBQcCARYraHR0cHM6Ly93d3cuYXBwbGUuY29tL2NlcnRpZmljYXRlYXV0aG9yaXR5LzCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjAwBgNVHR8EKTAnMCWgI6Ahhh9odHRwOi8vY3JsLmFwcGxlLmNvbS93d2RyZzcuY3JsMB0GA1UdDgQWBBSyRX3DRIprTEmvblHeF8lRRu\/7NDAOBgNVHQ8BAf8EBAMCB4AwEAYKKoZIhvdjZAYLAQQCBQAwDQYJKoZIhvcNAQEFBQADggEBAHeKAt2kspClrJ+HnX5dt7xpBKMa\/2Rx09HKJqGLePMVKT5wzOtVcCSbUyIJuKsxLJZ4+IrOFovPKD4SteF6dL9BTFkNb4BWKUaBj+wVlA9Q95m3ln+Fc6eZ7D4mpFTsx77\/fiR\/xsTmUBXxWRvk94QHKxWUs5bp2J6FXUR0rkXRqO\/5pe4dVhlabeorG6IRNA03QBTg6\/Gjx3aVZgzbzV8bYn\/lKmD2OV2OLS6hxQG5R13RylulVel+o3sQ8wOkgr\/JtFWhiFgiBfr9eWthaBD\/uNHuXuSszHKEbLMCFSuqOa+wBeZXWw+kKKYppEuHd52jEN9i2HloYOf6TsrIZMswggRVMIIDPaADAgECAhQ0GFj\/Af4GP47xnx\/pPAG0wUb\/yTANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJVUzETMBEGA1UEChMKQXBwbGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxFjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwHhcNMjIxMTE3MjA0MDUzWhcNMjMxMTE3MjA0MDUyWjB1MQswCQYDVQQGEwJVUzETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UECwwCRzcxRDBCBgNVBAMMO0FwcGxlIFdvcmxkd2lkZSBEZXZlbG9wZXIgUmVsYXRpb25zIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArK7R07aKsRsola3eUVFMPzPhTlyvs\/wC0mVPKtR0aIx1F2XPKORICZhxUjIsFk54jpJWZKndi83i1Mc7ohJFNwIZYmQvf2HG01kiv6v5FKPttp6Zui\/xsdwwQk+2trLGdKpiVrvtRDYP0eUgdJNXOl2e3AH8eG9pFjXDbgHCnnLUcTaxdgl6vg0ql\/GwXgsbEq0rqwffYy31iOkyEqJVWEN2PD0XgB8p27Gpn6uWBZ0V3N3bTg\/nE3xaKy4CQfbuemq2c2D3lxkUi5UzOJPaACU2rlVafJ\/59GIEB3TpHaeVVyOsKyTaZE8ocumWsAg8iBsUY0PXia6YwfItjuNRJQIDAQABo4HvMIHsMBIGA1UdEwEB\/wQIMAYBAf8CAQAwHwYDVR0jBBgwFoAUK9BpR5R2Cf70a40uQKb3R01\/CF4wRAYIKwYBBQUHAQEEODA2MDQGCCsGAQUFBzABhihodHRwOi8vb2NzcC5hcHBsZS5jb20vb2NzcDAzLWFwcGxlcm9vdGNhMC4GA1UdHwQnMCUwI6AhoB+GHWh0dHA6Ly9jcmwuYXBwbGUuY29tL3Jvb3QuY3JsMB0GA1UdDgQWBBRdQhBsG7vHUpdORL0TJ7k6EneDKzAOBgNVHQ8BAf8EBAMCAQYwEAYKKoZIhvdjZAYCAQQCBQAwDQYJKoZIhvcNAQEFBQADggEBAFKjCCkTZbe1H+Y0A+32GHe8PcontXDs7GwzS\/aZJZQHniEzA2r1fQouK98IqYLeSn\/h5wtLBbgnmEndwQyG14FkroKcxEXx6o8cIjDjoiVhRIn+hXpW8HKSfAxEVCS3taSfJvAy+VedanlsQO0PNAYGQv\/YDjFlbeYuAdkGv8XKDa5H1AUXiDzpnOQZZG2KlK0R3AH25Xivrehw1w1dgT5GKiyuJKHH0uB9vx31NmvF3qkKmoCxEV6yZH6zwVfMwmxZmbf0sN0x2kjWaoHusotQNRbm51xxYm6w8lHiqG34Kstoc8amxBpDSQE+qakAioZsg4jSXHBXetr4dswZ1bAwggS7MIIDo6ADAgECAgECMA0GCSqGSIb3DQEBBQUAMGIxCzAJBgNVBAYTAlVTMRMwEQYDVQQKEwpBcHBsZSBJbmMuMSYwJAYDVQQLEx1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEWMBQGA1UEAxMNQXBwbGUgUm9vdCBDQTAeFw0wNjA0MjUyMTQwMzZaFw0zNTAyMDkyMTQwMzZaMGIxCzAJBgNVBAYTAlVTMRMwEQYDVQQKEwpBcHBsZSBJbmMuMSYwJAYDVQQLEx1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEWMBQGA1UEAxMNQXBwbGUgUm9vdCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOSRqQkfkdseR1DrBe1eeYQt6zaiV0xV7IsZid75S2z1B6siMALoGD74UAnTf0GomPnRymacJGsR0KO75Bsqwx+VnnoMpEeLW9QWNzPLxA9NzhRp0ckZcvVdDtV\/X5vyJQO6VY9NXQ3xZDUjFUsVWR2zlPf2nJ7PULrBWFBnjwi0IPfLrCwgb3C2PwEwjLdDzw+dPfMrSSgayP7OtbkO2V4c1ss9tTqt9A8OAJILsSEWLnTVPA3bYharo3GSR1NVwa8vQbP4++NwzeajTEV+H0xrUJZBicR0YgsQg0GHM4qBsTBY7FoEMoxos48d3mVz\/2deZbxJ2HafMxRloXeUyS0CAwEAAaOCAXowggF2MA4GA1UdDwEB\/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH\/MB0GA1UdDgQWBBQr0GlHlHYJ\/vRrjS5ApvdHTX8IXjAfBgNVHSMEGDAWgBQr0GlHlHYJ\/vRrjS5ApvdHTX8IXjCCAREGA1UdIASCAQgwggEEMIIBAAYJKoZIhvdjZAUBMIHyMCoGCCsGAQUFBwIBFh5odHRwczovL3d3dy5hcHBsZS5jb20vYXBwbGVjYS8wgcMGCCsGAQUFBwICMIG2GoGzUmVsaWFuY2Ugb24gdGhpcyBjZXJ0aWZpY2F0ZSBieSBhbnkgcGFydHkgYXNzdW1lcyBhY2NlcHRhbmNlIG9mIHRoZSB0aGVuIGFwcGxpY2FibGUgc3RhbmRhcmQgdGVybXMgYW5kIGNvbmRpdGlvbnMgb2YgdXNlLCBjZXJ0aWZpY2F0ZSBwb2xpY3kgYW5kIGNlcnRpZmljYXRpb24gcHJhY3RpY2Ugc3RhdGVtZW50cy4wDQYJKoZIhvcNAQEFBQADggEBAFw2mUwteLftjJvc83eb8nbSdzBPwR+Fg4UbmT1HN\/Kpm0COLNSxkBLYvvRzm+7SZA\/LeU802KI++Xj\/a8gH7H05g4tTINM4xLG\/mk8Ka\/8r\/FmnBQl8F0BWER5007eLIztHo9VvJOLr0bdw3w9F4SfK8W147ee1Fxeo3H4iNcol1dkP1mvUoiQjEfehrI9zgWDGG1sJL5Ky+ERI8GA4nhX1PSZnIIozavcNgs\/e66Mv+VNqW2TAYzN39zoHLFbr2g8hDtq6cxlPtdk2f8GHVdmnmbkyQvvY1XGefqFStxu9k0IkEirHDx22TZxeY8hLgBdQqorV2uT80AkHN7B1dSExggGxMIIBrQIBATCBiTB1MQswCQYDVQQGEwJVUzETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UECwwCRzcxRDBCBgNVBAMMO0FwcGxlIFdvcmxkd2lkZSBEZXZlbG9wZXIgUmVsYXRpb25zIENlcnRpZmljYXRpb24gQXV0aG9yaXR5AhAtqwMbvdZlc9IHKXk8RJfEMAkGBSsOAwIaBQAwDQYJKoZIhvcNAQEBBQAEggEAKFgnGnib1CC5kEp+CgI1n8zS1IqUtFOVIpT+C7oAOg8kxquHF6PPNpNrhdy8wZMCgN67dijuIZ8ajKr2D5OGZZdnohfOZGN\/JDgqBWiwe7qSSqE9Ym2yxz58UAlFeF+1qGkn5DDiKDIfVADd\/ZC2XFnw\/ctDh+hjZOFzjDXYql45rdXBotobMrFfoOwKLmiAWrBSnymz0ri4sZw33icDdjnUyj2vWgBAvx4FCxSweWpE50GbBJjD2i0jMRNNWR80qNa\/mppxN96G0FrQD4tM2VdrGCkQDGIpovIazridCuVQppIdKKPQ25jF6h+TARPOFSE\/mMXGT\/x7vYtNcCARPw=="};
    
    NSDictionary *dic = @{@"receipt-data":@"MIIUWAYJKoZIhvcNAQcCoIIUSTCCFEUCAQExCzAJBgUrDgMCGgUAMIIDlgYJKoZIhvcNAQcBoIIDhwSCA4MxggN\/MAoCARQCAQEEAgwAMAsCARkCAQEEAwIBAzAMAgEOAgEBBAQCAgDlMA0CAQMCAQEEBQwDMS42MA0CAQoCAQEEBRYDMTcrMA0CAQsCAQEEBQIDANftMA0CAQ0CAQEEBQIDAiNEMA4CAQECAQEEBgIEViCnUzAOAgEJAgEBBAYCBFAyNjAwDgIBEAIBAQQGAgQzDRp3MA8CARMCAQEEBwwFMC4yMTQwEgIBDwIBAQQKAggG+H5fKs05FTAUAgEAAgEBBAwMClByb2R1Y3Rpb24wGAIBBAIBAgQQChgsM\/5qIfN5CRf1U9yZtzAcAgEFAgEBBBTg+uyXqYl1WNY19LAFkjtlG2ghCzAdAgECAgEBBBUME2NvbS5uY3NvZnQubGluZWFnZXcwHgIBCAIBAQQWFhQyMDIzLTA1LTA0VDE1OjA2OjU2WjAeAgEMAgEBBBYWFDIwMjMtMDUtMDRUMTU6MDY6NTZaMB4CARICAQEEFhYUMjAyMy0wMy0yNVQwNDoxMDowOVowPQIBBwIBAQQ119fkoMbuMCVimSR2KSFS0BAj+0rgm51\/wVm+dFHg4qYTW\/nFQ0kA8glSOc2eg58+LQ0b3C4wSgIBBgIBAQRCjZPVY13s3XDzvh3NsvIuqvMOgSfeWJQvRWm6c5Ah2jraW0CliemohW4jP\/8i5r1IJWo3+Zdhaxgn3liyTAIzZA1JMIIBawIBEQIBAQSCAWExggFdMAsCAgasAgEBBAIWADALAgIGrQIBAQQCDAAwCwICBrACAQEEAhYAMAsCAgayAgEBBAIMADALAgIGswIBAQQCDAAwCwICBrQCAQEEAgwAMAsCAga1AgEBBAIMADALAgIGtgIBAQQCDAAwDAICBqUCAQEEAwIBATAMAgIGqwIBAQQDAgEBMAwCAgavAgEBBAMCAQAwDAICBrECAQEEAwIBADAMAgIGugIBAQQDAgEAMA8CAgauAgEBBAYCBF56cwUwGgICBqcCAQEEEQwPNDgwMDAxNDk3OTM4ODU5MBoCAgapAgEBBBEMDzQ4MDAwMTQ5NzkzODg1OTAfAgIGqAIBAQQWFhQyMDIzLTA1LTA0VDE1OjA2OjU2WjAfAgIGqgIBAQQWFhQyMDIzLTA1LTA0VDE1OjA2OjU2WjAiAgIGpgIBAQQZDBdjb20ubmNzb2Z0LmxpbmVhZ2V3X2ExM6CCDuIwggXGMIIErqADAgECAhAtqwMbvdZlc9IHKXk8RJfEMA0GCSqGSIb3DQEBBQUAMHUxCzAJBgNVBAYTAlVTMRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQLDAJHNzFEMEIGA1UEAww7QXBwbGUgV29ybGR3aWRlIERldmVsb3BlciBSZWxhdGlvbnMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMjIxMjAyMjE0NjA0WhcNMjMxMTE3MjA0MDUyWjCBiTE3MDUGA1UEAwwuTWFjIEFwcCBTdG9yZSBhbmQgaVR1bmVzIFN0b3JlIFJlY2VpcHQgU2lnbmluZzEsMCoGA1UECwwjQXBwbGUgV29ybGR3aWRlIERldmVsb3BlciBSZWxhdGlvbnMxEzARBgNVBAoMCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwN3GrrTovG3rwX21zphZ9lBYtkLcleMaxfXPZKp\/0sxhTNYU43eBxFkxtxnHTUurnSemHD5UclAiHj0wHUoORuXYJikVS+MgnK7V8yVj0JjUcfhulvOOoArFBDXpOPer+DuU2gflWzmF\/515QPQaCq6VWZjTHFyKbAV9mh80RcEEzdXJkqVGFwaspIXzd1wfhfejQebbExBvbfAh6qwmpmY9XoIVx1ybKZZNfopOjni7V8k1lHu2AM4YCot1lZvpwxQ+wRA0BG23PDcz380UPmIMwN8vcrvtSr\/jyGkNfpZtHU8QN27T\/D0aBn1sARTIxF8xalLxMwXIYOPGA80mgQIDAQABo4ICOzCCAjcwDAYDVR0TAQH\/BAIwADAfBgNVHSMEGDAWgBRdQhBsG7vHUpdORL0TJ7k6EneDKzBwBggrBgEFBQcBAQRkMGIwLQYIKwYBBQUHMAKGIWh0dHA6Ly9jZXJ0cy5hcHBsZS5jb20vd3dkcmc3LmRlcjAxBggrBgEFBQcwAYYlaHR0cDovL29jc3AuYXBwbGUuY29tL29jc3AwMy13d2RyZzcwMTCCAR8GA1UdIASCARYwggESMIIBDgYKKoZIhvdjZAUGATCB\/zA3BggrBgEFBQcCARYraHR0cHM6Ly93d3cuYXBwbGUuY29tL2NlcnRpZmljYXRlYXV0aG9yaXR5LzCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjAwBgNVHR8EKTAnMCWgI6Ahhh9odHRwOi8vY3JsLmFwcGxlLmNvbS93d2RyZzcuY3JsMB0GA1UdDgQWBBSyRX3DRIprTEmvblHeF8lRRu\/7NDAOBgNVHQ8BAf8EBAMCB4AwEAYKKoZIhvdjZAYLAQQCBQAwDQYJKoZIhvcNAQEFBQADggEBAHeKAt2kspClrJ+HnX5dt7xpBKMa\/2Rx09HKJqGLePMVKT5wzOtVcCSbUyIJuKsxLJZ4+IrOFovPKD4SteF6dL9BTFkNb4BWKUaBj+wVlA9Q95m3ln+Fc6eZ7D4mpFTsx77\/fiR\/xsTmUBXxWRvk94QHKxWUs5bp2J6FXUR0rkXRqO\/5pe4dVhlabeorG6IRNA03QBTg6\/Gjx3aVZgzbzV8bYn\/lKmD2OV2OLS6hxQG5R13RylulVel+o3sQ8wOkgr\/JtFWhiFgiBfr9eWthaBD\/uNHuXuSszHKEbLMCFSuqOa+wBeZXWw+kKKYppEuHd52jEN9i2HloYOf6TsrIZMswggRVMIIDPaADAgECAhQ0GFj\/Af4GP47xnx\/pPAG0wUb\/yTANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJVUzETMBEGA1UEChMKQXBwbGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxFjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwHhcNMjIxMTE3MjA0MDUzWhcNMjMxMTE3MjA0MDUyWjB1MQswCQYDVQQGEwJVUzETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UECwwCRzcxRDBCBgNVBAMMO0FwcGxlIFdvcmxkd2lkZSBEZXZlbG9wZXIgUmVsYXRpb25zIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArK7R07aKsRsola3eUVFMPzPhTlyvs\/wC0mVPKtR0aIx1F2XPKORICZhxUjIsFk54jpJWZKndi83i1Mc7ohJFNwIZYmQvf2HG01kiv6v5FKPttp6Zui\/xsdwwQk+2trLGdKpiVrvtRDYP0eUgdJNXOl2e3AH8eG9pFjXDbgHCnnLUcTaxdgl6vg0ql\/GwXgsbEq0rqwffYy31iOkyEqJVWEN2PD0XgB8p27Gpn6uWBZ0V3N3bTg\/nE3xaKy4CQfbuemq2c2D3lxkUi5UzOJPaACU2rlVafJ\/59GIEB3TpHaeVVyOsKyTaZE8ocumWsAg8iBsUY0PXia6YwfItjuNRJQIDAQABo4HvMIHsMBIGA1UdEwEB\/wQIMAYBAf8CAQAwHwYDVR0jBBgwFoAUK9BpR5R2Cf70a40uQKb3R01\/CF4wRAYIKwYBBQUHAQEEODA2MDQGCCsGAQUFBzABhihodHRwOi8vb2NzcC5hcHBsZS5jb20vb2NzcDAzLWFwcGxlcm9vdGNhMC4GA1UdHwQnMCUwI6AhoB+GHWh0dHA6Ly9jcmwuYXBwbGUuY29tL3Jvb3QuY3JsMB0GA1UdDgQWBBRdQhBsG7vHUpdORL0TJ7k6EneDKzAOBgNVHQ8BAf8EBAMCAQYwEAYKKoZIhvdjZAYCAQQCBQAwDQYJKoZIhvcNAQEFBQADggEBAFKjCCkTZbe1H+Y0A+32GHe8PcontXDs7GwzS\/aZJZQHniEzA2r1fQouK98IqYLeSn\/h5wtLBbgnmEndwQyG14FkroKcxEXx6o8cIjDjoiVhRIn+hXpW8HKSfAxEVCS3taSfJvAy+VedanlsQO0PNAYGQv\/YDjFlbeYuAdkGv8XKDa5H1AUXiDzpnOQZZG2KlK0R3AH25Xivrehw1w1dgT5GKiyuJKHH0uB9vx31NmvF3qkKmoCxEV6yZH6zwVfMwmxZmbf0sN0x2kjWaoHusotQNRbm51xxYm6w8lHiqG34Kstoc8amxBpDSQE+qakAioZsg4jSXHBXetr4dswZ1bAwggS7MIIDo6ADAgECAgECMA0GCSqGSIb3DQEBBQUAMGIxCzAJBgNVBAYTAlVTMRMwEQYDVQQKEwpBcHBsZSBJbmMuMSYwJAYDVQQLEx1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEWMBQGA1UEAxMNQXBwbGUgUm9vdCBDQTAeFw0wNjA0MjUyMTQwMzZaFw0zNTAyMDkyMTQwMzZaMGIxCzAJBgNVBAYTAlVTMRMwEQYDVQQKEwpBcHBsZSBJbmMuMSYwJAYDVQQLEx1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEWMBQGA1UEAxMNQXBwbGUgUm9vdCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOSRqQkfkdseR1DrBe1eeYQt6zaiV0xV7IsZid75S2z1B6siMALoGD74UAnTf0GomPnRymacJGsR0KO75Bsqwx+VnnoMpEeLW9QWNzPLxA9NzhRp0ckZcvVdDtV\/X5vyJQO6VY9NXQ3xZDUjFUsVWR2zlPf2nJ7PULrBWFBnjwi0IPfLrCwgb3C2PwEwjLdDzw+dPfMrSSgayP7OtbkO2V4c1ss9tTqt9A8OAJILsSEWLnTVPA3bYharo3GSR1NVwa8vQbP4++NwzeajTEV+H0xrUJZBicR0YgsQg0GHM4qBsTBY7FoEMoxos48d3mVz\/2deZbxJ2HafMxRloXeUyS0CAwEAAaOCAXowggF2MA4GA1UdDwEB\/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH\/MB0GA1UdDgQWBBQr0GlHlHYJ\/vRrjS5ApvdHTX8IXjAfBgNVHSMEGDAWgBQr0GlHlHYJ\/vRrjS5ApvdHTX8IXjCCAREGA1UdIASCAQgwggEEMIIBAAYJKoZIhvdjZAUBMIHyMCoGCCsGAQUFBwIBFh5odHRwczovL3d3dy5hcHBsZS5jb20vYXBwbGVjYS8wgcMGCCsGAQUFBwICMIG2GoGzUmVsaWFuY2Ugb24gdGhpcyBjZXJ0aWZpY2F0ZSBieSBhbnkgcGFydHkgYXNzdW1lcyBhY2NlcHRhbmNlIG9mIHRoZSB0aGVuIGFwcGxpY2FibGUgc3RhbmRhcmQgdGVybXMgYW5kIGNvbmRpdGlvbnMgb2YgdXNlLCBjZXJ0aWZpY2F0ZSBwb2xpY3kgYW5kIGNlcnRpZmljYXRpb24gcHJhY3RpY2Ugc3RhdGVtZW50cy4wDQYJKoZIhvcNAQEFBQADggEBAFw2mUwteLftjJvc83eb8nbSdzBPwR+Fg4UbmT1HN\/Kpm0COLNSxkBLYvvRzm+7SZA\/LeU802KI++Xj\/a8gH7H05g4tTINM4xLG\/mk8Ka\/8r\/FmnBQl8F0BWER5007eLIztHo9VvJOLr0bdw3w9F4SfK8W147ee1Fxeo3H4iNcol1dkP1mvUoiQjEfehrI9zgWDGG1sJL5Ky+ERI8GA4nhX1PSZnIIozavcNgs\/e66Mv+VNqW2TAYzN39zoHLFbr2g8hDtq6cxlPtdk2f8GHVdmnmbkyQvvY1XGefqFStxu9k0IkEirHDx22TZxeY8hLgBdQqorV2uT80AkHN7B1dSExggGxMIIBrQIBATCBiTB1MQswCQYDVQQGEwJVUzETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UECwwCRzcxRDBCBgNVBAMMO0FwcGxlIFdvcmxkd2lkZSBEZXZlbG9wZXIgUmVsYXRpb25zIENlcnRpZmljYXRpb24gQXV0aG9yaXR5AhAtqwMbvdZlc9IHKXk8RJfEMAkGBSsOAwIaBQAwDQYJKoZIhvcNAQEBBQAEggEAcW97UwEePokcxXLHVLou3HsgU9mqi72OjeW4kTQrX29+C+qiRFVS9miydaiTQBjYXJcqR4fligCgPaViKOpB\/hZ8gIDRUGyQOwr9fQzDQrfyYwyXHKATdYayYcB6SUglsOTYlFB7wQaO\/kVoDkyEomjcHQIyfB2m47nFCoZ39lHjTM4sOqezsQ2YyQbPUSJPXrhvOSlqkLzolzZuSATNml9r4SnpZsLFJyfbw8B3zbU13l2c4W5HGvxZ1zpMrtUIouktoW9v+KOE+SU2bEgfT12OYk\/d1q5Ei3bNHgoDB+GEC2QVSDwoJVVV58K5azswex7SLVJfgSaHBAk1UXOfRQ=="};

    
    NSString *url = @"https://buy.itunes.apple.com/verifyReceipt";

    [manager  POST:url parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    
//    {
//        "original-purchase-date-pst" = "2018-06-18 22:48:54 America/Los_Angeles";
//        "purchase-date-ms" = "1529387334343";
//        "unique-identifier" = "f52e53ccc770fa8149322ad8480892b958652cef";
//        "original-transaction-id" = "340000248394359";
//        "bvrs" = "1";
//        "app-item-id" = "1258524226";
//        "transaction-id" = "340000248394359";
//        "quantity" = "1";
//        "original-purchase-date-ms" = "1529387334343";
//        "unique-vendor-identifier" = "81D86D7C-86AE-4038-B4F7-116AC957A1D3";
//        "item-id" = "1319809565";
//        "version-external-identifier" = "826781590";
//        "is-in-intro-offer-period" = "false";
//        "product-id" = "com.love.diamond6";
//        "purchase-date" = "2018-06-19 05:48:54 Etc/GMT";
//        "is-trial-period" = "false";
//        "original-purchase-date" = "2018-06-19 05:48:54 Etc/GMT";
//        "bid" = "com.papegames.evol";
//        "purchase-date-pst" = "2018-06-18 22:48:54 America/Los_Angeles";
//    }
}
@end
