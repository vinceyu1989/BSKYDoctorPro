//
//  PatientListCell.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "PatientListCell.h"
@interface PatientListCell ()
@property (weak, nonatomic) IBOutlet UILabel *cardIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *deptLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end

@implementation PatientListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.baseView.layer.cornerRadius = 5;
    self.baseView.layer.borderWidth = 0.5;
    self.baseView.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(PatientListModel *)model{
    _model = model;
    self.cardIdLabel.text = self.model.cardId.length ? [self.model.cardId secretStrFromIdentityCard] : @"--";
    self.nameLabel.text = self.model.personName.length ? self.model.personName : @"--";
    self.genderLabel.text = self.model.sex.length ? self.model.sex : @"--";
    NSString *age = self.model.cardId.length ? [self.model.cardId getIdentityCardAge] : @"";
    self.ageLabel.text = age.length ? [NSString stringWithFormat:@"%@岁",age] : (self.model.age.length ? self.model.age : @"--");
    self.doctorLabel.text = self.model.doctorName.length ? self.model.doctorName : @"--";
    self.deptLabel.text = self.model.deptName.length ? self.model.deptName : @"--";
}
@end
