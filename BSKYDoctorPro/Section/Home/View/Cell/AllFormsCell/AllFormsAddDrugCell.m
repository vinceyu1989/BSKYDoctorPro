//
//  AllFormsAddDrugCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AllFormsAddDrugCell.h"

@interface AllFormsAddDrugCell()


@end

@implementation AllFormsAddDrugCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addBtnPressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(allFormsAddDrugCellAddClick:)]) {
        [self.delegate allFormsAddDrugCellAddClick:self];
    }
}

@end
