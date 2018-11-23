//
//  FollowupLastInfoBaseRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/11.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "FollowupUpModel.h"

@interface FollowupLastInfoBaseRequest : BSBaseRequest

@property (nonatomic ,copy) NSString *personId;

@property (nonatomic ,copy) NSString *lastfollowdate;

@property (nonatomic ,strong) FollowupUpModel *lastModel;


@end
