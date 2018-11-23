//
//  PersonBaseInfoModel.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonBaseInfoModel : NSObject
@property (nonatomic ,copy) NSString *Photo;
@property (nonatomic ,copy) NSString *BirthDay;
@property (nonatomic ,strong) NSNumber *BloodType;
@property (nonatomic ,copy) NSString *BuildDate;
@property (nonatomic ,copy) NSString *BuildEmployeeID;
@property (nonatomic ,copy) NSString *BuildEmployeeName;
@property (nonatomic ,copy) NSString *CardID;
@property (nonatomic ,copy) NSString *BuildOrgID;
@property (nonatomic ,copy) NSString *ContactPerson;
@property (nonatomic ,copy) NSString *ContactTel;
@property (nonatomic ,copy) NSString *CurrentAddress;
@property (nonatomic ,copy) NSString *CustomNumber;
@property (nonatomic ,copy) NSString *DeathCause;
@property (nonatomic ,strong) NSNumber *Disability;
@property (nonatomic ,copy) NSString *DisabilityNumber;
@property (nonatomic ,strong) NSNumber *Drinkingwater;
@property (nonatomic ,strong) NSNumber *DrugAllergyHistory;
@property (nonatomic ,strong) NSNumber *EducationCode;
@property (nonatomic ,copy) NSString *FamilyID;
@property (nonatomic ,strong) NSNumber *FuelType;
@property (nonatomic ,strong) NSNumber *GenderCode;
@property (nonatomic ,strong) NSNumber *HouseholderRelationship;
@property (nonatomic ,copy) NSString *HrStatus;
@property (nonatomic ,copy) NSString *HrStatusDate;
@property (nonatomic ,copy) NSString *HrStatusRemark;
@property (nonatomic ,strong) NSNumber *HukouInd;
@property (nonatomic ,copy) NSString *ID;
@property (nonatomic ,copy) NSString *InFamilyDate;
@property (nonatomic ,copy) NSString *InOrgDate;
@property (nonatomic ,copy) NSString *IncomeType;
@property (nonatomic ,strong) NSNumber *IsFlowing;
@property (nonatomic ,copy) NSString *IsPoor;
@property (nonatomic ,strong) NSNumber *JobCode;
@property (nonatomic ,strong) NSNumber *KitchenExhaust;
@property (nonatomic ,copy) NSString *Lasthldate;
@property (nonatomic ,copy) NSString *Lastsynctime;
@property (nonatomic ,strong) NSNumber *LivestockColumn;
@property (nonatomic ,strong) NSNumber *MarryStatus;
@property (nonatomic ,copy) NSString *Name;
@property (nonatomic ,copy) NSString *NamePinyin;
@property (nonatomic ,copy) NSString *NationCode;
@property (nonatomic ,copy) NSString *NationalityCode;
@property (nonatomic ,copy) NSString *NhNumber;
@property (nonatomic ,copy) NSString *OtherDisability;
@property (nonatomic ,copy) NSString *OtherDrugAllergyHistory;
@property (nonatomic ,copy) NSString *OtherPaymentWaystring;
@property (nonatomic ,copy) NSString *PUserID;
@property (nonatomic ,copy) NSString *PUserName;
@property (nonatomic ,strong) NSNumber *PaymentWaystring;
@property (nonatomic ,copy) NSString *PersonCode;
@property (nonatomic ,copy) NSString *PersonTel;
@property (nonatomic ,copy) NSString *RegionCode;
@property (nonatomic ,copy) NSString *RegionID;
@property (nonatomic ,copy) NSString *Remark;
@property (nonatomic ,strong) NSNumber *ResType;
@property (nonatomic ,copy) NSString *ResidenceAddress;
@property (nonatomic ,copy) NSString *ResponsibilityDoctor;
@property (nonatomic ,copy) NSString *ResponsibilityID;
@property (nonatomic ,strong) NSNumber *RhBlood;
@property (nonatomic ,strong) NSNumber *Toilet;
@property (nonatomic ,copy) NSString *Updatedate;
@property (nonatomic ,copy) NSString *UpdatesyncStatus;
@property (nonatomic ,copy) NSString *WorkDate;
@property (nonatomic ,copy) NSString *WorkOrgName;
@property (nonatomic ,strong) NSNumber *ExposureHistory;
@property (nonatomic ,strong) NSArray *HealthHistory;
@property (nonatomic ,strong) NSArray *FamilyHistory;
@property (nonatomic ,strong) NSArray *CmData;
- (void)enctryptModel;
- (void)decryptModel;
- (void)decryptDeatalModel;
@end
