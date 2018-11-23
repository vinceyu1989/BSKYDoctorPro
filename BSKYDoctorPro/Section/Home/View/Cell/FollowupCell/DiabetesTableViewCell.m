//
//  DiabetesTableViewCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "DiabetesTableViewCell.h"

@interface DiabetesTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexIcon;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@end

@implementation DiabetesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setModel:(FollowupUserSearchModel *)model
{
    _model = model;
    self.nameLabel.text = _model.name;
    if ([_model.sex isEqualToString:@"女"]) {
        self.sexIcon.image = [UIImage imageNamed:@"female"];
    }
    else
    {
        self.sexIcon.image = [UIImage imageNamed:@"male"];
    }
    self.ageLabel.text = [_model.idCard isIdCard] ? [NSString stringWithFormat:@"%@岁",[_model.idCard getIdentityCardAge]] : @"--";
    if (_model.idCard.length < 15) {
        self.idCardLabel.text = _model.idCard;
    }
    else
    {
        NSValue *rangeValue = [NSValue valueWithRange:NSMakeRange(3, 11)];
        self.idCardLabel.text = [_model.idCard replaceCharactersAtIndexes:@[rangeValue] withString:@"***********"];
    }
    self.adressLabel.text = _model.currentAddress;
    
}
- (void)setZlModel:(ZLSearchPersonalModel *)zlModel
{
    _zlModel = zlModel;
    self.nameLabel.text = _zlModel.name;
    if ([_zlModel.gender isEqualToString:@"2"]) {
        self.sexIcon.image = [UIImage imageNamed:@"female"];
    }
    else
    {
        self.sexIcon.image = [UIImage imageNamed:@"male"];
    }
    self.ageLabel.text = _zlModel.age;
    if (_zlModel.cardId.length < 15) {
        self.idCardLabel.text = _zlModel.cardId;
    }
    else
    {
        NSValue *rangeValue = [NSValue valueWithRange:NSMakeRange(3, 11)];
        self.idCardLabel.text = [_zlModel.cardId replaceCharactersAtIndexes:@[rangeValue] withString:@"***********"];
    }
    self.adressLabel.text = _zlModel.address;
}
    

@end
