//
//  BSAboutViewController.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/12.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSAboutViewController.h"

@interface BSAboutViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation BSAboutViewController

+ (instancetype)viewControllerFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}
- (instancetype)init
{
    self = [BSAboutViewController viewControllerFromStoryboard];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];    
    [self setupView];
}

#pragma mark - 

- (void)setupView {
    self.title = @"关于";
    self.logoImageView.layer.cornerRadius = 9;
    self.logoImageView.layer.masksToBounds = YES;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"版本号：v%@",currentAppVersion];
}

@end
