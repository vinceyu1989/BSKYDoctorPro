//
//  ResponsibilityDoctorRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/13.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "FollowupDoctorModel.h"

@interface ResponsibilityDoctorRequest : BSBaseRequest

@property (nonatomic, copy) NSString *medWorkerName;  // 搜索关键字
@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, strong) NSNumber *pageSize;

@property (nonatomic ,strong) NSMutableArray *dataList;

@end
