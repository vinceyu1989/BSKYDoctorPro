//
//  ZLFollowupDetailModel.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/27.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFollowupLastModel.h"

@implementation ZLFollowupLastModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"drugList"  : @"ZLDrugModel"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idField":@"id"};
}
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([oldValue isKindOfClass:[NSString class]]) {
        if ([oldValue isNotEmptyString]) {
            return oldValue;
        }
        return nil;
    }
    return oldValue;
}
@end

@implementation ZLDrugModel

@end


