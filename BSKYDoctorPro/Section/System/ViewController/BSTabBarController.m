//
//  BSTabBarController.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/15.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSTabBarController.h"
#import "BSNavigationViewController.h"
#import "HomeViewController.h"
#import "BSMessageViewController.h"
#import "ToolViewController.h"
#import "PersonalViewController.h"
#import "LoginViewController.h"
#import "BSAppUpdateView.h"
#import "BSNeedEncryption.h"
#import "BSAuthPublicKeyRequest.h"
#import "BSGuideView.h"
#import "BSVerifyStatusRequest.h"

@interface BSTabBarController () <UITabBarControllerDelegate>


@end

@implementation BSTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.translucent = NO;

    [self setup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLogin:) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:LogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAudit) name:LoginChangeNotification object:nil];
    // 首次启动
    if(![[NSUserDefaults standardUserDefaults] objectForKey:kFirstLaunch]){
//    if(1){
        [self guideViewAppear];
    }else{
        [self configCBCBSNeedEncryption];
    }
 
    
}
- (void)guideViewAppear{
    BSGuideView *view = [[BSGuideView alloc] init];
    Bsky_WeakSelf;
    view.block = ^{
        Bsky_StrongSelf;
        [self configCBCBSNeedEncryption];
    };
    [self.view addSubview:view];
    [[NSUserDefaults standardUserDefaults] setObject:@"first" forKey:kFirstLaunch];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup
{
    BSNavigationViewController *nav1 = [[BSNavigationViewController alloc] initWithRootViewController:[HomeViewController viewControllerFromStoryboard]];
    [self builderTabBarWithTitle:@"工作台" selectImg:@"tab1_selected" normalImg:@"tab1_unselected" vc:nav1];
    
    BSNavigationViewController *nav2 = [[BSNavigationViewController alloc] initWithRootViewController:[[BSMessageViewController alloc]init]];
    [self builderTabBarWithTitle:@"用户" selectImg:@"tab2_selected" normalImg:@"tab2_unselected" vc:nav2];

    BSNavigationViewController *nav3 = [[BSNavigationViewController alloc] initWithRootViewController:[ToolViewController viewControllerFromStoryboard]];
    [self builderTabBarWithTitle:@"工具" selectImg:@"tab3_selected" normalImg:@"tab3_unselected" vc:nav3];

    BSNavigationViewController *nav4 = [[BSNavigationViewController alloc] initWithRootViewController:[PersonalViewController viewControllerFromStoryboard]];
    [self builderTabBarWithTitle:@"我的" selectImg:@"tab4_selected" normalImg:@"tab4_unselected" vc:nav4];
    
    self.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3, nav4,nil];//nav4

}
-(void)builderTabBarWithTitle:(NSString *)title selectImg:(NSString *) selectImg normalImg:(NSString *) normalImg vc:(UINavigationController *)vc{
    NSDictionary *selectTitleDic = @{NSForegroundColorAttributeName:UIColorFromRGB(0x4e7dd3),NSFontAttributeName:[UIFont systemFontOfSize:11.f]};
    NSDictionary *mormalTitleDic = @{NSForegroundColorAttributeName:UIColorFromRGB(0x333333),NSFontAttributeName:[UIFont systemFontOfSize:11.f]};
    [vc.tabBarItem setTitle:title];
    vc.view.backgroundColor = [UIColor clearColor];
    [vc.tabBarItem setImageInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
    [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.f, 0.f)];
    [vc.tabBarItem setSelectedImage:[[UIImage imageNamed:selectImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [vc.tabBarItem setImage:[[UIImage imageNamed:normalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [vc.tabBarItem setTitleTextAttributes:selectTitleDic forState:UIControlStateSelected];
    [vc.tabBarItem setTitleTextAttributes:mormalTitleDic forState:UIControlStateNormal];
    
}
#pragma mark ----- 登录退出处理
- (void)loginEvent
{
    NSString* token = [BSClientManager sharedInstance].tokenId;
    if (!token) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
    }else {
        [self autoLogin];
    }
}
- (void)showLogin:(NSNotification*)notification {
    BOOL animated = NO;
    if (notification.object) {
        animated = YES;
    }
    BSNavigationViewController *nav = [[BSNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    [self presentViewController:nav animated:animated completion:nil];
}
- (void)logout {
    self.selectedIndex = 0;
    [BSClientManager sharedInstance].tokenId = @"";
    [BSAppManager sharedInstance].currentUser = nil;
    [[self getCurrentVC].navigationController popToRootViewControllerAnimated:NO];
    // 弹出登录页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:@"animated"];
    });
}


#pragma mark - 网络处理

- (void)autoLogin {
    BSCmsCodeLoginRequest* request = [BSCmsCodeLoginRequest new];
    request.phone = [BSClientManager sharedInstance].lastUsername;
    request.cmsCode = @"";
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(BSCmsCodeLoginRequest* request) {
//        BSAuthLicenseRequest* q = [BSAuthLicenseRequest new];
//        [q startWithCompletionBlockWithSuccess:^(BSAuthLicenseRequest* request) {
//        } failure:^(BSAuthLicenseRequest* request) {
//            [UIView makeToast:request.msg];
//        }];
        Bsky_StrongSelf;
        BSVerifyStatusRequest* q = [BSVerifyStatusRequest new];
        [q startWithCompletionBlockWithSuccess:^(__kindof BSVerifyStatusRequest * _Nonnull request) {
            if (request.verifyStatus == 3) {
                BSDoctorPhisRequest* request = [BSDoctorPhisRequest new];
                [request startWithCompletionBlockWithSuccess:^(BSDoctorPhisRequest* request) {
                } failure:^(BSDoctorPhisRequest* request) {
                }];
            }else {
            }
        } failure:^(__kindof BSVerifyStatusRequest * _Nonnull request) {
        }];
    } failure:^(BSCmsCodeLoginRequest* request) {
        [UIView makeToast:request.msg];
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
    }];
}
//是否开启加密
- (void)configCBCBSNeedEncryption{
    BSNeedEncryption *needRq = [[BSNeedEncryption alloc] init];
    Bsky_WeakSelf;
    [MBProgressHUD showHudInView:self.view];
    [needRq startWithCompletionBlockWithSuccess:^(__kindof BSNeedEncryption * _Nonnull request) {
        Bsky_StrongSelf;
        [self configRSAPublickKeyAndCBCKey];
    } failure:^(__kindof BSNeedEncryption * _Nonnull request) {
        Bsky_StrongSelf;
        [self configRSAPublickKeyAndCBCKey];
    }];
}
//初始化RSA密钥和CBC密钥
- (void)configRSAPublickKeyAndCBCKey{
    BSAuthPublicKeyRequest *q = [[BSAuthPublicKeyRequest alloc] init];
    Bsky_WeakSelf;
    [q startWithCompletionBlockWithSuccess:^(__kindof BSAuthPublicKeyRequest * _Nonnull q) {
        Bsky_StrongSelf;
        [self checkAppVersion];
    } failure:^(__kindof BSAuthPublicKeyRequest * _Nonnull q) {
        Bsky_StrongSelf;
        [self checkAppVersion];
    }];
}
- (void)checkAppVersion {
    Bsky_WeakSelf;
    BSAppVersionRequest* request = [BSAppVersionRequest new];
    [request startWithCompletionBlockWithSuccess:^(__kindof BSAppVersionRequest * _Nonnull request) {
        Bsky_StrongSelf;
        [MBProgressHUD hideHudInView:self.view];
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = infoDic[@"CFBundleShortVersionString"];
        NSInteger appVersionInteger = [appVersion getNumText].integerValue;
        NSInteger httpVersionNum = [request.versionModel.versionNum getNumText].integerValue;
        
        // 判断是否审核模式
        if (request.isAudit != [BSAppManager sharedInstance].isAudit) {
            [BSAppManager sharedInstance].isAudit = request.isAudit;
            [[NSNotificationCenter defaultCenter] postNotificationName:AuditChangeNotification object:nil];
        }
        // 判断是否需要升级
        if (request.versionModel.mandatoryUpdate.integerValue != 9 && appVersionInteger < httpVersionNum) {
            
            [BSAppUpdateView showInView:self.view animated:YES info:request.versionModel.versionDesc mandatoryUpdate:request.versionModel.mandatoryUpdate.integerValue];
        }
        else
        {
            [self checkPublicKeyAndCBCKey];
        }
    } failure:^(__kindof BSAppVersionRequest * _Nonnull request) {
        Bsky_StrongSelf;
        [MBProgressHUD hideHudInView:self.view];
        [self checkPublicKeyAndCBCKey];
    }];
}
- (void)checkPublicKeyAndCBCKey{
    if (![BSAppManager sharedInstance].publicKey.length || ![BSAppManager sharedInstance].cbcKey.length || ![BSAppManager sharedInstance].needEncryption.length) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        alter.title = @"错误！";
        alter.message = @"系统初始化失败，请检查网络并重试或者联系客服！";
        Bsky_WeakSelf;
        UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            Bsky_StrongSelf;
            [self configCBCBSNeedEncryption];
        }];
        [alter addAction:resetAction];
        [self presentViewController:alter animated:YES completion:nil];
        return;
    }
    [self loginEvent];
}
- (void)checkAudit {
    BSAppVersionRequest* request = [BSAppVersionRequest new];
    [request startWithCompletionBlockWithSuccess:^(__kindof BSAppVersionRequest * _Nonnull request) {
        if (request.isAudit != [BSAppManager sharedInstance].isAudit) {
            [BSAppManager sharedInstance].isAudit = request.isAudit;
            [[NSNotificationCenter defaultCenter] postNotificationName:AuditChangeNotification object:nil];
        }
    } failure:^(__kindof BSAppVersionRequest * _Nonnull request) {
        
    }];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
    result = nextResponder;
    else
    result = window.rootViewController;
    return result;
}

@end
