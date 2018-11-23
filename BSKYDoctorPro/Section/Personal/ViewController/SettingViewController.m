//
//  SettingViewController.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/31.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "ResetPasswordVC.h"
#import "BSAboutViewController.h"
#import <WebKit/WKWebsiteDataStore.h>
#import "BSWebViewController.h"

@interface SettingViewController ()

@property (nonatomic ,copy) NSArray *dataArray;

@property (nonatomic ,strong) UIButton *logoutBtn;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.tableView registerNib:[SettingTableViewCell nib] forCellReuseIdentifier:[SettingTableViewCell cellIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArray = [NSArray arrayWithObjects:@"重置密码",@"联系我们",@"清除缓存",@"隐私政策",@"关于巴蜀快医", nil];
    [self.tableView addSubview:self.logoutBtn];
}
#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SettingTableViewCell cellIdentifier]];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    if (indexPath.row == self.dataArray.count-1) {
        [cell.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView);
        }];
    }
    else
    {
        [cell.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(15);
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SettingTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            ResetPasswordVC *vc = [[ResetPasswordVC alloc]init];
            vc.type = ResetPasswordTypeReset;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {

        }
            break;
        case 2:
        {
            [MBProgressHUD showHud];
            // 清理WK的缓存
            if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
                NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
                NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
                //// Execute
                [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                }];
            }
            else
            {
                NSString*libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES)objectAtIndex:0];
                NSString*cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
                NSError*errors;
                [[NSFileManager defaultManager]removeItemAtPath:cookiesFolderPath error:&errors];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHud];
                [UIView makeToast:@"清理成功"];
            });
        }
            break;
        case 4: {
            BSAboutViewController *vc = [[BSAboutViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {
            BSWebViewController *web = [[BSWebViewController alloc] init];
            web.showNavigationBar = YES;
            web.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
            web.ba_web_progressTrackTintColor = [UIColor whiteColor];
            NSString *url = @"https://apissl.jkscw.com.cn/bskyH5/PrivacyPolicy/PrivacyPolicy.html";
            [web ba_web_loadURLString:url];
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
            
        default:
        break;
    }
}
#pragma mark ----- logoutBtn

- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBtn.frame = CGRectMake(0, self.tableView.height-45-10-TOP_BAR_HEIGHT, self.tableView.width, 45);
        _logoutBtn.backgroundColor = [UIColor whiteColor];
         [_logoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:_logoutBtn.bounds.size] forState:UIControlStateNormal];
        [_logoutBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xededed) size:_logoutBtn.bounds.size] forState:UIControlStateHighlighted];
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:UIColorFromRGB(0xff2a2a) forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _logoutBtn.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
        _logoutBtn.layer.borderWidth = 0.5;
        [_logoutBtn addTarget:self action:@selector(logoutBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}
- (void)logoutBtnPressed {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定退出登录?" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];;
    [actionSheet setCompletionBlock:^(UIActionSheet* actionSheet, NSInteger index){
        if (index == 0) {
            [MBProgressHUD showHud];
            BSLogoutRequest* request = [BSLogoutRequest new];
            Bsky_WeakSelf
            [request startWithCompletionBlockWithSuccess:^(BSLogoutRequest* request) {
                Bsky_StrongSelf
                if ([[[NIMSDK sharedSDK] loginManager] isLogined]) {
                    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"IM退出错误%@", error);
                        }else {
                            NSLog(@"IM退出成功");
                        }
                    }];
                }
                [self.navigationController popViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
                [MBProgressHUD hideHud];
            } failure:^(BSLogoutRequest* request) {
                [MBProgressHUD hideHud];
                [UIView makeToast:request.msg];
            }];
        }
    }];
    
    [actionSheet showInView:self.view];
}

@end
