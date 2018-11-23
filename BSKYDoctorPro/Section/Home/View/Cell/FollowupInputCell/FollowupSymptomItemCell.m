//
//  FollowupSymptomItemCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupSymptomItemCell.h"

@implementation FollowupSymptomItemCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    [self.contentView setCornerRadius:15];
    self.contentView.layer.borderWidth = 1.f;
    self.contentView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.top.bottom.equalTo(self.contentView);
    }];
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.contentView.backgroundColor = UIColorFromRGB(0x7fc6f3);
        self.titleLabel.textColor = [UIColor whiteColor];
        self.contentView.layer.borderColor = UIColorFromRGB(0x7fc6f3).CGColor;
    }
    else
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = UIColorFromRGB(0x333333);
        self.contentView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    }
}

@end
