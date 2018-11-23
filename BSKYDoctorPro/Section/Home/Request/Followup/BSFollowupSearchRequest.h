//
//  BSFollowupSearchRequest.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//
//  5.根据用户姓名或身份证号码查询用户信息

#import <Foundation/Foundation.h>
#import "FollowupUserSearchModel.h"

@interface BSFollowupSearchRequest : BSBaseRequest

@property (nonatomic, copy) NSString *key;      // 姓名 or 身份证号
@property (nonatomic, strong) NSNumber *pageSize;
@property (nonatomic, strong) NSNumber *pageIndex;

@property (nonatomic ,copy) NSArray *dataList;

@end

@interface BskyProgressHUD : NSObject <YTKRequestAccessory>

@property (nonatomic, copy) void (^tapBlock)(void);

@end
