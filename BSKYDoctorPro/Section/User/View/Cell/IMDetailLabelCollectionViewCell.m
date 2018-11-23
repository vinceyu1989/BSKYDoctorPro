//
//  IMDetailLabelCollectionViewCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMDetailLabelCollectionViewCell.h"
@interface IMDetailLabelCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation IMDetailLabelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.cornerRadius = 2;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = UIColorFromRGB(0xcad1d6).CGColor;
    self.contentView.backgroundColor = [UIColor whiteColor];
}
- (void)setOption:(ArchiveSelectOptionModel *)option{
    _option = option;
    self.titleLabel.text = option.lebel;
    
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected){
        self.contentView.backgroundColor = UIColorFromRGB(0xe2f1ff);
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
}
@end
