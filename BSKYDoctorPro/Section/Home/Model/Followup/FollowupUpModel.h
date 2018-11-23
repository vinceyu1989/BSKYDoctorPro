//
//  FollowupDiUpModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/13.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

// 弄成一个大的才能和vc匹配
@class Body,CmModel,Drug,InsulinDrug,Labora,LifeStyle,Organ,Other,TransOut;

@interface FollowupUpModel : NSObject

@property (nonatomic, strong) Body * body;
@property (nonatomic, strong) CmModel * cmModel;            // 高血压、糖尿病、高糖模型
@property (nonatomic, strong) NSMutableArray * drug;
@property (nonatomic, strong) NSMutableArray * diabetesUseList;
@property (nonatomic, strong) NSMutableArray * drugUseList;
@property (nonatomic, strong) NSMutableArray * insulinDrug;
@property (nonatomic, strong) Labora * labora;
@property (nonatomic, strong) LifeStyle * lifeStyle;
@property (nonatomic, strong) NSString * orgId;
@property (nonatomic, strong) Organ * organ;
@property (nonatomic, strong) NSMutableArray * other;
@property (nonatomic, strong) TransOut * transOut;
@property (nonatomic, strong) NSNumber *type;  //  对应的followupType

@end

@interface Other : NSObject

@property (nonatomic, strong) NSString * attrName;
@property (nonatomic, strong) NSString * otherText;

@end

@interface Organ : NSObject

@property (nonatomic, strong) NSNumber* hearing;
@property (nonatomic, strong) NSNumber* leftEye;
@property (nonatomic, strong) NSNumber* leftEyeVc;
@property (nonatomic, strong) NSNumber* motorFunction;
@property (nonatomic, strong) NSNumber* rightEye;
@property (nonatomic, strong) NSNumber* rightEyeVc;
@end

@interface LifeStyle : NSObject

@property (nonatomic, strong) NSNumber* dailyAlcoholIntake;
@property (nonatomic, strong) NSNumber* eachExerciseTime;
@property (nonatomic, strong) NSNumber* exerciseFrequency;
@property (nonatomic, strong) NSNumber* exerciseWeekTimes;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSNumber* smoking;
@end

@interface Labora : NSObject

@property (nonatomic, strong) NSNumber* albumin;
@property (nonatomic, strong) NSString * bUltrasonicWave;
@property (nonatomic, strong) NSNumber* bilirubin;
@property (nonatomic, strong) NSNumber* bloodTransaminase;
@property (nonatomic, strong) NSNumber* bun;
@property (nonatomic, strong) NSString * cervicalSmear;
@property (nonatomic, strong) NSString * chestXRay;
@property (nonatomic, strong) NSString * differentialCount;
@property (nonatomic, strong) NSString * ecg;
@property (nonatomic, strong) NSString * erythrocytes;
@property (nonatomic, strong) NSString * examDate;
@property (nonatomic, strong) NSNumber* fastingBloodGlucose;
@property (nonatomic, strong) NSNumber* fecalOccultBlood;
@property (nonatomic, strong) NSNumber* glycatedHemoglobin;
@property (nonatomic, strong) NSString * gpt;
@property (nonatomic, strong) NSNumber* hdlCholesterol;
@property (nonatomic, strong) NSNumber* hemoglobin;
@property (nonatomic, strong) NSString * hepatitisBSurfaceAntigen;
@property (nonatomic, strong) NSString * hiv;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * ketone;
@property (nonatomic, strong) NSNumber* ldlCholesterol;
@property (nonatomic, strong) NSString * leukocyte;
@property (nonatomic, strong) NSString * ng;
@property (nonatomic, strong) NSString * occultBloodInUrine;
@property (nonatomic, strong) NSString * otherBlood;
@property (nonatomic, strong) NSString * otherLaboratory;
@property (nonatomic, strong) NSString * otherUrine;
@property (nonatomic, strong) NSString * ph;
@property (nonatomic, strong) NSString * platelet;
@property (nonatomic, strong) NSNumber* postprandialBloodGlucose;
@property (nonatomic, strong) NSNumber* potassiumConcentration;
@property (nonatomic, strong) NSNumber* randomBloodGlucose;
@property (nonatomic, strong) NSNumber* serumAa;
@property (nonatomic, strong) NSNumber* serumAla;
@property (nonatomic, strong) NSNumber* serumCreatinine;
@property (nonatomic, strong) NSString * sg;
@property (nonatomic, strong) NSNumber* sodiumConcentration;
@property (nonatomic, strong) NSNumber* totalBilirubin;
@property (nonatomic, strong) NSNumber* totalCholesterol;
@property (nonatomic, strong) NSString * tppa;
@property (nonatomic, strong) NSNumber* triglycerides;
@property (nonatomic, strong) NSNumber* urinaryAlbumin;
@property (nonatomic, strong) NSString * urine;
@property (nonatomic, strong) NSString * urineProtein;
@end

@interface Drug : NSObject

@property (nonatomic, strong) NSString * cmDrugId;
@property (nonatomic, strong) NSString * cmDrugName;
@property (nonatomic, strong) NSString * dailyTimes;
@property (nonatomic, strong) NSString * eachDose;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * remark1;
@property (nonatomic, strong) NSString * drugs;
@end

@interface InsulinDrug : NSObject

@property (nonatomic, strong) NSString * cmDrugId;
@property (nonatomic, strong) NSString * drugs;
@property (nonatomic, strong) NSString * dailyTimes;
@property (nonatomic, strong) NSNumber * eachDose;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * remark1;
@end

@interface Body : NSObject

@property (nonatomic, strong) NSNumber *bmi;
@property (nonatomic, strong) NSNumber *bodyTemperature;
@property (nonatomic, strong) NSNumber *heartRate;
@property (nonatomic, strong) NSNumber* height;
@property (nonatomic, strong) NSNumber* hip;
@property (nonatomic, strong) NSNumber* leftDbp;
@property (nonatomic, strong) NSNumber* leftSbp;
@property (nonatomic, strong) NSNumber* pulseRate;
@property (nonatomic, strong) NSNumber* respiratoryRate;
@property (nonatomic, strong) NSNumber* rightDbp;
@property (nonatomic, strong) NSNumber* rightSbp;
@property (nonatomic, strong) NSNumber* waistline;
@property (nonatomic, strong) NSNumber* weight;
@property (nonatomic, strong) NSString* dorsalisPedisArteryPulse;

@end

@interface TransOut : NSObject

@property (nonatomic, strong) NSString * targetOrgName;
@property (nonatomic, strong) NSString * tranoutReasons;
@end

@interface CmModel : NSObject

@property (nonatomic, strong) NSString * adverseDrugReactions;
@property (nonatomic, strong) NSNumber * complianceBehavior;
@property (nonatomic, strong) NSNumber * dbMedicationCompliance;
@property (nonatomic, strong) NSString * doctorId;
@property (nonatomic, strong) NSString * doctorName;
@property (nonatomic, strong) NSString * examBodyOther;
@property (nonatomic, strong) NSString * followUpDate;
@property (nonatomic, strong) NSString * followUpRemarks;
@property (nonatomic, strong) NSNumber * fuClassification;
@property (nonatomic, strong) NSNumber * hyMedicationCompliance;
//@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * lowBloodSugarReactions;
@property (nonatomic, strong) NSNumber * medicationCompliance;
@property (nonatomic, strong) NSString * nextDailyAlcohol;
@property (nonatomic, strong) NSString * nextExerciseWeekMinute;
@property (nonatomic, strong) NSString * nextExerciseWeekTimes;
@property (nonatomic, strong) NSString * nextFollowUpDate;
@property (nonatomic, strong) NSString * nextHeartRate;
@property (nonatomic, strong) NSString * nextSaltIntake;
@property (nonatomic, strong) NSString * nextSmoking;
@property (nonatomic, strong) NSString * nextStaple;
@property (nonatomic, strong) NSNumber * nextWeight;
@property (nonatomic, strong) NSString * personId;
@property (nonatomic, strong) NSNumber * psychologicalAdjustment;
@property (nonatomic, strong) NSString * saltIntake;
@property (nonatomic, strong) NSString * staple;
@property (nonatomic, strong) NSNumber * symptom;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * wayUp;

@end
