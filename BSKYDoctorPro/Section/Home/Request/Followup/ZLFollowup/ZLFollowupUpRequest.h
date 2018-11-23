//
//  ZLFollowupUpRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface ZLFollowupUpRequest : BSBaseRequest

@end

@interface ZLFollowupHyUpRequest : ZLFollowupUpRequest

@property (nonatomic, strong) NSMutableDictionary * hyForm;

@end

@interface ZLFollowupDbUpRequest : ZLFollowupUpRequest

@property (nonatomic, strong) NSMutableDictionary * dbForm;

@end

