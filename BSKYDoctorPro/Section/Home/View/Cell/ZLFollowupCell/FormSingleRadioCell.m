//
//  FormSingleRadioCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FormSingleRadioCell.h"

@interface FormSingleRadioCell()

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *requiredIcon;

@property (nonatomic ,strong) UIButton *prevBtn;

@end

@implementation FormSingleRadioCell

static NSInteger const kAllFormsRadioCellBtnTag = 650;

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
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(15);
            make.height.equalTo(@50);
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
    }
    return self;
}
- (void)setUiModel:(InterviewInputModel *)uiModel
{
    [super setUiModel:uiModel];
    self.titleLabel.text = self.uiModel.title;
    self.requiredIcon.hidden = !self.uiModel.isRequired;
    self.prevBtn = nil;
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.tag >= kAllFormsRadioCellBtnTag) {
            [btn removeFromSuperview];
        }
    }
    if (![self.uiModel.options isNotEmptyArray]) {
        return;
    }
    CGFloat allBtnWith = 0;
    
    for (NSInteger i = self.uiModel.options.count-1; i >= 0; i--) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.uiModel.options[i] forState:UIControlStateNormal];
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
        btn.tag = kAllFormsRadioCellBtnTag + i;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        allBtnWith = allBtnWith + btn.width+20+10;
        if (self.uiModel.contentStr && [self.uiModel.contentStr isEqualToString:btn.titleLabel.text]) {
            [btn setSelectedAndChangeBorderColor:YES];
            self.prevBtn = btn;
        }
    }
    CGFloat btnMargin = 10;
    [self.titleLabel sizeToFit];
    if (self.width - 30 - self.titleLabel.width - allBtnWith < 0) {
        btnMargin = 5;
    }
    for (NSInteger i = self.uiModel.options.count-1; i >= 0; i--) {
        UIButton *btn = [self viewWithTag:kAllFormsRadioCellBtnTag + i];
        UIView *view = [self viewWithTag:btn.tag+1];
        if (view) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.mas_left).offset(-btnMargin);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@30);
                make.width.equalTo(@(btn.width+20));
            }];
        }
        else
        {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-15);
                make.centerY.equalTo(self.mas_centerY);
                make.height.equalTo(@30);
                make.width.equalTo(@(btn.width+20));
            }];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)btnPressed:(UIButton *)sender
{
    [sender setSelectedAndChangeBorderColor:!sender.selected];
    
    if (self.prevBtn && self.prevBtn != sender) {
        [self.prevBtn setSelectedAndChangeBorderColor:NO];
    }
    self.prevBtn = sender;
    
    NSString *str = nil;
    if (sender.selected) {
        str = sender.titleLabel.text;
    }
    self.uiModel.contentStr = str;
    if (self.delegate && [self.delegate respondsToSelector:@selector(formBaseCell:configData:)]) {
        [self.delegate formBaseCell:self configData:self.uiModel];
    }
}

@end
