//
//  FormBoldTitleCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FormBoldTitleCell.h"

@interface FormBoldTitleCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FormBoldTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setUiModel:(InterviewInputModel *)uiModel
{
    [super setUiModel:uiModel];
    self.titleLabel.text = self.uiModel.title;
}

@end
