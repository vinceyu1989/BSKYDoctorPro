//
//  BSFriendVerifyModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/13.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSFriendVerifyModel : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString * charge;
@property (nonatomic, assign) BOOL isVerified;
@property (nonatomic, copy) NSString * mobileNo;
@property (nonatomic, copy) NSString * photourl;
@property (nonatomic, copy) NSString * realname;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * tags;

- (void)decryptModel;
@end
