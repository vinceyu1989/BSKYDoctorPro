//
//  ResidentSignInfoCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentSignInfoCell.h"

@interface ResidentSignInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *orgLabel;
@property (weak, nonatomic) IBOutlet UILabel *deputyLabel;
@property (weak, nonatomic) IBOutlet UILabel *attnLabel;
@property (weak, nonatomic) IBOutlet UILabel *validityLabel;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;

@end

@implementation ResidentSignInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.signBtn addBorderLine];
}
- (void)setDataModel:(SignContractModel *)dataModel
{
    _dataModel = dataModel;
    self.emptyView.hidden = _dataModel;
    self.orgLabel.text = _dataModel.teamName;
    self.deputyLabel.text = _dataModel.signPerson;
    self.attnLabel.text = _dataModel.createEmp;
    self.validityLabel.text = [NSString stringWithFormat:@"%@ 至 %@",_dataModel.startTime,_dataModel.endTime];
}
- (IBAction)moreBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentSignInfoCellMoreBtnPressed:)]) {
        [self.delegate residentSignInfoCellMoreBtnPressed:self];
    }
    
}
- (IBAction)signBtnPressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(residentSignInfoCellSignBtnPressed:)]) {
        [self.delegate residentSignInfoCellSignBtnPressed:self];
    }
}

@end
