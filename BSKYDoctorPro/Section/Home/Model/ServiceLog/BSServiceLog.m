//
//  BSServiceLog.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSServiceLog.h"

@implementation BSServiceLog

- (NSString*)serviceTypeWkt {
    if ([self.serviceType isEqualToString:@"01008001"]) {
        return @"高血压随访";
    }else if ([self.serviceType isEqualToString:@"01008002"]) {
        return @"糖尿病随访";
    }else if ([self.serviceType isEqualToString:@"01008003"]) {
        return @"高糖合并随访";
    }
    
    return @"未知随访类型";
}

@end
