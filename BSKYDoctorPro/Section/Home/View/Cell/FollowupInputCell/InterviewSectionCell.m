//
//  InterviewSectionCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/4.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "InterviewSectionCell.h"

@implementation InterviewSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.switchLabel.layer.borderColor = UIColorFromRGB(0x0eb2ff).CGColor;
    self.switchLabel.layer.borderWidth = 1.f;
    [self.switchLabel setCornerRadius:5];
    self.switchLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
