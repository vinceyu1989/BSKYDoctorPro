//
//  SignTeamMembersModel.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignTeamMembersModel.h"

@implementation SignTeamMembersModel
- (void)decryptModel{
    self.memberName = [self.memberName decryptCBCStr];
    self.phone = [self.phone decryptCBCStr];
}
@end
