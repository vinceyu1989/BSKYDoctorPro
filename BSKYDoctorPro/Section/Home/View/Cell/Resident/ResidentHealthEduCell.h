//
//  ResidentHealthEduCell.h
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResidentHealthEduCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eduTypeLabel;

@property (nonatomic, copy) void(^addNewHealthEduBlcok)(void);

@end
