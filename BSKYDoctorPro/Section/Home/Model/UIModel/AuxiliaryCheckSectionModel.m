//
//  AuxiliaryCheckSectionModel.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AuxiliaryCheckSectionModel.h"

@implementation AuxiliaryCheckSectionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isExpansion = NO;
        self.isEmpty = YES;
    }
    return self;
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"AuxiliaryCheckRowModel"};
}

@end

@implementation AuxiliaryCheckRowModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.content = @"";
    }
    return self;
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"pickerModels":@"InterviewPickerModel"};
}

@end
