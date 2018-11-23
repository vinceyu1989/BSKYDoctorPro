//
//  BSZYInputTextView.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/12/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSZYInputTextView.h"
#import "BRPlaceholderTextView.h"
@interface BSZYInputTextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel    *titleLabel;
@property (nonatomic, strong) BRPlaceholderTextView *textView;
@property (nonatomic, strong) UILabel    *numLabel;

@end
@implementation BSZYInputTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"备注(非必填)";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(10);
    }];
    
    self.textView = [[BRPlaceholderTextView alloc] init];
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
    self.textView.placeholder = @"请输入200字以内的备注信息";
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.delegate = self;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.textColor = [UIColor colorWithHexString:@"#666666"];
    WS(weakSelf);
    [self.textView addMaxTextLengthWithMaxLength:200 andEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"%@",text.text);
        if (weakSelf.block) {
            weakSelf.block(text.text);
        }
    }];
    [self.textView setLengthBlcok:^(NSInteger num) {
        weakSelf.numLabel.text = [NSString stringWithFormat:@"%ld/200",num];
    }];
    
    [self addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.height.equalTo(@13);
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.textColor = UIColorFromRGB(0x666666);
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.text = @"0/200";
    }
    return _numLabel;
}

@end
