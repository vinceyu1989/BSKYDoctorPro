//
//  BSFollowupPlanCell.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSFollowupPlanCell : UITableViewCell

@property (nonatomic ,copy) NSArray *eventsByDayList;
@property (nonatomic, copy) void (^overBlock)(void);
@property (nonatomic, copy) void (^dateTouchBlock)(NSDate* date);
@property (nonatomic, copy) void (^monthChangeBlock)(NSString* month);

@end
