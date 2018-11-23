//
//  FormSingleRadioAndOtherCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FormSingleRadioAndOtherCell.h"
#import "CATPlaceHolderTextView.h"

@interface FormSingleRadioAndOtherCell()<UITextViewDelegate>

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *requiredIcon;

@property (nonatomic ,strong) UIButton *prevBtn;

@property (nonatomic ,strong) CATPlaceHolderTextView *textView;

@end

@implementation FormSingleRadioAndOtherCell

static NSInteger const kAllFormsRadioAndTextCellBtnTag = 650;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = UIColorFromRGB(0x666666);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self.mas_left).offset(15);
        }];
        
        self.requiredIcon = [[UILabel alloc]init];
        self.requiredIcon.font = [UIFont systemFontOfSize:17];
        self.requiredIcon.textColor = UIColorFromRGB(0xff2a2a);
        self.requiredIcon.text = @"*";
        [self addSubview:self.requiredIcon];
        [self.requiredIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        
        self.textView = [[CATPlaceHolderTextView alloc]init];
        self.textView.placeholder = @"请输入";
        self.textView.textColor = UIColorFromRGB(0x333333);
        self.textView.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
        self.textView.layer.borderWidth = 1.0f;
        self.textView.layer.cornerRadius = 7;
        self.textView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        if (LESS_IOS8_2) {
            self.textView.font = [UIFont systemFontOfSize:14];
        }
        self.textView.delegate = self;
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@100).priorityLow();
            make.bottom.equalTo(self.mas_bottom).offset(-15);
        }];
    }
    return self;
}
- (void)setUiModel:(InterviewInputModel *)uiModel
{
    [super setUiModel:uiModel];
    self.titleLabel.text = self.uiModel.title;
    self.textView.placeholder = self.uiModel.otherModel.placeholder;
    self.textView.text = self.uiModel.otherModel.contentStr;
    self.requiredIcon.hidden = !self.uiModel.isRequired;
    self.prevBtn = nil;
    if (!self.uiModel.title || self.uiModel.title.length < 1) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15).priorityHigh();
        }];
    }
    else
    {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.equalTo(@50).priorityHigh();
        }];
    }
    [self.titleLabel setNeedsLayout];
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.tag >= kAllFormsRadioAndTextCellBtnTag) {
            [btn removeFromSuperview];
        }
    }
    NSArray *array = nil;
    if ([self.uiModel.options isNotEmptyArray]) {
       array = [[self.uiModel.options reverseObjectEnumerator] allObjects];
    }
    for (int i = 0; i<array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage yy_imageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage yy_imageWithColor:UIColorFromRGB(0x7fc6f3)] forState:UIControlStateSelected];
        
        [btn sizeToFit];
        
        btn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        btn.layer.borderWidth = 1.0;
        [btn setCornerRadius:15];
        btn.tag = kAllFormsRadioAndTextCellBtnTag + (array.count - i);
        
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        UIView *view = [self viewWithTag:btn.tag+1];
        
        if (view) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.mas_left).offset(-10);
                make.centerY.equalTo(self.titleLabel.mas_centerY);
                make.height.equalTo(@30);
                make.width.equalTo(@(btn.width+20));
            }];
        }
        else
        {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-15);
                make.centerY.equalTo(self.titleLabel.mas_centerY);
                make.height.equalTo(@30);
                make.width.equalTo(@(btn.width+20));
            }];
        }
        if (self.uiModel.contentStr && [self.uiModel.contentStr isEqualToString:btn.titleLabel.text]) {
            [btn setSelectedAndChangeBorderColor:YES];
            self.prevBtn = btn;
        }
    }
}
- (void)btnPressed:(UIButton *)sender
{
    if (self.textView.text.length > 1 &&
        sender.tag > kAllFormsRadioAndTextCellBtnTag+1 &&
        sender.selected ){
        // 输入框有值
    }
    else
    {
        [sender setSelectedAndChangeBorderColor:!sender.selected];
    }
    if (self.prevBtn && self.prevBtn != sender) {
        [self.prevBtn setSelectedAndChangeBorderColor:NO];
    }
    self.prevBtn = sender;
    self.uiModel.contentStr = nil;
    if (sender.selected) {
        self.uiModel.contentStr = sender.titleLabel.text;
        if (sender.tag-kAllFormsRadioAndTextCellBtnTag == 1) {
            self.textView.text = nil;
        }
    }
    self.uiModel.otherModel.contentStr = self.textView.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(formBaseCell:configData:)]) {
        [self.delegate formBaseCell:self configData:self.uiModel];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length < 1) {
        UIButton *btn = [self viewWithTag:kAllFormsRadioAndTextCellBtnTag+1];
        if (!btn.selected) {
            [self btnPressed:btn];
        }
    }
    else
    {
        UIButton *btn = [self viewWithTag:kAllFormsRadioAndTextCellBtnTag+2];
        if (!btn.selected) {
            [self btnPressed:btn];
        }
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.uiModel.otherModel.contentStr = self.textView.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(formBaseCell:configData:)]) {
        [self.delegate formBaseCell:self configData:self.uiModel];
    }
}
@end
