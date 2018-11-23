//
//  SystemMsgTableViewCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/8.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SystemMsgTableViewCell.h"

@interface SystemMsgTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *systemMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SystemMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.systemMsgLabel setCornerRadius:8];
}

- (void)setMsgNumber:(NSString *)num Time:(NSString *)time {
    self.systemMsgLabel.text = num;
    self.systemMsgLabel.hidden = [num integerValue]>0 ? NO : YES;
    self.timeLabel.text = time;
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
