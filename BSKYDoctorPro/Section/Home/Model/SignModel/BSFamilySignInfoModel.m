//
//  BSFamilySignInfoModel.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSFamilySignInfoModel.h"

@implementation BSFamilySignInfoModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{@"channel":@"Channel",
             @"endTime":@"EndTime",
             @"otheremark":@"Otheremark",
             @"startTime":@"StartTime",
             @"signPerson":@"SignPerson",
             @"teamID":@"TeamID",
             @"ID":@"id",
             };
}
- (void)encryptModel{
    self.signPerson = [self.signPerson encryptCBCStr];
//    [self.list encryptArray];
}
@end
