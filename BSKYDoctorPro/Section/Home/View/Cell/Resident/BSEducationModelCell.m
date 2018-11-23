//
//  BSEducationModelCell.m
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSEducationModelCell.h"

@interface BSEducationModelCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *syscleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eduTypeLabel;

@end

@implementation BSEducationModelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
}

- (void)setModel:(BSEduHealthContentModel *)model {
    self.titleLabel.text = model.Title;
    self.syscleLabel.text = [model.LifeCycleName isNotEmpty] ? model.LifeCycleName : @"暂无";
    self.eduTypeLabel.text = [model.KnowledgeTypeName isNotEmpty] ? model.KnowledgeTypeName : @"暂无";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
