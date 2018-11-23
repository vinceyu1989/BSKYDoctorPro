//
//  AllFormsRadioCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AllFormsRadioCell.h"

@interface AllFormsRadioCell()

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *waringLabel;

@property (nonatomic ,strong) UIView *line;

@property (nonatomic ,strong) UIButton *prevBtn;

@end

@implementation AllFormsRadioCell

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
        
        self.waringLabel = [[UILabel alloc]init];
        self.waringLabel.font = [UIFont systemFontOfSize:17];
        self.waringLabel.textColor = UIColorFromRGB(0xff2a2a);
        self.waringLabel.text = @"*";
        [self addSubview:self.waringLabel];
        [self.waringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        
        self.line = [[UIView alloc]init];
        self.line.backgroundColor = UIColorFromRGB(0xededed);
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.bottom.right.equalTo(self);
            make.height.equalTo(@(0.5));
        }];
    }
    return self;
}
- (void)setModel:(InterviewInputModel*)model
{
    _model = model;
    self.titleLabel.text = _model.title;
    self.waringLabel.hidden = !_model.isRequired;
    self.prevBtn = nil;
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.tag >= kAllFormsRadioCellBtnTag) {
            [btn removeFromSuperview];
        }
    }
    if (![model.options isNotEmptyArray]) {
        return;
    }
    CGFloat allBtnWith = 0;
    
    for (NSInteger i = _model.options.count-1; i >= 0; i--) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_model.options[i] forState:UIControlStateNormal];
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
        if (_model.contentStr.integerValue > 0 && log2(_model.contentStr.integerValue) == i) {
            [btn setSelectedAndChangeBorderColor:YES];
            self.prevBtn = btn;
        }
    }
    CGFloat btnMargin = 10;
    [self.titleLabel sizeToFit];
    if (self.width - 30 - self.titleLabel.width - allBtnWith < 0) {
        btnMargin = 5;
    }
    for (NSInteger i = _model.options.count-1; i >= 0; i--) {
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
    
    NSString *str = @"";
    NSInteger index = -100;
    
    if (sender.selected) {
        str = sender.titleLabel.text;
        index = sender.tag - kAllFormsRadioCellBtnTag;
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
    if ([self.model.title isEqualToString:@"随访方式"])
    {
        self.upModel.cmModel.wayUp = str;
    }
    else if ([self.model.title isEqualToString:@"足背动脉搏动"])
    {
        self.upModel.body.dorsalisPedisArteryPulse = str;
    }
    else if ([self.model.title isEqualToString:@"听力"])
    {
        self.upModel.organ.hearing = num;
    }
    else if ([self.model.title isEqualToString:@"运动"])
    {
        self.upModel.organ.motorFunction = num;
    }
    else if ([self.model.title isEqualToString:@"心理调整"])
    {
        self.upModel.cmModel.psychologicalAdjustment = num;
    }
    else if ([self.model.title isEqualToString:@"遵医行为"])
    {
        self.upModel.cmModel.complianceBehavior = num;
    }
    else if ([self.model.title isEqualToString:@"服药依从性"])
    {
        self.upModel.cmModel.medicationCompliance = num;
    }
    else if ([self.model.title isEqualToString:@"高血压服药依从性"])
    {
        self.upModel.cmModel.hyMedicationCompliance = num;
    }
    else if ([self.model.title isEqualToString:@"糖尿病服药依从性"])
    {
        self.upModel.cmModel.dbMedicationCompliance = num;
    }
    else if ([self.model.title isEqualToString:@"低血糖反应"])
    {
        self.upModel.cmModel.lowBloodSugarReactions = str;
    }
    else if ([self.model.title isEqualToString:@"摄盐情况"])
    {
        self.upModel.cmModel.saltIntake = str;
    }
    else if ([self.model.title isEqualToString:@"目标摄盐情况"])
    {
        self.upModel.cmModel.nextSaltIntake = str;
    }
}

@end
