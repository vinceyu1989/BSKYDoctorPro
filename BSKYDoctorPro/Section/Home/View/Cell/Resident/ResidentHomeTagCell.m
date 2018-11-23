//
//  ResidentHomeTagCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/19.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentHomeTagCell.h"

@implementation ResidentHomeTagCell

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = UIColorFromRGB(0x516676);
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.backgroundColor = UIColorFromRGB(0xf6fbff);
    self.contentLabel.layer.borderColor = UIColorFromRGB(0xcad1d6).CGColor;
    self.contentLabel.layer.borderWidth = 0.5f;
    [self.contentLabel setCornerRadius:3.0];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
