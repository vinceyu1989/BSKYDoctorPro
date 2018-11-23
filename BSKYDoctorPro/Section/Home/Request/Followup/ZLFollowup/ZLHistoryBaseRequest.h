//
//  ZLHistoryBaseRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "ZLFollowupHistoryModel.h"

@interface ZLHistoryBaseRequest : BSBaseRequest

@property (nonatomic ,copy) NSString *personId;

@property (nonatomic, copy) NSString * doctorId;

@property (nonatomic ,strong) NSNumber *pageSize;

@property (nonatomic ,strong) NSNumber *pageIndex;

@property (nonatomic ,copy) NSArray *dataList;

@end

@interface ZLHyHistoryRequest : ZLHistoryBaseRequest

@end

@interface ZLDbHistoryRequest : ZLHistoryBaseRequest

@end
