//
//  VisitDetailBaseCell.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "VisitDetailBaseCell.h"

@interface VisitDetailBaseCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *deptLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end

@implementation VisitDetailBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(210);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(VisitDetailModel *)model{
    _model = model;
    self.nameLabel.text = self.model.basicInfoDTO.personName.length ? self.model.basicInfoDTO.personName : @"--";
    self.ageLabel.text = self.model.basicInfoDTO.age.length ? self.model.basicInfoDTO.age : @"--";
    self.genderLabel.text = self.model.basicInfoDTO.sex.length ? self.model.basicInfoDTO.sex : @"--";
    self.deptLabel.text = self.model.basicInfoDTO.deptName.length ? self.model.basicInfoDTO.deptName : @"--";
    self.doctorLabel.text = self.model.basicInfoDTO.doctorName.length ? self.model.basicInfoDTO.doctorName : @"--";
    
}
@end
