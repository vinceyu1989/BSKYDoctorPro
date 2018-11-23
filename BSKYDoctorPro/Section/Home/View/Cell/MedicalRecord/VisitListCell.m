//
//  VisitListCell.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "VisitListCell.h"

@interface VisitListCell ()
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deptLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation VisitListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.baseView.layer.cornerRadius = 5;
    self.baseView.layer.borderWidth = 0.5;
    self.baseView.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
    self.deptLabel.numberOfLines = 2;
    self.deptLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(VisitListModel *)model{
    _model = model;
//    self.model.assessment = @"大方大家发大发；；阿开发的啦放假啦会计方法fdlsafldfjeijfiewjfwiejwfldkfdjfeifdkfkdjdidejf的咖啡加肥加大开发健康的减肥撒发生的开房记录是否科斯洛夫到了放假啊了";
    self.nameLabel.text = self.model.name.length ? self.model.name : @"--";
    self.doctorLabel.text = self.model.doctorName.length ? self.model.doctorName : @"--";
    self.deptLabel.text = self.model.assessment.length ? self.model.assessment : @"--";
    self.dateLabel.text = self.model.createTime.length ? [self.model.createTime convertDateStringWithTimeStr:@"yyyy-MM-dd"] : @"--";
    [self.deptLabel sizeToFit];
}
@end
