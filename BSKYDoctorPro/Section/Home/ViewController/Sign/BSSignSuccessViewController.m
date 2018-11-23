//
//  BSSignSuccessViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/12/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSSignSuccessViewController.h"

@interface BSSignSuccessViewController () {
    CGFloat _multiply;
}

@property (nonatomic, strong) UIImageView *finishView;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UIButton *signContractBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *addAddressBtn;

@end

@implementation BSSignSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    _multiply = SCREEN_WIDTH/375.0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.finishView = [[UIImageView alloc] init];
    self.finishView.image = [UIImage imageNamed:@"complete_ico"];
    self.finishView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.finishView];
    
    self.label1 = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"恭喜您";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:_multiply*22.0];
        [self.view addSubview:label];
        label;
    });
    
    self.label2 = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"本次签约完成!";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:_multiply*15.0];
        [self.view addSubview:label];
        label;
    });
    
    self.signContractBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(signContractPressed) forControlEvents:UIControlEventTouchUpInside];
        [btn setAttributedTitle:[self setAttrbuteString:@"查看签约合同" IsNormal:YES] forState:UIControlStateNormal];
        [btn setAttributedTitle:[self setAttrbuteString:@"查看签约合同" IsNormal:NO]  forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:_multiply*14.0];
        [self.view addSubview:btn];
        btn;
    });

    self.backBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#4e7dd3"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#a6bee9"] forState:UIControlStateHighlighted];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#4e7dd3"].CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:_multiply*18.0];
        [self.view addSubview:btn];
        btn;
    });
    
    self.addAddressBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4e7dd3"]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#273e69"]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(addAdressPressed) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"添加ta到通讯录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:_multiply*18.0];
        [self.view addSubview:btn];
        btn;
    });
    
    [self addContraint];
}

- (void)addContraint {
    
    [self.finishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(125*_multiply);
    }];
    
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.finishView.mas_bottom).offset(15*_multiply);
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.label1.mas_bottom).offset(15*_multiply);
    }];
    
    [self.signContractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.label2.mas_bottom).offset(15*_multiply);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signContractBtn.mas_bottom).offset(30*_multiply);
        make.left.equalTo(self.view.mas_left).offset(30*_multiply);
        make.height.equalTo(@(40*_multiply));
        make.width.equalTo(@(150*_multiply));
    }];
    
    [self.addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signContractBtn.mas_bottom).offset(30*_multiply);
        make.right.equalTo(self.view.mas_right).offset(-30*_multiply);
        make.height.equalTo(@(40*_multiply));
        make.width.equalTo(@(150*_multiply));
    }];
}

#pragma mark - button pressed
//*<查看签约合同 >/
- (void)signContractPressed {
    [UIView makeToast:@"此功能暂未开通"];
}
//*<返回 >/
- (void)backPressed {
    if (self.block) {
        self.block(self);
    }
}
//*<添加通讯录 >/
- (void)addAdressPressed {
    [UIView makeToast:@"此功能暂未开通"];
//    NIMUserRequest *request = [[NIMUserRequest alloc] init];
//    request.userId          = @"";            //封装用户ID
//    request.operation       = NIMUserOperationAdd;                    //封装验证方式
//    request.message         = @"请求添加好友";                          //封装自定义验
//
//    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
//        if (!error) {
//            [UIView makeToast:@"好友添加成功"];
//        }
//    }];
}

#pragma mark - private

- (NSMutableAttributedString *)setAttrbuteString:(NSString *)str IsNormal:(BOOL)isNormal{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttribute:NSUnderlineStyleAttributeName
                               value:@(NSUnderlineStyleSingle)
                               range:NSMakeRange(0, str.length)];
    if (isNormal) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHexString:@"#0eb2ff"]
                             range:NSMakeRange(0, str.length)];
    } else {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHexString:@"#86d8ff"]
                             range:NSMakeRange(0, str.length)];
    }
    
    return attributeStr;
}

@end
