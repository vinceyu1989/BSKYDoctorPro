//
//  PersonColligationModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

//  健康卡状态
typedef NS_ENUM(NSUInteger, HealthCardState) {
    
    HealthCardStateUnclaimed = 1,   // 未申领未激活
    
    HealthCardStateInactivated = 2,    // 已申领未激活
    
    HealthCardStateActivated = 3,    // 已申领已激活
};

@interface PersonColligationModel : NSObject

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * buildEmployeeID;
@property (nonatomic, copy) NSString * buildOrg;
@property (nonatomic, copy) NSString * buildOrgID;
@property (nonatomic, copy) NSString * cardId;
@property (nonatomic, copy) NSString * customNumber;
@property (nonatomic, copy) NSString * familyID;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * hmperfect;
@property (nonatomic, copy) NSString * hrStatus;
@property (nonatomic, copy) NSString * idField;
@property (nonatomic, copy) NSString * lastTime;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * personCode;
@property (nonatomic, copy) NSString * regionCode;
@property (nonatomic, copy) NSString * regionID;
@property (nonatomic, copy) NSString * regionName;
@property (nonatomic, copy) NSString * sophistication;
@property (nonatomic, copy) NSString * tG;
@property (nonatomic, copy) NSString * tH;
@property (nonatomic, copy) NSString * tJ;
@property (nonatomic, copy) NSString * tT;
@property (nonatomic, copy) NSString * telphone;
@property (nonatomic, copy) NSString * healthCardState;   // 健康卡状态
@property (nonatomic, copy) NSString * userId;            // userId
- (void)decryptModel;
- (void)encryptModel;
@end
