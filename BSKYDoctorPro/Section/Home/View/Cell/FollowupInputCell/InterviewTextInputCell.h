//
//  InterviewTextInputCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/4.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterviewInputModel.h"
#import "FollowupUpModel.h"

@interface InterviewTextInputCell : UITableViewCell

@property (nonatomic ,strong) FollowupUpModel *upModel;  //  需要保存的数据

@property (nonatomic ,strong) InterviewInputModel *model;    // UI model

@end
