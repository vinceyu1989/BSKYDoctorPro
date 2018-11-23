//
//  SignFamilyMembersModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignFamilyMembersModel : NSObject

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *cardID;
@property (nonatomic, copy) NSString *genderCode; //性别 0未知,1男,2女,9未说明的性别
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *personCode; // 个人编码
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *telphone;
@property (nonatomic, copy) NSString *hrStatus; //档案状态 :0活动，1迁出，2死亡，99已删除，3其他 ,
@property (nonatomic, copy) NSString *TG;       // 高 ,
@property (nonatomic, copy) NSString *TH;       // 结 ,
@property (nonatomic, copy) NSString *TJ;       // 精 ,
@property (nonatomic, copy) NSString *TT;       // 糖 ,
- (void)decryptModel;
@end
