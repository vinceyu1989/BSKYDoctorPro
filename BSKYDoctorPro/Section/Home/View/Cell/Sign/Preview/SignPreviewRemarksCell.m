//
//  SignPreviewRemarkCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignPreviewRemarksCell.h"

@interface SignPreviewRemarksCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentsLabel;

@end

@implementation SignPreviewRemarksCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentString:(NSString *)str {
    self.contentsLabel.text = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
