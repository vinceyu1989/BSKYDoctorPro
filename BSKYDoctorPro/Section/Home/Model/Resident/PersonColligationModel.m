//
//  PersonColligationModel.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "PersonColligationModel.h"

@implementation PersonColligationModel

+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"idField"]) {
        return @"ID";
    }
    if ([propertyName isEqualToString:@"healthCardState"]) {
        return @"healthCardState";
    }
    if ([propertyName isEqualToString:@"userId"]) {
        return @"userId";
    }
    return [propertyName mj_firstCharUpper];
}
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"tH"] || [property.name isEqualToString:@"tJ"] || [property.name isEqualToString:@"tT"] || [property.name isEqualToString:@"tG"]) {
        return oldValue;
    }
    if ([property.name isEqualToString:@"userId"]) {
        return oldValue;
    }
    if (![(NSString *)oldValue isNotEmptyString]) {
        return kModelEmptyString;
    }
    return oldValue;
}
- (void)decryptModel{
    self.address = [self.address decryptCBCStr];
    self.cardId = [self.cardId decryptCBCStr];
    self.name = [self.name decryptCBCStr];
    self.telphone = [self.telphone decryptCBCStr];
}
- (void)encryptModel{
    self.address = [self.address encryptCBCStr];
    self.cardId = [self.cardId encryptCBCStr];
    self.name = [self.name encryptCBCStr];
    self.telphone = [self.telphone encryptCBCStr];
}
@end
