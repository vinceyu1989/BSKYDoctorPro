//
//  InterviewOptionalInputModel.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/5.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "InterviewInputModel.h"

@implementation InterviewInputModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isRequired = NO;
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"pickerModels":@"InterviewPickerModel"};
}

@end

@implementation InterviewPickerModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.multiple = 1;
    }
    return self;
}

@end

@implementation InterviewOtherModel


@end
