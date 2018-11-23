//
//  ResidentFollowupSectionCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/22.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentFollowupSectionCell.h"

@interface ResidentFollowupSectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation ResidentFollowupSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsExpansion:(BOOL)isExpansion
{
    _isExpansion = isExpansion;
    [UIView beginAnimations:nil context:nil];
    if (_isExpansion) {
        self.icon.transform = CGAffineTransformMakeRotation(90 *M_PI / 180.0);
    }
    else
    {
         self.icon.transform = CGAffineTransformIdentity;
    }
    [UIView commitAnimations];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
