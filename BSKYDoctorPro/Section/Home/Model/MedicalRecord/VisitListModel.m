//
//  VisitListModel.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "VisitListModel.h"

@implementation VisitListModel
- (void)decryptModel{
    
    self.doctorName = [self.doctorName decryptCBCStr];
    self.name = [self.name decryptCBCStr];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"listId":@"id"};
}
@end
