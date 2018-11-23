//
//  ResidentChineseMedicineCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentChineseMedicineCell.h"

@interface ResidentChineseMedicineCell()
@property (weak, nonatomic) IBOutlet UILabel *latestLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *guideLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation ResidentChineseMedicineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.detailBtn addUnderLine];
    [self.addBtn addBorderLine];
}
- (void)setModel:(ResidentZhongYiModel *)model
{
    _model = model;
    self.latestLabel.text = [_model.followUpDate isNotEmptyString] ? _model.followUpDate : kModelEmptyString;
    self.nextTimeLabel.text = [_model.nextFollowUpDate isNotEmptyString] ? _model.nextFollowUpDate : kModelEmptyString;
    self.guideLabel.text = [_model.tcHealthGuide isNotEmptyString] ? _model.tcHealthGuide : kModelEmptyString;
}

- (IBAction)detailBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentChineseMedicineCellExamineBtnPressed:)]) {
        [self.delegate residentChineseMedicineCellExamineBtnPressed:self];
    }
    
}
- (IBAction)addBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentChineseMedicineCellAddBtnPressed:)]) {
        [self.delegate residentChineseMedicineCellAddBtnPressed:self];
    }
}

@end
