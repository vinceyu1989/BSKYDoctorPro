//
//  FollowupHistoryCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/10/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupHistoryCell.h"

@interface FollowupHistoryCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;    // 名字
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;     //时间Label
@property (weak, nonatomic) IBOutlet UILabel *xuetangTitleLabel;    //血糖title
@property (weak, nonatomic) IBOutlet UILabel *xuetangLabel;  //   血糖Label
@property (weak, nonatomic) IBOutlet UILabel *diTitleLabel;  //低血糖title
@property (weak, nonatomic) IBOutlet UILabel *diLabel;     //   低血糖Label
@property (weak, nonatomic) IBOutlet UILabel *zunLabel;   //    遵医行为
@property (weak, nonatomic) IBOutlet UILabel *wayLabel;   //    随访方式
@property (weak, nonatomic) IBOutlet UILabel *symptomTitleLabel; // 症状Title
@property (weak, nonatomic) IBOutlet UILabel *symptomLabel;       //   症状
@property (weak, nonatomic) IBOutlet UILabel *lawLabel;     //     服药依从性
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;        //  随访分类
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightConstraint;


@end

@implementation FollowupHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
    self.bgView.layer.borderWidth = 0.5;
    [self.bgView setCornerRadius:5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setType:(FollowupType)type
{
    _type = type;
    switch (_type) {
        case FollowupTypeHypertension:
        {
            self.xuetangTitleLabel.text = @"血压：";
            self.diTitleLabel.text = @"摄盐情况：";
            self.symptomTitleLabel.hidden = NO;
            self.symptomLabel.hidden = NO;
            self.bgViewHeightConstraint.constant = 177.5;
        }
            break;
        case FollowupTypeDiabetes:
        {
            self.xuetangTitleLabel.text = @"血糖值：";
            self.diTitleLabel.text = @"低血糖：";
            self.symptomTitleLabel.hidden = NO;
            self.symptomLabel.hidden = NO;
            self.bgViewHeightConstraint.constant = 177.5;
        }
            break;
        case FollowupTypeGaoTang:
        {
            self.xuetangTitleLabel.text = @"血压：";
            self.diTitleLabel.text = @"血糖值：";
            self.symptomTitleLabel.hidden = YES;
            self.symptomLabel.hidden = YES;
            self.bgViewHeightConstraint.constant = 119;
        }
            break;
        default:
            break;
    }
    
}
- (void)setModel:(FollowupHistoryModel *)model
{
    _model = model;
    self.nameLabel.text = _model.doctorName;
    switch (self.type) {
        case FollowupTypeHypertension:
        {
            self.timeLabel.text = [_model.followUpDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
            self.xuetangLabel.text = [NSString stringWithFormat:@"%@/%@mmHg",_model.sbp,_model.dbp];
            self.diLabel.text = _model.saltIntakeStr;
        }
            break;
        case FollowupTypeDiabetes:
        {
            self.timeLabel.text = [_model.followUpDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
            self.xuetangLabel.text = [NSString stringWithFormat:@"%@mmol/L",_model.fastingBloodGlucose];
            self.diLabel.text = _model.lowBloodSugarReactionsStr;
        }
            break;
        case FollowupTypeGaoTang:
        {
            self.timeLabel.text = [_model.examDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
            self.xuetangLabel.text = [NSString stringWithFormat:@"%@/%@mmHg",_model.sbp,_model.dbp];
            self.diLabel.text = [NSString stringWithFormat:@"%@mmol/L",_model.bloodSugar];
        }
            break;
        default:
            break;
    }
    self.symptomLabel.text = _model.symptomStr;
    self.zunLabel.text = _model.complianceBehaviorStr;
    self.wayLabel.text = _model.wayUpStr;
    self.lawLabel.text = _model.medicationComplianceStr;
    self.sortLabel.text = _model.fuClassificationStr;
}

- (void)setZlModel:(ZLFollowupHistoryModel *)zlModel
{
    _zlModel = zlModel;
    self.nameLabel.text = _zlModel.doctorName;
    switch (self.type) {
        case FollowupTypeHypertension:
        {
            self.timeLabel.text = _zlModel.followUpDate;
            self.xuetangLabel.text = [NSString stringWithFormat:@"%@/%@mmHg",_zlModel.sbp,_zlModel.dbp];
            self.diLabel.text = _zlModel.saltIntake;
        }
            break;
        case FollowupTypeDiabetes:
        {
            self.timeLabel.text = _zlModel.followUpDate;
            self.xuetangLabel.text = _zlModel.glu;
            self.diLabel.text = _zlModel.lowBloodSugarReactions;
        }
            break;
        case FollowupTypeGaoTang:
        {
            self.timeLabel.text = _zlModel.followUpDate;
            self.xuetangLabel.text = [NSString stringWithFormat:@"%@/%@mmHg",_zlModel.sbp,_zlModel.dbp];
//            self.diLabel.text = [NSString stringWithFormat:@"%@mmol/L",_zlModel.bloodSugar];
        }
            break;
        default:
            break;
    }
    self.symptomLabel.text = _zlModel.symptom;
    self.zunLabel.text = _zlModel.complianceBehavior;
    self.wayLabel.text = _zlModel.wayUp;
    self.lawLabel.text = _zlModel.medicationCompliance;
    self.sortLabel.text = _zlModel.fuClassification;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
