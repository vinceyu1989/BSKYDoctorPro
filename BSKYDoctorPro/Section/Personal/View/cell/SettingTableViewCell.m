//
//  SettingTableViewCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/31.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

+(CGFloat)cellHeight
{
    return 50;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = UIColorFromRGB(0xededed);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
