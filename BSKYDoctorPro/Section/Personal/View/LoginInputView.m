//
//  LoginInputView.m
//  Login
//
//  Created by kykj on 2017/8/16.
//  Copyright © 2017年 kykj. All rights reserved.
//

#import "LoginInputView.h"
#import "PassWordLoginView.h"
#import "QuickLoginView.h"

#define theWidth   [UIScreen mainScreen].bounds.size.width
#define theHeight  [UIScreen mainScreen].bounds.size.height
#define scrollViewHeight  theWidth/375 *132.0

@interface LoginInputView ()

@property (nonatomic, copy) QuickLoginCallback quickLoginCallback;
@property (nonatomic, copy) PassWordLoginCallback passwordLoginCallback;


@end

@implementation LoginInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame])
    {
        self.loginType = LoginTypeQuick;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIScrollView *inputScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, theWidth, scrollViewHeight)];
    inputScrollView.scrollEnabled = YES;
    inputScrollView.bounces = NO;
    inputScrollView.showsVerticalScrollIndicator = NO;
    inputScrollView.showsHorizontalScrollIndicator = NO;
    inputScrollView.pagingEnabled = YES;
    inputScrollView.scrollEnabled = NO;
    inputScrollView.contentSize = CGSizeMake(theWidth * 2, scrollViewHeight);
    self.inputScrollView = inputScrollView;
    [self addSubview:inputScrollView];
    
    QuickLoginView *quickLoginView = [[QuickLoginView alloc] initWithFrame:CGRectMake(0, 0, theWidth, scrollViewHeight)];
    self.quickLoginView = quickLoginView;
    [inputScrollView addSubview:quickLoginView];

    PassWordLoginView *passwordLoginView = [[PassWordLoginView alloc] initWithFrame:CGRectMake(theWidth, 0, theWidth, scrollViewHeight)];
    self.passwordLoginView = passwordLoginView;
    [inputScrollView addSubview:passwordLoginView];

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#4e7dd3"]] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#273e69"]] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:theWidth/375 *18.0];
    loginBtn.layer.cornerRadius = theWidth/375 *5.0;
    loginBtn.layer.masksToBounds = YES;
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(theWidth/375 *45.0);
        make.right.offset(-theWidth/375 * 45.0);
        make.height.offset(theWidth/375 *45.0);
        make.top.mas_equalTo(inputScrollView.mas_bottom).offset(theWidth/375 * 40.0);
    
    }];
    
    
}

#pragma mark click
/**
 登录
 */
- (void)loginBtnClick {

    [self.quickLoginView.acountT resignFirstResponder];
    [self.quickLoginView.codeT resignFirstResponder];
    [self.passwordLoginView.acountT resignFirstResponder];
    [self.passwordLoginView.passwordT resignFirstResponder];
    if (self.loginType == LoginTypeQuick) {
        if (self.quickLoginView.codeT.text.length == 0) {
            [UIView makeToast:@"请输入验证码"];
            return;
        }
        [self endEditing:YES];
        _quickLoginCallback(self.quickLoginView.acountT.text, self.quickLoginView.codeT.text);
    } else {
        if (self.passwordLoginView.acountT.text.length == 0) {
            [UIView makeToast:@"请输入手机号码"];
        } else if (![self.passwordLoginView.acountT.text isPhoneNumber]) {
            [UIView makeToast:@"请输入正确手机号码"];
            return;
        } else if (self.passwordLoginView.passwordT.text.length == 0) {
            [UIView makeToast:@"请输入密码"];
            return;
        }
        [self endEditing:YES];
        _passwordLoginCallback(self.passwordLoginView.acountT.text, self.passwordLoginView.passwordT.text);
    }
   
}

- (void)qucikLogin:(QuickLoginCallback)callback {
    _quickLoginCallback = callback;
}

- (void)passwordLogin:(PassWordLoginCallback)callback {
    _passwordLoginCallback = callback;
}

@end
