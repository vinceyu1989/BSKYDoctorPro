//
//  SignFamilyArchiveModel.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignFamilyArchiveModel.h"

@implementation SignFamilyArchiveModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{@"familyAddress":@"FamilyAddress",
             @"familyCode":@"FamilyCode",
             @"familyID":@"FamilyID",
             @"masterName":@"MasterName",
             @"telNumber":@"TelNumber",
             };
}
- (void)decryptModel{
    self.familyAddress = [self.familyAddress decryptCBCStr];
    self.familyCode = [self.familyCode decryptCBCStr];
    self.masterName = [self.masterName decryptCBCStr];
    self.telNumber = [self.telNumber decryptCBCStr];
}
@end
