//
//  RegistDoctorRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
@class RegistDoctorModel;
@interface RegistDoctorRequest : BSBaseRequest

@property (nonatomic, copy) NSDictionary *userInfoForm;

@end

@interface RegistDoctorModel: NSObject

@property (nonatomic, copy) NSString *mobileNo;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *documentNo;
@property (nonatomic, copy) NSNumber *organizationId;
@property (nonatomic, copy) NSString *practiceType;
- (void)entryptModel;
@end
