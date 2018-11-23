//
//  FolloupHistoryVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/10/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolloupHistoryVC : UITableViewController

@property (nonatomic ,copy) NSString *personId;

@property (nonatomic ,copy) NSString *personName;

@property (nonatomic ,assign) FollowupType type;

@end
