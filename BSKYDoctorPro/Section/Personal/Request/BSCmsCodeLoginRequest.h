//
//  BSCmsCodeLoginRequest.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/17.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSCmsCodeLoginRequest : BSBaseRequest

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *cmsCode;

@end
