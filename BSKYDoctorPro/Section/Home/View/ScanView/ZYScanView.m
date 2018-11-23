//
//  ZYScanView.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "ZYScanView.h"

@interface ZYScanView () {
    CGFloat _multply;
    CGFloat _lineHeight;
}

@property (nonatomic, strong) UIImageView * logoImage;
@property (nonatomic, strong) UIImageView * scanLineImg;
@property (nonatomic, strong) UIView  * maskView;
@property (nonatomic, strong) UILabel * hintLabel;
@property (nonatomic, strong) UIImageView * topLeftImg;
@property (nonatomic, strong) UIImageView * topRightImg;
@property (nonatomic, strong) UIImageView * bottomLeftImg;
@property (nonatomic, strong) UIImageView * bottomRightImg;

@property (nonatomic, strong) UIBezierPath * bezier;
@property (nonatomic, strong) CAShapeLayer * shapeLayer;

/** 第一次旋转 */
@property (nonatomic, assign) CGFloat isFirstTransition;

@end

@implementation ZYScanView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}
/**
 *  添加UI
 */
- (void)addUI {
    _multply = kScreenWidth/375.0;
    //遮罩层
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    self.maskView.layer.mask = [self maskLayer];
    [self addSubview:self.maskView];
    
    self.logoImage = [[UIImageView alloc] init];
    self.logoImage.image = [UIImage imageNamed:@"saomiao"];
    self.logoImage.contentMode = UIViewContentModeCenter;
    [self addSubview:self.logoImage];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(39*_multply);
    }];
    
    //左上
    CGFloat paddingWidth = self.width - 262*_multply;
    self.topLeftImg = [[UIImageView alloc] init];
    self.topLeftImg.image = [UIImage imageNamed:@"ScanQR1"];
    [self addSubview:self.topLeftImg];
    [self.topLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(paddingWidth/2.0);
        make.top.equalTo(self.mas_top).offset(150*_multply);
    }];
    
    //右上
    self.topRightImg = [[UIImageView alloc] init];
    self.topRightImg.image = [UIImage imageNamed:@"ScanQR2"];
    [self addSubview:self.topRightImg];
    [self.topRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-paddingWidth/2.0);
        make.top.equalTo(self.mas_top).offset(150*_multply);
    }];
    
    //左下
    self.bottomLeftImg = [[UIImageView alloc] init];
    self.bottomLeftImg.image = [UIImage imageNamed:@"ScanQR3"];
    [self addSubview:self.bottomLeftImg];
    [self.bottomLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(paddingWidth/2.0);
        make.bottom.equalTo(self.topLeftImg.mas_top).offset(262*_multply);
    }];
    
    //右下
    self.bottomRightImg = [[UIImageView alloc] init];
    self.bottomRightImg.image = [UIImage imageNamed:@"ScanQR4"];
    [self addSubview:self.bottomRightImg];
    [self.bottomRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-paddingWidth/2.0);
        make.bottom.equalTo(self.topRightImg.mas_top).offset(262*_multply);
    }];
    
    //提示框
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.text = @"请将二维码/条形码放入框内，即可自动扫描";
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.numberOfLines = 0;
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.bottomRightImg.mas_bottom).offset(30*_multply);
        make.width.equalTo(@(262*_multply));
    }];
    
    //扫描线
    UIImage * scanLine = [UIImage imageNamed:@"QRCodeScanLine"];
    self.scanLineImg = [[UIImageView alloc] init];
    self.scanLineImg.image = scanLine;
    _lineHeight = scanLine.size.height;
    self.scanLineImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.scanLineImg];
    [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
    self.scanLineImg.frame = CGRectMake((self.width - 262*_multply) * 0.5, (150-_lineHeight/2.0)*_multply, 262*_multply, _lineHeight);
}

/**
 *  动画
 */
- (CABasicAnimation *)animation{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = MAXFLOAT;
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (150 - _lineHeight/2.0)*_multply)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (150 + _lineHeight/2.0 + 262)*_multply)];
    return animation;
}

/**
 *  遮罩层bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)maskPath{
    self.bezier = nil;
    self.bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.width, self.height)];
    [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.width - 262*_multply) * 0.5, 150*_multply, 262*_multply, 262*_multply)] bezierPathByReversingPath]];
    [UIColorFromRGB(0xededed) setStroke];
    [self.bezier stroke];
    return self.bezier;
}

/**
 *  遮罩层ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)maskLayer{
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = [self maskPath].CGPath;
    
    return self.shapeLayer;
}

#pragma mark - public method

/**
 *  重设UI的frame
 */
- (void)resetFrame{
    self.maskView.frame = CGRectMake(0, 0, self.width, self.height);
    self.maskView.layer.mask = [self maskLayer];
    
    self.scanLineImg.frame = CGRectMake((self.width - 262*_multply) * 0.5, (150-_lineHeight/2.0)*_multply, 262*_multply, _lineHeight);
    [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
}

/**
 *  移除动画
 */
- (void)removeAnimation{
    [self.scanLineImg.layer removeAllAnimations];
}

@end
