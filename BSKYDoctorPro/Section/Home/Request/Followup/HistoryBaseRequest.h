//
//  HistoryBaseRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/11.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "FollowupHistoryModel.h"

@interface HistoryBaseRequest : BSBaseRequest

@property (nonatomic ,copy) NSString *personId;

@property (nonatomic ,strong) NSNumber *pageSize;

@property (nonatomic ,strong) NSNumber *pageIndex;

@property (nonatomic ,copy) NSArray *dataList;

@end
