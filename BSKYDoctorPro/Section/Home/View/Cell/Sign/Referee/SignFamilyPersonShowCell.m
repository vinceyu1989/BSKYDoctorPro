//
//  SignFamilyPersonShowCell.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignFamilyPersonShowCell.h"

@interface SignFamilyPersonShowCell ()

@property (weak, nonatomic) IBOutlet UILabel  *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UILabel  *relationLabel;
@property (weak, nonatomic) IBOutlet UILabel  *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel  *idCardLabel;
@property (weak, nonatomic) IBOutlet UIButton *isSelectedBtn;
@property (weak, nonatomic) IBOutlet UILabel  *fileTypeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLaout;

@end 

@implementation SignFamilyPersonShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.relationLabel.layer.borderColor = [UIColor colorWithHexString:@"#00AAFF"].CGColor;
    self.relationLabel.layer.borderWidth = 1;
}

- (void)setModel:(SignFamilyMembersModel *)model {
    _model = model;
    self.nameLabel.text = _model.name;
    NSString *typeSex = [_model.genderCode sexStrFromIdentityCard];
    if ([typeSex isEqualToString:@"1"]) {
        self.genderImage.image = [UIImage imageNamed:@"man"];
    } else if ([typeSex isEqualToString:@"2"]) {
        self.genderImage.image = [UIImage imageNamed:@"women"];
    } else {
        self.genderImage.image = nil;
    }
    self.ageLabel.text = _model.age;
    self.idCardLabel.text = [NSString idCardStrByReplacingCharactersWithAsterisk:_model.cardID];
    if ([_model.hrStatus isEqualToString:@"活动"] || _model.hrStatus.length == 0) {
        self.isSelectedBtn.enabled = YES;
        self.fileTypeLabel.hidden = YES;
    } else {
        self.isSelectedBtn.enabled = NO;
        self.fileTypeLabel.hidden = NO;
        self.fileTypeLabel.text = _model.hrStatus;
    }
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.fileTypeLabel.hidden == NO &&
        self.relationLabel.hidden == self.fileTypeLabel.hidden) {
        self.widthLaout.constant = 60.f;
    } else {
        self.widthLaout.constant = 10.f;
    }
}

- (void)setCellDataWithHead:(BOOL)isHead selectEnable:(BOOL)enable {
    self.relationLabel.hidden = !isHead;
//    self.isSelectedBtn.enabled = enable;
}

- (NSString *)returnHrStatusWithStatus:(NSInteger )status {
    switch (status) {
        case 1:
            return @"迁出";
        case 2:
            return @"死亡";
        case 3:
            return @"其他";
        case 99:
            return @"已删除";
    }
    return @"未知";
}

- (IBAction)isSelectedPressed:(id)sender {
    self.isSelectedBtn.selected = !self.isSelectedBtn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(isChooseShowCell:)]) {
        [self.delegate isChooseShowCell:self];
    }
}

- (void)setIsSelected:(BOOL)selected {
    self.isSelectedBtn.selected = selected;
}

- (void)setFileTypeWithText:(NSString *)text {
    self.fileTypeLabel.text = text;
    self.fileTypeLabel.hidden = NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
