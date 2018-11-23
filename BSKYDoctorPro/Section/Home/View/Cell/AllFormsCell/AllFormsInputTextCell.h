//
//  AllFormsInputTextCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowupUpModel.h"
#import "InterviewInputModel.h"

@interface AllFormsInputTextCell : UITableViewCell

@property (nonatomic ,strong) FollowupUpModel *upModel;  //  需要保存的数据

@property (nonatomic ,strong) InterviewInputModel *model;    // UI model

@end
