//
//  BSEducationModel.h
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/11.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSEducationModel : NSObject

@property (nonatomic, copy) NSString *activityTime;//起效日期(yyyy-mm-dd) ,
@property (nonatomic, copy) NSString *businessType;//教育类型 0:体检表 1:高血压 2:糖尿病 3:精神病 4:老年人 5:门诊 6:住院 15:脑卒中 16:结核病 17:COPD25:高糖合并 99:其他 ,
@property (nonatomic, copy) NSString *businessTypeA;//教育类型名称 ,
@property (nonatomic, copy) NSString *cardId;//居民身份证号 ,
@property (nonatomic, copy) NSString *eduContent;//健康教育内容 ,
@property (nonatomic, copy) NSString *idEdu;//个人健康教育ID ,
@property (nonatomic, copy) NSString *name;//责任医生姓名 ,
@property (nonatomic, copy) NSString *personCode;//居民建档档案编码 ,
@property (nonatomic, copy) NSString *personId;//居民ID ,
@property (nonatomic, copy) NSString *personName;//居民姓名 ,
@property (nonatomic, copy) NSString *R__N ;//R__N ,
@property (nonatomic, copy) NSString *userName;//操作人员姓名
@property (nonatomic, copy) NSString *SourceRecID;
- (void)decryptModel;
@end
