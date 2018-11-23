//
//  ArchivePickerTableViewCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchivePickerTableViewCell.h"
#import "InterviewPickerView.h"
#import "BSDatePickerView.h"
#import "TeamPickerView.h"
#import "FolloupDoctorsViewController.h"
#import "InterviewInputModel.h"
#import "AppDelegate.h"
#import "PersonHistoryModel.h"
#import "DisivionPicker.h"
#import "ArchiveFamilyDataManager.h"
#import "ArchivePersonDataManager.h"
#import "DiseasePersonVC.h"
#import "SignResidentInfoModel.h"

@interface ArchivePickerTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *waringLabel;
@property (weak, nonatomic) IBOutlet BSTextField *contentTF;
@property (weak, nonatomic) IBOutlet UIView *line;
//@property (nonatomic ,strong) DisivionPicker *textPickerView;
@property (nonatomic ,strong) UILabel *unitLabel;
@end

@implementation ArchivePickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setModel:(BSArchiveModel *)model
{
    _model = model;
    self.titleLabel.text = _model.title;
    self.titleLabel.hidden = NO;
    self.contentTF.placeholder = _model.placeholder;
    [self setContentText:_model.contentStr];
    self.contentTF.tapAcitonBlock = nil;
    self.contentTF.endEditBlock = nil;
    self.contentTF.enabled = model.canEdit;
    if ([self.model.code isEqualToString:@"HouseArea"] || [self.model.code isEqualToString:@"HouseArea"]){
        self.contentTF.pointNum = 2;
    }else{
        self.contentTF.pointNum = -1;
    }
    if (self.model.keybordType) {
         self.contentTF.keyboardType = self.model.keybordType;
    }else{
         self.contentTF.keyboardType = UIKeyboardTypeDefault;
    }
   
    self.waringLabel.hidden = !_model.isRequired;
    
    @weakify(self);
    if (_model.type == ArchiveModelTypeDatePicker) {
        self.contentTF.text = self.model.contentStr;
        self.contentTF.rightView = self.contentTF.moreIcon;
        self.contentTF.rightViewMode = UITextFieldViewModeAlways;
        @strongify(self);
        self.contentTF.tapAcitonBlock = ^{
            @strongify(self);
            NSString *max = nil;
            NSString *min = nil;
            if ([model.code isEqualToString:@"BuildDate"]) {
                NSString *year = [[NSDate date] stringWithFormat:@"yyyy"];
                NSString *mothAndDay = [[NSDate date] stringWithFormat:@"MM-dd"];
                max = [NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%d",year.intValue + 1],mothAndDay];
                min = [NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%d",year.intValue - 1],mothAndDay];
            }else{
                NSString *year = [[NSDate date] stringWithFormat:@"yyyy"];
                NSString *mothAndDay = [[NSDate date] stringWithFormat:@"MM-dd"];
                min = [NSString stringWithFormat:@"%d-%@",year.intValue - 100,mothAndDay];
                max = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
            }
            [BSDatePickerView showDatePickerWithTitle:self.model.title dateType:UIDatePickerModeDate defaultSelValue:self.contentTF.text minDateStr:min  maxDateStr:max isAutoSelect:NO isDelete:NO resultBlock:^(NSString *selectValue) {
                self.contentTF.text = selectValue;
                self.model.contentStr = selectValue;
                self.model.value = selectValue;
            }];
        };
    }
    if (_model.type == ArchiveModelTypeTextField) {
        self.contentTF.enabled = YES;
        if (self.model.unit.length) {
            self.contentTF.rightView = self.unitLabel;
            self.unitLabel.text = self.model.unit;
            [self.unitLabel sizeToFit];
            self.contentTF.rightViewMode = UITextFieldViewModeAlways;
        }else{
            self.contentTF.rightViewMode = UITextFieldViewModeNever;
        }
        
        
        Bsky_WeakSelf
        self.contentTF.endEditBlock = ^(NSString *text){
            Bsky_StrongSelf;
            if (![self handleTextFieldWithString:text]) {
                self.contentTF.text = @"";
                self.model.contentStr = nil;
                self.model.value = nil;
                return ;
            }
            if ([text isEqualToString:self.model.contentStr]) {
                return;
            }
            
            
            self.model.contentStr = text;
            self.model.value = text;
            if (self.endBlock) {
                self.endBlock(self.model);
            }else{
                
            }
            
        };
    }
    if (_model.type == ArchiveModelTypeLabel) {
        self.contentTF.enabled = NO;
        self.contentTF.rightViewMode = UITextFieldViewModeNever;
    }
    if (model.type == ArchiveModelTypeControllerPicker) {
        self.contentTF.rightView = self.contentTF.moreIcon;
        self.contentTF.rightViewMode = UITextFieldViewModeAlways;
//        BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
//        self.model.contentStr = info.UserName;
//        self.model.value = info.EmployeeID;
        self.contentTF.text = self.model.contentStr;
        Bsky_WeakSelf
        if ([self.model.code isEqualToString:@"personID"]) {
            self.contentTF.tapAcitonBlock = ^{
                DiseasePersonVC *doctorsVC = [[DiseasePersonVC alloc]init];
                Bsky_WeakSelf;
                doctorsVC.selectBlock = ^(id model) {
                    Bsky_StrongSelf;
                    if ([model isKindOfClass:[SignResidentInfoModel class]]) {
                        self.contentTF.text = self.model.contentStr =  [model valueForKey:@"name"];
                        self.model.value = [model valueForKey:@"personId"];
                        if (self.endBlock) {
                            self.endBlock(model);
                        }
                    }
                    
                };
//                doctorsVC.didSelectBlock = ^(FollowupDoctorModel *doctorModel) {
//                    Bsky_StrongSelf
//                    self.model.contentStr = doctorModel.employeeName;
//                    self.model.value = doctorModel.employeeId;
//                    self.contentTF.text = doctorModel.employeeName;
//                    
//                };
                AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UITabBarController *viewController = (UITabBarController *)deleate.window.rootViewController;
                UINavigationController *nav = [viewController.viewControllers firstObject];
                [nav pushViewController:doctorsVC animated:YES];
            };
        }else{
            self.contentTF.tapAcitonBlock = ^{
                FolloupDoctorsViewController *doctorsVC = [[FolloupDoctorsViewController alloc]init];
                
                doctorsVC.didSelectBlock = ^(FollowupDoctorModel *doctorModel) {
                    Bsky_StrongSelf
                    self.model.contentStr = doctorModel.employeeName;
                    self.model.value = doctorModel.employeeId;
                    self.contentTF.text = doctorModel.employeeName;
                    
                };
                AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UITabBarController *viewController = (UITabBarController *)deleate.window.rootViewController;
                UINavigationController *nav = [viewController.viewControllers firstObject];
                [nav pushViewController:doctorsVC animated:YES];
            };
        }
        
        
        
    }
    if (model.type == ArchiveModelTypeCustomOptionsPicker) {
        self.contentTF.rightViewMode = UITextFieldViewModeAlways;
        if ([model.pickerModel.options isEmptyArray] || !model.canEdit) {
            
        }else{
            if ([model.code isEqualToString:@"bp"]) {
                self.contentTF.tapAcitonBlock = ^{
                    InterviewPickerView *pickerView = [[InterviewPickerView alloc]init];
                    pickerView.items = [InterviewPickerModel mj_objectArrayWithKeyValuesArray:_model.pickerModels];
                    pickerView.selectedComplete = ^(NSString *str ,NSArray *selectItems){
                        @strongify(self);
                        self.model.value = str;
                        self.contentTF.text = str;
                        if ([self.model.title isEqualToString:@"血压(mmHg)"]) {
                            self.model.contentStr  = [NSString stringWithFormat:@"收缩压%@%@舒张压%@",selectItems[0],kFollowupSeparator,selectItems[1]];
                            self.contentTF.text = self.model.contentStr;
                        }
                        
                        
                    };
                    [pickerView show];
                };
            }else{
                self.contentTF.tapAcitonBlock = ^{
                    DisivionPicker *pickerView = [[DisivionPicker alloc] init];
                    [pickerView setItems:[ArchiveFamilyDataManager dataManager].disivionArray title:_model.title defaultStr:_model.contentStr];
                    pickerView.selectedIndex = ^(NSInteger firstIndex,NSInteger secondIndex)
                    {
                        @strongify(self);
                        ArchiveDivisionModel *firstModel = nil;
                        ArchiveDivisionModel *secondModel = nil;
                        if ([[ArchiveFamilyDataManager dataManager].disivionArray count] > firstIndex) {
                            firstModel = [[ArchiveFamilyDataManager dataManager].disivionArray objectAtIndex:firstIndex];
                        }
                        if ([firstModel.children count] > secondIndex) {
                            secondModel =  [firstModel.children objectAtIndex:secondIndex];
                        }
                        
                        
                        self.model.value = secondModel.divisionId;
                        NSString *firstName = firstModel.divisionName.length ? firstModel.divisionName : @"";
                        NSString *secendName = secondModel.divisionName.length ? secondModel.divisionName : @"";
                        self.model.contentStr = [NSString stringWithFormat:@"%@%@",firstName,secendName];
                        self.contentTF.text = [NSString stringWithFormat:@"%@%@",firstName,secendName];
                        
                        
                        
                        if (self.endBlock) {
                            self.endBlock(secondModel);
                        }
                    };
                    [pickerView show];
                };
            }
            
        }
    }
    if (model.type == ArchiveModelTypeCustomPicker ) {
        self.contentTF.rightView = self.contentTF.moreIcon;
        self.contentTF.rightViewMode = UITextFieldViewModeAlways;
        if ([model.pickerModel.options isEmptyArray] || !model.canEdit) {
            
        }else{
            NSMutableArray *array = [NSMutableArray array];
            for (NSObject *model in _model.pickerModel.options) {
                if ([model isKindOfClass:[ArchiveSelectOptionModel class]]) {
                    ArchiveSelectOptionModel *currentModel = (ArchiveSelectOptionModel *)model;
                    [array addObject:currentModel.title];
                }else if ([model isKindOfClass:[DiseaseModel class]]){
                    DiseaseModel *currentModel = (DiseaseModel *)model;
                    [array addObject:currentModel.diseaseName];
                }else{
                    
                }
                
            }
            self.contentTF.tapAcitonBlock = ^{
                if (array.count < 1) {
                    [UIView makeToast:[NSString stringWithFormat:@"获取%@列表失败",self.model.title]];
                }
                else
                {
                    TeamPickerView *pickerView = [[TeamPickerView alloc]init];
                    [pickerView setItems:array title:_model.title defaultStr:_model.contentStr];
                    pickerView.selectedIndex = ^(NSInteger index)
                    {
                        @strongify(self);
                        id model = self.model.pickerModel.options[index];
                        if ([self.model.code isEqualToString:@"diseaseKindId"]) {
                            DiseaseModel *disease = model;
                            NSMutableArray *array = [ArchivePersonDataManager dataManager].historySelectDisease;
                            if ([array containsObject:disease.diseaseName]) {
                                [UIView makeToast:@"已存在这种疾病!"];
                                return ;
                            }
                        }
                        if ([self.model.code isEqualToString:@"relationshipType"]) {
                            ArchiveSelectOptionModel *option = model;
                            NSMutableArray *array = [ArchivePersonDataManager dataManager].historySelectFamily;
                            if ([array containsObject:option.value]) {
                                [UIView makeToast:@"已存在该亲属!"];
                                return ;
                            }
                        }
//                        if ([self.model.code isEqualToString:@"relationshipType"]) {
//                            ArchiveSelectOptionModel *option = model;
//                            if ([[ArchivePersonDataManager dataManager].historyFamilyArray containsObject:option.value]) {
//                                [UIView makeToast:@"已存在该亲属家庭史!"];
//                                return ;
//                            }
//                        }
                        if ([model isKindOfClass:[ArchiveSelectOptionModel class]]) {
                            ArchiveSelectOptionModel *currentModel = (ArchiveSelectOptionModel *)model;
                            self.model.contentStr = currentModel.title;
                            self.model.value = currentModel.value;
                            self.contentTF.text = self.model.contentStr;
                        }else if ([model isKindOfClass:[DiseaseModel class]]){
                            DiseaseModel *currentModel = (DiseaseModel *)model;
                            self.model.contentStr = currentModel.diseaseName;
                            self.model.value = currentModel.diseaseId;
                            self.contentTF.text = self.model.contentStr;
                        }else{
                            
                        }
                        if (self.delegate && [self.delegate respondsToSelector:@selector(pickAction:)]) {
                            [self.delegate pickAction:model];
                        }
                    };
                    [pickerView show];
                }
            };
        }
    }
}
- (UILabel *)unitLabel
{
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc]init];
        _unitLabel.textColor = UIColorFromRGB(0x333333);
        _unitLabel.font = self.contentTF.font;
    }
    return _unitLabel;
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
           
        }
    }
    
}
#pragma mark --- 工具方法

-(BOOL )handleTextFieldWithString:(NSString *)str{
    if (!str.length) {
        return NO;
    }
    if ([self.model.code isEqualToString:@"MemberCount"] || [self.model.code isEqualToString:@"CurrentCount"] || [self.model.code isEqualToString:@"CurrentCount"]) {
        if (![str isNumText]) {
            [UIView makeToast:@"请输入有效数据!"];
            return NO;
        }else{
            if (str.integerValue > 20) {
                [UIView makeToast:@"请输入有效数据!"];
                return NO;
            }
        }
    }else if ([self.model.code isEqualToString:@"HouseArea"] || [self.model.code isEqualToString:@"HouseArea"]){
        if (![str isPureInt] && ![str isPureFloat]) {
            [UIView makeToast:@"请输入有效数据!"];
            return NO;
        }
    }else if ([self.model.code isEqualToString:@"FamilyTel"] || [self.model.code isEqualToString:@"PersonTel"] || [self.model.code isEqualToString:@"ContactTel"] || [self.model.code isEqualToString:@"personTel"]){
        if (![str isPhoneNumber] ) {
            [UIView makeToast:@"请输入有效手机号码!"];
            return NO;
        }
    }else if ([self.model.code isEqualToString:@"Remark"]){
        if (str.length > 200) {
            [UIView makeToast:@"请输入200个字符以下的备注!"];
            str = [str substringWithRange:NSMakeRange(0, 200)];
        }
    }else if ([self.model.code isEqualToString:@"Name"] || [self.model.code isEqualToString:@"ContactPerson"]){
        if (![str isChinese]) {
            [UIView makeToast:@"请输入中文名字!"];
            return NO;
        }
    }else if ([self.model.code isEqualToString:@"CustomNumber"]){
        if ([str includeChinese]) {
            [UIView makeToast:@"编号只能由字符和数字组成!"];
            return NO;
        }
    }
    
    return YES;
}
@end
