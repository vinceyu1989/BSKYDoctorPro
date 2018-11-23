//
//  BSFriendVerifyRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/13.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "BSFriendVerifyModel.h"

@interface BSFriendVerifyRequest : BSBaseRequest

@property (nonatomic ,copy) NSString *idcard;

@property (nonatomic ,copy) NSString *realname;

@property (nonatomic ,strong) BSFriendVerifyModel *model;

@end
