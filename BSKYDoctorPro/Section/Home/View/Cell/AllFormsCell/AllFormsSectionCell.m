//
//  AllFormsSectionCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AllFormsSectionCell.h"

@interface AllFormsSectionCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *clickLabel;

@end

@implementation AllFormsSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.titleLabel.text = _titleStr;
    self.clickLabel.hidden = YES;
    self.clickImageView.hidden = YES;
    if ([_titleStr isEqualToString:@"基本信息"]) {
        self.clickLabel.hidden = NO;
        if (self.upModel.type.integerValue == FollowupTypeGaoTang) {
            self.clickLabel.hidden = YES;
        }
        self.clickLabel.text = @"  切换至旧版  ";
        self.clickLabel.textColor = UIColorFromRGB(0x0eb2ff);
        self.clickLabel.layer.borderColor = UIColorFromRGB(0x0eb2ff).CGColor;
        self.clickLabel.layer.borderWidth = 1.f;
        [self.clickLabel setCornerRadius:5];
    }
    else if ([_titleStr isEqualToString:@"体征"])
    {
        self.clickLabel.hidden = NO;
        self.clickImageView.hidden = NO;
        self.clickImageView.image = [UIImage imageNamed:@"transport_icon"];
        self.clickLabel.text = @"数据读取";
        self.clickLabel.textColor = UIColorFromRGB(0x4e7dd3);
        self.clickLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }
    else if ([_titleStr isEqualToString:@"辅助检查"])
    {
        self.clickLabel.hidden = YES;
        self.clickLabel.text = @"";
        self.clickImageView.image = [UIImage imageNamed:@"more_icon"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
