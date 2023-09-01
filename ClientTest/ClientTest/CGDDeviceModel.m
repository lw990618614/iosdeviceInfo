//
//  CGDDeviceModel.m
//  CGDeviceRoot
//
//  Created by apple on 2022/6/15.
//

#import "CGDDeviceModel.h"


@implementation CGDDeviceIPModel
//
////@property (nonatomic, readonly) NSString *awdl0ipv6;
//- (NSString *)awdl0ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *en0ipv4;
//- (NSString *)en0ipv4 {
//    return @"192.168.31.21";
//}
////@property (nonatomic, readonly) NSString *en0ipv6;
//- (NSString *)en0ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *en2ipv4;
//- (NSString *)en2ipv4 {
//    return @"192.168.31.21";
//}
////@property (nonatomic, readonly) NSString *en2ipv6;
//- (NSString *)en2ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *lo0ipv4;
//- (NSString *)lo0ipv4 {
//    return @"192.168.31.21";
//}
////@property (nonatomic, readonly) NSString *lo0ipv6;
//- (NSString *)lo0ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////
////@property (nonatomic, readonly) NSString *pdp_ip0ipv4;
//- (NSString *)pdp_ip0ipv4 {
//    return @"192.168.31.21";
//}
////@property (nonatomic, readonly) NSString *pdp_ip0ipv6;
//- (NSString *)pdp_ip0ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *utun0ipv6;
//- (NSString *)utun0ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *utun1ipv6;
//- (NSString *)utun1ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *utun2ipv6;
//- (NSString *)utun2ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *utun3ipv6;
//- (NSString *)utun3ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *utun4ipv6;
//- (NSString *)utun4ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *utun5ipv6;
//- (NSString *)utun5ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *utun6ipv6;
//- (NSString *)utun6ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *utun7ipv6;
//- (NSString *)utun7ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////
////@property (nonatomic, readonly) NSString *pdp_ip1ipv6;
//- (NSString *)pdp_ip1ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *llw0ipv6;
//- (NSString *)llw0ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *ipsec0ipv6;
//- (NSString *)ipsec0ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}
////@property (nonatomic, readonly) NSString *ipsec1ipv6;
//- (NSString *)ipsec1ipv6 {
//    return @"fe80::fd2b:2032:a3b8:5816";
//}

@end

@implementation CGDDeviceAppMsgModel

@end

@implementation CGDDeviceInputModel

@end

@implementation CGDDeviceSimInfo

@end




@implementation CGDDeviceModel

- (void)setDeviceInfo:(NSDictionary *)deviceInfo{
    _deviceInfo = deviceInfo;
}

- (NSString *)languageCode {
    return [[self.currentLanguage componentsSeparatedByString:@"-"].firstObject lowercaseString] ?: @"";
}

- (NSString *)localeIdentifier {
//    return [NSString stringWithFormat:@"%@_%@", [self languageCode], self.currentCountryCode.uppercaseString];
    if ([self.currentLanguage isEqualToString:@"zh-Hans-CN"]) {
        return @"zh_CN";
    }
    NSMutableArray *componments = [self.currentLanguage componentsSeparatedByString:@"-"].mutableCopy;
    [componments removeLastObject];
    return [[componments componentsJoinedByString:@"-"] stringByAppendingFormat:@"_%@", self.currentCountryCode];
}

- (cpu_type_t)cputypeValue {
    if ([self.cpuType.lowercaseString containsString:@"arm64"]) {
        return CPU_TYPE_ARM64;
    } else {
        return CPU_TYPE_ARM;
    }
}

- (cpu_subtype_t)cpusubtypeValue {
    if ([self.cpuType.lowercaseString isEqualToString:@"arm64e"]) {
        return CPU_SUBTYPE_ARM64E;
    } else {
        return CPU_SUBTYPE_ARM64_V8;
    }
}

@end

