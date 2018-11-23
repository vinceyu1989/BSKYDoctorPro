//
//  BSSaveEducationModel.h
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/11.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSSaveEducationModel : NSObject

@property (nonatomic, copy) NSString *DoctorID;    //医生ID
@property (nonatomic, copy) NSString *PersonID;    //居民ID

@property (nonatomic, copy) NSString *EduContent;  //健康教育内容
@property (nonatomic, copy) NSString *ActivityTime;//健康教育日期(yyyy-mm-dd)
@property (nonatomic, copy) NSString *BusinessType;//教育类型

@property (nonatomic, copy) NSString *ID;          //个人健康教育ID
@property (nonatomic, copy) NSString *SourceRecID; // 比如高血随访记录ID

@end
