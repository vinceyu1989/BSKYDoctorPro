//
//  IncomeDetailTableViewCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IncomeDetailTableViewCell.h"

@interface IncomeDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation IncomeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateCellData:(BSBankIncomeDetailModel *)model {
    self.nameLabel.text = model.tradeType;
    self.timeLabel.text = model.tradeDate;
    if ([model.tradeDirection isEqualToString:@"收入"]) {
        self.balanceLabel.textColor = [UIColor colorWithHexString:@"#6eb73e"];
        self.balanceLabel.text = [NSString stringWithFormat:@"￥+%.2f",[model.tradeAmount floatValue]];
    } else if ([model.tradeDirection isEqualToString:@"支出"]) {
        self.balanceLabel.textColor = [UIColor colorWithHexString:@"#ff2a2a"];
        self.balanceLabel.text = [NSString stringWithFormat:@"￥-%.2f",[model.tradeAmount floatValue]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
