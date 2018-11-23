//
//  FormSectionCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/1.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FormSectionCell.h"

@interface FormSectionCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *requiredIcon;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIButton * btn;

@end

@implementation FormSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.backgroundColor = [UIColor clearColor];
    [self.btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.iconImageView);
        make.height.equalTo(self.contentView.mas_height);
        make.width.equalTo(@100);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setUiModel:(InterviewInputModel *)uiModel
{
    [super setUiModel:uiModel];
    self.titleLabel.text = self.uiModel.title;
    self.requiredIcon.hidden = !self.uiModel.isRequired;
    if ([self.uiModel.contentStr isNotEmptyString]) {
        self.iconImageView.hidden = NO;
        self.btn.enabled = YES;
        self.iconImageView.image = [UIImage imageNamed:self.uiModel.contentStr];
        [self.iconImageView sizeToFit];
    }
    else
    {
        self.btn.enabled = NO;
        self.iconImageView.hidden = YES;
    }
}
- (void)btnPressed:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(formBaseCell:configData:)]) {
        [self.delegate formBaseCell:self configData:self.uiModel];
    }
}

@end
