//
//  ToolViewController.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "ToolViewController.h"
#import "BSH5UrlRequest.h"
#import "HomeGridItemButton.h"

@interface ToolViewController ()

@property (weak, nonatomic) IBOutlet UIButton *zhiquBtn;
@property (weak, nonatomic) IBOutlet UIButton *trainBtn;

@property (weak, nonatomic) IBOutlet HomeGridItemButton *groupBtn;
@property (weak, nonatomic) IBOutlet HomeGridItemButton *knowledgeBtn;

@property (nonatomic, copy) NSString *zhiquUrlString;

@end

@implementation ToolViewController

+ (instancetype)viewControllerFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Tool" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"工具";
    [self.zhiquBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xededed) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [self.trainBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xededed) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:LogoutNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataWithBlock:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)logout {
    self.zhiquUrlString = nil;
}

#pragma mark -

- (void)loadDataWithBlock:(void (^)(NSString* urlString))block {
    BSUser* user = [BSAppManager sharedInstance].currentUser;
    if (!user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
        return;
    }
    
    WS(weakSelf);
    BSH5UrlRequest* request = [BSH5UrlRequest new];
    request.type = @"zhiqu";
    [request startWithCompletionBlockWithSuccess:^(BSH5UrlRequest* request) {
        weakSelf.zhiquUrlString = request.urlString;
        if (block) {
            block(weakSelf.zhiquUrlString);
        }
    } failure:^(BSH5UrlRequest* request) {
        if (block) {
            block(nil);
        }
    }];
}

#pragma mark - UI Actions

- (IBAction)onZhiQu:(id)sender {
    
    if (!self.zhiquUrlString) {
        [self loadDataWithBlock:^(NSString *urlString) {
            if (urlString && urlString.length > 1) {
                BSWebViewController *webVC = [[BSWebViewController alloc]init];
                webVC.showNavigationBar = YES;
                webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
                webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
                [webVC ba_web_loadURLString:urlString];
                [self.navigationController pushViewController:webVC animated:YES];
            }
            else
            {
                [UIView makeToast:@"获取地址失败"];
            }
        }];
    }else {
        BSWebViewController *webVC = [[BSWebViewController alloc]init];
        webVC.showNavigationBar = YES;
        webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
        webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
        [webVC ba_web_loadURLString:self.zhiquUrlString];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (IBAction)onZhuangangpeixun:(id)sender {
    if ([BSAppManager sharedInstance].isAudit == YES) {
        // 暂定
        [self loadDataWithBlock:^(NSString *urlString) {
            BSWebViewController *webVC = [[BSWebViewController alloc]init];
            webVC.showNavigationBar = YES;
            webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
            webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
            [webVC ba_web_loadURLString:urlString];
            [self.navigationController pushViewController:webVC animated:YES];
        }];
        return;
    }
    [UIView makeToast:@"该功能暂未开放"];
}

- (IBAction)onYihuanquan:(id)sender {
    if ([BSAppManager sharedInstance].isAudit == YES) {
        // 暂定
        [self loadDataWithBlock:^(NSString *urlString) {
            BSWebViewController *webVC = [[BSWebViewController alloc]init];
            webVC.showNavigationBar = YES;
            webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
            webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
            [webVC ba_web_loadURLString:urlString];
            [self.navigationController pushViewController:webVC animated:YES];
        }];
        return;
    }
    [UIView makeToast:@"该功能暂未开放"];
}

- (IBAction)onZhishiku:(id)sender {
    if ([BSAppManager sharedInstance].isAudit == YES) {
        // 暂定
        [self loadDataWithBlock:^(NSString *urlString) {
            BSWebViewController *webVC = [[BSWebViewController alloc]init];
            webVC.showNavigationBar = YES;
            webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
            webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
            [webVC ba_web_loadURLString:urlString];
            [self.navigationController pushViewController:webVC animated:YES];
        }];
        return;
    }
    [UIView makeToast:@"该功能暂未开放"];
}

@end
