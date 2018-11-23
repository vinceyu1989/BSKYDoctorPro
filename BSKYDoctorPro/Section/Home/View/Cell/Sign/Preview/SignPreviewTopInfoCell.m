//
//  SignPreviewTopInfoCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignPreviewTopInfoCell.h"

@interface SignPreviewTopInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *refereeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end

@implementation SignPreviewTopInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(SignInfoRequestModel *)model {
    _model = model;
    self.channelLabel.text = _model.channel;
    self.refereeLabel.text = _model.signPerson;
    self.startLabel.text = _model.startTime;
    self.endLabel.text = _model.endTime;
}

- (void)setTeamName:(NSString *)teamName TeamEmpName:(NSString *)teamEmpName {
    self.nameLabel.text = teamName;
    self.handleLabel.text = teamEmpName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
