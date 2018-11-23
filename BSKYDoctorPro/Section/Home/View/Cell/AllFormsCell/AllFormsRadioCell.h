//
//  AllFormsRadioCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowupUpModel.h"
#import "InterviewInputModel.h"

@interface AllFormsRadioCell : UITableViewCell

@property (nonatomic ,strong) FollowupUpModel *upModel;   // 配置数据

@property (nonatomic ,strong) InterviewInputModel *model;   // ui model

@end
