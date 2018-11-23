//
//  InterviewRequiredVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/4.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSFollowup.h"
#import "FollowupUpModel.h"

@interface InterviewRequiredVC : UITableViewController

@property (nonatomic ,strong)BSFollowup *planModel;

@property (nonatomic ,copy) void (^switchBlock)(void);

@end
