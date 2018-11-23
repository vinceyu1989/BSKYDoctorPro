//
//  BRTextField.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "BSTextField.h"

@interface BSTextField ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *tapView;

@end

@implementation BSTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];
}
- (void)initView
{
    self.pointNum = -1;
    self.textColor = UIColorFromRGB(0x333333);
    self.moreIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more_icon"]];
    [self.moreIcon sizeToFit];
    self.moreIcon.contentMode = UIViewContentModeRight;
    self.moreIcon.frame = CGRectMake(0, 0, self.moreIcon.width+5, self.moreIcon.height);
    self.rightView = self.moreIcon;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.returnKeyType = UIReturnKeyDone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;  // 取消自动纠错
    self.delegate = self;
}

- (void)setTapAcitonBlock:(BSTapAcitonBlock)tapAcitonBlock {
    _tapAcitonBlock = tapAcitonBlock;
    self.tapView.hidden = !_tapAcitonBlock;
}

- (void)setEndEditBlock:(BSEndEditBlock)endEditBlock {
    _endEditBlock = endEditBlock;
    [self addTarget:self action:@selector(didEndEditTextField:) forControlEvents:UIControlEventEditingDidEnd];
}
- (void)setMaxNum:(NSInteger)maxNum
{
    _maxNum = maxNum;
    [self addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc]initWithFrame:CGRectZero];
        _tapView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tapView];
        [_tapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTextField)];
        [_tapView addGestureRecognizer:myTap];
    }
    return _tapView;
}

- (void)didTapTextField {
    // 响应点击事件时，隐藏键盘
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
    if (self.tapAcitonBlock) {
        self.tapAcitonBlock();
    }
}

#pragma mark --- UITextFieldDelegate

//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.pointNum < 0) {
        return YES;
    }
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    //[self alertView:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    return YES;
                }else
                {
                    //[self alertView:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt = range.location-ran.location;
                    if (self.pointNum < 0) {
                        return YES;
                    }
                    else if (tt <= self.pointNum){
                        return YES;
                    }
                    else{
                        [UIView makeToast:[NSString stringWithFormat:@"最多输入%ld位有效小数",(long)self.pointNum]];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (void)didEndEditTextField:(UITextField *)textField {
    // 小数点判断
    if (self.pointNum >= 0) {
        NSRange range=[textField.text rangeOfString:@"."];
        if (textField.text.length < 1) {
            textField.text = @"";
        }
        else if(self.pointNum == 0 && range.location != NSNotFound)
        {
            textField.text = [textField.text substringToIndex:range.location];
        }
        else if (range.location == NSNotFound) {
            NSString *str = [NSString stringWithFormat:@"%@.",textField.text];
            for (int i = 0; i< self.pointNum; i++) {
                str = [str stringByAppendingString:@"0"];
            }
            textField.text = str;
        }
        else if (textField.text.length - range.location - 1 < self.pointNum) {
            NSString *str = [NSString stringWithFormat:@"%@",textField.text];
            for (int i = 0; i< self.pointNum - (textField.text.length - range.location-1); i++) {
                str = [str stringByAppendingString:@"0"];
            }
            textField.text = str;
        }
        textField.text = [textField.text getNumTextAndDecimalPoint];
    }
    if (self.endEditBlock) {
        self.endEditBlock(textField.text);
    }
}
-(void)textFieldEditingChanged:(UITextField *)textField {
    
    NSString *toBeString = textField.text;
    if (!toBeString || toBeString.length < 1) {
        return;
    }
    if (self.maxNum >= 1) {
        NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > self.maxNum) {
                    textField.text = [toBeString substringToIndex:self.maxNum];
                    [UIView makeToast:[NSString stringWithFormat:@"最多输入%ld位有效字符",(long)self.maxNum]];
                }
            }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
            }
        }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况   else{
        else if (toBeString.length > self.maxNum) {
            textField.text = [toBeString substringToIndex:self.maxNum];
            [UIView makeToast:[NSString stringWithFormat:@"最多输入%ld位有效字符",(long)self.maxNum]];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
