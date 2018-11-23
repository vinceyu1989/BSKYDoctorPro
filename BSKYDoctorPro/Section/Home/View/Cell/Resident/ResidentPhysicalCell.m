//
//  ResidentPhysicalCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentPhysicalCell.h"

@interface ResidentPhysicalCell()

@property (weak, nonatomic) IBOutlet UILabel *latestLabel;
@property (weak, nonatomic) IBOutlet UILabel *perfectLabel;
@property (weak, nonatomic) IBOutlet UIButton *examineBtn;
@property (weak, nonatomic) IBOutlet UIButton *perfectBtn;
//@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@end

@implementation ResidentPhysicalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.examineBtn.hidden = YES;
    self.perfectBtn.hidden = YES;
//    [self.examineBtn addUnderLine];
//    [self.perfectBtn addUnderLine];
//    [self.addBtn addBorderLine];
}
- (void)setModel:(PersonColligationModel *)model
{
    _model = model;
    self.latestLabel.text = _model.lastTime;
    self.perfectLabel.text = _model.hmperfect;
    if ([_model.hmperfect isEqualToString:@"完善"]) {
        self.perfectLabel.textColor = UIColorFromRGB(0x58bc00);
    }
    else
    {
        self.perfectLabel.textColor = UIColorFromRGB(0xff2a2a);
    }
}

- (IBAction)examineBtnPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentPhysicalCellExamineBtnPressed:)]) {
        [self.delegate residentPhysicalCellExamineBtnPressed:self];
    }
}
- (IBAction)perfectBtnPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentPhysicalCellPerfectBtnPressed:)]) {
        [self.delegate residentPhysicalCellPerfectBtnPressed:self];
    }
    
}
//- (IBAction)addBtnPressed:(UIButton *)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(residentPhysicalCellAddBtnPressed:)]) {
//        [self.delegate residentPhysicalCellAddBtnPressed:self];
//    }
//}

@end
