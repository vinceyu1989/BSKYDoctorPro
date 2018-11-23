//
//  ZLFollowupLastInfoBaseRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/27.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "ZLFollowupLastModel.h"

@interface ZLFollowupLastInfoBaseRequest : BSBaseRequest

@property (nonatomic ,copy) NSString *personId;

@property (nonatomic ,copy) NSString *lastfollowdate;

@property (nonatomic ,strong) ZLFollowupLastModel *lastModel;

@end

@interface ZLFollowupLastInfoHyRequest : ZLFollowupLastInfoBaseRequest

@end

@interface ZLFollowupLastInfoDbRequest : ZLFollowupLastInfoBaseRequest

@end
