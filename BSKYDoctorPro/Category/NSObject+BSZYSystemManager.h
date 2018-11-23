//
//  NSObject+BSZYSystemManager.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BSZYSystemManager)

/**
 *  检查设备是否允许打卡摄像头
 */
+ (void)checkAuthorizationStatusForCameraWithGrantBlock:(void (^)(void))grant
                                            DeniedBlock:(void (^)(void))denie;

/**
 *  检查设备是否允许访问相册
 */
+ (void)checkAuthorizationStatusForPhotoLibraryWithGrantBlock:(void (^)(void))grant
                                                  DeniedBlock:(void (^)(void))denied;

@end
