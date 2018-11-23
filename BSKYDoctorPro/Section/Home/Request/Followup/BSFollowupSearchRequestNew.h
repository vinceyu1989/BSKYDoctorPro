//
//  BSFollowupSearchRequestNew.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"
#import "FollowupUserSearchModel.h"

@interface BSFollowupSearchRequestNew : BSBaseRequest
@property (nonatomic, copy) NSString *key;      // 姓名 or 身份证号
@property (nonatomic, strong) NSNumber *pageSize;
@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, copy) NSString *buildType;

@property (nonatomic ,copy) NSArray *dataList;
@end
