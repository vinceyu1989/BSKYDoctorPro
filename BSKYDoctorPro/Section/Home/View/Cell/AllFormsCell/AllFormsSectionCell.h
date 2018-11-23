//
//  AllFormsSectionCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowupUpModel.h"

@interface AllFormsSectionCell : UITableViewCell

@property (nonatomic ,strong) FollowupUpModel *upModel;

@property (nonatomic ,copy) NSString *titleStr;

@property (weak, nonatomic) IBOutlet UIImageView *clickImageView;

@end
