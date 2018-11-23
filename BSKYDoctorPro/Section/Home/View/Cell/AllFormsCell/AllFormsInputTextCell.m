//
//  AllFormsInputTextCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AllFormsInputTextCell.h"
#import "BSTextField.h"
#import "BSDatePickerView.h"
#import "InterviewPickerView.h"
#import "TeamPickerView.h"
#import "FollowupDoctorModel.h"
#import <YYCategories/NSDate+YYAdd.h>

@interface AllFormsInputTextCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *waringLabel;
@property (weak, nonatomic) IBOutlet BSTextField *contentTF;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic ,strong) InterviewPickerView *textPickerView;


@end

@implementation AllFormsInputTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setModel:(InterviewInputModel *)model
{
    _model = model;
    self.titleLabel.text = _model.title;
    self.titleLabel.hidden = NO;
    self.contentTF.placeholder = _model.placeholder;
    [self setContentText:_model.contentStr];
    self.contentTF.tapAcitonBlock = nil;
    self.contentTF.endEditBlock = nil;
    self.contentTF.enabled = YES;
    self.contentTF.rightView = self.contentTF.moreIcon;
    self.contentTF.rightViewMode = UITextFieldViewModeAlways;
    self.contentTF.keyboardType = UIKeyboardTypeDefault;
    self.contentTF.pointNum = -1;
    self.waringLabel.hidden = !_model.isRequired;
    
    @weakify(self);
    if ([_model.title isEqualToString:@"随访时间"])
    {
        self.contentTF.tapAcitonBlock = ^{
            @strongify(self);
            InterviewPickerModel *pickerModel = _model.pickerModels[0];
            NSString *minDateStr = [[[NSDate date] dateByAddingMonths:pickerModel.min] stringWithFormat:@"yyyy-MM-dd"];
            NSString *maxDateStr = [[[NSDate date] dateByAddingMonths:pickerModel.max] stringWithFormat:@"yyyy-MM-dd"];
            [BSDatePickerView showDatePickerWithTitle:_model.title dateType:UIDatePickerModeDate defaultSelValue:self.contentTF.text minDateStr:minDateStr maxDateStr:maxDateStr isAutoSelect:NO isDelete:NO resultBlock:^(NSString *selectValue) {
                self.contentTF.text = selectValue;
                self.model.contentStr = selectValue;
                [self configUpModelWithTimeStr:selectValue];
            }];
        };
    }
    else if ([_model.title isEqualToString:@"下次随访时间"])
    {
        self.contentTF.tapAcitonBlock = ^{
            @strongify(self);
            InterviewPickerModel *pickerModel = _model.pickerModels[0];
            NSString *minDateStr = [[[NSDate date] dateByAddingMonths:pickerModel.min] stringWithFormat:@"yyyy-MM-dd"];
            NSString *maxDateStr = [[[NSDate date] dateByAddingMonths:pickerModel.max] stringWithFormat:@"yyyy-MM-dd"];
            [BSDatePickerView showDatePickerWithTitle:_model.title dateType:UIDatePickerModeDate defaultSelValue:self.contentTF.text minDateStr:minDateStr maxDateStr:maxDateStr isAutoSelect:NO isDelete:NO resultBlock:^(NSString *selectValue) {
                self.contentTF.text = selectValue;
                self.model.contentStr = selectValue;
                [self configUpModelWithTimeStr:selectValue];
            }];
        };
    }
    else if ([_model.title isEqualToString:@"检查日期"])
    {
        self.titleLabel.hidden = YES;
        NSString *str = _model.contentStr ? _model.contentStr : @"";
        self.contentTF.text = [NSString stringWithFormat:@"%@：%@",_model.title,str];
        self.contentTF.tapAcitonBlock = ^{
            @strongify(self);
            NSString *max = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
            [BSDatePickerView showDatePickerWithTitle:_model.title dateType:UIDatePickerModeDate defaultSelValue:_model.contentStr minDateStr:nil maxDateStr:max isAutoSelect:NO isDelete:YES resultBlock:^(NSString *selectValue) {
                NSString *str = selectValue ? selectValue : @"";
                self.contentTF.text = [NSString stringWithFormat:@"%@：%@",_model.title,str];
                self.model.contentStr = selectValue;
                [self configUpModelWithTimeStr:selectValue];
            }];
        };
    }
    else if([model.title isEqualToString:@"体质指数(BMI)"]) {
        self.contentTF.enabled = NO;
        self.contentTF.rightViewMode = UITextFieldViewModeNever;
    }
    else if([model.title isEqualToString:@"其他辅助检查"] || [model.title isEqualToString:@"随访医生"]) {
        self.contentTF.enabled = NO;
    }
    else if([_model.pickerModels isNotEmptyArray])
    {
        self.contentTF.tapAcitonBlock = ^{
            InterviewPickerView *pickerView = [[InterviewPickerView alloc]init];
            pickerView.items = _model.pickerModels;
            pickerView.selectedComplete = ^(NSString *str ,NSArray *selectItems){
                @strongify(self);
                self.model.contentStr = str;
                if ([self.model.title isEqualToString:@"血压(mmHg)"]) {
                    self.model.contentStr  = [NSString stringWithFormat:@"收缩压%@%@舒张压%@",selectItems[0],kFollowupSeparator,selectItems[1]];
                }
                [self setContentText:self.model.contentStr];
                [self configUpModelWithArray:selectItems];
                if ([self.model.title isEqualToString:@"身高(cm)"]) {
                    [self postNotification:kAllFormsBmiNeedRefresh];
                }
            };
            [pickerView show];
        };
    }
    else if ([_model.types isNotEmptyArray])
    {
        self.contentTF.tapAcitonBlock = ^{
            TeamPickerView *pickerView = [[TeamPickerView alloc]init];
            [pickerView setItems:_model.types title:_model.title defaultStr:_model.contentStr];
            pickerView.selectedIndex = ^(NSInteger index)
            {
                @strongify(self);
                self.model.contentStr = _model.types[index];
                self.contentTF.text = self.model.contentStr;
                [self configUpModelWithIndex:index];
            };
            [pickerView show];
        };
    }
    else
    {
        //        self.unitLabel.text = [self handleStringWithString:_model.title];
        self.contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.contentTF.pointNum = 2;
        self.contentTF.endEditBlock = ^(NSString *text) {
            @strongify(self);
            self.model.contentStr = text;
            [self configUpModelWithStr:text];
            if ([self.model.title isEqualToString:@"体重(kg)"] || [self.model.title isEqualToString:@"目标体重(kg)"]) {
                [self postNotification:kAllFormsBmiNeedRefresh];
            }
        };
    }
}
- (void)setContentText:(NSString *)str
{
    if (![str isNotEmptyString]) {
        self.contentTF.text = @"";
    }
    else
    {
        NSRange range = [str rangeOfString:kFollowupSeparator];
        if (range.location == NSNotFound) {
            self.contentTF.text = str;
            range = NSMakeRange(str.length, 0);
        }
        else
        {
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0,range.location)];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:range];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x72c125) range:NSMakeRange(range.location+range.length,str.length-range.location-range.length)];
            self.contentTF.attributedText = attributedStr;
        }
        if (self.model.pickerModels.count > 0) {
            for (int i = 0; i < self.model.pickerModels.count; i++) {
                InterviewPickerModel *pickerModel = self.model.pickerModels[i];
                if (i == 0) {
                    pickerModel.content = [[str substringToIndex:range.location] getNumTextAndDecimalPoint];
                }
                else if (i == 1)
                {
                    pickerModel.content = [[str substringFromIndex:range.location + range.length] getNumTextAndDecimalPoint];
                }
            }
        }
    }
    
}
#pragma mark ------ 配置代码

- (void)configUpModelWithTimeStr:(NSString *)timeStr
{
    if ([self.model.title isEqualToString:@"随访时间"]) {
        
        self.upModel.cmModel.followUpDate = timeStr;
    }
    else if ([self.model.title isEqualToString:@"下次随访时间"])
    {
        self.upModel.cmModel.nextFollowUpDate = timeStr;
    }
    else if ([self.model.title isEqualToString:@"检查日期"])
    {
        self.upModel.labora.examDate = timeStr;
    }
}
- (void)configUpModelWithStr:(NSString *)str
{
    NSNumber *num = nil;
    if (str.length > 0) {
      num = @(str.floatValue);
    }
    if ([self.model.title isEqualToString:@"体重(kg)"])
    {
        self.upModel.body.weight = num;
    }
    else if ([self.model.title isEqualToString:@"目标体重(kg)"])
    {
        self.upModel.cmModel.nextWeight = num;
    }
    else if ([self.model.title isEqualToString:@"空腹血糖值(mmol/L)"])
    {
        self.upModel.labora.fastingBloodGlucose = num;
    }
    else if ([self.model.title isEqualToString:@"餐后血糖值(mmol/L)"])
    {
        self.upModel.labora.postprandialBloodGlucose = num;
    }
    else if ([self.model.title isEqualToString:@"随机血糖值(mmol/L)"])
    {
        self.upModel.labora.randomBloodGlucose = num;
    }
    else if ([self.model.title isEqualToString:@"糖化血红蛋白(%)"])
    {
        self.upModel.labora.glycatedHemoglobin = num;
    }
}

- (void)configUpModelWithArray:(NSArray *)selectItems
{
    NSString *str = selectItems[0];
    NSNumber *num = @(str.floatValue);
    NSString *str1 = nil;
    NSNumber *num1 = nil;
    
    if (selectItems.count > 1) {
        str1 = selectItems[1];
        num1 = @(str1.floatValue);
    }
    if (![str isNotEmptyString]) {
        str = nil;
        num = nil;
        str1 = nil;
        num1 = nil;
    }
    if ([self.model.title isEqualToString:@"心率(次/分钟)"]) {
        self.upModel.body.heartRate =  num;
        self.upModel.cmModel.nextHeartRate = str1;
    }
    else if ([self.model.title isEqualToString:@"血压(mmHg)"]) {
        self.upModel.body.leftSbp =  num;
        self.upModel.body.rightSbp = num;
        self.upModel.body.leftDbp = num1;
        self.upModel.body.rightDbp = num1;
    }
    else if ([self.model.title isEqualToString:@"身高(cm)"])
    {
        self.upModel.body.height = num;
    }
    else if ([self.model.title isEqualToString:@"视力"])
    {
        self.upModel.organ.leftEye =  num;
        self.upModel.organ.rightEye = num1;
    }
    else if ([self.model.title isEqualToString:@"矫正视力"])
    {
        self.upModel.organ.leftEyeVc =  num;
        self.upModel.organ.rightEyeVc = num1;
    }
    else if ([self.model.title isEqualToString:@"日饮酒量(两/日)"])
    {
        self.upModel.lifeStyle.dailyAlcoholIntake =  num;
        self.upModel.cmModel.nextDailyAlcohol = str1;
    }
    else if ([self.model.title isEqualToString:@"日吸烟量(支/日)"])
    {
        self.upModel.lifeStyle.smoking = num;
        self.upModel.cmModel.nextSmoking = str1;
    }
    else if ([self.model.title isEqualToString:@"主食(克/日)"])
    {
        self.upModel.cmModel.staple =  str;
        self.upModel.cmModel.nextStaple = str1;
    }
    else if ([self.model.title isEqualToString:@"运动次数(次/周)"])
    {
        self.upModel.lifeStyle.exerciseWeekTimes = num;
        self.upModel.cmModel.nextExerciseWeekTimes = str1;
        
    }
    else if ([self.model.title isEqualToString:@"运动时间(分钟/次)"])
    {
        self.upModel.lifeStyle.eachExerciseTime = num;
        self.upModel.cmModel.nextExerciseWeekMinute = str1;
    }
}
- (void)configUpModelWithIndex:(NSInteger)index
{
    if ([self.model.title isEqualToString:@"随访医生"])
    {
        FollowupDoctorModel *doctorModel = _model.types[index];
        self.upModel.cmModel.doctorId = doctorModel.employeeId;
        self.upModel.cmModel.doctorName = doctorModel.employeeName;
    }
}
#pragma mark --- 工具方法

-(NSString *)handleStringWithString:(NSString *)str{
    
    while (1) {
        NSRange range = [str rangeOfString:@"("];
        NSRange range1 = [str rangeOfString:@")"];
        if (range.location != NSNotFound) {
            NSInteger loc = range.location;
            NSInteger len = range1.location - range.location;
            str = [str substringWithRange:NSMakeRange(loc+1, len-1)];
            break;
        }else{
            str = @"";
            break;
        }
    }
    return str;
}
@end
