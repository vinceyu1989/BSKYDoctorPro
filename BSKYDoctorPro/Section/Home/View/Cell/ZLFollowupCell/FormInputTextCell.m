//
//  ZLFollowupInputTextCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FormInputTextCell.h"
#import "BSDatePickerView.h"
#import "InterviewPickerView.h"
#import "FollowupDoctorModel.h"
#import <YYCategories/NSDate+YYAdd.h>

@interface FormInputTextCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet BSTextField *contentTF;
@property (weak, nonatomic) IBOutlet UILabel *requiredIcon;

@end

@implementation FormInputTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setUiModel:(InterviewInputModel *)uiModel
{
    [super setUiModel:uiModel];
    self.titleLabel.text = self.uiModel.title;
    self.titleLabel.hidden = NO;
    self.contentTF.placeholder = self.uiModel.placeholder;
    [self setContentText:self.uiModel.contentStr];
    self.contentTF.tapAcitonBlock = nil;
    self.contentTF.endEditBlock = nil;
    self.contentTF.enabled = YES;
    self.contentTF.rightViewMode = UITextFieldViewModeAlways;
    self.requiredIcon.hidden = !self.uiModel.isRequired;
    
    Bsky_WeakSelf;
    if (self.uiModel.type == BSFormCellTypeDatePicker) {
        InterviewPickerModel *pickerModel = self.uiModel.pickerModels[0];
        NSString *minDateStr = [[[NSDate date] dateByAddingMonths:pickerModel.min] stringWithFormat:@"yyyy-MM-dd"];
        NSString *maxDateStr = [[[NSDate date] dateByAddingMonths:pickerModel.max] stringWithFormat:@"yyyy-MM-dd"];
        self.contentTF.tapAcitonBlock = ^{
            Bsky_StrongSelf
            BOOL isDelete = [self.uiModel.title isEqualToString:@"糖化血红蛋白检查时间"];
            [BSDatePickerView showDatePickerWithTitle:self.uiModel.title dateType:UIDatePickerModeDate defaultSelValue:self.contentTF.text minDateStr:minDateStr maxDateStr:maxDateStr isAutoSelect:NO isDelete:isDelete resultBlock:^(NSString *selectValue) {
                self.contentTF.text = selectValue;
                self.uiModel.contentStr = selectValue;
                if (self.delegate && [self.delegate respondsToSelector:@selector(formBaseCell:configData:)]) {
                    [self.delegate formBaseCell:self configData:self.uiModel];
                }
            }];
        };
    }
    else if(self.uiModel.type == BSFormCellTypeTFEnabled ) {
        self.contentTF.enabled = NO;
        self.contentTF.rightViewMode = UITextFieldViewModeNever;
    }
    else if(self.uiModel.type == BSFormCellTypeTap) {
        self.contentTF.tapAcitonBlock = ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(formBaseCell:configData:)])
            {
                [self.delegate formBaseCell:self configData:self.uiModel];
            }
        };
    }
    else if(self.uiModel.type == BSFormCellTypeCustomPicker)
    {
        self.contentTF.tapAcitonBlock = ^{
            InterviewPickerView *pickerView = [[InterviewPickerView alloc]init];
            pickerView.items = self.uiModel.pickerModels;
            pickerView.selectedComplete = ^(NSString *str ,NSArray *selectItems){
                Bsky_StrongSelf;
                self.uiModel.contentStr = str;
//                if ([self.uiModel.title isEqualToString:@"血压(mmHg)"]) {
//                    self.uiModel.contentStr  = [NSString stringWithFormat:@"收缩压%@%@舒张压%@",selectItems[0],kFollowupSeparator,selectItems[1]];
//                }
                [self setContentText:self.uiModel.contentStr];
                if (self.delegate && [self.delegate respondsToSelector:@selector(formBaseCell:configData:)]) {
                    [self.delegate formBaseCell:self configData:self.uiModel];
                }
            };
            [pickerView show];
        };
    }
    else
    {
        self.contentTF.rightViewMode = UITextFieldViewModeNever;
        self.contentTF.keyboardType = self.uiModel.keyboardType;
        self.contentTF.pointNum = self.uiModel.keyboardType == UIKeyboardTypeNumbersAndPunctuation ? 2 : -1;
        self.contentTF.endEditBlock = ^(NSString *text) {
            Bsky_StrongSelf
            self.uiModel.contentStr = text;
            if (self.delegate && [self.delegate respondsToSelector:@selector(formBaseCell:configData:)]) {
                [self.delegate formBaseCell:self configData:self.uiModel];
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
        if (self.uiModel.type == BSFormCellTypeCustomPicker) {
            for (int i = 0; i < self.uiModel.pickerModels.count; i++) {
                InterviewPickerModel *pickerModel = self.uiModel.pickerModels[i];
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
