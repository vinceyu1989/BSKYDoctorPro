//
//  PatientListModel.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "PatientListModel.h"

@implementation PatientListModel
- (void)decryptModel{
    self.cardId = [self.cardId decryptCBCStr];
    self.doctorName = [self.doctorName decryptCBCStr];
    self.personName = [self.personName decryptCBCStr];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"listId":@"id"};
}
@end
