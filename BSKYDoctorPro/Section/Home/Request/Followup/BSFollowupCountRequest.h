//
//  BSFollowupCountRequest.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//
//  4.根据月份查询当月每天随访计划总数

#import <Foundation/Foundation.h>
#import "FollowupMonthCountModel.h"

@interface BSFollowupCountRequest : BSBaseRequest

@property (nonatomic, copy) NSString *month;    // 2017-08

@property (nonatomic, copy) NSArray * eventsByDayList; //  FollowupMonthCountModel 数组

@end
