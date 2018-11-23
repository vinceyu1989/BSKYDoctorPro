//
//  ResidentFollowupSectionCell.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/22.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResidentFollowupSectionCell : UITableViewCell

@property (nonatomic, assign) BOOL  isExpansion;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
