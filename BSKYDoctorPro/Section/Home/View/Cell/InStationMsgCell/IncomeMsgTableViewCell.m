//
//  IncomeMsgTableViewCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IncomeMsgTableViewCell.h"

@interface IncomeMsgTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numberMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation IncomeMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.numberMsgLabel setCornerRadius:8];
}

- (void)setMsgNumber:(NSString *)num Time:(NSString *)time {
    self.numberMsgLabel.text = num;
    self.numberMsgLabel.hidden = [num integerValue]>0 ? NO : YES;
    self.timeLabel.text = time;
}

@end
