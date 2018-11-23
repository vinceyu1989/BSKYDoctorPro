//
//  BSFriendVerifyModel.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/13.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFriendVerifyModel.h"

@implementation BSFriendVerifyModel
- (void)decryptModel{
    self.mobileNo = [self.mobileNo decryptCBCStr];
    self.realname = [self.realname decryptCBCStr];
    self.photourl = [self.photourl decryptCBCStr];
}
@end
