//
//  CheckPhoneRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@class CheckPhoneModel;
@interface CmsCodeAndCheckRequest : BSBaseRequest

@property (nonatomic, copy) NSString    *phone;

/**
 *类型:1只获取验证码，
 *2或空:类似医生端登录且要求验证手机号是否存在，
 *3类似医生端注册且需返回姓名身份证号
 */
@property (nonatomic, strong) NSNumber  *type;

@property (nonatomic, assign) BOOL  isValid;   // 返回判断手机是否有效

@property (nonatomic, strong) CheckPhoneModel *model;

@end

@interface CheckPhoneModel : NSObject

@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString *userName;
- (void)decryptModel;
@end
