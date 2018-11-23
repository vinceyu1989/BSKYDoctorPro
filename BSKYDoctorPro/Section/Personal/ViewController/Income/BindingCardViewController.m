//
//  BindingCardViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BindingCardViewController.h"
#import "BSApplyBCardRequest.h"
#import "BSBankInfoModel.h"
#import "UIViewController+BackButtonHandler.h"

@interface BindingCardViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *ensureButton;

@property (nonatomic, strong) BSApplyBCardRequest     *applyRequest;

@end

@implementation BindingCardViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    self.applyRequest = [[BSApplyBCardRequest alloc] init];
    if (self.model.bankAccount.length != 0) {
        self.nameTextField.text = self.model.bankOwner;
        self.bankTextField.text = self.model.bankBranch;
        self.cardNumberTextField.text = self.model.bankAccount;
    }
}

- (void)initView {
    [self setLabelWithTextField:self.nameTextField text:@"户主姓名"];
    [self setLabelWithTextField:self.bankTextField text:@"开户行"];
    [self setLabelWithTextField:self.cardNumberTextField text:@"银行卡号"];
    
    [self.ensureButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x4e7dd3) size:self.ensureButton.bounds.size] forState:UIControlStateNormal];
    [self.ensureButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x273e69) size:self.ensureButton.bounds.size] forState:UIControlStateDisabled];
    [self.ensureButton setCornerRadius:5];
}

- (IBAction)respondToApplying:(id)sender {
    if (self.nameTextField.text.length == 0 || ![self.nameTextField.text isChinese]) {
        [UIView makeToast:@"请输入有效的真实姓名"];
    } else if (self.bankTextField.text.length == 0 || ![self.bankTextField.text isChinese]) {
        [UIView makeToast:@"请输入有效的开户行名称"];
    } else if (self.cardNumberTextField.text.length < 15) {
        [UIView makeToast:@"请输入有效的银行卡号"];
    } else {
        BSBankInfoModel *info = [[BSBankInfoModel alloc] init];
        info.userId = [NSString stringWithFormat:@"%@",[BSAppManager sharedInstance].currentUser.userId];
        info.bankOwner = [self.nameTextField.text encryptCBCStr];
        info.bankBranch = [self.bankTextField.text encryptCBCStr];
        info.bankAccount = [self.cardNumberTextField.text encryptCBCStr];
        if (_model && _model.bankId.length != 0) {
            info.bankId = _model.bankId;
        }
        
        self.applyRequest.paymentBank = [info mj_keyValues];
        [MBProgressHUD showHud];
        [self.applyRequest startWithCompletionBlockWithSuccess:^(__kindof BSApplyBCardRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
            if (self.blcok) {
                self.blcok(self);
            }
        } failure:^(__kindof BSApplyBCardRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }
}

- (void)setModel:(BSBankInfoModel *)model  {
    _model = model;
}

- (void)setLabelWithTextField:(UITextField *)textField text:(NSString *)text {
    textField.leftViewMode = UITextFieldViewModeAlways;
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    label.font = [UIFont systemFontOfSize:14.0];
    textField.leftView = label;
    [textField.leftView sizeToFit];
}

#pragma mark ----- BackButtonHandlerProtocol
-(BOOL)navigationShouldPopOnBackButton {
    [self backAction];
    return NO;
}

- (void)backAction{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定退出?" message:@"内容尚未提交" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1402;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1402) {
        switch (buttonIndex) {
            case 0:
                break;
            default:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        [self backAction];
        return NO;
    }
    return YES;
}

@end
