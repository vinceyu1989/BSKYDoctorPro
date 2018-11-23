//
//  LoginViewController.m
//  Login
//
//  Created by kykj on 2017/8/15.
//  Copyright © 2017年 kykj. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTypeView.h"
#import "LoginInputView.h"
#import "QuickLoginView.h"
#import "PassWordLoginView.h"
#import "RegistViewController.h"

#import "CmsCodeAndCheckRequest.h"
#import "BSCmsCodeLoginRequest.h"
#import "BSAuthLicenseRequest.h"
#import "BSUserLoginRequest.h"
#import "ResetPasswordVC.h"

#define theWidth   [UIScreen mainScreen].bounds.size.width
#define theHeight  [UIScreen mainScreen].bounds.size.height
#define topImageHeight  theWidth/375 *231.5
#define loginTypeHeight  theWidth/375 *37.0
#define scrollViewHeight  theWidth/375 *132.0
#define loginInputViewHeight  theWidth/375 *217.0

@interface LoginViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) LoginInputView *loginInputView;
@property (nonatomic, strong) LoginTypeView *typeView;
@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UIButton *registBtn;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, theWidth, topImageHeight)];
    imageView.image = [UIImage imageNamed:@"login_top"];
    [self.view addSubview:imageView];
    
    self.typeView = [[LoginTypeView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(imageView.bounds) + theWidth/375 *30.0, theWidth, loginTypeHeight)];
    
    WS(weakSelf);
    [self.typeView loginTypeSelectedCallback:^(NSInteger idx) {
        [weakSelf.view resignFirstResponder];
        [weakSelf.loginInputView.inputScrollView setContentOffset:CGPointMake(theWidth*idx, 0)];
        weakSelf.loginInputView.loginType = idx;
        weakSelf.forgetBtn.hidden = idx == LoginTypePassWord ? NO :YES;
    }];
    [self.view addSubview:self.typeView];
    
    LoginInputView *loginInputView = [[LoginInputView alloc] initWithFrame:CGRectMake(0, topImageHeight + (theWidth/375 *30.0) + loginTypeHeight, theWidth, loginInputViewHeight)];
    loginInputView.inputScrollView.delegate = self;
    self.loginInputView = loginInputView;
    [self.view addSubview:loginInputView];
    
    //获取验证码
    Bsky_WeakSelf
    [loginInputView.quickLoginView getCodeCallback:^(NSString *phoneNum) {
        [MBProgressHUD showHud];
        CmsCodeAndCheckRequest *request = [[CmsCodeAndCheckRequest alloc]init];
        request.phone = phoneNum;
        request.type = @2;
        [request startWithCompletionBlockWithSuccess:^(CmsCodeAndCheckRequest* request) {
            Bsky_StrongSelf
            [MBProgressHUD hideHud];
            if (!request.isValid) {
                [UIView makeToast:request.msg];
                [self.loginInputView.quickLoginView cancelTimer];
            }
        } failure:^(CmsCodeAndCheckRequest* request) {
            Bsky_StrongSelf
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
            [self.loginInputView.quickLoginView cancelTimer];
        }];
    }];
    
    //快速登录
    [loginInputView qucikLogin:^(NSString *phoneNum, NSString *codeStr) {
        [MBProgressHUD showHud];

        BSCmsCodeLoginRequest* request = [BSCmsCodeLoginRequest new];
        request.phone = phoneNum;
        request.cmsCode = codeStr;
        [request startWithCompletionBlockWithSuccess:^(BSCmsCodeLoginRequest* request) {
            [weakSelf requestAuthLicense];
        } failure:^(BSCmsCodeLoginRequest* request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }];
    
    //密码登录
    [loginInputView passwordLogin:^(NSString *phoneNum, NSString *passwordStr) {
        [MBProgressHUD showHud];

        BSUserLoginRequest* request = [BSUserLoginRequest new];
        request.phone = phoneNum;
        request.password = passwordStr;
        [request startWithCompletionBlockWithSuccess:^(BSUserLoginRequest* request) {
            [weakSelf requestAuthLicense];
        } failure:^(BSUserLoginRequest* request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }];
    
    NSString *lstr = @"登录即表示您同意";
    NSString *btnstr = @"《巴蜀快医使用条款》";
    CGFloat padding = [self returnPaddingWithFirstParty:lstr SecondParty:btnstr FirstFont:theWidth/375 *11.0 SecondFont:theWidth/375 *11.0];
    UILabel *agreeL = [[UILabel alloc] init];
    agreeL.text = lstr;
    agreeL.textColor = [UIColor colorWithHexString:@"#999999"];
    agreeL.font = [UIFont systemFontOfSize:theWidth/375 *11.0];
    [self.view addSubview:agreeL];
    [agreeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginInputView.mas_bottom).offset(theWidth/375 *20.0);
        make.height.mas_offset(theWidth/375 *11.0);
        make.left.mas_offset(padding);
    }];
    
    UIButton *clauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clauseBtn addTarget:self action:@selector(clauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [clauseBtn setTitle:btnstr forState:UIControlStateNormal];
    clauseBtn.titleLabel.font = [UIFont systemFontOfSize:theWidth/375 *11.0];
    [clauseBtn setTitleColor:[UIColor colorWithHexString:@"#0eb2ff"] forState:UIControlStateNormal];
    [self.view addSubview:clauseBtn];
    [clauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginInputView.mas_bottom).offset(theWidth/375 *20.0);
        make.height.mas_offset(theWidth/375 *11.0);
        make.right.mas_offset(-padding);
    }];
    
    self.forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:UIColorFromRGB(0xbcbcbc) forState:UIControlStateHighlighted];
    self.forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.forgetBtn addTarget:self action:@selector(forgetBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.forgetBtn.hidden = YES;
    [self.view addSubview:self.forgetBtn];
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20-SafeAreaBottomHeight);
        make.left.equalTo(self.view.mas_left).offset(45);
    }];
    
    self.registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registBtn setTitle:@"立即注册>>" forState:UIControlStateNormal];
    [self.registBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.registBtn setTitleColor:UIColorFromRGB(0xbcbcbc) forState:UIControlStateHighlighted];
    self.registBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.registBtn addTarget:self action:@selector(registBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registBtn];
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20-SafeAreaBottomHeight);
        make.right.equalTo(self.view.mas_right).offset(-45);
    }];
}

#pragma mark - click
//*<协议点击 >/
- (void)clauseBtnClick {
    BSWebViewController *webVC = [[BSWebViewController alloc]init];
    webVC.showNavigationBar = YES;
    webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
    webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
    [webVC ba_web_loadHTMLFileName:@"agreement"];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)forgetBtnPressed {
    ResetPasswordVC *vc = [[ResetPasswordVC alloc]init];
    vc.type = ResetPasswordTypeForget;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registBtnPressed {
    RegistViewController *registVC = [[RegistViewController alloc] init];
    Bsky_WeakSelf
    [registVC setBlock:^(RegistViewController *vc, NSString *phone, NSString *pw) {
        Bsky_StrongSelf
        [self.loginInputView.inputScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
        self.loginInputView.passwordLoginView.acountT.text = phone;
        self.loginInputView.passwordLoginView.passwordT.text = pw;
        self.loginInputView.loginType = LoginTypePassWord;
        [self.typeView setButtonLoginType:ButtonLoginPWType];
        self.forgetBtn.hidden = NO;
        [self.loginInputView loginBtnClick];
    }];
    [self.navigationController pushViewController:registVC animated:YES];
}

#pragma mark - PrivateMethod
- (void)requestAuthLicense {
    WS(weakSelf);
    BSVerifyStatusRequest* request = [BSVerifyStatusRequest new];
    [request startWithCompletionBlockWithSuccess:^(__kindof BSVerifyStatusRequest * _Nonnull request) {
        if (request.verifyStatus == 3) {
            BSDoctorPhisRequest* request = [BSDoctorPhisRequest new];
            [request startWithCompletionBlockWithSuccess:^(BSDoctorPhisRequest* request) {
            } failure:^(BSDoctorPhisRequest* request) {
            }];
        }else {
        }
        [MBProgressHUD hideHud];
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginChangeNotification object:nil];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } failure:^(__kindof BSVerifyStatusRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
//    BSAuthLicenseRequest* q = [BSAuthLicenseRequest new];
//    [q startWithCompletionBlockWithSuccess:^(BSAuthLicenseRequest* request) {
//        [MBProgressHUD hideHud];
//        [[NSNotificationCenter defaultCenter] postNotificationName:LoginChangeNotification object:nil];
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//    } failure:^(BSAuthLicenseRequest* request) {
//        [MBProgressHUD hideHud];
//        [UIView makeToast:request.msg];
//    }];
}
//*<居中显示  距离边界间距 >/
- (CGFloat)returnPaddingWithFirstParty:(NSString *)party1 SecondParty:(NSString *)party2 FirstFont:(CGFloat)font1 SecondFont:(CGFloat)font2 {
    CGFloat labelwidth = [party1 boundingRectWithSize:CGSizeMake(MAXFLOAT, font1)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font1]}
                                              context:nil].size.width;
    CGFloat btnwidth = [party2 boundingRectWithSize:CGSizeMake(MAXFLOAT,font2)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font2]}
                                            context:nil].size.width;
    CGFloat padding = (theWidth - labelwidth - btnwidth) * 0.5;
    return padding;
}

@end
