//
//  QuickLoginView.m
//  Login
//
//  Created by kykj on 2017/8/15.
//  Copyright © 2017年 kykj. All rights reserved.
//

#import "QuickLoginView.h"

#define theWidth   [UIScreen mainScreen].bounds.size.width
#define theHeight  [UIScreen mainScreen].bounds.size.height

@interface QuickLoginView ()<UITextFieldDelegate> {
    int _timerNum;
}

@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, copy)   GetCodeCallback codeCallback;
@property (nonatomic, strong) UIView *accountLine;
@property (nonatomic, strong) UIView *codeLine;
@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation QuickLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}
- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"获取验证码测试释放");
}

- (void)setupUI {
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self addSubview:line1];
    self.accountLine = line1;
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.offset(theWidth/375 *45.0);
        make.right.offset(-theWidth/375 * 45.0);
        make.height.offset(1);
        make.top.offset(theWidth/375 *65.0);
    }];
    
    UIImage *accountImage = [UIImage imageNamed:@"手机号ico"];
    UIImageView *accountImageView = [[UIImageView alloc] init];
    accountImageView.image = accountImage;
    [self addSubview:accountImageView];
    [accountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(theWidth/375 *55.0);
        make.bottom.mas_equalTo(line1.mas_top).offset(-theWidth/375 *15.0);
        make.width.mas_equalTo(accountImage.size);
        make.height.mas_equalTo(accountImage.size);

    }];
    
    NSString *acountTHolderText = @"请输入手机号";
    NSMutableAttributedString *acountTPlaceholder = [[NSMutableAttributedString alloc]initWithString:acountTHolderText];
    [acountTPlaceholder addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithHexString:@"#cccccc"]
                               range:NSMakeRange(0, acountTHolderText.length)];
    UITextField *acountT = [[UITextField alloc] init];
    acountT.attributedPlaceholder = acountTPlaceholder;
    acountT.tintColor = [UIColor colorWithHexString:@"#cccccc"];
    acountT.keyboardType = UIKeyboardTypeNumberPad;
    acountT.font = [UIFont systemFontOfSize:theWidth/375 *16.0 weight:UIFontWeightLight];
    if (LESS_IOS8_2) {
        acountT.font = [UIFont systemFontOfSize:theWidth/375 *16.0];
    }
    acountT.textColor = [UIColor colorWithHexString:@"#333333"];
    acountT.clearButtonMode = UITextFieldViewModeWhileEditing;
    acountT.delegate = self;
    self.acountT = acountT;
    [self addSubview:acountT];
    [acountT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountImageView.mas_right).offset(theWidth/375 *15.0);
        make.right.offset(-theWidth/375 * 45.0);
        make.centerY.equalTo(accountImageView.mas_centerY).offset(theWidth/375*1);
        make.height.offset(theWidth/375 *35.0);
        
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self addSubview:line2];
    self.codeLine = line2;
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(theWidth/375 *45.0);
        make.right.offset(-theWidth/375 * 45.0);
        make.height.offset(1);
        make.bottom.offset(0);
    }];
    
    UIImage *codeImage = [UIImage imageNamed:@"验证码ico"];
    UIImageView *codeImageView = [[UIImageView alloc] init];
    codeImageView.image = codeImage;
    [self addSubview:codeImageView];
    [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(theWidth/375 *55.0);
        make.bottom.mas_equalTo(line2.mas_top).offset(-theWidth/375 *15.0);
        make.width.mas_equalTo(codeImage.size);
        make.height.mas_equalTo(codeImage.size);
    }];
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#0eb2ff"]] forState:UIControlStateNormal];
    [codeBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#07597f"]] forState:UIControlStateHighlighted];
    [codeBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#cccccc"]] forState:UIControlStateDisabled];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:theWidth/375 *13.0];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.layer.cornerRadius = 4.0;
    codeBtn.layer.masksToBounds = YES;
    [codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.codeBtn = codeBtn;
    [self addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-theWidth/375 * 55.0);
        make.height.offset(theWidth/375 * 30.0);
        make.bottom.mas_equalTo(line2.mas_top).offset(-theWidth/375 *7.5);
        make.width.offset(theWidth/375 * 80.0);
        
    }];
    
    NSString *codeTHolderText = @"短信验证码";
    NSMutableAttributedString *codeTPlaceholder = [[NSMutableAttributedString alloc]initWithString:codeTHolderText];
    [acountTPlaceholder addAttribute:NSForegroundColorAttributeName
                               value:[UIColor colorWithHexString:@"#cccccc"]
                               range:NSMakeRange(0, codeTHolderText.length)];
    UITextField *codeT = [[UITextField alloc] init];
    codeT.tintColor = [UIColor colorWithHexString:@"#cccccc"];
    codeT.attributedPlaceholder = codeTPlaceholder;
    codeT.keyboardType = UIKeyboardTypeNumberPad;
    codeT.font = [UIFont systemFontOfSize:theWidth/375 *16.0 weight:UIFontWeightLight];
    if (LESS_IOS8_2) {
        codeT.font = [UIFont systemFontOfSize:theWidth/375 *16.0];
    }
    codeT.textColor = [UIColor colorWithHexString:@"#333333"];
    codeT.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeT.delegate = self;
    self.codeT = codeT;
    [self addSubview:codeT];
    [codeT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeImageView.mas_right).offset(theWidth/375 *15.0);
        make.right.mas_equalTo(codeBtn.mas_left);
        make.centerY.equalTo(codeImageView.mas_centerY).offset(theWidth/375*1);
        make.height.offset(theWidth/375 *35.0);
        
    }];
}

- (void)codeBtnClick {

    [self.acountT resignFirstResponder];
    [self.codeT resignFirstResponder];
    if (self.acountT.text.length == 0) {
        [UIView makeToast:@"请填写手机号码"];
        return;
    } else if (![self.acountT.text isPhoneNumber]) {
        [UIView makeToast:@"请填写正确手机号码"];
        return;
    }
    _timerNum = 60;
    [self startTimer];
    _codeCallback(self.acountT.text);
}

///启动定时器
-(void)startTimer {
    self.codeBtn.enabled = NO;
   self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(funcTimer:) userInfo:nil repeats:YES];
}
// 取消定时器
- (void)cancelTimer
{
    self.codeBtn.enabled = YES;
    _timerNum = 60;
    [self.timer invalidate];
    self.timer = nil;
}

-(void)funcTimer:(NSTimer *)timer {
    _timerNum--;
    NSString * strTitle = [NSString stringWithFormat:@"%.d秒后重发", _timerNum];
    [self.codeBtn setTitle:strTitle forState:UIControlStateNormal];
    [self.codeBtn setBackgroundColor:[UIColor colorWithHexString:@"#cccccc"]];
    if(_timerNum == 0)
    {
        [timer invalidate];
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.codeBtn setBackgroundColor:[UIColor colorWithHexString:@"#0eb2ff"]];
        self.codeBtn.enabled = YES;
    }
}

- (void)getCodeCallback:(GetCodeCallback)callback {
    _codeCallback = callback;
}

#pragma mark - UITextFieldDelegate 
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.acountT) {
        self.accountLine.backgroundColor = [UIColor colorWithHexString:@"4e7dd3"];
        self.codeLine.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    } else {
        self.codeLine.backgroundColor = [UIColor colorWithHexString:@"4e7dd3"];
        self.accountLine.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.acountT) {
        self.accountLine.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        self.codeLine.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    } else {
        self.codeLine.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        self.accountLine.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (textField == self.acountT) {
        if (textField.text.length >= 11) {
            return NO;
        }
    }
 
    if (textField == self.codeT) {
        if (textField.text.length >= 6) {
            return NO;
        }
    }
    return YES;
}

@end
