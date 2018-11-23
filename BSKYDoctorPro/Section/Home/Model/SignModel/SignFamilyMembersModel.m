//
//  SignFamilyMembersModel.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignFamilyMembersModel.h"

@implementation SignFamilyMembersModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{@"age":@"Age",
             @"cardID":@"CardID",
             @"genderCode":@"GenderCode",
             @"name":@"Name",
             @"personCode":@"PersonCode",
             @"personId":@"PersonId",
             @"telphone":@"Telphone",
             @"hrStatus":@"HrStatus",
             };
}
- (void)decryptModel{
    self.cardID = [self.cardID decryptCBCStr];
    self.name = [self.name decryptCBCStr];
    self.telphone = [self.telphone decryptCBCStr];
    self.personCode = [self.personCode decryptCBCStr];
}
@end
