//
//  VisitDetailModel.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "VisitDetailModel.h"

@implementation VisitDetailModel
- (void)decryptModel{
    [self.basicInfoDTO decryptModel];
}
@end
@implementation VisitDetailBaseModel
- (void)decryptModel{
    self.doctorName = [self.doctorName decryptCBCStr];
    self.personName = [self.personName decryptCBCStr];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"detailId":@"id"};
}
@end


