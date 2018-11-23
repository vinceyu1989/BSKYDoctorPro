//
//  FamilyListModel.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/6.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FamilyListModel.h"

@implementation FamilyListModel
- (void)decryptModel{
    self.MasterName = [self.MasterName decryptCBCStr];
    self.TelNumber = [self.TelNumber decryptCBCStr];
    self.FamilyAddress = [self.FamilyAddress decryptCBCStr];
}
@end

@implementation FamilyMemberListModel

@end

@implementation ZLFamilyListModel

@end

@implementation ZLFamilyMemberListModel

@end

