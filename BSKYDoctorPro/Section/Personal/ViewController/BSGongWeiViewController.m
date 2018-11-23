//
//  BSGongWeiViewController.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSGongWeiViewController.h"
#import "LoginTextField.h"
#import "GWBindingRequest.h"
#import "GWResetPWRequest.h"
#import "GWAginBindingRequest.h"

@interface BSGongWeiViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *belongLabel;
@property (weak, nonatomic) IBOutlet LoginTextField *accountField;
@property (weak, nonatomic) IBOutlet LoginTextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation BSGongWeiViewController

+ (instancetype)viewControllerFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}
- (instancetype)init {
    self = [BSGongWeiViewController viewControllerFromStoryboard];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公卫审核";
    [self setupView];
}

#pragma mark - initView
- (void)setupView {
    if ([BSAppManager sharedInstance].currentUser.phisInfo) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",[BSAppManager sharedInstance].currentUser.phisInfo.UserName,[BSAppManager sharedInstance].currentUser.phisInfo.account];
        self.belongLabel.text = [BSAppManager sharedInstance].currentUser.phisInfo.OrgName;
        if (self.verifyStatus == PhisVerifyStatusPwError) {
            self.accountField.text = [BSAppManager sharedInstance].currentUser.phisInfo.account;
            self.accountField.enabled = NO;
            [self.commitButton setTitle:@"匹配密码" forState:UIControlStateNormal];
        }
        else
        {
            [self.commitButton setTitle:@"提交审核" forState:UIControlStateNormal];
        }
    }
    else
    {
        self.captionLabel.hidden = YES;
        self.detailView.hidden = YES;
        self.topConstraint.constant = 50;
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gwDoctorico"]];
    imageView.frame = CGRectMake(0, 0, 30, 30);
    imageView.contentMode = UIViewContentModeCenter;
    self.accountField.leftView = imageView;
    
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gwico"]];
    imageView2.frame = CGRectMake(0, 0, 30, 30);
    imageView2.contentMode = UIViewContentModeCenter;
    self.passwordField.leftView = imageView2;
    
    self.commitButton.layer.cornerRadius = 5;
}

#pragma mark - UI Actions

- (IBAction)onCommit:(id)sender {
    if (self.accountField.text.length < 1 || self.passwordField.text.length < 1) {
        [UIView makeToast:@"请完善信息"];
        return;
    }
    if (self.verifyStatus == PhisVerifyStatusPwError) {
        
        GWResetPWRequest *request = [[GWResetPWRequest alloc]init];
        request.password = self.passwordField.text;
        [MBProgressHUD showHud];
        [request startWithCompletionBlockWithSuccess:^(__kindof BSBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:@"重置密码成功"];
        } failure:^(__kindof BSBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }
    else if(self.verifyStatus == PhisVerifyStatusUnregistered)
    {
        GWBindingRequest *request = [[GWBindingRequest alloc]init];
        GWBindingModel *model = [[GWBindingModel alloc]init];
        model.account = self.accountField.text;
        model.password = self.passwordField.text;
        model.extInfo = @"";
        model.regionCode = [BSAppManager sharedInstance].currentUser.divisionCode;
        
        request.registryInVM = [model mj_JSONString];
        request.registryInVM = [request.registryInVM stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [MBProgressHUD showHud];
        Bsky_WeakSelf
        [request startWithCompletionBlockWithSuccess:^(__kindof BSBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            Bsky_StrongSelf
            [UIView makeToast:@"绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(__kindof BSBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }
    else
    {
        GWAginBindingRequest *request = [[GWAginBindingRequest alloc]init];
        GWBindingModel *model = [[GWBindingModel alloc]init];
        model.account = self.accountField.text;
        model.password = self.passwordField.text;
        model.extInfo = [NSString stringWithFormat:@"%ld",arc4random() % 10000000000];
        model.regionCode = [BSAppManager sharedInstance].currentUser.divisionCode;

        request.registryInVM = [model mj_JSONString];
        request.registryInVM = [request.registryInVM stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [MBProgressHUD showHud];
        Bsky_WeakSelf
        [request startWithCompletionBlockWithSuccess:^(__kindof BSBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            Bsky_StrongSelf
            [UIView makeToast:@"绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(__kindof BSBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }
    
}

@end

