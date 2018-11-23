//
//  DiseaseSelectedCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "DiseaseSelectedCell.h"

@implementation DiseaseSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.cornerRadius = 7.5;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
    self.contentView.backgroundColor = UIColorFromRGB(0xedfaff);
    self.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.titleLabel.backgroundColor = [UIColor  redColor];
}
- (void)setModel:(ZLDiseaseModel *)model{
    _model = model;
    
    self.titleLabel.text = _model.name;
//    [self.titleLabel sizeToFit];
//    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.width.mas_equalTo(self.titleLabel.width);
//        make.height.mas_equalTo(self.titleLabel.height);
//        make.centerY.equalTo(self);
//    }];
}
- (IBAction)deleteAction:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.model);
    }
}

@end
