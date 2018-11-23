//
//  SignResidentInfoModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignResidentInfoModel : NSObject

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *currentAddress; //现住址
@property (nonatomic, copy) NSString *personId;       //居民id
@property (nonatomic, copy) NSString *idcard;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
- (void)decryptModel;
@end
