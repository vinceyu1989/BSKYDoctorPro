//
//  SignRemarkCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "SignRemarkCell.h"
#import "BSZYInputTextView.h"

@interface SignRemarkCell ()

@property (weak, nonatomic) IBOutlet BSZYInputTextView *inputTextView;

@end

@implementation SignRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    WS(weakSelf);
    [self.inputTextView setBlock:^(NSString *text) {
        if (weakSelf.textBlock) {
            weakSelf.textBlock(text);
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
