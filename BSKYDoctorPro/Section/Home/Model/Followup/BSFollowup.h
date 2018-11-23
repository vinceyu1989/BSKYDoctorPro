//
//  BSFollowup.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/11.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    address = 1;
//    age = 18;
//    doctorId = 40;
//    followDate = "2017-08-27";
//    followUpType = 06002002;
//    gwUserId = 1;
//    lastFollowDate = "2017-08-24";
//    phone = 13567890987;
//    planId = 7;
//    sex = 1;
//    status = 06001001;
//    userIdCard = 1;
//    username = "\U6d4b\U8bd5";
//}

typedef NS_ENUM(NSInteger, BSSex) {
    BSSexUnknow = 0,
    BSSexMale = 1,
    BSSexFemale = 2
};

@interface BSFollowup : NSObject

@property (nonatomic, strong) NSNumber *planId;
@property (nonatomic, copy) NSString *username;             // 随访用户名
@property (nonatomic, copy) NSString *sex;                    // 性别
@property (nonatomic, copy) NSString *age;                  // 年龄,27岁
@property (nonatomic, copy) NSString *phone;                // 联系电话
@property (nonatomic, copy) NSString *lastFollowDate;       // 上次随访时间
@property (nonatomic, copy) NSString *followDate;           // 计划随访时间
@property (nonatomic, copy) NSString *followUpType;         // 随访类型
@property (nonatomic, copy) NSString *address;              // 常住地址
@property (nonatomic, copy) NSString *status;               // 随访状态 06001001(未完成)  06001002(已完成)
@property (nonatomic, copy) NSString *userIdCard;           // 身份证号
@property (nonatomic, copy) NSString *gwUserId;             // 公卫id
@property (nonatomic, strong) NSNumber *doctorId;           // 随访医生在平台的id
@property (nonatomic, copy) NSString *completeDate;
- (void)decryptModel;
- (void)encryptModel;
@end
