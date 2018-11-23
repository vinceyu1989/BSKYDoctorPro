//
//  ArchivePickerTableViewCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/2.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLArchivePickerTableViewCell.h"
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
#import "ZLDisivionPicker.h"
#import "ZLDoctorListVC.h"
#import "DiseaseViewController.h"
#import "ZLDiseaseModel.h"

@interface ZLArchivePickerTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *waringLabel;
@property (weak, nonatomic) IBOutlet BSTextField *contentTF;
@property (weak, nonatomic) IBOutlet UIView *line;
//@property (nonatomic ,strong) DisivionPicker *textPickerView;
@property (nonatomic ,strong) UILabel *unitLabel;
@end

@implementation ZLArchivePickerTableViewCell

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
        self.contentTF.rightView = self.contentTF.moreIcon;
        self.contentTF.rightViewMode = UITextFieldViewModeAlways;
        @strongify(self);
        self.contentTF.tapAcitonBlock = ^{
            @strongify(self);
            NSString *max = nil;
            NSString *min = nil;
            if ([model.code isEqualToString:@"registrationDate"]) {
                NSString *year = [[NSDate date] stringWithFormat:@"yyyy"];
                NSString *mothAndDay = [[NSDate date] stringWithFormat:@"MM-dd"];
                max = [NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%d",year.intValue + 1],mothAndDay];
                min = [NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%d",year.intValue - 1],mothAndDay];
            }else{
                max = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
            }
            [BSDatePickerView showDatePickerWithTitle:_model.title dateType:UIDatePickerModeDate defaultSelValue:self.contentTF.text minDateStr:min  maxDateStr:max isAutoSelect:NO isDelete:NO resultBlock:^(NSString *selectValue) {
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
                return ;
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
        self.contentTF.text = self.model.contentStr;
        self.contentTF.rightViewMode = UITextFieldViewModeAlways;
        if ([model.code isEqualToString:@"responsibleDoctorId"] || [model.code isEqualToString:@"buildDoctorId"]) {
            Bsky_WeakSelf
            self.contentTF.tapAcitonBlock = ^{
                AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UITabBarController *viewController = (UITabBarController *)deleate.window.rootViewController;
                UINavigationController *nav = [viewController.viewControllers firstObject];
                ZLDoctorListVC *doctorsVC = [[ZLDoctorListVC alloc]init];
                
                doctorsVC.didSelectBlock = ^(ZLDoctorModel *doctorModel) {
                    Bsky_StrongSelf
                    self.model.contentStr = doctorModel.name;
                    self.model.value = doctorModel.doctorId;
                    self.contentTF.text = doctorModel.name;
                    //                self.dataModel.followUpDoctorId = doctorModel.doctorId;
                    
                };
                [nav pushViewController:doctorsVC animated:YES];
            };
            
        }else if ([model.code isEqualToString:@"diseaseDiscrebe"]) {
                self.contentTF.tapAcitonBlock = ^{
                    DiseaseViewController *cv = [[DiseaseViewController alloc] init];
                    cv.selectCount = 1;
                    if (self.model.contentStr.length) {
                        ZLDiseaseModel *zlModel = [[ZLDiseaseModel alloc] init];
                        zlModel.name = self.model.contentStr;
                        zlModel.code = self.model.code;
                        cv.selectedArray = [NSMutableArray arrayWithObject:zlModel];
                    }
                    
                    Bsky_WeakSelf;
                    cv.block = ^(NSArray *options) {
                        Bsky_StrongSelf;
                        if (options.count > 0) {
                            ZLDiseaseModel *zlModel = options.firstObject;
                            self.model.contentStr = zlModel.name;
                            self.model.value = zlModel.code;
                            self.contentTF.text = zlModel.name;
                            self.model.selectModel.selectArray = options;
                        }
                    };
                    
                    AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    UITabBarController *viewController = (UITabBarController *)deleate.window.rootViewController;
                    UINavigationController *nav = [viewController.viewControllers firstObject];
                    [nav pushViewController:cv animated:YES];
                    };
        }
        
//        BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
//        self.model.contentStr = info.UserName;
//        self.model.value = info.EmployeeID;
//        self.contentTF.text = info.UserName;
//        Bsky_WeakSelf
//        self.contentTF.tapAcitonBlock = ^{
//            FolloupDoctorsViewController *doctorsVC = [[FolloupDoctorsViewController alloc]init];
//
//            doctorsVC.didSelectBlock = ^(FollowupDoctorModel *doctorModel) {
//                Bsky_StrongSelf
//                self.model.contentStr = doctorModel.employeeName;
//                self.model.value = doctorModel.employeeId;
//                self.contentTF.text = doctorModel.employeeName;
//
//            };
//            AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            UITabBarController *viewController = (UITabBarController *)deleate.window.rootViewController;
//            UINavigationController *nav = [viewController.viewControllers firstObject];
//            [nav pushViewController:doctorsVC animated:YES];
//        };
        
        
    }
    if (model.type == ArchiveModelTypeCustomOptionsPicker) {
        self.contentTF.rightViewMode = UITextFieldViewModeAlways;
        if ([model.pickerModel.options isEmptyArray] || !model.canEdit) {
            
        }else{
            if ([model.code isEqualToString:@"registerTownship,registerCommittee"] || [model.code isEqualToString:@"township,committee"]) {
                
                self.contentTF.tapAcitonBlock = ^{
                    if ([model.code isEqualToString:@"township,committee"] && ![ArchivePersonDataManager dataManager].zlCommitteeArrayOfAdress.count) {
                        [UIView makeToast:@"请先选择现住址所在的省、市、区!"];
                        return;
                    }
                    if ([model.code isEqualToString:@"registerTownship,registerCommittee"] && ![ArchivePersonDataManager dataManager].zlCommitteeArrayOfRegister.count) {
                        [UIView makeToast:@"请先选择户籍所在的省、市、区!"];
                        return;
                    }
                    ZLDisivionPicker *pickerView = [[ZLDisivionPicker alloc] init];
                    pickerView.type = ZLDisivionPickerTypeCommittee;
                    if ([model.code isEqualToString:@"registerTownship,registerCommittee"]) {
                        [pickerView setItems:[ArchivePersonDataManager dataManager].zlCommitteeArrayOfRegister title:_model.title defaultStr:_model.contentStr];
                    }else{
                        [pickerView setItems:[ArchivePersonDataManager dataManager].zlCommitteeArrayOfAdress title:_model.title defaultStr:_model.contentStr];
                    }
                    
                    pickerView.selectedIndex = ^(NSInteger firstIndex,NSInteger secondIndex ,NSInteger thirdIndex)
                    {
                        @strongify(self);
                        ArchiveDivisionModel *firstModel = nil;
                        ArchiveDivisionModel *secondModel = nil;
                        if ([self.model.code isEqualToString:@"registerTownship,registerCommittee"]){
                            if ([[ArchivePersonDataManager dataManager].zlCommitteeArrayOfRegister count] > firstIndex) {
                                firstModel = [[ArchivePersonDataManager dataManager].zlCommitteeArrayOfRegister objectAtIndex:firstIndex];
                            }
                        }else{
                            if ([[ArchivePersonDataManager dataManager].zlCommitteeArrayOfAdress count] > firstIndex) {
                                firstModel = [[ArchivePersonDataManager dataManager].zlCommitteeArrayOfAdress objectAtIndex:firstIndex];
                            }
                        }
                        
                        if ([firstModel.children count] > secondIndex) {
                            secondModel =  [firstModel.children objectAtIndex:secondIndex];
                        }
                        NSMutableString *contentStr = [[NSMutableString alloc] init];
                        NSMutableString *contentValue = [[NSMutableString alloc] init];
                        if (firstModel.divisionName.length) {
                            [contentStr appendString:firstModel.divisionName];
                        }
                        if (secondModel.divisionName.length) {
                            [contentStr appendString:secondModel.divisionName];
                        }
                        if (firstModel.divisionId.length) {
                            [contentValue appendString:firstModel.divisionId];
                        }
                        if (secondModel.divisionId.length) {
                            if (contentValue.length) {
                                [contentValue appendFormat:@",%@",secondModel.divisionId];
                            }else{
                                [contentValue appendString:secondModel.divisionId];
                            }
                        }
                        self.model.value = contentValue;
                        
                        self.model.contentStr = contentStr;
                        self.contentTF.text = contentStr;
                        
                        
                        
                        if (self.endBlock) {
                            self.endBlock(secondModel);
                        }
                    };
                    [pickerView show];
                };
            }else if ([model.code isEqualToString:@"registerProvince,registerCity,registerDistrict"] || [model.code isEqualToString:@"province,city,district"]){
                self.contentTF.tapAcitonBlock = ^{
                    ZLDisivionPicker *pickerView = [[ZLDisivionPicker alloc] init];
//                    NSArray *array = [ArchivePersonDataManager dataManager].zlCityArray;
                    pickerView.type = ZLDisivionPickerTypeCity;
                    [pickerView setItems:[ArchivePersonDataManager dataManager].zlCityArray title:_model.title defaultStr:_model.contentStr];
                    pickerView.selectedIndex = ^(NSInteger firstIndex,NSInteger secondIndex ,NSInteger thirdIndex)
                    {
                        @strongify(self);
                        ArchiveDivisionModel *firstModel = nil;
                        ArchiveDivisionModel *secondModel = nil;
                        ArchiveDivisionModel *thirdModel = nil;
                        if ([[ArchivePersonDataManager dataManager].zlCityArray count] > firstIndex) {
                            firstModel = [[ArchivePersonDataManager dataManager].zlCityArray objectAtIndex:firstIndex];
                        }
                        if ([firstModel.children count] > secondIndex) {
                            secondModel =  [firstModel.children objectAtIndex:secondIndex];
                        }
                        if ([secondModel.children count] > thirdIndex) {
                            thirdModel =  [secondModel.children objectAtIndex:thirdIndex];
                        }
                        
                        
                        self.model.value = [NSString stringWithFormat:@"%@,%@,%@",firstModel.divisionId,secondModel.divisionId,thirdModel.divisionId];
                        
                        self.model.contentStr = [NSString stringWithFormat:@"%@%@%@",firstModel.divisionName,secondModel.divisionName,thirdModel.divisionName];
                        self.contentTF.text = [NSString stringWithFormat:@"%@%@%@",firstModel.divisionName,secondModel.divisionName,thirdModel.divisionName];
                        if ([self.model.code isEqualToString:@"registerProvince,registerCity,registerDistrict"]) {
                            [[ArchivePersonDataManager dataManager] getCommitteeOfRegisterDict:thirdModel.divisionCode];
                        }else{
                            [[ArchivePersonDataManager dataManager] getCommitteeOfAdressDict:thirdModel.divisionCode];
                        }
                        
                        
                        if (self.endBlock) {
                            self.endBlock(secondModel);
                        }
                    };
                    [pickerView show];
                };
            }else if ([model.code isEqualToString:@""]){
                
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
                        
                        self.model.contentStr = [NSString stringWithFormat:@"%@%@",firstModel.divisionName,secondModel.divisionName];
                        self.contentTF.text = [NSString stringWithFormat:@"%@%@",firstModel.divisionName,secondModel.divisionName];
                        
                        
                        
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
                        
                        NSObject *model = self.model.pickerModel.options[index];
                        if ([self.model.code isEqualToString:@"relationshipType"]) {
                            if ([[ArchivePersonDataManager dataManager].zlFamilyRelationForHistory containsObject:[model valueForKey:@"value"]]) {
                                [UIView makeToast:@"已存在该亲属的家族史!"];
                                return;
                            }
                        }
                        self.model.pickerModel.selectOption = model;
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
#pragma mark --- 工具方法

-(BOOL )handleTextFieldWithString:(NSString *)str{
    if (!str.length) {
        return NO;
    }
    if ([self.model.code isEqualToString:@"qq"]) {
        if (![str validationQQ]) {
            [UIView makeToast:@"请输入有效QQ!"];
            return NO;
        }
    }else if ([self.model.code isEqualToString:@"weChat"]){
        if (![str validationWX]) {
            [UIView makeToast:@"请输入有效微信号!"];
            return NO;
        }
    }else if ([self.model.code isEqualToString:@"contactTelPhone"] || [self.model.code isEqualToString:@"telPhone"] || [self.model.code isEqualToString:@"ContactTel"]){
        if (![str isPhoneNumber] ) {
            [UIView makeToast:@"请输入有效手机号码!"];
            return NO;
        }
    }else if ([self.model.code isEqualToString:@"zipCode"]){
        if (![str validationPostCode]) {
            [UIView makeToast:@"请输入有效邮编!"];
            return NO;
        }
    }else if ([self.model.code isEqualToString:@"name"] || [self.model.code isEqualToString:@"contactName"]){
        if (![str isChinese]) {
            [UIView makeToast:@"请输入中文名字!"];
            return NO;
        }
    }else if ([self.model.code isEqualToString:@"CustomNumber"]){
        if ([str includeChinese]) {
            [UIView makeToast:@"编号只能由字符和数字组成!"];
            return NO;
        }
    }else if ([self.model.code isEqualToString:@"mail"]){
        if (![str validationEmail]) {
            [UIView makeToast:@"请输入有效的邮箱地址!"];
            return NO;
        }
    }else if ([self.model.code isEqualToString:@"healthCardId"]){
        if (![str validationHealthCard]) {
            [UIView makeToast:@"请输入有效健康卡号!"];
            return NO;
        }
    }
    
    return YES;
}
@end
