//
//  DiabetesTableViewCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowupUserSearchModel.h"
#import "ZLSearchPersonalModel.h"

@interface DiabetesTableViewCell : UITableViewCell

@property (nonatomic ,strong) FollowupUserSearchModel *model;

@property (nonatomic, strong) ZLSearchPersonalModel * zlModel;

@end
