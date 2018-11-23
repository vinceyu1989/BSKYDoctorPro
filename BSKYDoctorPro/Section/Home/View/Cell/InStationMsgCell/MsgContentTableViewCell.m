//
//  MsgContentTableViewCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/8.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "MsgContentTableViewCell.h"

@interface MsgContentTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *cashLabel;

@end

@implementation MsgContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    [self.contentView setCornerRadius:10];
    [self.contentView setCornerShadowColor:[UIColor blackColor]
                                   opacity:0.18
                                    offset:CGSizeZero
                                blurRadius:3];
}

- (IBAction)respondeToDetail:(id)sender {
    if (self.block) {
        self.block();
    }
}

- (void)setContentStr:(NSString *)contentStr {
    self.cashLabel.text = [NSString stringWithFormat:@"￥+%@", contentStr];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
