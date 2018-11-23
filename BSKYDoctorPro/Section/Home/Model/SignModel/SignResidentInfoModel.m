//
//  SignResidentInfoModel.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignResidentInfoModel.h"

@implementation SignResidentInfoModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{@"personId":@"id"};
}
- (void)decryptModel{
    self.currentAddress = [self.currentAddress decryptCBCStr];
    self.idcard = [self.idcard decryptCBCStr];
    self.name = [self.name decryptCBCStr];
}
@end

