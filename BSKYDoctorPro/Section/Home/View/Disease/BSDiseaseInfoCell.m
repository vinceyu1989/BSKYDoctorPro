//
//  BSDiseaseInfoCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/8/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSDiseaseInfoCell.h"

@interface BSDiseaseInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *dangerLabel;
@property (weak, nonatomic) IBOutlet UIButton *followupBtn;

@end

@implementation BSDiseaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    [self.contentView setCornerRadius:10];
    [self.contentView setCornerShadowColor:[UIColor blackColor]
                                   opacity:0.18
                                    offset:CGSizeZero
                                blurRadius:3];
    [self.followupBtn setAttributedTitle:[self attributedStringWithString:@"随访记录>" obj:self.followupBtn]
                                forState:UIControlStateNormal];
    
    [self.followupBtn setEnlargeEdge:10];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(BSDiseaseInfoModel *)model {
    _model = model;
    self.nameLabel.text = model.NAME;
    self.ageLabel.text = model.Age;
    self.timeLabel.text = model.DIAGNOSIS_DATE;
    self.levelLabel.text = model.strHyLevel;
    self.dangerLabel.text = model.strHyRisk;
    self.lastTimeLabel.text = model.LastHlDate;
    self.doctorLabel.text = model.DOCTOR_NAME;
    if ([model.Gender isEqualToString:@"男"]) {
        self.sexImageView.image = [UIImage imageNamed:@"icon_man_disease"];
    } else if ([model.Gender isEqualToString:@"女"]) {
        self.sexImageView.image = [UIImage imageNamed:@"icon_women_disease"];
    } else {
        self.sexImageView.image = nil;
    }
    if ([model.Telphone isNotEmptyString]) {
        [self.phoneBtn setAttributedTitle:[self attributedStringWithString:model.Telphone obj:self.phoneBtn]
                                 forState:UIControlStateNormal];
        [self.phoneBtn setEnlargeEdge:10];
    } else {
        [self.phoneBtn setTitle:@"-" forState:UIControlStateNormal];
    }
    
}

- (IBAction)phoneBtnPressed:(id)sender {
    if (self.block) {
        self.block(self.model,@"电话");
    }
}

- (IBAction)followupBtnPressed:(id)sender {
    if (self.block) {
        self.block(self.model,@"随访");
    }
}

- (NSMutableAttributedString *)attributedStringWithString:(NSString *)str obj:(UIButton *)btn {
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName
                  value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                  range:titleRange];
    [title addAttribute:NSUnderlineColorAttributeName
                  value:btn.titleLabel.textColor
                  range:titleRange];
    return title;
}

@end
