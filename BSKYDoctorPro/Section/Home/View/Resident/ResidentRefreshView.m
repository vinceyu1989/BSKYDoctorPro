//
//  ResidentRefreshView.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/19.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentRefreshView.h"

@interface ResidentRefreshView()

@property (nonatomic, strong) UIImageView * refreshIcon;

@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation ResidentRefreshView

- (instancetype)init
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
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
}
- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    [self removeAllSubviews];
    
    self.refreshIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_refresh_resident"]];
    [self.refreshIcon sizeToFit];
    [self addSubview:self.refreshIcon];
    
    UILabel *refreshLabel = [[UILabel alloc]init];
    refreshLabel.text = @"刷新";
    refreshLabel.textColor = UIColorFromRGB(0x28a6ff);
    refreshLabel.font = [UIFont systemFontOfSize:18];
    [refreshLabel sizeToFit];
    [self addSubview:refreshLabel];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.text = @"读取数据失败，请尝试刷新";
    self.contentLabel.textColor = UIColorFromRGB(0x999999);
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    [self.contentLabel sizeToFit];
    [self addSubview:self.contentLabel];
    
    CGFloat width = self.refreshIcon.width + refreshLabel.width+5;
    CGFloat height = self.refreshIcon.height + self.contentLabel.height+5;
    
    [self.refreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset((self.refreshIcon.width-width)/2);
        make.centerY.equalTo(self.mas_centerY).offset((self.refreshIcon.height-height)/2);
    }];
    [refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset((width-refreshLabel.width)/2);
        make.centerY.equalTo(self.refreshIcon.mas_centerY);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset((height-self.contentLabel.height)/2);
    }];
}
- (void)startRefresh
{
    [self stopRefresh];
    [self.refreshIcon setNeedsDisplay];
    CABasicAnimation * rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.toValue = @(2*M_PI);
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = NSIntegerMax;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.refreshIcon.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    self.contentLabel.text = @"正在刷新请等待...";
}
- (void)stopRefresh
{
    if ([self.refreshIcon.layer.animationKeys containsObject:@"rotationAnimation"]) {
        [self.refreshIcon.layer removeAnimationForKey:@"rotationAnimation"];
    }
    self.contentLabel.text = @"读取数据失败，请尝试刷新";
}



@end
