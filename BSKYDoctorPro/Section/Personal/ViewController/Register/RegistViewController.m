//
//  RegistViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistSuccessViewController.h"
#import "OrganStreetViewController.h"

#import "LoginTextField.h"
#import "TeamPickerView.h"

#import "RegistDoctorRequest.h"
#import "DivisionCodeModel.h"
#import "CmsCodeAndCheckRequest.h"

#define theWidth   [UIScreen mainScreen].bounds.size.width

@interface RegistViewController () <UITextFieldDelegate>{
    int     _timerNum;
    CGFloat _fitWidth;
    __block NSString *_practiceType;
}

@property (nonatomic, strong) UIView    *topView;
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton    *codeButton;
@property (nonatomic, strong) UIImageView *isVisibleImage;
@property (nonatomic, strong) UILabel     *remarkLabel;

@property (nonatomic, strong) UIView    *bottomView;
@property (strong, nonatomic) UIButton  *registButton;
@property (strong, nonatomic) UIButton  *clauseButton;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *IDCodeTextField;
@property (nonatomic, strong) UITextField *organTextField;
@property (nonatomic, strong) UITextField *classTextField;

@property (nonatomic, strong) RegistDoctorRequest *registRequest;
@property (nonatomic, strong) CmsCodeAndCheckRequest   *checkPhoneRequest;
@property (nonatomic, strong) OrganStreetViewController *organVC;

@property (nonatomic, strong) NSString *divisionId;
@property (nonatomic, assign) BOOL      isVisible;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self addConstraint];
}

#pragma mark - init
- (void)initData {
    _fitWidth = theWidth/375.0f;
    self.isVisible = YES;
    self.registRequest = [[RegistDoctorRequest alloc] init];
    self.checkPhoneRequest = [[CmsCodeAndCheckRequest alloc] init];
}

- (void)initView {
    self.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    
    self.phoneTextField = [self setTextFieldWithKeyboardType:UIKeyboardTypeNumberPad TextAlignment:NSTextAlignmentLeft AttrbuteString:@"请输入手机号" ImageName:@"手机号ico"];
    [self.phoneTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.phoneTextField.delegate = self;
    [self.topView addSubview:self.phoneTextField];
    
    self.codeTextField = [self setTextFieldWithKeyboardType:UIKeyboardTypeNumberPad TextAlignment:NSTextAlignmentLeft AttrbuteString:@"请输入验证码" ImageName:@"验证码ico"];
    [self.codeTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.topView addSubview:self.codeTextField];
    
    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.codeButton.titleLabel.font = [UIFont systemFontOfSize:13*_fitWidth];
    [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(codeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.codeButton sizeToFit];
    [self.codeButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#0eb2ff"]] forState:UIControlStateNormal];
    [self.codeButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#07597f"]] forState:UIControlStateHighlighted];
    [self.codeButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#cccccc"]] forState:UIControlStateDisabled];
    [self.codeButton setCornerRadius:5];
    
    [self.topView addSubview:self.codeButton];
    
    self.passwordTextField = [self setTextFieldWithKeyboardType:UIKeyboardTypeDefault TextAlignment:NSTextAlignmentLeft AttrbuteString:@"请输入登录密码" ImageName:@"密码ico"];
    [self.passwordTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.passwordTextField.secureTextEntry = YES;
    [self.topView addSubview:self.passwordTextField];
    
    self.isVisibleImage = [[UIImageView alloc] init];
    self.isVisibleImage.contentMode = UIViewContentModeCenter;
    self.isVisibleImage.userInteractionEnabled = YES;
    self.isVisibleImage.image = [UIImage imageNamed:@"密码-不可见"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visiblePress)];
    [self.isVisibleImage addGestureRecognizer:tap];
    [self.topView addSubview:self.isVisibleImage];
    
    self.remarkLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"密码为6~20位字符，仅支持数字、字母，区分大小写";
        label.textColor = [UIColor colorWithHexString:@"#ffc000"];
        label.font = [UIFont systemFontOfSize:11*_fitWidth];
        label;
    });
    [self.topView addSubview:self.remarkLabel];
    
    self.nameTextField = [self setTextFieldWithKeyboardType:UIKeyboardTypeDefault TextAlignment:NSTextAlignmentRight AttrbuteString:@"请输入真实姓名" ImageName:nil];
    self.nameTextField.leftView = [self setLabelWithText:@"姓名"];
    self.nameTextField.delegate = self;
    [self.nameTextField.leftView sizeToFit];
    [self.bottomView addSubview:self.nameTextField];
    
    self.IDCodeTextField = [self setTextFieldWithKeyboardType:UIKeyboardTypeDefault TextAlignment:NSTextAlignmentRight AttrbuteString:@"请输入18位身份证号" ImageName:nil];
    self.IDCodeTextField.attributedPlaceholder = [self setAttrbuteString:@"请输入18位身份证号"];
    self.IDCodeTextField.leftView = [self setLabelWithText:@"身份证号"];
    [self.IDCodeTextField.leftView sizeToFit];
    [self.IDCodeTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.IDCodeTextField.delegate = self;
    [self.bottomView addSubview:self.IDCodeTextField];
    
    self.organTextField = [self setTextFieldWithKeyboardType:UIKeyboardTypeDefault TextAlignment:NSTextAlignmentRight AttrbuteString:@"请选择医疗机构" ImageName:nil];
    self.organTextField.delegate = self;
    self.organTextField.rightViewMode = UITextFieldViewModeAlways;
    self.organTextField.leftView = [self setLabelWithText:@"医疗机构"];
    [self.organTextField.leftView sizeToFit];
    self.organTextField.rightView = [self setImageViewWithImageName:@"next"];
    [self.organTextField addTarget:self action:@selector(clickOrganTextField) forControlEvents:UIControlEventTouchDown];
    [self.bottomView addSubview:self.organTextField];
    
    self.classTextField = [self setTextFieldWithKeyboardType:UIKeyboardTypeDefault TextAlignment:NSTextAlignmentRight AttrbuteString:@"请选择执业类别" ImageName:nil];
    self.classTextField.delegate = self;;
    self.classTextField.rightViewMode = UITextFieldViewModeAlways;
    self.classTextField.leftView = [self setLabelWithText:@"执业类别"];
    [self.classTextField.leftView sizeToFit];
    self.classTextField.rightView = [self setImageViewWithImageName:@"next"];
    [self.classTextField addTarget:self action:@selector(clickClassTextField) forControlEvents:UIControlEventTouchDown];
    [self.bottomView addSubview:self.classTextField];
    
    self.registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registButton.titleLabel.font = [UIFont systemFontOfSize:18*_fitWidth];
    [self.registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registButton addTarget:self action:@selector(registBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.registButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x4e7dd3) size:self.codeButton.bounds.size] forState:UIControlStateNormal];
    [self.registButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x273e69) size:self.codeButton.bounds.size] forState:UIControlStateDisabled];
    [self.registButton setCornerRadius:5];
    [self.view addSubview:self.registButton];
    
    NSString *lstr = @"注册即表示您同意";
    NSString *btnstr = @"《巴蜀快医使用条款》";
    CGFloat padding = [self returnPaddingWithFirstParty:lstr SecondParty:btnstr FirstFont:11.0*_fitWidth SecondFont:11.0*_fitWidth];
    UILabel *agreeL = [[UILabel alloc] init];
    agreeL.text = lstr;
    agreeL.textColor = [UIColor colorWithHexString:@"#999999"];
    agreeL.font = [UIFont systemFontOfSize:11.0*_fitWidth];
    [self.view addSubview:agreeL];
    [agreeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.registButton.mas_bottom).offset(15.0*_fitWidth);
        make.height.mas_offset(11.0);
        make.left.mas_offset(padding);
    }];
    
    self.clauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clauseButton setTitle:btnstr forState:UIControlStateNormal];
    [self.clauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.clauseButton addTarget:self action:@selector(clauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.clauseButton setCornerRadius:5];
    self.clauseButton.titleLabel.font = [UIFont systemFontOfSize:_fitWidth*11.0];
    [self.clauseButton setTitleColor:[UIColor colorWithHexString:@"#0eb2ff"] forState:UIControlStateNormal];
    [self.view addSubview:self.clauseButton];
    [self.clauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.registButton.mas_bottom).offset(_fitWidth*15.0);
        make.height.mas_offset(11.0);
        make.right.mas_offset(-padding);
    }];
}

- (void)addConstraint {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@165);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@180);
    }];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.topView);
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.height.equalTo(@45);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom);
        make.right.equalTo(self.topView.mas_right).offset(-130);
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.height.equalTo(@45);
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeTextField.mas_centerY);
        make.right.equalTo(self.topView.mas_right).offset(-15);
        make.height.equalTo(@(30*_fitWidth));
        make.width.equalTo(@(88*_fitWidth));
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTextField.mas_bottom);
        make.right.equalTo(self.topView.mas_right).offset(-40);
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.height.equalTo(@45);
    }];
    [self.isVisibleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passwordTextField.mas_centerY);
        make.right.equalTo(self.topView.mas_right).offset(-20);
        make.width.equalTo(@(20*_fitWidth));
    }];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom);
        make.left.right.equalTo(self.topView);
        make.height.equalTo(@30);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top);
        make.right.equalTo(self.bottomView.mas_right).offset(-15);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.height.equalTo(@45);
    }];
    [self.IDCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextField.mas_bottom);
        make.right.equalTo(self.bottomView.mas_right).offset(-15);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.height.equalTo(@45);
    }];
    [self.organTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IDCodeTextField.mas_bottom);
        make.right.equalTo(self.bottomView.mas_right).offset(-15);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.height.equalTo(@45);
    }];
    [self.classTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.organTextField.mas_bottom);
        make.right.equalTo(self.bottomView.mas_right).offset(-15);
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.height.equalTo(@45);
    }];
    
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.equalTo(@45);
    }];
    [self addLinesWithTextField:self.phoneTextField];
    [self addLinesWithTextField:self.codeTextField];
    [self addLinesWithTextField:self.passwordTextField];
    [self addLinesWithTextField:self.nameTextField];
    [self addLinesWithTextField:self.IDCodeTextField];
    [self addLinesWithTextField:self.organTextField];
}

- (void)addLinesWithTextField:(UITextField *)textField {
    UIView*underLine = [[UIView alloc] init];
    underLine.backgroundColor = UIColorFromRGB(0xededed);
    [self.bottomView addSubview:underLine];
    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(textField);
        make.height.equalTo(@0.7);
    }];
}

#pragma mark - Button Pressed

- (void)codeBtnPressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (![self.phoneTextField.text isPhoneNumber]) {
        [UIView makeToast:@"请输入正确手机号码"];
        return;
    }
    [self startTimer];
    [MBProgressHUD showHud];
    self.checkPhoneRequest.phone = self.phoneTextField.text;
    self.checkPhoneRequest.type = @3;
    Bsky_WeakSelf
    [self.checkPhoneRequest startWithCompletionBlockWithSuccess:^(__kindof BSBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        Bsky_StrongSelf
        if (self.checkPhoneRequest.model.idCard.length != 0) {
            self.IDCodeTextField.text = [self idCardStrByReplacingCharactersWithAsterisk:self.checkPhoneRequest.model.idCard];
            self.nameTextField.text = [self.checkPhoneRequest.model.userName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
            self.IDCodeTextField.enabled = NO;
            self.nameTextField.enabled = NO;
            [UIView makeToast:@"已通过巴蜀快医居民端同步您的个人信息，如有误请联系客服~"];
            return;
        }
        self.IDCodeTextField.enabled = YES;
        self.nameTextField.enabled = YES;
    } failure:^(__kindof CmsCodeAndCheckRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        Bsky_StrongSelf
        self.IDCodeTextField.enabled = YES;
        self.nameTextField.enabled = YES;
        [UIView makeToast:request.msg];
    }];
}

//是否显示密码
- (void)visiblePress {
    [self.view endEditing:YES];
    self.isVisible = !self.isVisible;
    self.isVisibleImage.image = self.isVisible == YES ? [UIImage imageNamed:@"密码-不可见"] : [UIImage imageNamed:@"密码-可见"];
    self.passwordTextField.secureTextEntry = self.isVisible;
}

//注册
- (void)registBtnPressed:(UIButton *)sender {
    if (![self.phoneTextField.text isPhoneNumber]) {
        [UIView makeToast:@"请输入正确手机号码"];
        return;
    } else if (self.codeTextField.text.length == 0) {
        [UIView makeToast:@"请输入验证码"];
        return;
    } else if (self.passwordTextField.text.length == 0) {
        [UIView makeToast:@"请输入密码"];
        return;
    } else if (![self.passwordTextField.text isMatchesRegularExp:@"^[0-9A-Za-z]{6,20}$"]) {
        [UIView makeToast:@"密码格式不正确"];
        return;
    } else if (self.nameTextField.text.length == 0) {
        [UIView makeToast:@"请输入真实姓名"];
        return;
    } else if (self.IDCodeTextField.text.length == 0) {
        [UIView makeToast:@"请输入身份证号码"];
        return;
    } else if ((self.IDCodeTextField.enabled == NO && ![self.checkPhoneRequest.model.idCard isIdCard])
               || (self.IDCodeTextField.enabled == YES && ![self.IDCodeTextField.text isIdCard])) {
        [UIView makeToast:@"请填写正确的身份证号"];
        return;
    } else if (self.organTextField.text.length == 0) {
        [UIView makeToast:@"请输入医疗机构"];
        return;
    } else if (self.classTextField.text.length == 0) {
        [UIView makeToast:@"请输入执业类别"];
        return;
    }
    if ([self.IDCodeTextField.text containsString:@"x"]) {
        self.IDCodeTextField.text = [self.IDCodeTextField.text replaceWithKeyWord:@"x" replace:@"X"];
    }
    RegistDoctorModel *model = [[RegistDoctorModel alloc] init];
    model.mobileNo = self.phoneTextField.text;
    model.smsCode = self.codeTextField.text;
    model.password = self.passwordTextField.text;
    model.realName = self.nameTextField.enabled == YES ? self.nameTextField.text : self.checkPhoneRequest.model.userName;
    model.documentNo = self.IDCodeTextField.enabled == YES ? self.IDCodeTextField.text :self.checkPhoneRequest.model.idCard;
    model.organizationId = [NSNumber numberWithInteger:[_divisionId integerValue]];
    model.practiceType = _practiceType;
    [model entryptModel];
    self.registRequest.userInfoForm = [model mj_keyValues];
    [MBProgressHUD showHud];
    MJWeakSelf;
    [self.registRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [BSClientManager sharedInstance].lastUsername =  weakSelf.phoneTextField.text;
        // 跳转注册成功页面
        RegistSuccessViewController *successVC = [[RegistSuccessViewController alloc] init];
        BSNavigationViewController *nav = [[BSNavigationViewController alloc] initWithRootViewController:successVC];
        [successVC setBlocks:^(RegistSuccessViewController *vc) {
            [vc dismissViewControllerAnimated:YES completion:nil];
            if (weakSelf.block) {
                weakSelf.block(weakSelf, weakSelf.phoneTextField.text, weakSelf.passwordTextField.text);
            }
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
        [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
    } failure:^(__kindof RegistDoctorRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}

//*<协议点击 >/
- (void)clauseBtnClick {
    BSWebViewController *webVC = [[BSWebViewController alloc]init];
    webVC.showNavigationBar = YES;
    webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
    webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
    [webVC ba_web_loadHTMLFileName:@"agreement"];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - TextField Response
//*<机构 >/
- (void)clickOrganTextField {
    [self.view endEditing:YES];
    NSLog(@"====选择机构===");
    if (!self.organVC) {
        self.organVC = [[OrganStreetViewController alloc] init];
    }
    [self.navigationController pushViewController:self.organVC animated:YES];
    @weakify(self);
    [self.organVC setBlock:^(OrganStreetViewController *vc, DivisionCodeModel *model) {
        @strongify(self);
        self.organTextField.text = model.divisionName;
        self.divisionId = model.divisionId;
        [vc.navigationController popViewControllerAnimated:NO];
    }];
}
//*<执业 >/
- (void)clickClassTextField {
    [self.view endEditing:YES];
    NSLog(@"====选择执业===");
    __block NSArray *arr = @[@"全科医生",@"专科医生",@"乡村医生",@"护士",@"公卫人员",@"中医",@"其他"];
    TeamPickerView *pickerView = [[TeamPickerView alloc]init];
    [pickerView setItems:arr title:@"请选择执业类型" defaultStr:@""];
    @weakify(self);
    pickerView.selectedIndex = ^(NSInteger index) {
        @strongify(self);
        //02022001-02022007
        self.classTextField.text = arr[index];
        self->_practiceType = [NSString stringWithFormat:@"0202200%@",@(index+1)];
    };
    [pickerView show];
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField{
    if (textField == self.organTextField || textField == self.classTextField) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

//*<手机号和姓名、身份证失去焦点验证 >/
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        return YES;
    }
    if (textField == self.phoneTextField) {
        if (![textField.text isPhoneNumber]) {
            self.phoneTextField.text = @"";
            [UIView makeToast:@"请输入正确的手机号"];
        }
    } else if (textField == self.nameTextField) {
        if (![textField.text isChinese]) {
            self.nameTextField.text = @"";
            [UIView makeToast:@"请输入正确的姓名"];
        }
    } else if (textField == self.IDCodeTextField) {
        if (![self.IDCodeTextField.text isIdCard]) {
            self.IDCodeTextField.text = @"";
            [UIView makeToast:@"请输入正确的身份证"];
        }
    }
    return YES;
}

-(void)textFieldEditingChanged:(UITextField *)textField {
    
    if (textField.text.length < 1) {
        return;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textField == self.phoneTextField) {
                if (toBeString.length > 11) {
                    textField.text = [toBeString substringToIndex:11];
                    [UIView makeToast:@"超出了限制字数长度"];
                }
            } else if (textField == self.codeTextField) {
                if (toBeString.length > 6) {
                    textField.text = [toBeString substringToIndex:6];
                    [UIView makeToast:@"超出了限制字数长度"];
                }
            } else if (textField == self.passwordTextField) {
                if (toBeString.length > 20) {
                    textField.text = [toBeString substringToIndex:20];
                    [UIView makeToast:@"超出了限制字数长度"];
                }
            } else if (textField == self.IDCodeTextField) {
                if (toBeString.length > 18) {
                    textField.text = [toBeString substringToIndex:18];
                    [UIView makeToast:@"超出了限制字数长度"];
                }
            }
        }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况   else{
    }
    if (textField == self.phoneTextField) {
        if (toBeString.length > 11) {
            textField.text = [toBeString substringToIndex:11];
            [UIView makeToast:@"超出了限制字数长度"];
        }
    } else if (textField == self.codeTextField) {
        if (toBeString.length > 6) {
            textField.text = [toBeString substringToIndex:6];
            [UIView makeToast:@"超出了限制字数长度"];
        }
    } else if (textField == self.passwordTextField) {
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            [UIView makeToast:@"超出了限制字数长度"];
        }
    } else if (textField == self.IDCodeTextField) {
        if (toBeString.length > 18) {
            textField.text = [toBeString substringToIndex:18];
            [UIView makeToast:@"超出了限制字数长度"];
        }
    }
}

#pragma mark - timer
//*<启动定时器 >/
-(void)startTimer {
    self.codeButton.enabled = NO;
    _timerNum = 60;
    NSString * strTitle = [NSString stringWithFormat:@"%.d秒后重发", _timerNum];
    [self.codeButton setTitle:strTitle forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(funcTimer:) userInfo:nil repeats:YES];
}

-(void)funcTimer:(NSTimer *)timer {
    _timerNum--;
    NSString * strTitle = [NSString stringWithFormat:@"%.d秒后重发", _timerNum];
    [self.codeButton setTitle:strTitle forState:UIControlStateNormal];
    if(_timerNum == 0)
    {
        [timer invalidate];
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeButton.enabled = YES;
    }
}

#pragma mark - Private
//*<统一配置 >/
- (UITextField *)setTextFieldWithKeyboardType:(UIKeyboardType)keyboardType TextAlignment:(NSTextAlignment)textAlignment AttrbuteString:(NSString *)attrbuteString ImageName:(NSString *)imageName {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:15*_fitWidth];
    textField.attributedPlaceholder = [self setAttrbuteString:attrbuteString];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (imageName != nil) {
         textField.leftView = [self setLeftViewImage:[UIImage imageNamed:imageName]];
    }
    textField.keyboardType = keyboardType;
    textField.textColor = [UIColor colorWithHexString:@"#333333"];
    textField.textAlignment = textAlignment;
    return textField;
}

- (UIImageView *)setLeftViewImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [imageView sizeToFit];
    imageView.width = imageView.width +10;
    imageView.contentMode = UIViewContentModeLeft;
    return imageView;
}

- (NSMutableAttributedString *)setAttrbuteString:(NSString *)str {
    NSMutableAttributedString *acountTPlaceholder = [[NSMutableAttributedString alloc]initWithString:str];
    [acountTPlaceholder addAttribute:NSForegroundColorAttributeName
                               value:UIColorFromRGB(0xcccccc)
                               range:NSMakeRange(0, str.length)];
    return acountTPlaceholder;
}

- (UILabel *)setLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    label.font = [UIFont systemFontOfSize:_fitWidth*15.0];
    return label;
}

- (UIImageView *)setImageViewWithImageName:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(theWidth-30*_fitWidth, 0, 15*_fitWidth, 30*_fitWidth)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeRight;
    return imageView;
}
//*<居中显示  距离边界间距 >/
- (CGFloat)returnPaddingWithFirstParty:(NSString *)party1 SecondParty:(NSString *)party2 FirstFont:(CGFloat)font1 SecondFont:(CGFloat)font2 {
    CGFloat labelwidth = [party1 boundingRectWithSize:CGSizeMake(MAXFLOAT, font1)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font1]}
                                            context:nil].size.width;
    CGFloat btnwidth = [party2 boundingRectWithSize:CGSizeMake(MAXFLOAT,font2)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font2]}
                                            context:nil].size.width;
    CGFloat padding = (theWidth - labelwidth - btnwidth) * 0.5;
    return padding;
}

- (NSString *)idCardStrByReplacingCharactersWithAsterisk:(NSString *)str {
    for (int i = 3; i<str.length-4; i++) {
        str = [str stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return str;
}

@end
