//
//  BSEducationModel.m
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/11.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSEducationModel.h"

@implementation BSEducationModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    
    return @{@"activityTime":@"ACTIVITYTIME",
             @"businessType":@"BUSINESSTYPE",
             @"businessTypeA":@"BUSINESSTYPEA",
             @"cardId":@"CARDID",
             @"eduContent":@"EDUCONTENT",
             @"name":@"NAME",
             @"idEdu":@"ID",
             @"personCode":@"PERSONCODE",
             @"personId":@"PERSONID",
             @"personName":@"PERSONNAME",
             @"userName":@"USERNAME",
             };
}
- (void)decryptModel{
    self.cardId = [self.cardId decryptCBCStr];
    self.name = [self.name decryptCBCStr];
    self.personCode = [self.personCode decryptCBCStr];
    self.personName = [self.personName decryptCBCStr];
    self.userName = [self.userName decryptCBCStr];
}
@end
