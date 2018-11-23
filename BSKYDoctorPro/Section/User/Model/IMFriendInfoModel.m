//
//  IMFriendInfoModel.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMFriendInfoModel.h"

@implementation IMFriendInfoModel
- (void)decryptModel{
    self.accid = [self.accid decryptCBCStr];
    self.iocn = [self.iocn decryptCBCStr];
    self.mobile = [self.mobile decryptCBCStr];
    self.name = [self.name decryptCBCStr];
}
@end
