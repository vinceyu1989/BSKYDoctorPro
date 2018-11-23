//
//  FollowupUserSearchModel.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/13.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupUserSearchModel.h"

@implementation FollowupUserSearchModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    
    return @{@"idField":@"id"};
}
- (void)decryptModel{
    self.idCard = [self.idCard decryptCBCStr];
    self.name = [self.name decryptCBCStr];
    self.tel = [self.tel decryptCBCStr];
    self.currentAddress = [self.currentAddress decryptCBCStr];
}
@end
