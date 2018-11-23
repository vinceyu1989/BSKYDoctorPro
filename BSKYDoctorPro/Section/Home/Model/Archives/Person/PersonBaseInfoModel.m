//
//  PersonBaseInfoModel.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "PersonBaseInfoModel.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation PersonBaseInfoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)anilistMyClass:(Class)className{
    u_int count;
    objc_property_t * properties  = class_copyPropertyList(className, &count);
    for (int i=0; i<count; i++) {
//        objc_property_t property = properties[i];
//        NSLog(@"%@-->%@",getPropertyType(property),getPropertyName(property));
    }
    free(properties);
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"HealthHistory":@"HistoryModelDetail",
             @"CmData":@"DiseaseModelDetail",
             @"FamilyHistory":@"FamilyHistoryModelDetail"
             };
}
- (void)enctryptModel{
    self.BuildEmployeeName = [self.BuildEmployeeName encryptCBCStr];
    self.CardID = [self.CardID encryptCBCStr];
    self.ContactPerson = [self.ContactPerson encryptCBCStr];
    self.ContactTel = [self.ContactTel encryptCBCStr];
    self.CurrentAddress = [self.CurrentAddress encryptCBCStr];
    self.Name = [self.Name encryptCBCStr];
    self.NamePinyin = [self.NamePinyin encryptCBCStr];
    self.PUserName = [self.PUserName encryptCBCStr];
    self.PersonTel = [self.PersonTel encryptCBCStr];
    self.ResidenceAddress = [self.ResidenceAddress encryptCBCStr];
    self.WorkOrgName = [self.WorkOrgName encryptCBCStr];
    self.ResponsibilityDoctor = [self.ResponsibilityDoctor encryptCBCStr];
}
- (void)decryptModel{
    self.BuildEmployeeName = [self.BuildEmployeeName decryptCBCStr];
    self.CardID = [self.CardID decryptCBCStr];
    self.ContactPerson = [self.ContactPerson decryptCBCStr];
    self.ContactTel = [self.ContactTel decryptCBCStr];
    self.CurrentAddress = [self.CurrentAddress decryptCBCStr];
    self.Name = [self.Name decryptCBCStr];
    self.NamePinyin = [self.NamePinyin decryptCBCStr];
    self.PUserName = [self.PUserName decryptCBCStr];
    self.PersonTel = [self.PersonTel decryptCBCStr];
    self.ResidenceAddress = [self.ResidenceAddress decryptCBCStr];
    self.WorkOrgName = [self.WorkOrgName decryptCBCStr];
    self.ResponsibilityDoctor = [self.ResponsibilityDoctor decryptCBCStr];
}
- (void)decryptDeatalModel{
//    self.BuildEmployeeName = [self.BuildEmployeeName decryptCBCStr];
    self.CardID = [self.CardID decryptCBCStr];
    self.ContactPerson = [self.ContactPerson decryptCBCStr];
    self.ContactTel = [self.ContactTel decryptCBCStr];
    self.CurrentAddress = [self.CurrentAddress decryptCBCStr];
    self.Name = [self.Name decryptCBCStr];
    self.NamePinyin = [self.NamePinyin decryptCBCStr];
//    self.PUserName = [self.PUserName decryptCBCStr];
    self.PersonTel = [self.PersonTel decryptCBCStr];
    self.ResidenceAddress = [self.ResidenceAddress decryptCBCStr];
//    self.WorkOrgName = [self.WorkOrgName decryptCBCStr];
}
@end
