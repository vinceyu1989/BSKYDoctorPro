//
//  VisitDetailRecordCell.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "VisitDetailRecordCell.h"

@interface VisitDetailRecordCell ()
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *subjectiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *diseaseHistoryLabel;

@end

@implementation VisitDetailRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.diseaseHistoryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.diseaseHistoryLabel.numberOfLines = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(VisitDetailModel *)model{
    _model = model;
    self.subjectiveLabel.text = self.model.basicInfoDTO.subjective.length ? self.model.basicInfoDTO.subjective : @"--";
//    NSString *str = @"大方大家发大发；；阿开发的啦放假啦会计方法fdlsafldfjeijfiewjfwiejwfldkfdjfeifdkfkdjdidejf的咖啡加肥加大开发健康的减肥撒发生的开房记录是否科斯洛夫到了放假啊了";
//    self.diseaseHistoryLabel.text = test;
    NSString *str = self.model.basicInfoDTO.diseaseHistory.length ? self.model.basicInfoDTO.diseaseHistory : @"--";
    self.diseaseHistoryLabel.text = str;
    [self.diseaseHistoryLabel sizeToFit];
}
@end
