//
//  FormBaseCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FormBaseCell.h"

@implementation FormBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setUiModel:(InterviewInputModel *)uiModel
{
    _uiModel = uiModel;
}

@end
