//
//  ZLFollowupCountRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/19.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface ZLFollowupCountRequest : BSBaseRequest

@property (nonatomic ,copy) NSString *personId;

@property (nonatomic ,assign) NSInteger count;   // 随访次数

@end

@interface ZLHyFollowupCountRequest : ZLFollowupCountRequest

@end

@interface ZLDbFollowupCountRequest : ZLFollowupCountRequest

@end
