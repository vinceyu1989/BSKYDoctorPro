//
//  SignatureShowView.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignatureShowView.h"
#import "SignatureView.h"

@interface SignatureShowView ()

@property (nonatomic, strong) UIButton      *clearBtn;
@property (nonatomic, strong) UIButton      *cancelBtn;
@property (nonatomic, strong) UIButton      *ensureBtn;
@property (nonatomic, strong) SignatureView *contentView;

@end

@implementation SignatureShowView

- (instancetype)init {
    self= [super init];
    if (self) {
        [self initView];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self= [super initWithFrame:frame];
    if (self) {
        [self initView];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

- (void)initView {
    [self setFrame:[UIScreen mainScreen].bounds];
    
    self.contentView = [[SignatureView alloc] init];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    WS(weakSelf);
    self.contentView.completeBlock = ^(UIImage *signatureImage) {
        [MBProgressHUD hideHud];
        NSLog(@"生成图片contentView===%@",signatureImage);
        if (weakSelf.block && signatureImage) {
            UIImage *image = [signatureImage imageByRotateLeft90];
            weakSelf.block(image);
        }
        [weakSelf dismissView];
    };
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(41);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(STATUS_BAR_HEIGHT);
        make.bottom.equalTo(self.mas_bottom).offset(-SafeAreaBottomHeight);
    }];
    
    self.cancelBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[[UIImage imageNamed:@"sign_close"] imageByRotateRight90] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [btn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn;
    });
    
    self.clearBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[[UIImage imageNamed:@"sign_clear"] imageByRotateRight90] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [btn addTarget:self action:@selector(clearSignatureView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn;
    });

    self.ensureBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
         [btn setImage:[[UIImage imageNamed:@"sign_ensure"] imageByRotateRight90] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [btn addTarget:self action:@selector(ensurePressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn;
    });
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(STATUS_BAR_HEIGHT);
        make.left.equalTo(self.mas_left).offset(1);
        make.height.equalTo(@((self.height-SafeAreaBottomHeight-STATUS_BAR_HEIGHT)/3.0));
        make.width.equalTo(@40);
    }];
    
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelBtn.mas_bottom);
        make.left.equalTo(self.mas_left).offset(1);
        make.height.equalTo(@((self.height-SafeAreaBottomHeight-STATUS_BAR_HEIGHT)/3.0));
        make.width.equalTo(@40);
    }];
    
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-SafeAreaBottomHeight);
        make.left.equalTo(self.mas_left).offset(1);
        make.height.equalTo(@((self.height-SafeAreaBottomHeight-STATUS_BAR_HEIGHT)/3.0));
        make.width.equalTo(@40);
    }];
    
    [self showView];
}
#pragma mark - private

- (void)clearSignatureView {
    [self.contentView clearSignature];
}

- (void)ensurePressed {
    [MBProgressHUD showHud];
    [self.contentView completeSignature];
}

- (void)showView {
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissView {
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
    } completion:^(BOOL finished) {
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
    if (self.dismissBlock) {
        self.dismissBlock(self);
    }
}

@end
