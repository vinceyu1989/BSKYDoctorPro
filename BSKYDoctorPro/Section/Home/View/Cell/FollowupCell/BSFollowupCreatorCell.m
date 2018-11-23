//
//  BSFollowupCreatorCell.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowupCreatorCell.h"

@interface BSFollowupCreatorCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn11;
@property (weak, nonatomic) IBOutlet UIButton *btn12;
@property (weak, nonatomic) IBOutlet UIButton *btn21;
@property (weak, nonatomic) IBOutlet UIButton *btn22;

@end

@implementation BSFollowupCreatorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.btn11.layer.cornerRadius = 7;
    self.btn11.layer.borderWidth = .5f;
    self.btn11.layer.borderColor = UIColorFromRGB(0xbddcff).CGColor;
    self.btn12.layer.cornerRadius = 7;
    self.btn12.layer.borderWidth = .5f;
    self.btn12.layer.borderColor = UIColorFromRGB(0xbddcff).CGColor;
    self.btn21.layer.cornerRadius = 7;
    self.btn21.layer.borderWidth = .5f;
    self.btn21.layer.borderColor = UIColorFromRGB(0xbddcff).CGColor;
    self.btn22.layer.cornerRadius = 7;
    self.btn22.layer.borderWidth = .5f;
    self.btn22.layer.borderColor = UIColorFromRGB(0xbddcff).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - UI Actions

- (IBAction)onDiabetes:(id)sender {
    if (self.diabetesBlock) {
        self.diabetesBlock();
    }
}

- (IBAction)onHypertension:(id)sender {
    if (self.hypertensionBlock) {
        self.hypertensionBlock();
    }
}

- (IBAction)onHighGlucose:(id)sender {
    if (self.highGlucoseBlock) {
        self.highGlucoseBlock();
    }
}

- (IBAction)onMentalDisease:(id)sender {
    if (self.mentalDiseaseBlock) {
        self.mentalDiseaseBlock();
    }
}

@end
