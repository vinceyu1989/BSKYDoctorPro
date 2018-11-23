//
//  BSArchiveModel.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSArchiveModel.h"

@implementation BSArchiveModel

@end

@implementation ArchiveModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"content":@"BSArchiveModel"};
}

@end
@implementation ArchiveAddModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"adds":@"BSArchiveModel"};
}

@end
@implementation ArchiveSelectOptionModel
- (NSString *)title{
    if (self.lebel.length) {
        return _lebel;
    }else{
        return _title;
    }
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"title": @"lebel"};
}
- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[ArchiveSelectOptionModel class]]) {
        return NO;
    }
    
    return [self isEqualToModel:(ArchiveSelectOptionModel *)object];
}
- (BOOL )isEqualToModel:(ArchiveSelectOptionModel *)object{
    if (![self.title isEqualToString:object.title]){
        return NO;
    }
    if (![self.lebel isEqualToString:object.lebel]){
        return NO;
    }
    if (![self.value isEqualToString:object.value]){
        return NO;
    }
    if (![self.dictId isEqualToString:object.dictId]){
        return NO;
    }
    return YES;
}

@end

@implementation ArchivePickerModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"options":@"ArchiveSelectOptionModel"};
}
@end

@implementation ArchiveLimitModel

@end

@implementation ArchiveSelectModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"options":@"ArchiveSelectOptionModel",
             @"selectArray":@"ArchiveSelectOptionModel",
             };
}
@end
