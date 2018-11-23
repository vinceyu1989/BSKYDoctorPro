//
//  ResidentListCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentListCell.h"

@interface ResidentListCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIView  *iconsView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *filePerfectLabel;
@property (weak, nonatomic) IBOutlet UILabel *examinationTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *examinationPerfectLabel;    //体检完善状态
@property (weak, nonatomic) IBOutlet UILabel *healthCardLabel;   // 健康卡
@property (weak, nonatomic) IBOutlet UILabel *fileNumberLabel;   // 档案编号
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;     // 自定义编号

@property (strong, nonatomic) UIImageView *tempIcon;

@end

@implementation ResidentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bgView setCornerRadius:7.5];
    self.bgView.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setModel:(PersonColligationModel *)model
{
    _model = model;
    self.nameLabel.text = _model.name;
    self.sexLabel.text = _model.gender;
    self.ageLabel.text = _model.age;
    self.idCardLabel.text = [_model.cardId secretStrFromIdentityCard];
    self.phoneLabel.text = [_model.telphone secretStrFromPhoneStr];
    self.fileStatusLabel.text = _model.hrStatus;
    self.filePerfectLabel.text = _model.sophistication;
    self.fileNumberLabel.text = _model.personCode;
    self.addressLabel.text = _model.address;
    self.numberLabel.text = _model.customNumber;
    if ([_model.sophistication isEqualToString:@"完善"]) {
        self.filePerfectLabel.textColor = UIColorFromRGB(0x58bc00);
    }
    else
    {
        self.filePerfectLabel.textColor = UIColorFromRGB(0xff2a2a);
    }
    self.examinationTimeLabel.text = _model.lastTime;
    self.examinationPerfectLabel.text = _model.hmperfect;
    if ([_model.hmperfect isEqualToString:@"完善"]) {
        self.examinationPerfectLabel.textColor = UIColorFromRGB(0x58bc00);
    }
    else
    {
        self.examinationPerfectLabel.textColor = UIColorFromRGB(0xff2a2a);
    }
    NSMutableArray *iconArray = [NSMutableArray array];
    if ([_model.tH isNotEmptyString]) {
        [iconArray addObject:@"icon_jieTag"];
    }
    if ([_model.tJ isNotEmptyString]) {
        [iconArray addObject:@"icon_jingTag"];
    }
    if ([_model.tT isNotEmptyString]) {
        [iconArray addObject:@"icon_tangTag"];
    }
    if ([_model.tG isNotEmptyString]) {
        [iconArray addObject:@"icon_gaoTag"];
    }
    self.tempIcon = nil;
    [self.iconsView removeAllSubviews];
    for (int i = 0; i<iconArray.count; i++) {
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconArray[i]]];
        [icon sizeToFit];
        [self.iconsView addSubview:icon];
        if (self.tempIcon) {
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.tempIcon.mas_left).offset(-5);
                make.centerY.equalTo(self.tempIcon.mas_centerY);
            }];
        }
        else
        {
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.iconsView.mas_right).offset(-5);
                make.centerY.equalTo(self.iconsView.mas_centerY);
            }];
        }
        self.tempIcon = icon;
    }
    switch (_model.healthCardState.integerValue) {
        case HealthCardStateUnclaimed:
            self.healthCardLabel.text = @"未申领";
            self.healthCardLabel.textColor = UIColorFromRGB(0xff2a2a);
            break;
        case HealthCardStateInactivated:
            self.healthCardLabel.text = @"未激活";
            self.healthCardLabel.textColor = UIColorFromRGB(0xff9000);
            break;
        case HealthCardStateActivated:
            self.healthCardLabel.text = @"已激活";
            self.healthCardLabel.textColor = UIColorFromRGB(0x58bc00);
            break;
        default:
            self.healthCardLabel.text = nil;
            break;
    }
    
}

@end
