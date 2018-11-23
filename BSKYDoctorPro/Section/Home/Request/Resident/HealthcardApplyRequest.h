//
//  HealthcardApplyRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/4/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

//  申请健康卡状态
typedef NS_ENUM(NSUInteger, HealthCardSate) {
    
    HealthCardSateSuccess = 1,    // 成功
    
    HealthCardSateVerifiedFailure = 2,   // 实名认证失败
    
    HealthCardSateApplyFailure = 3,   // 申领失败
    
    HealthCardSateTelRepeat = 4,   // 电话号码重复
};

@class HealthCardUpModel,HealthCardDataModel;

@interface HealthcardApplyRequest : BSBaseRequest

@property (nonatomic, strong) NSMutableDictionary * healthCardFrom;

@property (nonatomic, strong) HealthCardDataModel * dataModel;

@end

@interface HealthCardUpModel : NSObject

@property (nonatomic, copy) NSString * divisionCode;
@property (nonatomic, copy) NSString * documentNo;
@property (nonatomic, assign) NSInteger orgId;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * realName;
- (void)encryptModel;
@end

@interface HealthCardDataModel : NSObject

@property (nonatomic, copy) NSString * healthSate;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * msg;

@end


