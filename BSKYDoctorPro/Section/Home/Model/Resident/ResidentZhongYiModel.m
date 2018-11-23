//
//  ResidentZhongYiModel.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/22.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentZhongYiModel.h"

@implementation ResidentZhongYiModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    
    return @{@"idField":@"id"};
}
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"idField"]) {
        return oldValue;
    }
    else if (![(NSString *)oldValue isNotEmptyString]) {
        return kModelEmptyString;
    }
    return oldValue;
}

@end
