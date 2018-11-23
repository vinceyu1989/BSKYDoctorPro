//
//  SignTagPackPersonInfoCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignTagPackPersonInfoCell.h"

@interface SignTagPackPersonInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDCardLabel;

@property (weak, nonatomic) IBOutlet UILabel *gaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *tangLabel;
@property (weak, nonatomic) IBOutlet UILabel *jingLabel;
@property (weak, nonatomic) IBOutlet UILabel *jieLabel;

@end

@implementation SignTagPackPersonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(PersonColligationModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.ageLabel.text = model.age;
    self.IDCardLabel.text = [NSString idCardStrByReplacingCharactersWithAsterisk:model.cardId];
    if ([model.tG isNotEmptyString]) {
        self.gaoLabel.hidden = NO;
    }
    if ([model.tT isNotEmptyString]) {
        self.tangLabel.hidden = NO;
    }
    if ([model.tJ isNotEmptyString]) {
        self.jingLabel.hidden = NO;
    }
    if ([model.tH isNotEmptyString]) {
        self.jieLabel.hidden = NO;
    }
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
