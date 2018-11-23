//
//  LoginTextField.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "LoginTextField.h"

#define theWidth   [UIScreen mainScreen].bounds.size.width

@interface LoginTextField ()<UITextFieldDelegate>

@property (nonatomic ,strong) UIView *underLine;

@property (nonatomic ,strong) UIButton *clearBtn;

@end

@implementation LoginTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
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
    self.maxNum = 10000000;
    
    self.tintColor = UIColorFromRGB(0xcccccc);
    self.textColor = UIColorFromRGB(0x333333);
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.delegate = self;   
    
    self.underLine = [[UIView alloc]init];
    self.underLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [self addSubview:self.underLine];
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
    
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearBtn setImage:[UIImage imageNamed:@"清空"] forState:UIControlStateNormal];
    [self.clearBtn addTarget:self action:@selector(clearBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.clearBtn sizeToFit];
    self.clearBtn.hidden = YES;
    [self addSubview:self.clearBtn];
    
}
#pragma mark ---- UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (self.text.length > 0 ) {
        self.clearBtn.hidden = NO;
    }
    self.underLine.backgroundColor = UIColorFromRGB(0x4e7dd3);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.clearBtn.hidden = YES;
    self.underLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.text.length == 1 &&[string isEqualToString:@""] ) {
        self.clearBtn.hidden = YES;
    }
    else if (self.text.length > 0 || string.length > 0 ) {
        self.clearBtn.hidden = NO;
    }
    else if (self.text.length == 0) {
        self.clearBtn.hidden = YES;
    }
    
    if (self.text.length >= self.maxNum && ![string isEqualToString:@""]) {
        
//        [UIView makeToast:@"超过了限制字数"];
        
        return NO;
    }
    
    return YES;
}

#pragma mark ---- pressed

- (void)clearBtnPressed
{
    self.text = @"";
    self.clearBtn.hidden = YES;
}

#pragma mark ---- UI

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat x = self.rightView ? self.rightView.x : self.width;
    
    self.clearBtn.center = CGPointMake(x-self.clearBtn.width/2-10, self.height/2);
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x -= 10;
    return iconRect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super placeholderRectForBounds:bounds];
    if (iconRect.size.width + self.leftView.width >= self.width) {
        return iconRect;
    }
    iconRect.size.width =  iconRect.size.width+self.clearBtn.width+15;
    return iconRect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super editingRectForBounds:bounds];
    iconRect.size.width = iconRect.size.width-self.clearBtn.width-15;
    return iconRect;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.clearBtn.frame, point)) {
        return self.clearBtn;
    }
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView;
}

- (void)setLeftViewImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 20.0)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeCenter;
    self.leftView = imageView;
}

- (void)setRightViewImage:(UIImage *)image {
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(theWidth-60, 0, 30, 30)];
//    imageView.image = image;
//    imageView.contentMode = UIViewContentModeCenter;
//    self.rightView = imageView;
//    [self.rightView sizeToFit];
}

@end
