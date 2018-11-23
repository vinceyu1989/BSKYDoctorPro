//
//  ZLFollowupDetailModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/27.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZLDrugModel;

@interface ZLFollowupLastModel : NSObject

@property (nonatomic, copy) NSString * adverseDrugReactionDescribe;
@property (nonatomic, copy) NSString * adverseDrugReactions;
@property (nonatomic, copy) NSString * bmi;
@property (nonatomic, copy) NSString * bodyOther;
@property (nonatomic, copy) NSString * category;
@property (nonatomic, copy) NSString * causeOfReferral;
@property (nonatomic, copy) NSString * complianceBehavior;
@property (nonatomic, copy) NSString * dailyAlcohol;
@property (nonatomic, copy) NSString * dailySmoking;
@property (nonatomic, copy) NSString * dbp;
@property (nonatomic, copy) NSString * dorsalArteryOfFoot;
@property (nonatomic, strong) NSMutableArray * drugList;
@property (nonatomic, copy) NSString * examDate;
@property (nonatomic, copy) NSString * examOther;
@property (nonatomic, copy) NSString * exerciseMinute;
@property (nonatomic, copy) NSString * exerciseWeekTimes;
@property (nonatomic, copy) NSString * followUpDate;
@property (nonatomic, copy) NSString * followUpDoctorId;
@property (nonatomic, copy) NSString * fuClassification;
@property (nonatomic, copy) NSString * glu;
@property (nonatomic, copy) NSString * hba1c;
@property (nonatomic, copy) NSString * height;
@property (nonatomic, copy) NSString * idField;
@property (nonatomic, copy) NSString * insulinAmount;
@property (nonatomic, copy) NSString * insulinType;
@property (nonatomic, copy) NSString * lowBloodSugarReactions;
@property (nonatomic, copy) NSString * medicationCompliance;
@property (nonatomic, copy) NSString * nextBmi;
@property (nonatomic, copy) NSString * nextDailyAlcohol;
@property (nonatomic, copy) NSString * nextDailySmoking;
@property (nonatomic, copy) NSString * nextExerciseMinute;
@property (nonatomic, copy) NSString * nextExerciseWeekTimes;
@property (nonatomic, copy) NSString * nextFollowUpDate;
@property (nonatomic, copy) NSString * nextStapleDailyGrams;
@property (nonatomic, copy) NSString * nextWeight;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * orgId;
@property (nonatomic, copy) NSString * personId;
@property (nonatomic, copy) NSString * personName;
@property (nonatomic, copy) NSString * projectId;
@property (nonatomic, copy) NSString * protoTypeId;
@property (nonatomic, copy) NSString * psychologicalAdjustment;
@property (nonatomic, copy) NSString * registrant;
@property (nonatomic, copy) NSString * registrantDate;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * sbp;
@property (nonatomic, copy) NSString * serviceId;
@property (nonatomic, copy) NSString * stapleDailyGrams;
@property (nonatomic, copy) NSString * symptom;
@property (nonatomic, copy) NSString * symptomOther;
@property (nonatomic, copy) NSString * updateDate;
@property (nonatomic, copy) NSString * version;
@property (nonatomic, copy) NSString * wayUp;
@property (nonatomic, copy) NSString * weight;

@property (nonatomic, assign) FollowupType type;

// 高血压特有
@property (nonatomic, strong) NSString * heartRate;
@property (nonatomic, strong) NSString * nextSaltintake;
@property (nonatomic, strong) NSString * saltintake;
@property (nonatomic, strong) NSString * supplementaryExamination;

@end

@interface ZLDrugModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * frequency;
@property (nonatomic, copy) NSString * rate;
@property (nonatomic, copy) NSString * unit;
@property (nonatomic, copy) NSString * amount;

@end
