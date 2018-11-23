//
//  AuxiliaryCheckVC.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowupUpModel.h"

@interface AuxiliaryCheckVC : UITableViewController

@property (nonatomic ,strong) FollowupUpModel *upModel;

@property (nonatomic ,assign) BOOL isTang;  // 是否显示糖化血红蛋白 默认yes

@end
