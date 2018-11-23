//
//  FollowupUpRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/14.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface FollowupUpRequest : BSBaseRequest

@property (nonatomic ,copy) NSString *followUp;

@property (nonatomic ,copy) NSString *followupPlan;

@property (nonatomic ,strong) NSDictionary *followUpPlanForm;
@end
