//
//  ResetPasswordRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/23.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResetPasswordRequest : BSBaseRequest

@property (nonatomic , copy) NSString *phone;

@property (nonatomic , copy) NSString *cmsCode;

@property (nonatomic , copy) NSString *password;

@end
