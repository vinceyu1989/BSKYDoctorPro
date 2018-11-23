//
//  InterviewMedicateCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/6.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterviewInputModel.h"
#import "FollowupUpModel.h"

@class InterviewMedicateCell;

@protocol InterviewMedicateCellDelegate <NSObject>

- (void)interviewMedicateCellDelete:(InterviewMedicateCell *)cell;
@end

@interface InterviewMedicateCell : UITableViewCell

@property (nonatomic ,weak) id<InterviewMedicateCellDelegate> delegate;

@property (nonatomic ,strong) InterviewInputModel *model;    // UI model

@property (nonatomic ,strong) Drug *drug;

@property (nonatomic ,strong) InsulinDrug *insulinDrug;

@end
