//
//  ResetPasswordVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ResetPasswordType) {
    
    ResetPasswordTypeForget = 1,    // 忘记密码
    
    ResetPasswordTypeReset = 2        //  重置密码
};

@interface ResetPasswordVC : UIViewController

@property (nonatomic ,assign) ResetPasswordType type;

@end
