//
//  ZLFollowupHistoryListVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLFollowupHistoryListVC : UITableViewController

@property (nonatomic ,copy) NSString *personId;

@property (nonatomic ,copy) NSString *personName;

@property (nonatomic ,assign) FollowupType type;

@end
