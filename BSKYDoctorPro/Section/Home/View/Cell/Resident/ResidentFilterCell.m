//
//  ResidentFilterCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentFilterCell.h"

@interface ResidentFilterCell()

@end

@implementation ResidentFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isSelected = NO;
    [self.contentLabel setCornerRadius:5];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        self.contentLabel.backgroundColor = [UIColor whiteColor];
        self.contentLabel.textColor = UIColorFromRGB(0xff2a2a);
        self.contentLabel.layer.borderColor = UIColorFromRGB(0xff2a2a).CGColor;
        self.contentLabel.layer.borderWidth = 1.f;
    }
    else
    {
        self.contentLabel.backgroundColor = UIColorFromRGB(0xf7f7f7);
        self.contentLabel.textColor = UIColorFromRGB(0x666666);
        self.contentLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }
}


@end
