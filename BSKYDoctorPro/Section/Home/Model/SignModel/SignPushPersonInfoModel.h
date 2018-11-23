//
//  SignPushPersonInfoModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/15.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignPushPersonInfoModel : NSObject

@property (nonatomic, copy) NSArray  *contractServices;  //服务包ID集合 ,
@property (nonatomic, copy) NSNumber *fee;               //该居民选择的服务包总金额
@property (nonatomic, copy) NSString *personAge;         //居民年龄
@property (nonatomic, copy) NSString *personId;          //居民在基卫ID
@property (nonatomic, copy) NSString *personIdcard;      //居民身份证号
@property (nonatomic, copy) NSString *personName;        //居民姓名
@property (nonatomic, copy) NSString *personSex;         //居民性别
@property (nonatomic, copy) NSArray  *tags;              //人群标签
@property (nonatomic, strong) NSMutableDictionary *contractSmsContent;
- (void)encryptModel;
@end
