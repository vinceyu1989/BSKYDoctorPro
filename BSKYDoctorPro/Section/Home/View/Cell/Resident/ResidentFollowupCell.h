//
//  ResidentFollowupCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/19.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentRefreshCell.h"

@class ResidentFollowupCell;

@protocol ResidentFollowupCellDelegate <NSObject>

- (void)residentFollowupCellExamineBtnPressed:(ResidentFollowupCell *)cell;

- (void)residentFollowupCellAddBtnPressed:(ResidentFollowupCell *)cell;

@end

@class ResidentFollowupUiModel;

@interface ResidentFollowupCell : UITableViewCell

@property (nonatomic, strong) ResidentFollowupUiModel *model;

@property (nonatomic, weak) id<ResidentFollowupCellDelegate> delegate;

@end

@interface ResidentFollowupUiModel : NSObject

@property (nonatomic, assign) BOOL isExpansion;

@property (nonatomic, copy) NSString * count;

@property (nonatomic, copy) NSString * lastTime;

@property (nonatomic, copy) NSString * nextTime;

@property (nonatomic, assign) BOOL isAnimation;   // 是否动画

@end
