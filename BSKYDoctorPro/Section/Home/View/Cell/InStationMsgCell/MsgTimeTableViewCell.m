//
//  MsgTimeTableViewCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/8.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "MsgTimeTableViewCell.h"

@interface MsgTimeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation MsgTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.timeLabel setCornerRadius:10];
}

- (void)setMsgTimeInfo:(NSString *)time {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
