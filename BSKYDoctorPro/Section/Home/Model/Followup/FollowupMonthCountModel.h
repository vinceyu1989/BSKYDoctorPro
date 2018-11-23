//
//  FollowupMonthCountModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/21.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowupMonthCountModel : NSObject

@property (nonatomic, assign) NSInteger count;  // 总数

@property (nonatomic, copy) NSString *day;   //  日期

@property (nonatomic, assign) NSInteger standard;    //  已完成数

@end
