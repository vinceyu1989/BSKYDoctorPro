//
//  IMFriendInfoModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMEXModel.h"

@interface IMFriendInfoModel : NSObject

@property (nonatomic, copy) NSString *accid;//手机号码
@property (nonatomic, copy) NSString *iocn;// 头像 ,
//@property (nonatomic, copy) NSString *professionType;//职业编码,见数据字典profession_type
@property (nonatomic, copy) NSString *name;//姓名
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, strong) IMEXModel *ex;
- (void)decryptModel;
@end
