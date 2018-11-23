//
//  SignFamilyPersonCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignFamilyPersonCell.h"

@interface SignFamilyPersonCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation SignFamilyPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setModel:(SignFamilyArchiveModel *)model {
    _model = model;
    self.nameLabel.text = _model.masterName;
    self.phoneLabel.text = [NSString idCardStrByReplacingCharactersWithAsterisk:_model.telNumber];
    self.codeLabel.text = _model.familyCode;
    self.addressLabel.text = _model.familyAddress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
