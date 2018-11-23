//
//  FollowupDiUpModel.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/13.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupUpModel.h"

@implementation FollowupUpModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"drug"  : @"Drug",
             @"diabetesUseList"  : @"Drug",
             @"drugUseList"  : @"Drug",
             @"insulinDrug":@"InsulinDrug",
             @"other" : @"Other"
             };
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.body = [[Body alloc]init];
        self.cmModel = [[CmModel alloc]init];
        self.drug = [NSMutableArray array];
        self.diabetesUseList = [NSMutableArray array];
        self.drugUseList = [NSMutableArray array];
        self.insulinDrug = [NSMutableArray array];
        self.labora = [[Labora alloc]init];
        self.lifeStyle = [[LifeStyle alloc]init];
        self.orgId = @"";
        self.organ = [[Organ alloc]init];
        self.other = [NSMutableArray array];
        self.transOut = [[TransOut alloc]init];
    }
    return self;
}
@end

@implementation Body

@end

@implementation TransOut

@end

@implementation Other

@end

@implementation Organ

@end

@implementation LifeStyle

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idField":@"id"};
}

@end

@implementation Labora

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idField":@"id"};
}

@end

@implementation Drug

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idField":@"id"};
}

@end

@implementation InsulinDrug

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idField":@"id"};
}

@end

@implementation CmModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idField":@"id"};
}

@end



