//
//  DiseaseCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "DiseaseCell.h"

@implementation DiseaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(ZLDiseaseModel *)model{
    _model = model;
    if (model != nil) {
        self.titleLabel.text = _model.name;
        self.codeLabel.text = _model.code;
        self.titleLabel.textColor = UIColorFromRGB(0x4e7dd3);
    }else{
        self.titleLabel.textColor = UIColorFromRGB(0x333333);
        self.titleLabel.text = @"搜索结果";
        self.codeLabel.text = @"";
    }
    
}
@end
