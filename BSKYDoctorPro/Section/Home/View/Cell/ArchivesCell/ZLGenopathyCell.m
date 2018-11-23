//
//  ZLGenopathyCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLGenopathyCell.h"
@interface ZLGenopathyCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZLGenopathyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.cornerRadius = 2.5;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = UIColorFromRGB(0xdbdbdb).CGColor;
    self.contentView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.titleLabel.font = [UIFont systemFontOfSize:14];
}
- (void)setModel:(ZLDiseaseModel *)model{
    _model = model;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = _model.name;
}
@end
