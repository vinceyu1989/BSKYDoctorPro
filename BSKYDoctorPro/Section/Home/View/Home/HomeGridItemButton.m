//
//  HomeGridItemButton.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/16.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "HomeGridItemButton.h"

@implementation HomeGridItemButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        
        // 适配iOS9注释
//        [self setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xededed) size:self.bounds.size] forState:UIControlStateHighlighted];
        
        self.redPiont = [[UIView alloc]initWithFrame:CGRectZero];
        self.redPiont.backgroundColor = [UIColor redColor];
        self.redPiont.hidden = YES;
        [self addSubview:self.redPiont];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.center = CGPointMake(self.width/2, self.height/2-self.titleLabel.height/2-5);
    
    self.titleLabel.center = CGPointMake(self.width/2, self.height/2+self.imageView.height/2+5);
    
    self.redPiont.frame = CGRectMake(self.imageView.right-5, self.imageView.top-5, 9, 9);
    
    [self.redPiont setCornerRadius:self.redPiont.width/2];
}

@end
