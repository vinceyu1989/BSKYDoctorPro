//
//  BSServiceLogCell.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/31.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSServiceLogCell.h"

@interface BSServiceLogCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation BSServiceLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setServiceLog:(BSServiceLog *)serviceLog {
    _serviceLog = serviceLog;
    
    self.titleLabel.text = serviceLog.serviceTypeWkt;
    self.nameLabel.text = serviceLog.personName;
    if (serviceLog.personSex == 1) {
        self.genderImageView.image = [UIImage imageNamed:@"male"];
    }else if (serviceLog.personSex == 2) {
        self.genderImageView.image = [UIImage imageNamed:@"female"];
    }
    self.ageLabel.text = serviceLog.personAge;
    self.dateLabel.text = serviceLog.serviceLogDate;
}

@end
