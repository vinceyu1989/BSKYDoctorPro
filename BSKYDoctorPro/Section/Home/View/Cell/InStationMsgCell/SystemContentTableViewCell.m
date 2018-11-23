//
//  SystemContentTableViewCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SystemContentTableViewCell.h"

@interface SystemContentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *msgContentLabel;

@end

@implementation SystemContentTableViewCell

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

- (void)setContentStr:(NSString *)contentStr {
    self.msgContentLabel.text = contentStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
