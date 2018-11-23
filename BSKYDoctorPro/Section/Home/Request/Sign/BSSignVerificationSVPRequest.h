//
//  BSSignVerificationSVPRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"

@interface BSSignVerificationSVPRequest : BSBaseRequest

@property (nonatomic, copy) NSString *personId;     //居民Id
@property (nonatomic, copy) NSString *teamId;       //团队Id
@property (nonatomic, copy) NSString *servicesId;   //服务包Id
@property (nonatomic, copy) NSString *startTime;    //开始时间
@property (nonatomic, copy) NSString *endTime;

@end
