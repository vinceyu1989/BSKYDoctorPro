//
//  BSStreatmentModel.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/9/7.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSStreatmentModel.h"

@implementation BSStreatmentModel

- (void)decryptModel{
    self.name = [self.name decryptCBCStr];
    self.doctorame = [self.doctorame decryptCBCStr];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"treatmentId":@"id"};
}

@end
