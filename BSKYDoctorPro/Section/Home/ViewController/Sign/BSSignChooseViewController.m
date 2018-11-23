//
//  BSSignChooseViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/12/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSSignChooseViewController.h"
#import "BSSignViewController.h"
#import "BSSignSuccessViewController.h"
#import "BSSignCheckSignature.h"

@interface BSSignChooseViewController () {
    __block CGFloat _multiply;
}

@property (nonatomic, strong) UIView    *backView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIButton  *paperBtn;
@property (nonatomic, strong) UIButton  *electronicBtn;
@property (nonatomic ,copy) NSString *familySignUrlString;          // 家庭签约

@property (nonatomic, strong) BSSignCheckSignature *checkRequest;

@end

@implementation BSSignChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initView {
    _multiply = SCREEN_WIDTH/375.0;
    self.title = @"签约方式";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"请选择签约的方式";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLabel.font = [UIFont systemFontOfSize:_multiply*16.0];
    [self.backView addSubview:self.titleLabel];
    
    self.paperBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"paperSign"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"paperSign_down"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(signPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.tag = 890;
        [self.backView addSubview:btn];
        btn;
    });
    
    self.electronicBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"eletronicSign"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"eletronicSign_down"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(signPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.tag = 891;
        [self.backView addSubview:btn];
        btn;
    });
    
    [self addContraint];
}

- (void)addContraint {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(380*_multiply));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(10);
        make.top.right.equalTo(self.backView);
        make.height.equalTo(@(45*_multiply));
    }];
    
    [self.paperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(10);
        make.right.equalTo(self.backView.mas_right).offset(-10);
        make.top.equalTo(self.backView.mas_top).offset(45*_multiply);
        make.height.equalTo(@(150*_multiply));
    }];
    
    [self.electronicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(10);
        make.right.equalTo(self.backView.mas_right).offset(-10);
        make.top.equalTo(self.paperBtn.mas_bottom).offset(15);
        make.height.equalTo(@(150*_multiply));
    }];
}

- (void)signPressed:(UIButton *)sender {
    switch (sender.tag) {
        case 890:
        {
            BSSignViewController *signVC = [[BSSignViewController alloc] init];
            signVC.type = BSPaperSignType;
            [self.navigationController pushViewController:signVC animated:YES];
        }
            break;
        case 891:
        {
            
            if (self.checkRequest == nil) {
                self.checkRequest = [[BSSignCheckSignature alloc] init];
            }
            Bsky_WeakSelf
            [MBProgressHUD showHud];
            [self.checkRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignCheckSignature * _Nonnull request) {
                [MBProgressHUD hideHud];
                Bsky_StrongSelf
                BSSignViewController *signVC = [[BSSignViewController alloc] init];
                signVC.type = BSEletronicSignType;
                [self.navigationController pushViewController:signVC animated:YES];
            } failure:^(__kindof BSSignCheckSignature * _Nonnull request) {
                [MBProgressHUD hideHud];
                [UIView makeToast:request.msg];
            }];
        }
            break;
        default:
            break;
    }
}

@end
