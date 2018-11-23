//
//  SignPushPersonInfoModel.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/15.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignPushPersonInfoModel.h"

@implementation SignPushPersonInfoModel
- (void)encryptModel{
    self.personIdcard = [self.personIdcard encryptCBCStr];
    self.personName = [self.personName encryptCBCStr];
    NSString *cbcPersonName = [[self.contractSmsContent objectForKey:@"personName"] encryptCBCStr];
    [self.contractSmsContent setObject:cbcPersonName forKey:@"personName"];
    NSString *cbcDoctorName = [[self.contractSmsContent objectForKey:@"doctorName"] encryptCBCStr];
    [self.contractSmsContent setObject:cbcDoctorName forKey:@"doctorName"];
    NSString *cbcPersonPhone = [[self.contractSmsContent objectForKey:@"personPhone"] encryptCBCStr];
    [self.contractSmsContent setObject:cbcPersonPhone forKey:@"personPhone"];
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"contractServices":@"SignSVPackModel",
             };
}
@end
