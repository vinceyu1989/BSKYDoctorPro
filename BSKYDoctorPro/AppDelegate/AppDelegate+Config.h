//
//  AppDelegate+Config.h
//  BSKYDoctorPro
//
//  Created by Apple on 2017/7/21.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AppDelegate.h"
#import <GTSDK/GeTuiSdk.h>

@interface AppDelegate (Config)

- (void)configNetworkWithType:(AppType)type;

- (void)configGeTuiWithType:(AppType)type;

- (void)configUMeng;

- (void)configIQKeyboard;

- (void)registerRemoteNotification;

@end
