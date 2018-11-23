//
//  SignedTextViewCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/12.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "SignedTextViewCell.h"

@implementation SignedTextViewCell

+(CGFloat)cellHeight
{
    return 190;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
    [self.textView setCornerRadius:5];
    self.textView.placeholder = @"请输入驳回理由，不超过200字";
    [self.textView addMaxTextLengthWithMaxLength:200 andEvent:^(BRPlaceholderTextView *text) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
