//
//  ResidentHealthEduCell.m
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentHealthEduCell.h"

@interface ResidentHealthEduCell ()

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation ResidentHealthEduCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.addBtn addBorderLine];
}

- (IBAction)respondesToAdd:(id)sender {
    if (self.addNewHealthEduBlcok) {
        self.addNewHealthEduBlcok();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
