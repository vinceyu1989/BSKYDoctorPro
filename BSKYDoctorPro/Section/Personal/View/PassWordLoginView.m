//
//  PassWordLoginView.m
//  Login
//
//  Created by kykj on 2017/8/16.
//  Copyright © 2017年 kykj. All rights reserved.
//

#import "PassWordLoginView.h"

#define theWidth   [UIScreen mainScreen].bounds.size.width
#define theHeight  [UIScreen mainScreen].bounds.size.height

@interface PassWordLoginView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *accountLine;
@property (nonatomic, strong) UIView *passwordLine;

@end

@implementation PassWordLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [self addSubview:line1];
    self.accountLine = line1;
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(theWidth/375 *45.0);
        make.right.offset(-theWidth/375 * 45.0);
        make.height.offset(1);
        make.top.offset(theWidth/375 *65.0);
    }];
    
    UIImage *accountImage = [UIImage imageNamed:@"手机号ico"];
    UIImageView *accountImageView = [[UIImageView alloc] init];
    accountImageView.image = accountImage;
    [self addSubview:accountImageView];
    [accountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(theWidth/375 *55.0);
        make.bottom.mas_equalTo(line1.mas_top).offset(-theWidth/375 *15.0);
        make.width.mas_equalTo(accountImage.size);
        make.height.mas_equalTo(accountImage.size);
        
    }];
    
    NSString *acountTHolderText = @"请输入手机号";
    NSMutableAttributedString *acountTPlaceholder = [[NSMutableAttributedString alloc]initWithString:acountTHolderText];
    [acountTPlaceholder addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xcccccc)
                        range:NSMakeRange(0, acountTHolderText.length)];
    UITextField *acountT = [[UITextField alloc] init];
    acountT.attributedPlaceholder = acountTPlaceholder;
    acountT.keyboardType = UIKeyboardTypeNumberPad;
    acountT.font = [UIFont systemFontOfSize:theWidth/375 *16.0 weight:UIFontWeightLight];
    if (LESS_IOS8_2) {
        acountT.font = [UIFont systemFontOfSize:theWidth/375 *16.0];
    }
    acountT.textColor = UIColorFromRGB(0x333333);
    acountT.clearButtonMode = UITextFieldViewModeWhileEditing;
    acountT.delegate = self;
    acountT.text = [BSClientManager sharedInstance].lastUsername;
    self.acountT = acountT;
    [self addSubview:acountT];
    [acountT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountImageView.mas_right).offset(theWidth/375 *15.0);
        make.right.offset(-theWidth/375 * 45.0);
        make.centerY.equalTo(accountImageView.mas_centerY).offset(theWidth/375*1);
        make.height.offset(theWidth/375 *35.0);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [self addSubview:line2];
    self.passwordLine = line2;
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(theWidth/375 *45.0);
        make.right.offset(-theWidth/375 * 45.0);
        make.height.offset(1);
        make.bottom.offset(0);
    }];
    
    UIImage *passwordImage = [UIImage imageNamed:@"密码ico"];
    UIImageView *passwordImageView = [[UIImageView alloc] init];
    passwordImageView.image = passwordImage;
    [self addSubview:passwordImageView];
    [passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(theWidth/375 *55.0);
        make.bottom.mas_equalTo(line2.mas_top).offset(-theWidth/375 *15.0);
        make.width.mas_equalTo(passwordImage.size);
        make.height.mas_equalTo(passwordImage.size);
        
    }];
    
    NSString *holderText = @"请输入密码";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xcccccc)
                        range:NSMakeRange(0, holderText.length)];
    UITextField *passwordT = [[UITextField alloc] init];
    passwordT.attributedPlaceholder = placeholder;
    passwordT.keyboardType = UIKeyboardTypeDefault;
    passwordT.secureTextEntry = YES;
    passwordT.font = [UIFont systemFontOfSize:theWidth/375 *16.0 weight:UIFontWeightLight];
    if (LESS_IOS8_2) {
        passwordT.font = [UIFont systemFontOfSize:theWidth/375 *16.0];
    }
    passwordT.textColor = UIColorFromRGB(0x333333);
    passwordT.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordT.delegate = self;
    self.passwordT = passwordT;
    [self addSubview:passwordT];
    [passwordT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordImageView.mas_right).offset(theWidth/375 *15.0);
        make.right.offset(-theWidth/375 * 45.0);
        make.centerY.equalTo(passwordImageView.mas_centerY).offset(theWidth/375*1);
        make.height.offset(theWidth/375 *35.0);
        
    }];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.acountT) {
        self.accountLine.backgroundColor = UIColorFromRGB(0x4e7dd3);
        self.passwordLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    } else {
        
        self.passwordLine.backgroundColor = UIColorFromRGB(0x4e7dd3);
        self.accountLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.acountT) {
        self.accountLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
        self.passwordLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    } else {
        self.passwordLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
        self.accountLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 0 && textField == self.acountT) {
        if (textField.text.length >= 11) {
            return NO;
        }
    }
    return YES;
}

@end
