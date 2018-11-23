//
//  AuxiliaryCheckSectionCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AuxiliaryCheckSectionCell.h"

@interface AuxiliaryCheckSectionCell()

@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AuxiliaryCheckSectionCell

+(CGFloat)cellHeight
{
    return 50;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.enterBtn setImage:[UIImage imageNamed:@"未勾选"] forState:UIControlStateNormal];
    [self.enterBtn setImage:[UIImage imageNamed:@"勾"] forState:UIControlStateSelected];
//    [self.enterBtn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setModel:(AuxiliaryCheckSectionModel *)model
{
    _model = model;
    self.titleLabel.text = _model.title;
    self.selectIcon.image = _model.isExpansion ? [UIImage imageNamed:@"收起"] : [UIImage imageNamed:@"展开"];
    self.enterBtn.selected = !_model.isEmpty;
    
}
//- (void)btnPressed
//{
//    if (self.model.isEmpty) {
//        self.enterBtn.selected = NO;
//        return;
//    }
//    self.enterBtn.selected = !self.enterBtn.selected;
//    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(auxiliaryCheckSectionCell:select:)]) {
//        [self.delegate auxiliaryCheckSectionCell:self select:self.enterBtn.selected];
//    }
//}

@end
