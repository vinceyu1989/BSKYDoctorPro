//
//  SignServiceDetailCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignServiceDetailCell.h"

@interface SignServiceDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *baceInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *preLabel;
@end

@implementation SignServiceDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SignSVPackContentModel *)model {
    _model = model;
    self.baceInfoLabel.text = _model.name;
    self.contentLabel.text = _model.remark;
    if ([_model.freCompare containsString:@">"]) {
        self.preLabel.text = [NSString stringWithFormat:@"频次：不少于%@次/年",_model.freNum];
    } else if ([_model.freCompare containsString:@"="]) {
        self.preLabel.text = [NSString stringWithFormat:@"频次：%@次/年",_model.freNum];
    } else if ([_model.freCompare containsString:@"<"]) {
        self.preLabel.text = [NSString stringWithFormat:@"频次：最多%@次/年",_model.freNum];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
