//
//  ZLFollowupUpModel.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFollowupUpModel.h"

@implementation ZLFollowupUpModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"drugList"  : @"ZLDrugModel"};
}
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([oldValue isKindOfClass:[NSString class]]) {
        if ([oldValue isNotEmptyString]) {
            return oldValue;
        }
        return nil;
    }
    else if ([oldValue isKindOfClass:[NSArray class]])
    {
        if ([oldValue isNotEmptyArray]) {
            return oldValue;
        }
        return nil;
    }
    return oldValue;
}

@end
