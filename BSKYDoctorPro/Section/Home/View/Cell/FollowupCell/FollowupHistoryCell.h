//
//  FollowupHistoryCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/10/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowupHistoryModel.h"
#import "ZLFollowupHistoryModel.h"

@interface FollowupHistoryCell : UITableViewCell

@property (nonatomic ,assign) FollowupType type;

@property (nonatomic ,strong) FollowupHistoryModel *model;

@property (nonatomic, strong) ZLFollowupHistoryModel * zlModel;

@end
