//
//  HealthScanRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/12/1.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

/*
 * 应用业务代码
 * 默认 BusinessType = 0
 */
typedef NS_ENUM(NSInteger, ScanBusinessType) {
    ScanBusinessHomeDoctorType = 0  , //家庭医生服务(包括签约)
    ScanBusinessHealthFilesType     , //健康档案
    ScanBusinessEHVisitType         , //高血压随访
    ScanBusinessDMVisitType         , //糖尿病随访
};

@class HealthScanRequestModel,HealthScanRespondseModel;

@interface HealthScanRequest : BSBaseRequest

@property (nonatomic, copy) NSString *ehealthCode;
@property (nonatomic, copy)   NSDictionary    *c5RequestForm;
@property (nonatomic, assign) ScanBusinessType businessType;
@property (nonatomic, strong) HealthScanRequestModel    *requestModel;
@property (nonatomic, strong) HealthScanRespondseModel  *responseModel;

@end

@interface HealthScanRequestModel : NSObject

@property (nonatomic, copy) NSString *ewmsg;
@property (nonatomic, copy) NSString *business; //应用业务代码

@end

@interface HealthScanRespondseModel : NSObject

@property (nonatomic, copy) NSString *zjlb;//证件类别
@property (nonatomic, copy) NSString *zjhm;//证件号码
- (void)decryptModel;
@end
