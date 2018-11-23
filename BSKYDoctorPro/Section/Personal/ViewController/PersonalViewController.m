//
//  PersonalViewController.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/21.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "PersonalViewController.h"
#import "SettingViewController.h"
#import "BSGongWeiViewController.h"
#import "PersonListTableView.h"
#import "ZLAccountVerifyRequest.h"
#import "ZLAccountBindingVC.h"
#import "MyIncomeViewController.h"

@interface PersonalViewController () <PersonListTableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UIButton *QRButton;

@property (nonatomic, retain) BSUser *user;
@property (nonatomic, strong) PersonListTableView *tableView;

@end

@implementation PersonalViewController
+ (instancetype)viewControllerFromStoryboard {
    
    return [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[PersonListTableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.myDelegate = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(self.view.width);
        make.top.mas_equalTo(160);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
    }];
    
    self.topConstraint.constant = - STATUS_BAR_HEIGHT;
    self.tableView.isAudit = [BSAppManager sharedInstance].isAudit;
    if ([BSAppManager sharedInstance].isAudit == YES) {
        self.QRButton.hidden = YES;
    } else {
        self.QRButton.hidden = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(auditChanged) name:AuditChangeNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.user = [BSAppManager sharedInstance].currentUser;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - UI Actions
//公卫
- (void)onGongWei {
    [self pushBindingVC];
}
//设置
- (void)settingBtnPressed {
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
//收入
- (void)myInComePressed {
    MyIncomeViewController *income_vc = [[MyIncomeViewController alloc] init];
    [self.navigationController pushViewController:income_vc animated:YES];
}
//订单
- (void)myOrderPressed {
    [UIView makeToast:@"该功能暂未开放"];
}
//处方
- (void)presgriptionPressed {
    [UIView makeToast:@"该功能暂未开放"];
}

#pragma mark -

- (void)setUser:(BSUser *)user {
    _user = user;
    self.nameLabel.text = user.realName;
    self.hospitalLabel.text = user.organizationName;
}

#pragma mark - audit

- (void)auditChanged {
    self.tableView.isAudit = [BSAppManager sharedInstance].isAudit;
    if ([BSAppManager sharedInstance].isAudit == YES) {
        self.QRButton.hidden = YES;
    } else {
        self.QRButton.hidden = NO;
    }
}

- (void)didSelectedIndex:(NSInteger)index {
    if ([BSAppManager sharedInstance].isAudit == YES) {
        switch (index) {
            case 0:
                [self onGongWei];
                break;
            case 1:
                [self settingBtnPressed];
                break;
            default:
                break;
        }
    } else {
        switch (index) {
            case 0:
                [self myInComePressed];
                break;
            case 1:
                [self myOrderPressed];
                break;
            case 2:
                [self presgriptionPressed];
                break;
            case 3:
                [self onGongWei];
                break;
            case 4:
                [self settingBtnPressed];
                break;
            default:
                break;
        }
    }
}

- (void)pushBindingVC {
    
    NSInteger sysType = [BSAppManager sharedInstance].currentUser.sysType.integerValue;
    
    if (sysType == InterfaceServerTypeScwjw) {
        BSVerifyStatusRequest *statusRequest = [[BSVerifyStatusRequest alloc]init];
        [MBProgressHUD showHud];
        Bsky_WeakSelf;
        [statusRequest startWithCompletionBlockWithSuccess:^(__kindof BSVerifyStatusRequest * _Nonnull request) {
            Bsky_StrongSelf;
            if (request.verifyStatus == PhisVerifyStatusSuccess) {
                BSDoctorPhisRequest* request = [BSDoctorPhisRequest new];
                [request startWithCompletionBlockWithSuccess:^(BSDoctorPhisRequest* request) {
                    [MBProgressHUD hideHud];
                    BSGongWeiViewController *vc = [[BSGongWeiViewController alloc]init];
                    vc.verifyStatus = PhisVerifyStatusSuccess;
                    [self.navigationController pushViewController:vc animated:YES];
                } failure:^(BSDoctorPhisRequest* request) {
                    [MBProgressHUD hideHud];
                    BSGongWeiViewController *vc = [[BSGongWeiViewController alloc]init];
                    vc.verifyStatus = PhisVerifyStatusFailure;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
            else if (request.verifyStatus == PhisVerifyStatusNonactivated || request.verifyStatus == PhisVerifyStatusProcessing)
            {
                [MBProgressHUD hideHud];
                [UIView makeToast:request.verifyMessage];
            }
            else
            {
                [MBProgressHUD hideHud];
                [UIView makeToast:request.verifyMessage];
                BSGongWeiViewController *vc = [[BSGongWeiViewController alloc]init];
                vc.verifyStatus = request.verifyStatus;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(__kindof BSVerifyStatusRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }
    else if (sysType == InterfaceServerTypeSczl)
    {
        ZLAccountVerifyRequest * request = [[ZLAccountVerifyRequest alloc]init];
        [MBProgressHUD showHud];
        Bsky_WeakSelf
        [request startWithCompletionBlockWithSuccess:^(__kindof ZLAccountVerifyRequest * _Nonnull request) {
            Bsky_StrongSelf
            [MBProgressHUD hideHud];
            ZLAccountBindingVC *vc = [[ZLAccountBindingVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(__kindof ZLAccountVerifyRequest * _Nonnull request) {
            Bsky_StrongSelf
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
            ZLAccountBindingVC *vc = [[ZLAccountBindingVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

@end
