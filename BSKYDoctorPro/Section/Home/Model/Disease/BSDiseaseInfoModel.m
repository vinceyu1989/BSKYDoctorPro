//
//  BSDiseaseInfoModel.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/8/21.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSDiseaseInfoModel.h"

@implementation BSDiseaseInfoModel
- (void)decryptModel{
    self.DOCTOR_NAME = [self.DOCTOR_NAME decryptCBCStr];
    self.Telphone = [self.Telphone decryptCBCStr];
    self.USER_NAME = [self.USER_NAME decryptCBCStr];
    self.NAME = [self.NAME decryptCBCStr];
}
@end
