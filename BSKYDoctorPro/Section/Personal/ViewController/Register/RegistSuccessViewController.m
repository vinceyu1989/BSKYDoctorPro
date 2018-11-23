//
//  RegistSuccessViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "RegistSuccessViewController.h"

@interface RegistSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@end

@implementation RegistSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册成功";
    
    self.homeButton.layer.borderColor = [UIColor colorWithHexString:@"#4e7dd3"].CGColor;
    self.homeButton.layer.borderWidth = 0.8;
    self.homeButton.layer.cornerRadius = 5;
    self.homeButton.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)responseToHome:(id)sender {
    
    if (self.blocks) {
        self.blocks(self);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
