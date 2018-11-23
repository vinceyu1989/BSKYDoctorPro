//
//  BSUser.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/12.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    accToken = "";
//    loginMark = c5a0ad431a3ad3942f45a6e7adaef415;
//    organizationId = 41;
//    organizationName = "\U534e\U4e3a\U836f\U623f";
//    professionType = 1;
//    realName = "\U963f\U82b1";
//    regCode = 84715274d2fbf9704c33b17685f74c6a;
//    reqDigest = "ZTcxNWE1ZmUxMzEyMjY2MWI1OGYxNWJiNjlhZDNhNmU=";
//    token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxODIwMDExMjE3MiIsInVzZXJpZCI6IjQwIiwicm9sZSI6IjEifQ.gYpQD1qHAK2E_CO1eQUxn6foU-SI_6IwHcL-VHuLOU9ZqgV50Eb5RYeYKZuSKMGWsyUm0kCuZhO7Xs7U1qrXgw";
//    userId = 40;
//}


@class ZLAccountInfo;

@interface BSUser : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, assign) NSInteger professionType; //执业类型
@property (nonatomic, copy) NSString *organizationName;
@property (nonatomic, assign) NSInteger organizationId;
@property (nonatomic, copy) NSString *accToken;         
//@property (nonatomic, copy) NSString *regCode;          // 登录加密用的
@property (nonatomic, copy) NSString *divisionCode;     // 区划code
@property (nonatomic, strong) NSNumber *sysType;          // 系统类型 对应InterfaceServerType

@property (nonatomic, strong) BSPhisInfo *phisInfo;     // 基卫信息

@property (nonatomic, strong) ZLAccountInfo * zlAccountInfo;  // 中联账号信息

- (void)decryptModel;
@end



@interface ZLAccountInfo : NSObject

@property (nonatomic, copy) NSString *account;          // 医生中联账号
@property (nonatomic, copy) NSString *employeeId;       // 中联医生ID
@property (nonatomic, copy) NSString *employeeName;     // 中联医生名字
@property (nonatomic, copy) NSString *orgId;            // 中联医生所属机构ID
@property (nonatomic, copy) NSString *orgName;          // 中联医生所属机构名称

@end
