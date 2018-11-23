//
//  ZLAccountBindingVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLAccountBindingVC.h"
#import "LoginTextField.h"
#import "ZLAccountRegistryRequest.h"

@interface ZLAccountBindingVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *belongLabel;
@property (weak, nonatomic) IBOutlet LoginTextField *accountTF;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation ZLAccountBindingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}
- (void)setupView {
    self.title = @"中联账号";
    if ([BSAppManager sharedInstance].currentUser.zlAccountInfo) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",[BSAppManager sharedInstance].currentUser.zlAccountInfo.employeeName,[BSAppManager sharedInstance].currentUser.zlAccountInfo.account];
        self.belongLabel.text = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
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
    self.accountTF.leftView = imageView;
    
    self.commitButton.layer.cornerRadius = 5;
}
- (IBAction)commitBtnPressed:(UIButton *)sender {
    
    if (self.accountTF.text.length < 1) {
        [UIView makeToast:@"请输入中联账号"];
        return;
    }
    ZLAccountRegistryRequest *request = [[ZLAccountRegistryRequest alloc]init];
    request.account = self.accountTF.text;
    [MBProgressHUD showHud];
    [request startWithCompletionBlockWithSuccess:^(__kindof BSBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:@"绑定成功"];
    } failure:^(__kindof BSBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
    
}


@end
