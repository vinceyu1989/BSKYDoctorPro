//
//  IMEXModel.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMEXModel : NSObject
@property (nonatomic ,copy) NSString *idcard;
@property (nonatomic ,copy) NSString *professionType;
@property (nonatomic ,copy) NSString *age;
@end

@interface IMFriendEXModel : NSObject
@property (nonatomic ,copy) NSString *userLabel;
@end
