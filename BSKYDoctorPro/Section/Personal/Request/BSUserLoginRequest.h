//
//  BSUserLoginRequest.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/18.
//  Copyright © 2017年 ky. All rights reserved.
//
//  

#import <Foundation/Foundation.h>

@interface BSUserLoginRequest : BSBaseRequest

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;

@end
