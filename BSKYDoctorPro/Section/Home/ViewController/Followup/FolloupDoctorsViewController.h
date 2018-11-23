//
//  FolloupDoctorsViewController.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowupDoctorModel.h"

@interface FolloupDoctorsViewController : UIViewController

@property (nonatomic, copy) void(^didSelectBlock)(FollowupDoctorModel *doctorModel);

@end
