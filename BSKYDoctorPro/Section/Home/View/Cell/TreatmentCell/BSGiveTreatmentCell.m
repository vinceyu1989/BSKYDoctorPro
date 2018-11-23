//
//  BSGiveTreatmentCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/9/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSGiveTreatmentCell.h"

@interface BSGiveTreatmentCell ()

@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personAgeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *personSexImage;
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation BSGiveTreatmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    [self.contentView setCornerRadius:10];
    [self.contentView setCornerShadowColor:[UIColor blackColor]
                                   opacity:0.18
                                    offset:CGSizeZero
                                blurRadius:3];
}

- (void)setModel:(BSStreatmentModel *)model {
    _model = model;
    
    self.personNameLabel.text = model.name;
    self.doctorNameLabel.text = model.doctorame;
    self.personAgeLabel.text = model.age;
    self.timeLabel.text = model.treatmentTime;
    self.resultLabel.text = model.moreAssessment;
    
    if ([model.gender isEqualToString:@"男"]) {
        self.personSexImage.image = [UIImage imageNamed:@"icon_man_disease"];
    } else if ([model.gender isEqualToString:@"女"]) {
        self.personSexImage.image = [UIImage imageNamed:@"icon_women_disease"];
    } else {
        self.personSexImage.image = nil;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
