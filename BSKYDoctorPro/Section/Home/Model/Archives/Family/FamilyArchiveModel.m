//
//  FamilyArchiveModel.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FamilyArchiveModel.h"

@implementation FamilyArchiveModel
- (void)decryptModel{
    self.FamilyAddress = [self.FamilyAddress decryptCBCStr];
    self.FamilyTel = [self.FamilyTel decryptCBCStr];
    self.MasterName = [self.MasterName decryptCBCStr];
    self.MasterCardID = [self.MasterCardID decryptCBCStr];
    self.Position = [self.Position decryptCBCStr];
}
- (void)encryptModel{
    self.FamilyAddress = [self.FamilyAddress encryptCBCStr];
    self.FamilyTel = [self.FamilyTel encryptCBCStr];
    self.MasterName = [self.MasterName encryptCBCStr];
    self.MasterCardID = [self.MasterCardID encryptCBCStr];
    self.Position = [self.Position encryptCBCStr];
}
@end

@implementation FamilyDetailModel
- (void)decryptModel{
    self.FamilyAddress = [self.FamilyAddress decryptCBCStr];
    self.FamilyTel = [self.FamilyTel decryptCBCStr];
    self.MasterName = [self.MasterName decryptCBCStr];
    self.MasterCardID = [self.MasterCardID decryptCBCStr];
}
@end

NSString *const kRootClassAnimalOil = @"animalOil";
NSString *const kRootClassBuildDate = @"buildDate";
NSString *const kRootClassBuildDoctor = @"buildDoctor";
NSString *const kRootClassBuildDoctorId = @"buildDoctorId";
NSString *const kRootClassBuildOrg = @"buildOrg";
NSString *const kRootClassBuildOrgId = @"buildOrgId";
NSString *const kRootClassCity = @"city";
NSString *const kRootClassCommittee = @"committee";
NSString *const kRootClassCorral = @"corral";
NSString *const kRootClassDistrict = @"district";
NSString *const kRootClassFamilyAddress = @"familyAddress";
NSString *const kRootClassFamilyAddressSupplement = @"familyAddressSupplement";
NSString *const kRootClassFamilyTel = @"familyTel";
NSString *const kRootClassFamilyType = @"familyType";
NSString *const kRootClassFloor = @"floor";
NSString *const kRootClassFoodType = @"foodType";
NSString *const kRootClassFuelType = @"fuelType";
NSString *const kRootClassGarbage = @"garbage";
NSString *const kRootClassHouseType = @"houseType";
NSString *const kRootClassHouseholdFacilities = @"householdFacilities";
NSString *const kRootClassHygiene = @"hygiene";
NSString *const kRootClassKitchenArea = @"kitchenArea";
NSString *const kRootClassManageOrg = @"manageOrg";
NSString *const kRootClassManageOrgId = @"manageOrgId";
NSString *const kRootClassMonthAverageIncome = @"monthAverageIncome";
NSString *const kRootClassPerCapitaArea = @"perCapitaArea";
NSString *const kRootClassPermanentMemberCount = @"permanentMemberCount";
NSString *const kRootClassPersonId = @"personId";
NSString *const kRootClassPostcode = @"postcode";
NSString *const kRootClassProvince = @"province";
NSString *const kRootClassRegistrant = @"registrant";
NSString *const kRootClassRegistrantId = @"registrantId";
NSString *const kRootClassRemark = @"remark";
NSString *const kRootClassRmemberCountoom = @"rmemberCountoom";
NSString *const kRootClassRoom = @"room";
NSString *const kRootClassSalt = @"salt";
NSString *const kRootClassSewage = @"sewage";
NSString *const kRootClassSmokeExtraction = @"smokeExtraction";
NSString *const kRootClassToCalzada = @"toCalzada";
NSString *const kRootClassToMedicalStation = @"toMedicalStation";
NSString *const kRootClassToPoliceStation = @"toPoliceStation";
NSString *const kRootClassToShop = @"toShop";
NSString *const kRootClassToiletType = @"toiletType";
NSString *const kRootClassTownship = @"township";
NSString *const kRootClassVegetableOil = @"vegetableOil";
NSString *const kRootClassVentilationAndLighting = @"ventilationAndLighting";
NSString *const kRootClassVillage = @"village";
NSString *const kRootClassWaterQuality = @"waterQuality";
NSString *const kRootClassWaterType = @"waterType";
@implementation ZLFamilyArchiveModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kRootClassAnimalOil] isKindOfClass:[NSNull class]]){
        self.animalOil = dictionary[kRootClassAnimalOil];
    }
    if(![dictionary[kRootClassBuildDate] isKindOfClass:[NSNull class]]){
        self.buildDate = dictionary[kRootClassBuildDate];
    }
    if(![dictionary[kRootClassBuildDoctor] isKindOfClass:[NSNull class]]){
        self.buildDoctor = dictionary[kRootClassBuildDoctor];
    }
    if(![dictionary[kRootClassBuildDoctorId] isKindOfClass:[NSNull class]]){
        self.buildDoctorId = dictionary[kRootClassBuildDoctorId];
    }
    if(![dictionary[kRootClassBuildOrg] isKindOfClass:[NSNull class]]){
        self.buildOrg = dictionary[kRootClassBuildOrg];
    }
    if(![dictionary[kRootClassBuildOrgId] isKindOfClass:[NSNull class]]){
        self.buildOrgId = dictionary[kRootClassBuildOrgId];
    }
    if(![dictionary[kRootClassCity] isKindOfClass:[NSNull class]]){
        self.city = dictionary[kRootClassCity];
    }
    if(![dictionary[kRootClassCommittee] isKindOfClass:[NSNull class]]){
        self.committee = dictionary[kRootClassCommittee];
    }
    if(![dictionary[kRootClassCorral] isKindOfClass:[NSNull class]]){
        self.corral = dictionary[kRootClassCorral];
    }
    if(![dictionary[kRootClassDistrict] isKindOfClass:[NSNull class]]){
        self.district = dictionary[kRootClassDistrict];
    }
    if(![dictionary[kRootClassFamilyAddress] isKindOfClass:[NSNull class]]){
        self.familyAddress = dictionary[kRootClassFamilyAddress];
    }
    if(![dictionary[kRootClassFamilyAddressSupplement] isKindOfClass:[NSNull class]]){
        self.familyAddressSupplement = dictionary[kRootClassFamilyAddressSupplement];
    }
    if(![dictionary[kRootClassFamilyTel] isKindOfClass:[NSNull class]]){
        self.familyTel = dictionary[kRootClassFamilyTel];
    }
    if(![dictionary[kRootClassFamilyType] isKindOfClass:[NSNull class]]){
        self.familyType = dictionary[kRootClassFamilyType];
    }
    if(![dictionary[kRootClassFloor] isKindOfClass:[NSNull class]]){
        self.floor = dictionary[kRootClassFloor];
    }
    if(![dictionary[kRootClassFoodType] isKindOfClass:[NSNull class]]){
        self.foodType = dictionary[kRootClassFoodType];
    }
    if(![dictionary[kRootClassFuelType] isKindOfClass:[NSNull class]]){
        self.fuelType = dictionary[kRootClassFuelType];
    }
    if(![dictionary[kRootClassGarbage] isKindOfClass:[NSNull class]]){
        self.garbage = dictionary[kRootClassGarbage];
    }
    if(![dictionary[kRootClassHouseType] isKindOfClass:[NSNull class]]){
        self.houseType = dictionary[kRootClassHouseType];
    }
    if(![dictionary[kRootClassHouseholdFacilities] isKindOfClass:[NSNull class]]){
        self.householdFacilities = dictionary[kRootClassHouseholdFacilities];
    }
    if(![dictionary[kRootClassHygiene] isKindOfClass:[NSNull class]]){
        self.hygiene = dictionary[kRootClassHygiene];
    }
    if(![dictionary[kRootClassKitchenArea] isKindOfClass:[NSNull class]]){
        self.kitchenArea = dictionary[kRootClassKitchenArea];
    }
    if(![dictionary[kRootClassManageOrg] isKindOfClass:[NSNull class]]){
        self.manageOrg = dictionary[kRootClassManageOrg];
    }
    if(![dictionary[kRootClassManageOrgId] isKindOfClass:[NSNull class]]){
        self.manageOrgId = dictionary[kRootClassManageOrgId];
    }
    if(![dictionary[kRootClassMonthAverageIncome] isKindOfClass:[NSNull class]]){
        self.monthAverageIncome = dictionary[kRootClassMonthAverageIncome];
    }
    if(![dictionary[kRootClassPerCapitaArea] isKindOfClass:[NSNull class]]){
        self.perCapitaArea = dictionary[kRootClassPerCapitaArea];
    }
    if(![dictionary[kRootClassPermanentMemberCount] isKindOfClass:[NSNull class]]){
        self.permanentMemberCount = dictionary[kRootClassPermanentMemberCount];
    }
    if(![dictionary[kRootClassPersonId] isKindOfClass:[NSNull class]]){
        self.personId = dictionary[kRootClassPersonId];
    }
    if(![dictionary[kRootClassPostcode] isKindOfClass:[NSNull class]]){
        self.postcode = dictionary[kRootClassPostcode];
    }
    if(![dictionary[kRootClassProvince] isKindOfClass:[NSNull class]]){
        self.province = dictionary[kRootClassProvince];
    }
    if(![dictionary[kRootClassRegistrant] isKindOfClass:[NSNull class]]){
        self.registrant = dictionary[kRootClassRegistrant];
    }
    if(![dictionary[kRootClassRegistrantId] isKindOfClass:[NSNull class]]){
        self.registrantId = dictionary[kRootClassRegistrantId];
    }
    if(![dictionary[kRootClassRemark] isKindOfClass:[NSNull class]]){
        self.remark = dictionary[kRootClassRemark];
    }
    if(![dictionary[kRootClassRmemberCountoom] isKindOfClass:[NSNull class]]){
        self.rmemberCountoom = dictionary[kRootClassRmemberCountoom];
    }
    if(![dictionary[kRootClassRoom] isKindOfClass:[NSNull class]]){
        self.room = dictionary[kRootClassRoom];
    }
    if(![dictionary[kRootClassSalt] isKindOfClass:[NSNull class]]){
        self.salt = dictionary[kRootClassSalt];
    }
    if(![dictionary[kRootClassSewage] isKindOfClass:[NSNull class]]){
        self.sewage = dictionary[kRootClassSewage];
    }
    if(![dictionary[kRootClassSmokeExtraction] isKindOfClass:[NSNull class]]){
        self.smokeExtraction = dictionary[kRootClassSmokeExtraction];
    }
    if(![dictionary[kRootClassToCalzada] isKindOfClass:[NSNull class]]){
        self.toCalzada = dictionary[kRootClassToCalzada];
    }
    if(![dictionary[kRootClassToMedicalStation] isKindOfClass:[NSNull class]]){
        self.toMedicalStation = dictionary[kRootClassToMedicalStation];
    }
    if(![dictionary[kRootClassToPoliceStation] isKindOfClass:[NSNull class]]){
        self.toPoliceStation = dictionary[kRootClassToPoliceStation];
    }
    if(![dictionary[kRootClassToShop] isKindOfClass:[NSNull class]]){
        self.toShop = dictionary[kRootClassToShop];
    }
    if(![dictionary[kRootClassToiletType] isKindOfClass:[NSNull class]]){
        self.toiletType = dictionary[kRootClassToiletType];
    }
    if(![dictionary[kRootClassTownship] isKindOfClass:[NSNull class]]){
        self.township = dictionary[kRootClassTownship];
    }
    if(![dictionary[kRootClassVegetableOil] isKindOfClass:[NSNull class]]){
        self.vegetableOil = dictionary[kRootClassVegetableOil];
    }
    if(![dictionary[kRootClassVentilationAndLighting] isKindOfClass:[NSNull class]]){
        self.ventilationAndLighting = dictionary[kRootClassVentilationAndLighting];
    }
    if(![dictionary[kRootClassVillage] isKindOfClass:[NSNull class]]){
        self.village = dictionary[kRootClassVillage];
    }
    if(![dictionary[kRootClassWaterQuality] isKindOfClass:[NSNull class]]){
        self.waterQuality = dictionary[kRootClassWaterQuality];
    }
    if(![dictionary[kRootClassWaterType] isKindOfClass:[NSNull class]]){
        self.waterType = dictionary[kRootClassWaterType];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.animalOil != nil){
        dictionary[kRootClassAnimalOil] = self.animalOil;
    }
    if(self.buildDate != nil){
        dictionary[kRootClassBuildDate] = self.buildDate;
    }
    if(self.buildDoctor != nil){
        dictionary[kRootClassBuildDoctor] = self.buildDoctor;
    }
    if(self.buildDoctorId != nil){
        dictionary[kRootClassBuildDoctorId] = self.buildDoctorId;
    }
    if(self.buildOrg != nil){
        dictionary[kRootClassBuildOrg] = self.buildOrg;
    }
    if(self.buildOrgId != nil){
        dictionary[kRootClassBuildOrgId] = self.buildOrgId;
    }
    if(self.city != nil){
        dictionary[kRootClassCity] = self.city;
    }
    if(self.committee != nil){
        dictionary[kRootClassCommittee] = self.committee;
    }
    if(self.corral != nil){
        dictionary[kRootClassCorral] = self.corral;
    }
    if(self.district != nil){
        dictionary[kRootClassDistrict] = self.district;
    }
    if(self.familyAddress != nil){
        dictionary[kRootClassFamilyAddress] = self.familyAddress;
    }
    if(self.familyAddressSupplement != nil){
        dictionary[kRootClassFamilyAddressSupplement] = self.familyAddressSupplement;
    }
    if(self.familyTel != nil){
        dictionary[kRootClassFamilyTel] = self.familyTel;
    }
    if(self.familyType != nil){
        dictionary[kRootClassFamilyType] = self.familyType;
    }
    if(self.floor != nil){
        dictionary[kRootClassFloor] = self.floor;
    }
    if(self.foodType != nil){
        dictionary[kRootClassFoodType] = self.foodType;
    }
    if(self.fuelType != nil){
        dictionary[kRootClassFuelType] = self.fuelType;
    }
    if(self.garbage != nil){
        dictionary[kRootClassGarbage] = self.garbage;
    }
    if(self.houseType != nil){
        dictionary[kRootClassHouseType] = self.houseType;
    }
    if(self.householdFacilities != nil){
        dictionary[kRootClassHouseholdFacilities] = self.householdFacilities;
    }
    if(self.hygiene != nil){
        dictionary[kRootClassHygiene] = self.hygiene;
    }
    if(self.kitchenArea != nil){
        dictionary[kRootClassKitchenArea] = self.kitchenArea;
    }
    if(self.manageOrg != nil){
        dictionary[kRootClassManageOrg] = self.manageOrg;
    }
    if(self.manageOrgId != nil){
        dictionary[kRootClassManageOrgId] = self.manageOrgId;
    }
    if(self.monthAverageIncome != nil){
        dictionary[kRootClassMonthAverageIncome] = self.monthAverageIncome;
    }
    if(self.perCapitaArea != nil){
        dictionary[kRootClassPerCapitaArea] = self.perCapitaArea;
    }
    if(self.permanentMemberCount != nil){
        dictionary[kRootClassPermanentMemberCount] = self.permanentMemberCount;
    }
    if(self.personId != nil){
        dictionary[kRootClassPersonId] = self.personId;
    }
    if(self.postcode != nil){
        dictionary[kRootClassPostcode] = self.postcode;
    }
    if(self.province != nil){
        dictionary[kRootClassProvince] = self.province;
    }
    if(self.registrant != nil){
        dictionary[kRootClassRegistrant] = self.registrant;
    }
    if(self.registrantId != nil){
        dictionary[kRootClassRegistrantId] = self.registrantId;
    }
    if(self.remark != nil){
        dictionary[kRootClassRemark] = self.remark;
    }
    if(self.rmemberCountoom != nil){
        dictionary[kRootClassRmemberCountoom] = self.rmemberCountoom;
    }
    if(self.room != nil){
        dictionary[kRootClassRoom] = self.room;
    }
    if(self.salt != nil){
        dictionary[kRootClassSalt] = self.salt;
    }
    if(self.sewage != nil){
        dictionary[kRootClassSewage] = self.sewage;
    }
    if(self.smokeExtraction != nil){
        dictionary[kRootClassSmokeExtraction] = self.smokeExtraction;
    }
    if(self.toCalzada != nil){
        dictionary[kRootClassToCalzada] = self.toCalzada;
    }
    if(self.toMedicalStation != nil){
        dictionary[kRootClassToMedicalStation] = self.toMedicalStation;
    }
    if(self.toPoliceStation != nil){
        dictionary[kRootClassToPoliceStation] = self.toPoliceStation;
    }
    if(self.toShop != nil){
        dictionary[kRootClassToShop] = self.toShop;
    }
    if(self.toiletType != nil){
        dictionary[kRootClassToiletType] = self.toiletType;
    }
    if(self.township != nil){
        dictionary[kRootClassTownship] = self.township;
    }
    if(self.vegetableOil != nil){
        dictionary[kRootClassVegetableOil] = self.vegetableOil;
    }
    if(self.ventilationAndLighting != nil){
        dictionary[kRootClassVentilationAndLighting] = self.ventilationAndLighting;
    }
    if(self.village != nil){
        dictionary[kRootClassVillage] = self.village;
    }
    if(self.waterQuality != nil){
        dictionary[kRootClassWaterQuality] = self.waterQuality;
    }
    if(self.waterType != nil){
        dictionary[kRootClassWaterType] = self.waterType;
    }
    return dictionary;
    
}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.animalOil != nil){
        [aCoder encodeObject:self.animalOil forKey:kRootClassAnimalOil];
    }
    if(self.buildDate != nil){
        [aCoder encodeObject:self.buildDate forKey:kRootClassBuildDate];
    }
    if(self.buildDoctor != nil){
        [aCoder encodeObject:self.buildDoctor forKey:kRootClassBuildDoctor];
    }
    if(self.buildDoctorId != nil){
        [aCoder encodeObject:self.buildDoctorId forKey:kRootClassBuildDoctorId];
    }
    if(self.buildOrg != nil){
        [aCoder encodeObject:self.buildOrg forKey:kRootClassBuildOrg];
    }
    if(self.buildOrgId != nil){
        [aCoder encodeObject:self.buildOrgId forKey:kRootClassBuildOrgId];
    }
    if(self.city != nil){
        [aCoder encodeObject:self.city forKey:kRootClassCity];
    }
    if(self.committee != nil){
        [aCoder encodeObject:self.committee forKey:kRootClassCommittee];
    }
    if(self.corral != nil){
        [aCoder encodeObject:self.corral forKey:kRootClassCorral];
    }
    if(self.district != nil){
        [aCoder encodeObject:self.district forKey:kRootClassDistrict];
    }
    if(self.familyAddress != nil){
        [aCoder encodeObject:self.familyAddress forKey:kRootClassFamilyAddress];
    }
    if(self.familyAddressSupplement != nil){
        [aCoder encodeObject:self.familyAddressSupplement forKey:kRootClassFamilyAddressSupplement];
    }
    if(self.familyTel != nil){
        [aCoder encodeObject:self.familyTel forKey:kRootClassFamilyTel];
    }
    if(self.familyType != nil){
        [aCoder encodeObject:self.familyType forKey:kRootClassFamilyType];
    }
    if(self.floor != nil){
        [aCoder encodeObject:self.floor forKey:kRootClassFloor];
    }
    if(self.foodType != nil){
        [aCoder encodeObject:self.foodType forKey:kRootClassFoodType];
    }
    if(self.fuelType != nil){
        [aCoder encodeObject:self.fuelType forKey:kRootClassFuelType];
    }
    if(self.garbage != nil){
        [aCoder encodeObject:self.garbage forKey:kRootClassGarbage];
    }
    if(self.houseType != nil){
        [aCoder encodeObject:self.houseType forKey:kRootClassHouseType];
    }
    if(self.householdFacilities != nil){
        [aCoder encodeObject:self.householdFacilities forKey:kRootClassHouseholdFacilities];
    }
    if(self.hygiene != nil){
        [aCoder encodeObject:self.hygiene forKey:kRootClassHygiene];
    }
    if(self.kitchenArea != nil){
        [aCoder encodeObject:self.kitchenArea forKey:kRootClassKitchenArea];
    }
    if(self.manageOrg != nil){
        [aCoder encodeObject:self.manageOrg forKey:kRootClassManageOrg];
    }
    if(self.manageOrgId != nil){
        [aCoder encodeObject:self.manageOrgId forKey:kRootClassManageOrgId];
    }
    if(self.monthAverageIncome != nil){
        [aCoder encodeObject:self.monthAverageIncome forKey:kRootClassMonthAverageIncome];
    }
    if(self.perCapitaArea != nil){
        [aCoder encodeObject:self.perCapitaArea forKey:kRootClassPerCapitaArea];
    }
    if(self.permanentMemberCount != nil){
        [aCoder encodeObject:self.permanentMemberCount forKey:kRootClassPermanentMemberCount];
    }
    if(self.personId != nil){
        [aCoder encodeObject:self.personId forKey:kRootClassPersonId];
    }
    if(self.postcode != nil){
        [aCoder encodeObject:self.postcode forKey:kRootClassPostcode];
    }
    if(self.province != nil){
        [aCoder encodeObject:self.province forKey:kRootClassProvince];
    }
    if(self.registrant != nil){
        [aCoder encodeObject:self.registrant forKey:kRootClassRegistrant];
    }
    if(self.registrantId != nil){
        [aCoder encodeObject:self.registrantId forKey:kRootClassRegistrantId];
    }
    if(self.remark != nil){
        [aCoder encodeObject:self.remark forKey:kRootClassRemark];
    }
    if(self.rmemberCountoom != nil){
        [aCoder encodeObject:self.rmemberCountoom forKey:kRootClassRmemberCountoom];
    }
    if(self.room != nil){
        [aCoder encodeObject:self.room forKey:kRootClassRoom];
    }
    if(self.salt != nil){
        [aCoder encodeObject:self.salt forKey:kRootClassSalt];
    }
    if(self.sewage != nil){
        [aCoder encodeObject:self.sewage forKey:kRootClassSewage];
    }
    if(self.smokeExtraction != nil){
        [aCoder encodeObject:self.smokeExtraction forKey:kRootClassSmokeExtraction];
    }
    if(self.toCalzada != nil){
        [aCoder encodeObject:self.toCalzada forKey:kRootClassToCalzada];
    }
    if(self.toMedicalStation != nil){
        [aCoder encodeObject:self.toMedicalStation forKey:kRootClassToMedicalStation];
    }
    if(self.toPoliceStation != nil){
        [aCoder encodeObject:self.toPoliceStation forKey:kRootClassToPoliceStation];
    }
    if(self.toShop != nil){
        [aCoder encodeObject:self.toShop forKey:kRootClassToShop];
    }
    if(self.toiletType != nil){
        [aCoder encodeObject:self.toiletType forKey:kRootClassToiletType];
    }
    if(self.township != nil){
        [aCoder encodeObject:self.township forKey:kRootClassTownship];
    }
    if(self.vegetableOil != nil){
        [aCoder encodeObject:self.vegetableOil forKey:kRootClassVegetableOil];
    }
    if(self.ventilationAndLighting != nil){
        [aCoder encodeObject:self.ventilationAndLighting forKey:kRootClassVentilationAndLighting];
    }
    if(self.village != nil){
        [aCoder encodeObject:self.village forKey:kRootClassVillage];
    }
    if(self.waterQuality != nil){
        [aCoder encodeObject:self.waterQuality forKey:kRootClassWaterQuality];
    }
    if(self.waterType != nil){
        [aCoder encodeObject:self.waterType forKey:kRootClassWaterType];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.animalOil = [aDecoder decodeObjectForKey:kRootClassAnimalOil];
    self.buildDate = [aDecoder decodeObjectForKey:kRootClassBuildDate];
    self.buildDoctor = [aDecoder decodeObjectForKey:kRootClassBuildDoctor];
    self.buildDoctorId = [aDecoder decodeObjectForKey:kRootClassBuildDoctorId];
    self.buildOrg = [aDecoder decodeObjectForKey:kRootClassBuildOrg];
    self.buildOrgId = [aDecoder decodeObjectForKey:kRootClassBuildOrgId];
    self.city = [aDecoder decodeObjectForKey:kRootClassCity];
    self.committee = [aDecoder decodeObjectForKey:kRootClassCommittee];
    self.corral = [aDecoder decodeObjectForKey:kRootClassCorral];
    self.district = [aDecoder decodeObjectForKey:kRootClassDistrict];
    self.familyAddress = [aDecoder decodeObjectForKey:kRootClassFamilyAddress];
    self.familyAddressSupplement = [aDecoder decodeObjectForKey:kRootClassFamilyAddressSupplement];
    self.familyTel = [aDecoder decodeObjectForKey:kRootClassFamilyTel];
    self.familyType = [aDecoder decodeObjectForKey:kRootClassFamilyType];
    self.floor = [aDecoder decodeObjectForKey:kRootClassFloor];
    self.foodType = [aDecoder decodeObjectForKey:kRootClassFoodType];
    self.fuelType = [aDecoder decodeObjectForKey:kRootClassFuelType];
    self.garbage = [aDecoder decodeObjectForKey:kRootClassGarbage];
    self.houseType = [aDecoder decodeObjectForKey:kRootClassHouseType];
    self.householdFacilities = [aDecoder decodeObjectForKey:kRootClassHouseholdFacilities];
    self.hygiene = [aDecoder decodeObjectForKey:kRootClassHygiene];
    self.kitchenArea = [aDecoder decodeObjectForKey:kRootClassKitchenArea];
    self.manageOrg = [aDecoder decodeObjectForKey:kRootClassManageOrg];
    self.manageOrgId = [aDecoder decodeObjectForKey:kRootClassManageOrgId];
    self.monthAverageIncome = [aDecoder decodeObjectForKey:kRootClassMonthAverageIncome];
    self.perCapitaArea = [aDecoder decodeObjectForKey:kRootClassPerCapitaArea];
    self.permanentMemberCount = [aDecoder decodeObjectForKey:kRootClassPermanentMemberCount];
    self.personId = [aDecoder decodeObjectForKey:kRootClassPersonId];
    self.postcode = [aDecoder decodeObjectForKey:kRootClassPostcode];
    self.province = [aDecoder decodeObjectForKey:kRootClassProvince];
    self.registrant = [aDecoder decodeObjectForKey:kRootClassRegistrant];
    self.registrantId = [aDecoder decodeObjectForKey:kRootClassRegistrantId];
    self.remark = [aDecoder decodeObjectForKey:kRootClassRemark];
    self.rmemberCountoom = [aDecoder decodeObjectForKey:kRootClassRmemberCountoom];
    self.room = [aDecoder decodeObjectForKey:kRootClassRoom];
    self.salt = [aDecoder decodeObjectForKey:kRootClassSalt];
    self.sewage = [aDecoder decodeObjectForKey:kRootClassSewage];
    self.smokeExtraction = [aDecoder decodeObjectForKey:kRootClassSmokeExtraction];
    self.toCalzada = [aDecoder decodeObjectForKey:kRootClassToCalzada];
    self.toMedicalStation = [aDecoder decodeObjectForKey:kRootClassToMedicalStation];
    self.toPoliceStation = [aDecoder decodeObjectForKey:kRootClassToPoliceStation];
    self.toShop = [aDecoder decodeObjectForKey:kRootClassToShop];
    self.toiletType = [aDecoder decodeObjectForKey:kRootClassToiletType];
    self.township = [aDecoder decodeObjectForKey:kRootClassTownship];
    self.vegetableOil = [aDecoder decodeObjectForKey:kRootClassVegetableOil];
    self.ventilationAndLighting = [aDecoder decodeObjectForKey:kRootClassVentilationAndLighting];
    self.village = [aDecoder decodeObjectForKey:kRootClassVillage];
    self.waterQuality = [aDecoder decodeObjectForKey:kRootClassWaterQuality];
    self.waterType = [aDecoder decodeObjectForKey:kRootClassWaterType];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    ZLFamilyArchiveModel *copy = [ZLFamilyArchiveModel new];
    
    copy.animalOil = [self.animalOil copy];
    copy.buildDate = [self.buildDate copy];
    copy.buildDoctor = [self.buildDoctor copy];
    copy.buildDoctorId = [self.buildDoctorId copy];
    copy.buildOrg = [self.buildOrg copy];
    copy.buildOrgId = [self.buildOrgId copy];
    copy.city = [self.city copy];
    copy.committee = [self.committee copy];
    copy.corral = [self.corral copy];
    copy.district = [self.district copy];
    copy.familyAddress = [self.familyAddress copy];
    copy.familyAddressSupplement = [self.familyAddressSupplement copy];
    copy.familyTel = [self.familyTel copy];
    copy.familyType = [self.familyType copy];
    copy.floor = [self.floor copy];
    copy.foodType = [self.foodType copy];
    copy.fuelType = [self.fuelType copy];
    copy.garbage = [self.garbage copy];
    copy.houseType = [self.houseType copy];
    copy.householdFacilities = [self.householdFacilities copy];
    copy.hygiene = [self.hygiene copy];
    copy.kitchenArea = [self.kitchenArea copy];
    copy.manageOrg = [self.manageOrg copy];
    copy.manageOrgId = [self.manageOrgId copy];
    copy.monthAverageIncome = [self.monthAverageIncome copy];
    copy.perCapitaArea = [self.perCapitaArea copy];
    copy.permanentMemberCount = [self.permanentMemberCount copy];
    copy.personId = [self.personId copy];
    copy.postcode = [self.postcode copy];
    copy.province = [self.province copy];
    copy.registrant = [self.registrant copy];
    copy.registrantId = [self.registrantId copy];
    copy.remark = [self.remark copy];
    copy.rmemberCountoom = [self.rmemberCountoom copy];
    copy.room = [self.room copy];
    copy.salt = [self.salt copy];
    copy.sewage = [self.sewage copy];
    copy.smokeExtraction = [self.smokeExtraction copy];
    copy.toCalzada = [self.toCalzada copy];
    copy.toMedicalStation = [self.toMedicalStation copy];
    copy.toPoliceStation = [self.toPoliceStation copy];
    copy.toShop = [self.toShop copy];
    copy.toiletType = [self.toiletType copy];
    copy.township = [self.township copy];
    copy.vegetableOil = [self.vegetableOil copy];
    copy.ventilationAndLighting = [self.ventilationAndLighting copy];
    copy.village = [self.village copy];
    copy.waterQuality = [self.waterQuality copy];
    copy.waterType = [self.waterType copy];
    
    return copy;
}

@end
