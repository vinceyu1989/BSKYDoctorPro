//
//  ArchiveFamilyListCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveFamilyListCell.h"
#import "FamilyInfoView.h"

@interface ArchiveFamilyListCell()

@property (strong, nonatomic) FamilyInfoView *infoView;

@end

@implementation ArchiveFamilyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.infoView];
    self.infoView.layer.cornerRadius = 5;
    self.infoView.layer.borderWidth = 0.5;
    self.infoView.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(@0);
        make.bottom.mas_equalTo(-10);
    }];
    // Initialization code
}
- (FamilyInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[[NSBundle mainBundle] loadNibNamed:@"FamilyInfoView" owner:nil options:nil] firstObject];
    }
    return _infoView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(FamilyListModel *)model{
    _model = model;
    [self.infoView setModel:_model];
    [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(114);
    }];
    
}
@end
