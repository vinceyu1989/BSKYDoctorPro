//
//  FamilyArchiveModel.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

//卫计委
@interface FamilyArchiveModel : NSObject
@property (nonatomic, strong) NSString * ID;
@property (nonatomic, strong) NSString * BuildDate;
@property (nonatomic, strong) NSString * BuildEmployeeID;
@property (nonatomic, strong) NSString * BuildOrgID;
@property (nonatomic, strong) NSString * CountyCommittee;
@property (nonatomic, copy) NSNumber * CurrentCount;
@property (nonatomic, strong) NSString * CustomNumber;
@property (nonatomic, copy) NSNumber * DisabilityCount;
@property (nonatomic, strong) NSString * FamilyAddress;
@property (nonatomic, strong) NSString * FamilyTel;
@property (nonatomic, copy) NSNumber * FuelType;
@property (nonatomic, strong) NSString * HaveIcebox;
@property (nonatomic, copy) NSNumber * HouseArea;
@property (nonatomic, copy) NSNumber * HouseType;
@property (nonatomic, strong) NSString * Lastsynctime;
@property (nonatomic, strong) NSString * MasterCardID;
@property (nonatomic, strong) NSString * MasterName;
@property (nonatomic, copy) NSNumber * MemberCount;
@property (nonatomic, copy) NSNumber * MonthAverageIncome;
@property (nonatomic, strong) NSString * PoliceStation;
@property (nonatomic, strong) NSString * Position;
@property (nonatomic, strong) NSString * RegionID;
@property (nonatomic, strong) NSString * Remark;
@property (nonatomic, copy) NSNumber * Salcro;
@property (nonatomic, copy) NSNumber * Tohealthstation;
@property (nonatomic, copy) NSNumber * Tohospitals;
@property (nonatomic, copy) NSNumber * ToiletType;
@property (nonatomic, copy) NSNumber * WaterType;
- (void)decryptModel;
- (void)encryptModel;
@end

@interface FamilyDetailModel : NSObject
@property (nonatomic, copy) NSString * FamilyId;
@property (nonatomic, copy) NSString * BuildDate;
@property (nonatomic, copy) NSString * BuildEmployeeID;
@property (nonatomic, copy) NSString * BuildOrgID;
@property (nonatomic, copy) NSString * CountyCommittee;
@property (nonatomic, copy) NSString * CurrentCount;
@property (nonatomic, copy) NSString * CustomNumber;
@property (nonatomic, copy) NSNumber * DisabilityCount;
@property (nonatomic, copy) NSString * FamilyAddress;
@property (nonatomic, copy) NSString * FamilyTel;
@property (nonatomic, copy) NSString * FuelType;
@property (nonatomic, copy) NSString * HaveIcebox;
@property (nonatomic, copy) NSString * HouseArea;
@property (nonatomic, copy) NSString * HouseType;
@property (nonatomic, copy) NSString * Lastsynctime;
@property (nonatomic, copy) NSString * MasterCardID;
@property (nonatomic, copy) NSString * MasterName;
@property (nonatomic, copy) NSString * MemberCount;
@property (nonatomic, copy) NSString * MonthAverageIncome;
@property (nonatomic, copy) NSString * PoliceStation;
@property (nonatomic, copy) NSString * Position;
@property (nonatomic, copy) NSString * RegionID;
@property (nonatomic, copy) NSString * Remark;
@property (nonatomic, copy) NSString * Salcro;
@property (nonatomic, copy) NSString * Tohealthstation;
@property (nonatomic, copy) NSString * Tohospitals;
@property (nonatomic, copy) NSString * ToiletType;
@property (nonatomic, copy) NSString * WaterType;
@property (nonatomic, copy) NSString * DataStatus;
@property (nonatomic, copy) NSString * FamilyCode;
@property (nonatomic, copy) NSString * RegionName;
- (void)decryptModel;
@end
//中年
@interface ZLFamilyArchiveModel : NSObject

@property (nonatomic, strong) NSString * animalOil;
@property (nonatomic, strong) NSString * buildDate;
@property (nonatomic, strong) NSString * buildDoctor;
@property (nonatomic, strong) NSString * buildDoctorId;
@property (nonatomic, strong) NSString * buildOrg;
@property (nonatomic, strong) NSString * buildOrgId;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * committee;
@property (nonatomic, strong) NSString * corral;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, strong) NSString * familyAddress;
@property (nonatomic, strong) NSString * familyAddressSupplement;
@property (nonatomic, strong) NSString * familyTel;
@property (nonatomic, strong) NSString * familyType;
@property (nonatomic, strong) NSString * floor;
@property (nonatomic, strong) NSString * foodType;
@property (nonatomic, strong) NSString * fuelType;
@property (nonatomic, strong) NSString * garbage;
@property (nonatomic, strong) NSString * houseType;
@property (nonatomic, strong) NSString * householdFacilities;
@property (nonatomic, strong) NSString * hygiene;
@property (nonatomic, strong) NSString * kitchenArea;
@property (nonatomic, strong) NSString * manageOrg;
@property (nonatomic, strong) NSString * manageOrgId;
@property (nonatomic, strong) NSString * monthAverageIncome;
@property (nonatomic, strong) NSString * perCapitaArea;
@property (nonatomic, strong) NSString * permanentMemberCount;
@property (nonatomic, strong) NSString * personId;
@property (nonatomic, strong) NSString * postcode;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * registrant;
@property (nonatomic, strong) NSString * registrantId;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * rmemberCountoom;
@property (nonatomic, strong) NSString * room;
@property (nonatomic, strong) NSString * salt;
@property (nonatomic, strong) NSString * sewage;
@property (nonatomic, strong) NSString * smokeExtraction;
@property (nonatomic, strong) NSString * toCalzada;
@property (nonatomic, strong) NSString * toMedicalStation;
@property (nonatomic, strong) NSString * toPoliceStation;
@property (nonatomic, strong) NSString * toShop;
@property (nonatomic, strong) NSString * toiletType;
@property (nonatomic, strong) NSString * township;
@property (nonatomic, strong) NSString * vegetableOil;
@property (nonatomic, strong) NSString * ventilationAndLighting;
@property (nonatomic, strong) NSString * village;
@property (nonatomic, strong) NSString * waterQuality;
@property (nonatomic, strong) NSString * waterType;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
