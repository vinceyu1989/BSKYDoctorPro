//
//  InterviewOptionalVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/5.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowupUpModel.h"

@interface InterviewOptionalVC : UITableViewController

@property (nonatomic ,assign) FollowupType type;    // 随访类型

@property (nonatomic ,strong) FollowupUpModel *upModel;   // 上传的Model

@end
