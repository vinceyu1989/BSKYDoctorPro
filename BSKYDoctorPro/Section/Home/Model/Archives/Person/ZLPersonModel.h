//
//  ZLPersonModel.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSArchiveModel.h"

//数据相关模型
@interface PersonInfo : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * addressSupplement;
@property (nonatomic, strong) NSString * buildDoctor;
@property (nonatomic, strong) NSString * buildDoctorId;
@property (nonatomic, strong) NSString * buildOrg;
@property (nonatomic, strong) NSString * buildOrgId;
@property (nonatomic, strong) NSString * cardId;
@property (nonatomic, strong) NSString * cardType;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * committee;
@property (nonatomic, strong) NSString * concern;
@property (nonatomic, strong) NSString * contactName;
@property (nonatomic, strong) NSString * contactTelPhone;
@property (nonatomic, strong) NSString * dateOfBirth;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSString * floatingPopulation;
@property (nonatomic, strong) NSString * floor;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * healthCardId;
@property (nonatomic, strong) NSString * householdRelationship;
@property (nonatomic, strong) NSString * hukouInd;
@property (nonatomic, strong) NSString * manageOrg;
@property (nonatomic, strong) NSString * manageOrgId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * registerAddress;
@property (nonatomic, strong) NSString * registerAddressSupplement;
@property (nonatomic, strong) NSString * registerCity;
@property (nonatomic, strong) NSString * registerCommittee;
@property (nonatomic, strong) NSString * registerDistrict;
@property (nonatomic, strong) NSString * registerProvince;
@property (nonatomic, strong) NSString * registerTownship;
@property (nonatomic, strong) NSString * registrantId;
@property (nonatomic, strong) NSString * registrationDate;
@property (nonatomic, strong) NSString * responsibleDoctor;
@property (nonatomic, strong) NSString * responsibleDoctorId;
@property (nonatomic, strong) NSString * room;
@property (nonatomic, strong) NSString * socialRelation;
@property (nonatomic, strong) NSString * teamId;
@property (nonatomic, strong) NSString * telPhone;
@property (nonatomic, strong) NSString * township;
@property (nonatomic, strong) NSString * village;
@property (nonatomic, strong) NSString * workUnit;
@property (nonatomic, strong) NSString * familyId;
@end

@interface OtherInfo : NSObject
@property (nonatomic, strong) NSString * drugAllergyOther;
@property (nonatomic, strong) NSString * drugAllergy;
@property (nonatomic, strong) NSString * bloodRHType;
@property (nonatomic, strong) NSString * bloodType;
@property (nonatomic, strong) NSString * degreeOfEducation;
@property (nonatomic, strong) NSString * mail;
@property (nonatomic, strong) NSString * maritalStatus;
@property (nonatomic, strong) NSString * medicalPayment;
@property (nonatomic, strong) NSString * medicalPaymentOther;
@property (nonatomic, strong) NSString * nation;
@property (nonatomic, strong) NSString * occupation;
@property (nonatomic, strong) NSString * qq;
@property (nonatomic, strong) NSString * registeredNature;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * weChat;
@property (nonatomic, strong) NSString * zipCode;
@property (nonatomic, strong) NSString * exposure;
@property (nonatomic, strong) NSString * hereditaryDisease;
@property (nonatomic, strong) NSString * hasHereditaryDisease;
@end
@interface History : NSObject

@property (nonatomic, strong) NSString * dateEnd;
@property (nonatomic, strong) NSString * dateStart;
@property (nonatomic, strong) NSString * orgId;
@property (nonatomic, strong) NSString * orgName;
@property (nonatomic, strong) NSString * projectCode;
@property (nonatomic, strong) NSString * projectName;
@property (nonatomic, strong) NSString * resultCode;
@property (nonatomic, strong) NSString * resultValue;
@property (nonatomic, strong) NSString * saveNum;
@property (nonatomic, strong) NSString * serviceId;
@end
@interface Environment : NSObject

@property (nonatomic, strong) NSString * fuel;
@property (nonatomic, strong) NSString * livestock;
@property (nonatomic, strong) NSString * toilet;
@property (nonatomic, strong) NSString * ventilatingEquipment;
@property (nonatomic, strong) NSString * water;
@end

@interface ZLPersonModel : NSObject
@property (nonatomic, strong) Environment * environment;
@property (nonatomic, strong) NSArray * history;
@property (nonatomic, strong) OtherInfo * otherInfo;
@property (nonatomic, strong) PersonInfo * personInfo;
@property (nonatomic, strong) NSString * photo;
@end

@interface ZLHistoryModel : NSObject
@property (nonatomic, strong) NSString * dateEnd;
@property (nonatomic, strong) NSString * dateStart;
@property (nonatomic, strong) NSString * orgId;
@property (nonatomic, strong) NSString * orgName;
@property (nonatomic, strong) NSString * projectCode;
@property (nonatomic, strong) NSString * projectName;
@property (nonatomic, strong) NSString * resultCode;
@property (nonatomic, strong) NSString * resultValue;
@property (nonatomic, strong) NSString * saveNum;
@end;

//UI 相关模型
@interface ZLPersonUIModel : NSObject
@property (nonatomic ,strong) ArchiveModel *personInfo;
@property (nonatomic ,strong) ArchiveModel *otherInfo;
@property (nonatomic ,strong) ArchiveModel *medicalHistoryInfo;
@property (nonatomic ,strong) ArchiveModel *pastHistory;
@property (nonatomic ,strong) ArchiveModel *familyHistory;
@property (nonatomic ,strong) ArchiveModel *environment;
@end

//既往史子视图模型
@interface ZLHistoryAddUIModel : NSObject
@property (nonatomic ,strong) ArchiveModel *diseaseHistory;
@property (nonatomic ,strong) ArchiveModel *diseaseHistoryEspecial;
@property (nonatomic ,strong) ArchiveModel *diseaseHistoryOther;
@property (nonatomic ,strong) ArchiveModel *surgeryHistory;
@property (nonatomic ,strong) ArchiveModel *traumaHistory;
@property (nonatomic ,strong) ArchiveModel *bloodHistory;
@property (nonatomic ,strong) ArchiveModel *familyHistory;
@property (nonatomic ,strong) ArchiveModel *drugAllergyOther;
@end
