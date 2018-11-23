//
//  IMRemarkCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/15.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMRemarkCell.h"

@interface IMRemarkCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation IMRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.text = @"备注名";
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.remarkLabel.textColor = UIColorFromRGB(0x333333);
//    self.titleLabel.text = @"备注";
    self.remarkLabel.font = [UIFont systemFontOfSize:14];
    self.remarkLabel.textAlignment = NSTextAlignmentRight;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setRemark:(NSString *)remark{
    _remark = remark;
    if (remark.length) {
        self.remarkLabel.text = remark;
    }else{
        self.remarkLabel.text = @"暂无";
    }
    
}
@end
