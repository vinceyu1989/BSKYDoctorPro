//
//  BSFamilySignPersonModel.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSFamilySignPersonModel.h"

@implementation BSFamilySignPersonModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{@"attachfile":@"Attachfile",
             @"contractServices":@"ContractServices",
             @"tags":@"Tags",
             @"personId":@"PERSON_ID",
             @"fee":@"Fee",
             };
}
- (void)encryptModel{
    NSString *cbcPersonName = [[self.contractSmsContent objectForKey:@"personName"] encryptCBCStr];
    [self.contractSmsContent setObject:cbcPersonName forKey:@"personName"];
    NSString *cbcDoctorName = [[self.contractSmsContent objectForKey:@"doctorName"] encryptCBCStr];
    [self.contractSmsContent setObject:cbcDoctorName forKey:@"doctorName"];
    NSString *cbcPersonPhone = [[self.contractSmsContent objectForKey:@"personPhone"] encryptCBCStr];
    [self.contractSmsContent setObject:cbcPersonPhone forKey:@"personPhone"];
}
@end
