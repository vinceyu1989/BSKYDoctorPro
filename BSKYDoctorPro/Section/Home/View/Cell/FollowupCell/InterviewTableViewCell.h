//
//  InterviewTableViewCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InterviewTableViewCell;

@protocol InterviewTableViewCellDelegate <NSObject>

- (void)interviewTableViewCell:(InterviewTableViewCell *)cell clickPhoneNum:(NSString *)phoneNum;

- (void)interviewTableViewCellDelete:(InterviewTableViewCell *)cell;  // 删除

- (void)interviewTableViewCellModify:(InterviewTableViewCell *)cell dateStr:(NSString *)dateStr;    // 修改日期

- (void)interviewTableViewCellStart:(InterviewTableViewCell *)cell;   // 开始

@end

@interface InterviewTableViewCell : UITableViewCell

@property (nonatomic ,weak) id<InterviewTableViewCellDelegate> delegate;
@property (nonatomic, retain) BSFollowup *followup;

@end
