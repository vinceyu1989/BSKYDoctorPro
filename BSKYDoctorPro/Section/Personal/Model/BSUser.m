//
//  BSUser.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/12.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSUser.h"

@implementation BSUser

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"sysType"]) {
        
        NSString *tempStr = (NSString *)oldValue;
        if ([tempStr isEqualToString:@"scwjw"]) {
            return @1;
        }
        else if ([tempStr isEqualToString:@"sczl"])
        {
            return @2;
        }
        else if ([tempStr isEqualToString:@"schc"])
        {
            return @3;
        }
        return oldValue;
    }
    return oldValue;
}
- (void)decryptModel{
    self.organizationName = [self.organizationName decryptCBCStr];
    self.realName = [self.realName decryptCBCStr];
//    self.regCode = [self.regCode decryptCBCStr];
    self.userId = [self.userId decryptCBCStr];
}
@end

@implementation ZLAccountInfo

@end


