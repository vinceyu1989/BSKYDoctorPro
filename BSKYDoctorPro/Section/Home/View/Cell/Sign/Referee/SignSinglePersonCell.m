//
//  SignSinglePersonCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignSinglePersonCell.h"

@interface SignSinglePersonCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation SignSinglePersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(SignResidentInfoModel *)model {
    _model = model;
    self.nameLabel.text = _model.name;
    self.idCardLabel.text = [NSString idCardStrByReplacingCharactersWithAsterisk:_model.idcard];
    self.ageLabel.text = _model.age;
    NSString *typeSex = [_model.idcard sexStrFromIdentityCard];
    if ([typeSex isEqualToString:@"1"]) {
        self.genderImage.image = [UIImage imageNamed:@"man"];
    } else if ([typeSex isEqualToString:@"2"]) {
        self.genderImage.image = [UIImage imageNamed:@"women"];
    } else {
        self.genderImage.image = nil;
    }
    self.addressLabel.text = _model.currentAddress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
