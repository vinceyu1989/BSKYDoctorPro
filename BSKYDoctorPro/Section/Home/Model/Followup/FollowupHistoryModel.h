//
//  FollowupHistoryModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/10/31.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowupHistoryModel : NSObject

// 糖尿病
@property (nonatomic, copy) NSString * complianceBehaviorStr;
@property (nonatomic, copy) NSString * doctorName;
@property (nonatomic, copy) NSString * fastingBloodGlucose;
@property (nonatomic, copy) NSString * followUpDate;
@property (nonatomic, copy) NSString * fuClassificationStr;
@property (nonatomic, copy) NSString * idField;
@property (nonatomic, copy) NSString * lowBloodSugarReactionsStr;
@property (nonatomic, copy) NSString * medicationComplianceStr;
@property (nonatomic, copy) NSString * symptomStr;
@property (nonatomic, copy) NSString * wayUpStr;
// 高血压特有的
@property (nonatomic, copy) NSString * dbp;
@property (nonatomic, copy) NSString * saltIntakeStr;
@property (nonatomic, copy) NSString * sbp;

// 高糖
@property (nonatomic, copy) NSString * bloodSugar;
@property (nonatomic, copy) NSString * examDate;

@end
