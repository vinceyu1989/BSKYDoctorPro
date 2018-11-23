//
//  InterviewRadioCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/4.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterviewInputModel.h"
#import "FollowupUpModel.h"

@class InterviewRadioCell;

@protocol InterviewRadioCellDelegate <NSObject>

- (void)interviewRadioCell:(InterviewRadioCell *)cell selectedString:(NSString *)string;

@end

@interface InterviewRadioCell : UITableViewCell

@property (nonatomic ,strong) FollowupUpModel *upModel;

@property (nonatomic ,strong) InterviewInputModel *model;

@property (nonatomic ,weak) id<InterviewRadioCellDelegate> delegate;

@end
