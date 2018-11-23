//
//  BSNavigationViewController.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/15.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSNavigationViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface BSNavigationViewController ()

@end

@implementation BSNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count) { // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        // 自定义返回按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(0, 0, 44, 44);
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        if (kiOS9Later) {
            __weak typeof(viewController) weakVC = viewController;
            self.interactivePopGestureRecognizer.delegate = (id)weakVC;
        }
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    UIViewController* vc = [self topViewController];
    // 判断两种情况: push 和 present
    if ((self.presentedViewController || self.presentingViewController) && self.childViewControllers.count == 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)] && ![vc navigationShouldPopOnBackButton])
    {
        
    }else
    {
         [self popViewControllerAnimated:YES];
    }
    
}


@end
