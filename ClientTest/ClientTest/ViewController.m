//
//  ViewController.m
//  ClientTest
//
//  Created by 王鹏飞 on 16/7/1.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "ViewController.h"
#import "fishhook.h"
#import "BasicViewController.h"
#import "NetWorkInfoManager.h"

@interface ViewController ()
@property (nonatomic ,copy)NSString *age;
@end
@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.age =@"111";
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //    2,  恢复默认设置
    [filter setDefaults];
    //    3,给过滤器添加数据
    NSData *data = [@"{\"iosId\":\"00008101-001C694024B82C3A\",\"terminalId\":\"\"}" dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    //    4，获取输出的二维码
    CIImage *image = [filter outputImage]; //返回的是一个CIImage
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN((375 / 2)/CGRectGetWidth(extent), 642/CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
    EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    CIContext *context = [CIContext contextWithEAGLContext:eaglContext];

    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
  UIImage *imageddd =   [UIImage imageWithCGImage:scaledImage];
    UIImageView *vie =   [[UIImageView alloc] initWithImage:imageddd];
    vie.frame =CGRectMake(10, 200, vie.frame.size.width, vie.frame.size.height);
    [self.view addSubview:vie];

}

#pragma mark - Event Response
- (IBAction)hardWareInfoButtonTapped:(id)sender {
    
    [self _pushVCWithType:BasicInfoTypeHardWare sender:sender];
}

- (IBAction)batteryInfoButtonTapped:(id)sender {
    [self _pushVCWithType:BasicInfoTypeBattery sender:sender];
}

- (IBAction)addressInfoButtonTapped:(id)sender {
    [self _pushVCWithType:BasicInfoTypeIpAddress sender:sender];
}

- (IBAction)CPUInfoButtonTapped:(id)sender {
    [self _pushVCWithType:BasicInfoTypeCPU sender:sender];
}

- (IBAction)diskInfoButtonTapped:(id)sender {
    [self _pushVCWithType:BasicInfoTypeDisk sender:sender];
}

- (IBAction)jsbrokenTap:(id)sender {
    [self _pushVCWithType:BasicInfoTypeBroken sender:sender];
}


- (void)_pushVCWithType:(BasicInfoType)type sender:(UIButton *)sender {
    BasicViewController *basicVC = [[BasicViewController alloc] initWithType:type];
    basicVC.navigationItem.title = sender.titleLabel.text;
    [self.navigationController pushViewController:basicVC  animated:YES];
}


@end
