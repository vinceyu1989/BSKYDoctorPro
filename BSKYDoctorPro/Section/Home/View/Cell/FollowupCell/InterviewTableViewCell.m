//
//  InterviewTableViewCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "InterviewTableViewCell.h"
#import "BSDatePickerView.h"
#import <YYCategories/NSDate+YYAdd.h>

@interface InterviewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *avatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeDateTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timePadding;

@end

@implementation InterviewTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.startBtn.layer.borderColor = UIColorFromRGB(0x4e7dd3).CGColor;
    
    self.startBtn.layer.borderWidth = 1.0f;
    
    [self.startBtn setCornerRadius:5];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"修改"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [title addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4e7dd3) range:titleRange];
    [self.modifyBtn setAttributedTitle:title
                              forState:UIControlStateNormal];
    
    [self.phoneBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.modifyBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.startBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setFollowup:(BSFollowup *)followup {
    _followup = followup;
    
    self.nameLabel.text = followup.username;
    
    if (followup.username.length >= 2) {
        
        NSRange range = NSMakeRange(followup.username.length-2, 2);
        
        NSString *str = [followup.username substringWithRange:range];
        
        [self.avatarBtn setTitle:str forState:UIControlStateNormal];
    }
    
    switch (followup.sex.integerValue) {
        case BSSexUnknow:
            self.genderImageView.image = nil;
            break;
        case BSSexMale:
            self.genderImageView.image = [UIImage imageNamed:@"male"];
            break;
        case BSSexFemale:
            self.genderImageView.image = [UIImage imageNamed:@"female"];
            break;
    }
    if (followup.phone.length > 0) {
        self.phoneBtn.hidden = NO;
        [self.phoneBtn setTitle:followup.phone forState:UIControlStateNormal];
    }
    else
    {
        self.phoneBtn.hidden = YES;
    }
    self.ageLabel.text = followup.age;
    self.lastTimeLabel.text = [NSString stringWithFormat:@"上次随访:%@", followup.lastFollowDate];
    self.dateLabel.text = followup.followDate;
    
    switch (followup.followUpType.integerValue) {
        case FollowupTypeHypertension:
            self.typeLabel.text = @"随访类型：高血压随访";
            break;
        case FollowupTypeDiabetes:
            self.typeLabel.text = @"随访类型：糖尿病随访";
            break;
        case FollowupTypeGaoTang:
            self.typeLabel.text = @"随访类型：高糖合并随访";
            break;
        default:
            break;
    }
    self.addressLabel.text = followup.address;
    
    // 状态
    if ([followup.status isEqualToString:@"06001001"]) {
        self.startBtn.layer.borderColor = UIColorFromRGB(0x4e7dd3).CGColor;
        self.startBtn.layer.borderWidth = 1.0f;
        [self.startBtn setCornerRadius:5];
        [self.startBtn setTitle:@"开始随访" forState:UIControlStateNormal];
        [self.startBtn setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
        self.startBtn.userInteractionEnabled = YES;
        self.modifyBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.timeHeight.constant = CGFLOAT_MIN;
        self.timePadding.constant = CGFLOAT_MIN;
        self.completeDateTipLabel.text = @"";
    }else if([followup.status isEqualToString:@"06001002"]) {
        self.startBtn.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
        self.startBtn.layer.borderWidth = 1.0f;
        [self.startBtn setCornerRadius:5];
        [self.startBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [self.startBtn setTitleColor:UIColorFromRGB(0xededed) forState:UIControlStateNormal];
        self.startBtn.userInteractionEnabled = NO;
        self.modifyBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
        self.timeHeight.constant = 16;
        self.timePadding.constant = 10;
        self.completeDateTipLabel.text = @"实际完成时间：";
    }
    
    self.completeDateLabel.text = followup.completeDate;
}

#pragma mark ---- click

- (void)buttonPressed:(UIButton *)sender
{
    if (!self.delegate) {
        return;
    }
    if (sender == self.phoneBtn && [self.delegate respondsToSelector:@selector(interviewTableViewCell:clickPhoneNum:)]) {
        [self.delegate interviewTableViewCell:self clickPhoneNum:self.phoneBtn.titleLabel.text];
    }
    if (sender == self.deleteBtn && [self.delegate respondsToSelector:@selector(interviewTableViewCellDelete:)]) {
        [self.delegate interviewTableViewCellDelete:self];
    }
    if (sender == self.modifyBtn) {
        @weakify(self);
        NSString *min = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
        [BSDatePickerView showDatePickerWithTitle:@"选择时间" dateType:UIDatePickerModeDate defaultSelValue:self.dateLabel.text minDateStr:min maxDateStr:nil isAutoSelect:NO isDelete:NO resultBlock:^(NSString *selectValue) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(interviewTableViewCellModify:dateStr:)] && ![self.dateLabel.text isEqualToString:selectValue]) {
                [self.delegate interviewTableViewCellModify:self dateStr:selectValue];
            }
        }];
        
    }
    if (sender == self.startBtn && [self.delegate respondsToSelector:@selector(interviewTableViewCellStart:)]) {
        [self.delegate interviewTableViewCellStart:self];
    }
}



@end
