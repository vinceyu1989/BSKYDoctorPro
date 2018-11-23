//
//  BSFollowupListRequest.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//
//  1.根据计划随访时间分页查询随访列表

#import <Foundation/Foundation.h>

@interface BSFollowupListRequest : BSBaseRequest

@property (nonatomic, copy) NSString *followDate;    // 2017-08-12
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *pageNo;

@property (nonatomic, retain) NSArray *followupList;

@end
