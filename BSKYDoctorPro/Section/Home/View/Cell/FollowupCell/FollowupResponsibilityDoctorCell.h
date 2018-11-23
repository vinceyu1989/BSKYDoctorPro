//
//  FollowupResponsibilityDoctorCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowupDoctorModel.h"
#import "ZLDoctorModel.h"

@interface FollowupResponsibilityDoctorCell : UITableViewCell

@property (nonatomic, strong) FollowupDoctorModel * doctorModel;

@property (nonatomic, strong) ZLDoctorModel * zlDoctorModel;

@end
