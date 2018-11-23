//
//  ResetPasswordVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "ResetPasswordVC.h"
#import "LoginTextField.h"
#import "ResetPasswordRequest.h"
#import "CmsCodeAndCheckRequest.h"

@interface ResetPasswordVC ()<UITextFieldDelegate>
{
    int _timerNum;
}

@property (weak, nonatomic) IBOutlet LoginTextField *telTextField;

@property (weak, nonatomic) IBOutlet LoginTextField *yanTextField;

@property (weak, nonatomic) IBOutlet LoginTextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *defineBtn;

@property (nonatomic ,strong) UIButton *yanBtn;

@property (nonatomic ,strong) UIButton *displayBtn;

@property (nonatomic ,strong) ResetPasswordRequest *request;

@property (nonatomic ,strong) CmsCodeAndCheckRequest *cmsCodeRequest;

@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation ResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.request = [[ResetPasswordRequest alloc]init];
    self.cmsCodeRequest = [[CmsCodeAndCheckRequest alloc]init];
}
- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"获取验证码测试释放");
}

- (void)initView {
    
    switch (self.type) {
        case ResetPasswordTypeForget:
            self.title = @"忘记密码";
            break;
        default:
            self.title = @"重置密码";
            self.telTextField.text = [BSClientManager sharedInstance].lastUsername;
            break;
    }
    self.telTextField.maxNum = 11;
    self.yanTextField.maxNum = 6;
    self.passwordTF.maxNum = 20;
    
    self.yanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.yanBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.yanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.yanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.yanBtn addTarget:self action:@selector(yanBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.yanBtn sizeToFit];
    self.yanBtn.frame = CGRectMake(0, 0, self.yanBtn.width+10, 30);
    [self.yanBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x0eb2ff) size:self.yanBtn.bounds.size] forState:UIControlStateNormal];
    [self.yanBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xcccccc) size:self.yanBtn.bounds.size] forState:UIControlStateDisabled];
    [self.yanBtn setCornerRadius:5];
    self.yanTextField.rightView = self.yanBtn;
    self.yanTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.displayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.displayBtn setImage:[UIImage imageNamed:@"密码-不可见"] forState:UIControlStateNormal];
    [self.displayBtn setImage:[UIImage imageNamed:@"密码-可见"] forState:UIControlStateSelected];
    [self.displayBtn sizeToFit];
    [self.displayBtn addTarget:self action:@selector(displayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.displayBtn.frame = CGRectMake(0, 0, self.displayBtn.width, self.displayBtn.height);
    self.passwordTF.rightView = self.displayBtn;
    self.passwordTF.rightViewMode = UITextFieldViewModeAlways;
    
    [self.defineBtn setCornerRadius:5];
    [self.defineBtn addTarget:self action:@selector(defineBtnPressed) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -----  click

- (void)yanBtnPressed:(UIButton *)sender {
    if (![self.telTextField.text isPhoneNumber]) {
        [UIView makeToast:@"手机号格式不正确"];
        return;
    }
    [self startTimer];
    self.cmsCodeRequest.phone = self.telTextField.text;
    self.cmsCodeRequest.type = @2;
    
    Bsky_WeakSelf
    [MBProgressHUD showHud];
    [self.cmsCodeRequest startWithCompletionBlockWithSuccess:^(__kindof CmsCodeAndCheckRequest * _Nonnull request) {
        Bsky_StrongSelf
        [MBProgressHUD hideHud];
        if (!request.isValid) {
            [UIView makeToast:request.msg];
            [self cancelTimer];
        }
    } failure:^(__kindof CmsCodeAndCheckRequest * _Nonnull request) {
        Bsky_StrongSelf
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
        [self cancelTimer];
    }];
}

- (void)displayBtnPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTF.secureTextEntry = !sender.selected;
}

- (void)defineBtnPressed {
    if (![self.telTextField.text isPhoneNumber]) {
        [UIView makeToast:@"手机号格式不正确"];
        return;
    }
    if (self.yanTextField.text.length < 6) {
        [UIView makeToast:@"请输入正确验证码"];
        return;
    }
    
    if (![self.passwordTF.text isMatchesRegularExp:@"^[0-9A-Za-z]{6,20}$"]) {
        [UIView makeToast:@"密码格式不正确"];
        return;
    }
    [self.telTextField resignFirstResponder];
    [self.yanTextField resignFirstResponder];
    [self.passwordTF resignFirstResponder];
 
    self.request.phone = self.telTextField.text;
    self.request.cmsCode = self.yanTextField.text;
    self.request.password = self.passwordTF.text;
    [MBProgressHUD showHud];
    @weakify(self);
    [self.request startWithCompletionBlockWithSuccess:^(__kindof BSBaseRequest * _Nonnull request) {
         [MBProgressHUD hideHud];
        @strongify(self);
        switch (self.type) {
            case ResetPasswordTypeForget:
            {
                [UIView makeToast:@"设置密码成功"];
                [self.navigationController popViewControllerAnimated:NO];
            }
                break;
            default:
            {
                [UIView makeToast:@"重置密码成功"];
                [self.navigationController popToRootViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
            }
                break;
        }
    } failure:^(__kindof BSBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}

#pragma mark  ----- timer

///启动定时器
-(void)startTimer
{
    self.yanBtn.enabled = NO;
    _timerNum = 60;
    NSString * strTitle = [NSString stringWithFormat:@"%.d秒后重发", _timerNum];
    [self.yanBtn setTitle:strTitle forState:UIControlStateDisabled];
   self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(funcTimer:) userInfo:nil repeats:YES];
}
// 取消定时器
- (void)cancelTimer
{
    self.yanBtn.enabled = YES;
    _timerNum = 60;
    [self.timer invalidate];
    self.timer = nil;
}

-(void)funcTimer:(NSTimer *)timer
{
    _timerNum--;
    NSString * strTitle = [NSString stringWithFormat:@"%.d秒后重发", _timerNum];
    [self.yanBtn setTitle:strTitle forState:UIControlStateDisabled];
    if(_timerNum == 0)
    {
        [timer invalidate];
        self.yanBtn.enabled = YES;
    }
}

@end
