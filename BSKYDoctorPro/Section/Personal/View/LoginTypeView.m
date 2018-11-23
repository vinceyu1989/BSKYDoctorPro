//
//  LoginInputView.m
//  Login
//
//  Created by kykj on 2017/8/15.
//  Copyright © 2017年 kykj. All rights reserved.
//

#import "LoginTypeView.h"
#import "Masonry.h"

#define theWidth   [UIScreen mainScreen].bounds.size.width

@interface LoginTypeView ()

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIView *btnBottomLine;
@property (nonatomic, copy) LoginTypeSelectedCallback callback;

@end

@implementation LoginTypeView


- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *loginTypeView = [[UIView alloc] init];
    [self addSubview:loginTypeView];
    [loginTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        
    }];
    
    UIView *midLine = [[UIView alloc] init];
    midLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [loginTypeView addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.centerX.mas_equalTo(loginTypeView.mas_centerX).offset(0);
        make.width.offset(1);
        make.height.offset(theWidth/375 *25.0);
        
    }];
    
    UIButton *quickLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quickLoginBtn setTitle:@"快速登录" forState:UIControlStateNormal];
    quickLoginBtn.titleLabel.font = [UIFont systemFontOfSize:theWidth/375 * 15.0];
    quickLoginBtn.tag = 10000;
    [quickLoginBtn setTitleColor:[UIColor colorWithHexString:@"#4e7dd3"] forState:UIControlStateSelected];
    [quickLoginBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    quickLoginBtn.selected = YES;
    self.selectBtn = quickLoginBtn;
    [quickLoginBtn addTarget:self action:@selector(loginTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginTypeView addSubview:quickLoginBtn];
    [quickLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(midLine.mas_left).offset(-theWidth/375 * 25.0);
        make.centerY.mas_equalTo(midLine.mas_centerY).offset(0);
        make.height.offset(theWidth/375 * 15.0);
    }];
    
    UIButton *passWordLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [passWordLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
    passWordLoginBtn.titleLabel.font = [UIFont systemFontOfSize:theWidth/375 * 15.0];
    passWordLoginBtn.tag = 10001;
    [passWordLoginBtn setTitleColor:[UIColor colorWithHexString:@"#4e7dd3"] forState:UIControlStateSelected];
    [passWordLoginBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    passWordLoginBtn.selected = NO;
    [passWordLoginBtn addTarget:self action:@selector(loginTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginTypeView addSubview:passWordLoginBtn];
    [passWordLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(midLine.mas_right).offset(theWidth/375 * 25.0);
        make.centerY.mas_equalTo(midLine.mas_centerY).offset(0);
        make.height.offset(theWidth/375 * 15.0);
    }];
    
    UIView *btnBottomLine = [[UIView alloc] init];
    btnBottomLine.backgroundColor = [UIColor colorWithHexString:@"#4e7dd3"];
    btnBottomLine.layer.cornerRadius = 2.0;
    btnBottomLine.layer.masksToBounds = YES;
    self.btnBottomLine = btnBottomLine;
    [loginTypeView addSubview:btnBottomLine];
    [btnBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(quickLoginBtn.mas_bottom).offset(theWidth/375 * 10.0);
        make.right.mas_equalTo(midLine.mas_left).offset(-theWidth/375 * 25.0);
        make.width.mas_equalTo(quickLoginBtn.mas_width);
        make.height.offset(2);
        
    }];
}

- (void)setButtonLoginType:(ButtonLoginType)type {
    switch (type) {
        case ButtonLoginSMSType:
        {
            UIButton *btn = (UIButton *)[self viewWithTag:10000];
            [self loginTypeClick:btn];
        }
            break;
        case ButtonLoginPWType:
        {
            UIButton *btn = (UIButton *)[self viewWithTag:10001];
            [self loginTypeClick:btn];
        }
            break;
        default:
            break;
    }
}

#pragma mark loginTypeClick
- (void)loginTypeClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    } else {
        self.selectBtn.selected = NO;
        self.selectBtn = sender;
        self.selectBtn.selected = YES;
        NSInteger index = sender.tag - 10000;
        [self addAnimationWithSelectedItem:sender];
        _callback(index);
    }
}

- (void)addAnimationWithSelectedItem:(UIButton *)btn {
    
    // Caculate the distance of translation
    CGFloat dx = CGRectGetMidX(btn.frame) - CGRectGetMidX(self.btnBottomLine.frame);
        
    // Add the animation about translation
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.fromValue = @(self.btnBottomLine.layer.position.x);
    positionAnimation.toValue = @(self.btnBottomLine.layer.position.x + dx);
    
    CABasicAnimation *boundsAnimation = [CABasicAnimation animation];
    boundsAnimation.keyPath = @"bounds.size.width";
    boundsAnimation.fromValue = @(CGRectGetWidth(self.btnBottomLine.layer.bounds));
    boundsAnimation.toValue = @([btn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:theWidth/375 * 15.0]}
                                                                  context:nil].size.width);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, boundsAnimation];
    animationGroup.duration = 0.2;
    
    [self.btnBottomLine.layer addAnimation:animationGroup forKey:@"basic"];
    
    //     Keep the state after animating
    self.btnBottomLine.layer.position = CGPointMake(self.btnBottomLine.layer.position.x + dx, self.btnBottomLine.layer.position.y);
    CGRect rect = self.btnBottomLine.layer.bounds;
    rect.size.width = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:theWidth/375 * 15.0]}
                                                        context:nil].size.width;
    self.btnBottomLine.layer.bounds = rect;
}

- (void)loginTypeSelectedCallback:(LoginTypeSelectedCallback)callback {
    _callback = callback;
}

@end
