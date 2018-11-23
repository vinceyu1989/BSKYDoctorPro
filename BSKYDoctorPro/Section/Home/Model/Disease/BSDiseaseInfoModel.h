//
//  BSDiseaseInfoModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/8/21.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSDiseaseInfoModel : NSObject

@property (nonatomic, copy) NSString *Age;//年龄 ,
@property (nonatomic, copy) NSString *DIAGNOSIS_DATE;//确诊时间 ,
@property (nonatomic, copy) NSString *DOCTOR_ID;//责任医生ID ,
@property (nonatomic, copy) NSString *DOCTOR_NAME;//责任医生 ,
@property (nonatomic, copy) NSString *Gender;//性别 ,
@property (nonatomic, copy) NSString *ID;//名册ID ,
@property (nonatomic, copy) NSString *LastHlDate;//最后一次随访时间 ,
@property (nonatomic, copy) NSString *NAME ;//姓名 ,
@property (nonatomic, copy) NSString *PERSON_ID ;//居民ID ,
@property (nonatomic, copy) NSString *RecordDate ;// 建档日期 ,
@property (nonatomic, copy) NSString *Telphone ;//电话号码 ,
@property (nonatomic, copy) NSString *USER_NAME;//操作用户名 ,
@property (nonatomic, copy) NSString *strHyLevel;// 建档级别 ,
@property (nonatomic, copy) NSString *strHyRisk ;//危险度
- (void)decryptModel;
@end
