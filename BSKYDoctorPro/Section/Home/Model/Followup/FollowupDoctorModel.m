//
//  FollowupDoctorModel.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/14.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupDoctorModel.h"

@implementation FollowupDoctorModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    
    return @{@"employeeId":@"EMPLOYEEID",
             @"employeeName":@"EMPLOYEENAME",
             @"telphone":@"TELPHONE"};
}
- (void)decryptModel{
    self.employeeName = [self.employeeName decryptCBCStr];
    self.telphone = [self.telphone decryptCBCStr];
}
@end
