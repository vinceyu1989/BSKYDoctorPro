//
//  FollowupResponsibilityDoctorCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FollowupResponsibilityDoctorCell.h"

@interface FollowupResponsibilityDoctorCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgLabel;

@end

@implementation FollowupResponsibilityDoctorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bgView setCornerRadius:5];
    self.bgView.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    self.bgView.layer.borderWidth = 1.0;
    self.orgLabel.text = @"萨哈思考后打开撒谎的卡上的卡";
}
- (void)setDoctorModel:(FollowupDoctorModel *)doctorModel
{
    _doctorModel = doctorModel;
    self.nameLabel.text = _doctorModel.employeeName;
    if (!_doctorModel.telphone || _doctorModel.telphone.length < 1) {
        self.phoneLabel.text = @"- -";
    }
    else
    {
      self.phoneLabel.text = _doctorModel.telphone;
    }
}
- (void)setZlDoctorModel:(ZLDoctorModel *)zlDoctorModel
{
    _zlDoctorModel = zlDoctorModel;
    self.nameLabel.text = _zlDoctorModel.name;
    if (!_zlDoctorModel.tel || _zlDoctorModel.tel.length < 1) {
        self.phoneLabel.text = @"- -";
    }
    else
    {
        self.phoneLabel.text = _zlDoctorModel.tel;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
