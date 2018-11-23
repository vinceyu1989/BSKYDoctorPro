//
//  NSObject+BSZYSystemManager.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NSObject+BSZYSystemManager.h"
#import <Photos/Photos.h>

@implementation NSObject (BSZYSystemManager)

+ (void)checkAuthorizationStatusForCameraWithGrantBlock:(void (^)(void))grant
                                            DeniedBlock:(void (^)(void))denied {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                // 第一次选择
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (grant) {
                            grant();
                        }
                    });
                } else {
                    
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            if (grant) {
                grant();
            }
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            if (denied) {
                denied();
            }
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法打开相机");
        }
    } else {
        
    }
}

+ (void)checkAuthorizationStatusForPhotoLibraryWithGrantBlock:(void (^)(void))grant
                                                  DeniedBlock:(void (^)(void))denied {
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (grant) {
                        grant();
                    }
                });
            } else {
                
            }
        }];
        
    } else if (status == PHAuthorizationStatusAuthorized) {
        if (grant) {
            grant();
        }
    } else if (status == PHAuthorizationStatusDenied) {
        if (denied) {
            denied();
        }
    } else if (status == PHAuthorizationStatusRestricted) {
        NSLog(@"因为系统原因, 无法访问相册");
    }
}
@end
