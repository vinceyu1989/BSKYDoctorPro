//
//  AllFormsSymptomCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterviewInputModel.h"
#import "FollowupUpModel.h"

@interface AllFormsSymptomCell : UITableViewCell

@property (nonatomic ,strong) InterviewInputModel *model;

@property (nonatomic ,strong) FollowupUpModel *upModel;

@end
