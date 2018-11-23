//
//  AllFormsRadioAndTextCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AllFormsRadioAndTextCell.h"
#import "CATPlaceHolderTextView.h"

@interface AllFormsRadioAndTextCell()<UITextViewDelegate>

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UIView *line;

@property (nonatomic ,strong) UIButton *prevBtn;

@property (nonatomic ,strong) CATPlaceHolderTextView *textView;

@end

@implementation AllFormsRadioAndTextCell

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
            make.height.equalTo(@50);
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
        }];
        
        self.line = [[UIView alloc]init];
        self.line.backgroundColor = UIColorFromRGB(0xededed);
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.bottom.right.equalTo(self);
            make.top.equalTo(self.textView.mas_bottom).offset(15);
            make.height.equalTo(@(0.5));
        }];
    }
    return self;
}
- (void)setModel:(InterviewInputModel*)model
{
    _model = model;
    self.titleLabel.text = _model.title;
    self.textView.placeholder = [NSString stringWithFormat:@"请输入%@",_model.title];
    self.textView.text = _model.object;
    self.prevBtn = nil;
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.tag >= kAllFormsRadioAndTextCellBtnTag) {
            [btn removeFromSuperview];
        }
    }
    if (![model.options isNotEmptyArray]) {
        return;
    }
    NSArray *array = [[_model.options reverseObjectEnumerator] allObjects];
    
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
        btn.tag = kAllFormsRadioAndTextCellBtnTag + (array.count - i-1);
        
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
        if (_model.contentStr.integerValue > 0 && log2(_model.contentStr.integerValue) == array.count - i-1) {
            [btn setSelectedAndChangeBorderColor:YES];
            self.prevBtn = btn;
        }
    }
}
- (void)btnPressed:(UIButton *)sender
{
    if (self.textView.text.length > 1 &&
        sender.tag > kAllFormsRadioAndTextCellBtnTag &&
        sender.selected ){
        // 输入框有值
        return;
    }
    [sender setSelectedAndChangeBorderColor:!sender.selected];
    
    if (self.prevBtn && self.prevBtn != sender) {
        [self.prevBtn setSelectedAndChangeBorderColor:NO];
    }
    self.prevBtn = sender;
    
    NSString *str = @"";
    NSInteger index = -100;
    
    if (sender.selected) {
        str = sender.titleLabel.text;
        index = sender.tag - kAllFormsRadioAndTextCellBtnTag;
        index = (NSInteger)pow(2, index);
    }
    self.model.contentStr = [NSString stringWithFormat:@"%ld",(long)index];
    [self configUpModelWithIndex:index];
}
- (void)configUpModelWithIndex:(NSInteger)index
{
    NSString *str = nil;
    NSNumber *num = nil;
    if (index >= 0) {
        str = [NSString stringWithFormat:@"%ld",(long)index];
        num = @(index);
    }
    if ([self.model.title isEqualToString:@"药物不良反应"])
    {
        if (index == 1) {  // 选择无
            self.textView.text = nil;
            [self addOtherAdverseDrugReactionsWithStr:self.textView.text];
        }
        self.upModel.cmModel.adverseDrugReactions = str;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.model.object = textView.text;
    if ([self.model.title isEqualToString:@"药物不良反应"])
     {
        [self addOtherAdverseDrugReactionsWithStr:textView.text];
     }
     else if ([self.model.title isEqualToString:@"随访结局(非必填)"])
     {
        self.upModel.cmModel.followUpRemarks = textView.text;
     }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.model.title isEqualToString:@"药物不良反应"]){
        if (textView.text.length < 1) {
            UIButton *btn = [self viewWithTag:kAllFormsRadioAndTextCellBtnTag];
            if (!btn.selected) {
                [self btnPressed:btn];
            }
        }
        else
        {
            UIButton *btn = [self viewWithTag:kAllFormsRadioAndTextCellBtnTag+1];
            if (!btn.selected) {
                [self btnPressed:btn];
            }
        }
    }
}
#pragma mark ----- 添加OtherModel
- (void)addOtherAdverseDrugReactionsWithStr:(NSString *)str
{
    BOOL isHave = NO;
    NSInteger index = -1;
    for (Other *otherModel in self.upModel.other) {
        if ([otherModel.attrName isEqualToString:@"AdverseDrugReactions"]) {
            if (!str || str.length < 1) {
                index = [self.upModel.other indexOfObject:otherModel];
            }
            else
            {
                otherModel.otherText = str;
            }
            isHave = YES;
            break;
        }
    }
    if (index >= 0) {
        [self.upModel.other removeObjectAtIndex:index];
    }
    if (!isHave && str.length > 0) {
        Other *otherModel = [[Other alloc]init];
        otherModel.attrName = @"AdverseDrugReactions";
        otherModel.otherText = str;
        [self.upModel.other addObject:otherModel];
    }
}


@end
