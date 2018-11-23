//
//  FollowupUpdateDateRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/10/31.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface FollowupUpdateDateRequest : BSBaseRequest

@property (nonatomic ,copy) NSString *followdate;

@property (nonatomic ,copy) NSString *planId;

@end
