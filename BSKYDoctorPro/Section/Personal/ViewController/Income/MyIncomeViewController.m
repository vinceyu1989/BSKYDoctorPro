//
//  MyIncomeViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "MyIncomeViewController.h"
#import "IncomeDetailViewController.h"
#import "BSBankViewController.h"
#import "BSBankBalanceInfoRequest.h"

@interface MyIncomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel;

@property (nonatomic, strong) BSBankBalanceInfoRequest *balanceRequest;

@end

@implementation MyIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收入";
    self.balanceRequest = [[BSBankBalanceInfoRequest alloc] init];
    [self.balanceRequest startWithCompletionBlockWithSuccess:^(__kindof BSBankBalanceInfoRequest * _Nonnull request) {
        if (request.model) {
            self.balanceLabel.text = [NSString stringWithFormat:@"￥%.2f",[request.model.virtualBalance floatValue]];
            self.earningsLabel.text = [NSString stringWithFormat:@"￥%.2f",[request.model.tradeAmount floatValue]];
        }
    } failure:^(__kindof BSBankBalanceInfoRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
}

- (IBAction)respondToIncomeDetail:(id)sender {
    IncomeDetailViewController *detail_vc = [[IncomeDetailViewController alloc] init];
    [self.navigationController pushViewController:detail_vc animated:YES];
}

- (IBAction)respondToBank:(id)sender {
    BSBankViewController *bank_vc = [[BSBankViewController alloc] init];
    [self.navigationController pushViewController:bank_vc animated:YES];
}

@end
