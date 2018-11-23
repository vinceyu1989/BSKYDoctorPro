//
//  ZLFollowupFormVM.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFollowupFormVM.h"
#import "ZLFollowupLastInfoBaseRequest.h"
#import "ZLFollowupCountRequest.h"
#import "ZLFollowupUpRequest.h"
#import "ZLFollowupUpModel.h"

@implementation ZLFollowupFormVM

SYNTHESIZE_SINGLETON_FOR_CLASS(ZLFollowupFormVM);

- (void)getLastDataWithPlanModel:(BSFollowup *)planModel success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    switch (planModel.followUpType.integerValue) {
        case FollowupTypeHypertension:
        {
            ZLFollowupLastInfoHyRequest *infoAllRequest = [[ZLFollowupLastInfoHyRequest alloc]init];
            infoAllRequest.personId = planModel.gwUserId;
            infoAllRequest.lastfollowdate = planModel.lastFollowDate;
            [infoAllRequest startWithCompletionBlockWithSuccess:success failure:failure];
        }
            break;
        case FollowupTypeDiabetes:
        {
            ZLFollowupLastInfoDbRequest *infoAllRequest = [[ZLFollowupLastInfoDbRequest alloc]init];
            infoAllRequest.personId = planModel.gwUserId;
            infoAllRequest.lastfollowdate = planModel.lastFollowDate;
            [infoAllRequest startWithCompletionBlockWithSuccess:success failure:failure];
        }
            break;
        default:
        {
            BSBaseRequest *request = [[BSBaseRequest alloc]init];
            failure(request);
        }
            break;
    }
}
- (void)getYearCountWithPlanModel:(BSFollowup *)planModel success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    switch (planModel.followUpType.integerValue) {
        case FollowupTypeHypertension:
        {
            ZLHyFollowupCountRequest *countRequest = [[ZLHyFollowupCountRequest alloc]init];
            countRequest.personId = planModel.gwUserId;
            [countRequest startWithCompletionBlockWithSuccess:success failure:failure];
        }
            break;
        case FollowupTypeDiabetes:
        {
            ZLDbFollowupCountRequest *countRequest = [[ZLDbFollowupCountRequest alloc]init];
            countRequest.personId = planModel.gwUserId;
            [countRequest startWithCompletionBlockWithSuccess:success failure:failure];
        }
            break;
        default:
        {
            BSBaseRequest *request = [[BSBaseRequest alloc]init];
            failure(request);
        }
            break;
    }
}

- (void)configDefaultUIArray:(NSMutableArray *)uiArray lastModel:(ZLFollowupLastModel *)dataModel planModel:(BSFollowup *)planModel
{
    for (int i = 0; i<uiArray.count; i++) {
        NSMutableArray *array = uiArray[i];
        for (InterviewInputModel *model in array) {
            if ([model.title isEqualToString:@"随访对象"]) {
                model.contentStr = planModel.username;
                dataModel.personName = planModel.username;
                dataModel.personId = planModel.gwUserId;
            }
            else if ([model.title isEqualToString:@"随访时间"]) {
                NSString *str = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
                model.contentStr = str;
                planModel.lastFollowDate = str;
                dataModel.followUpDate = str;
            }
            else if ([model.title isEqualToString:@"下次随访时间"])
            {
                NSString *str = [[[NSDate date] dateByAddingMonths:3] stringWithFormat:@"yyyy-MM-dd"];
                model.contentStr = str;
                planModel.followDate = str;
                dataModel.nextFollowUpDate = str;
            }
            else if ([model.title isEqualToString:@"随访医生"]) {
                ZLAccountInfo *info = [BSAppManager sharedInstance].currentUser.zlAccountInfo;
                dataModel.followUpDoctorId = info.employeeId;
                dataModel.registrant = info.employeeId;
                dataModel.orgId = info.orgId;
                planModel.doctorId = [BSAppManager sharedInstance].currentUser.userId;
                model.contentStr = info.employeeName;
            }
            else if ([model.title isEqualToString:@"随访分类"])
            {
                model.contentStr = @"控制满意";
                dataModel.fuClassification = @"控制满意";
            }
        }
    }
    
}
- (void)configUIArray:(NSMutableArray *)uiArray lastModel:(ZLFollowupLastModel *)dataModel planModel:(BSFollowup *)planModel
{
    NSMutableArray *drugArray = [NSMutableArray array];
    NSInteger drugI = 0;
    NSInteger drugJ = 0;
    for (int i = 0; i<uiArray.count; i++) {
        NSMutableArray *array = uiArray[i];
        for (int j = 0; j< array.count; j++) {
            InterviewInputModel *uiModel = array[j];
            switch (uiModel.type) {
                case BSFormCellTypeTextField:
                case BSFormCellTypeSingleRadio:
                case BSFormCellTypeWrapRadio:
                {
                    for (NSString *propertyName in dataModel.getProperties) {
                        if ([uiModel.propertyName isEqualToString:propertyName]) {
                            uiModel.contentStr = [dataModel valueForKey:propertyName];
                            break;
                        }
                    }
                }
                    break;
                case BSFormCellTypeDatePicker:
                {
                   if ([uiModel.title isEqualToString:@"随访时间"]) {
                        NSString *str = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
                        uiModel.contentStr = str;
                        planModel.lastFollowDate = str;
                        dataModel.followUpDate = str;
                    }
                    else if ([uiModel.title isEqualToString:@"下次随访时间"])
                    {
                        NSString *str = [[[NSDate date] dateByAddingMonths:3] stringWithFormat:@"yyyy-MM-dd"];
                        uiModel.contentStr = str;
                        planModel.followDate = str;
                        dataModel.nextFollowUpDate = str;
                    }
                    else
                    {
                        for (NSString *propertyName in dataModel.getProperties) {
                            if ([uiModel.propertyName isEqualToString:propertyName]) {
                                uiModel.contentStr = [dataModel valueForKey:propertyName];
                                break;
                            }
                        }
                    }
                }
                    break;
                case BSFormCellTypeChoicesAndOther:
                case BSFormCellTypeSingleRadioAndOther:
                {
                    for (NSString *propertyName in dataModel.getProperties) {
                        if ([uiModel.propertyName isEqualToString:propertyName]) {
                            uiModel.contentStr = [dataModel valueForKey:propertyName];
                        }
                        if ([uiModel.otherModel.propertyName isEqualToString:propertyName]) {
                            uiModel.otherModel.contentStr = [dataModel valueForKey:propertyName];
                        }
                    }
                }
                    break;
                case BSFormCellTypeCustomPicker:
                {
                    NSString *str = @"";
                    for (InterviewPickerModel *pickerModel in uiModel.pickerModels) {
                        for (NSString *propertyName in dataModel.getProperties) {
                            if ([pickerModel.propertyName isEqualToString:propertyName]) {
                                NSString *content = [dataModel valueForKey:propertyName];
                                if ([content isNotEmptyString]) {
                                    pickerModel.content = content;
                                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@",kFollowupSeparator,pickerModel.content]];
                                }
                            }
                        }
                    }
                    if (str.length > kFollowupSeparator.length) {
                        str = [str substringFromIndex:kFollowupSeparator.length];
                    }
                    uiModel.contentStr = str;
                }
                    break;
                case BSFormCellTypeTFEnabled:{
                    if ([uiModel.title containsString:@"体质指数"]) {
                        uiModel.contentStr = [NSString stringWithFormat:@"%@%@%@",dataModel.bmi,kFollowupSeparator,dataModel.nextBmi];
                        uiModel.contentStr = [uiModel.contentStr isNotEmptyString] ? uiModel.contentStr : nil;
                    }
                }
                    break;
                    
                default:
                    break;
            }
            if ([uiModel.title containsString:@"用药情况"]) {
                drugI = i;
                drugJ = j;
                for (ZLDrugModel *drugModel in dataModel.drugList) {
                    InterviewInputModel *uiModel = [[InterviewInputModel alloc]init];
                    uiModel.type = BSFormCellTypeDrug;
                    uiModel.object = drugModel;
                    [drugArray addObject:uiModel];
                }
            }
        }
    }
    if (drugArray.count >= 1) {
        NSMutableArray *tempArray = uiArray[drugI];
        [tempArray insertObjects:drugArray atIndex:drugJ+1];
    }
}
- (void)configDataModel:(ZLFollowupLastModel *)dataModel baseCell:(FormBaseCell *)cell uiModel:(InterviewInputModel *)uiModel
{
    if (uiModel.type == BSFormCellTypeCustomPicker) {
        for (InterviewPickerModel *pickerModel in uiModel.pickerModels) {
            for (NSString *propertyName in dataModel.getProperties) {
                if ([pickerModel.propertyName isEqualToString:propertyName]) {
                    [dataModel setValue:pickerModel.content forKey:propertyName];
                    break;
                }
            }
        }
    }
    else if (uiModel.type == BSFormCellTypeChoicesAndOther || uiModel.type == BSFormCellTypeSingleRadioAndOther)
    {
        for (NSString *propertyName in dataModel.getProperties) {
            if ([uiModel.propertyName isEqualToString:propertyName]) {
                [dataModel setValue:uiModel.contentStr forKey:propertyName];
                break;
            }
        }
        for (NSString *propertyName in dataModel.getProperties) {
            if ([uiModel.otherModel.propertyName isEqualToString:propertyName]) {
                [dataModel setValue:uiModel.otherModel.contentStr forKey:propertyName];
                break;
            }
        }
    }
    else if (uiModel.type == BSFormCellTypeTFEnabled)
    {
        
    }
    else
    {
        for (NSString *propertyName in dataModel.getProperties) {
            if ([uiModel.propertyName isEqualToString:propertyName]) {
                [dataModel setValue:uiModel.contentStr forKey:propertyName];
                break;
            }
        }
    }
}
- (FollowupCheckModel *)checkDataModel:(ZLFollowupLastModel *)dataModel planModel:(BSFollowup *)planModel uiArray:(NSMutableArray *)uiArray
{
    FollowupCheckModel *checkModel = [[FollowupCheckModel alloc]init];
    checkModel.isValid = YES;
    checkModel.contentStr = nil;
    for (int i = 0; i<uiArray.count; i++) {
        NSMutableArray *array = uiArray[i];
        for (int j = 0; j<array.count; j++) {
            InterviewInputModel *uiModel = array[j];
            if (uiModel.type == BSFormCellTypeDrug) {
                ZLDrugModel *drugModel = uiModel.object;
                for (NSString *key in drugModel.getProperties) {
                    NSString *value = [drugModel valueForKey:key];
                    if (!value || value.length < 1) {
                        checkModel.isValid = NO;
                        checkModel.contentStr = @"请完善药品信息";
                        checkModel.indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                        return checkModel;
                    }
                }
            }
            else if (uiModel.type != BSFormCellTypeSection ) {
                if (uiModel.isRequired) {
                    if (uiModel.contentStr.length < 1) {
                        if ((uiModel.otherModel && uiModel.otherModel.contentStr.length < 1) || !uiModel.otherModel) {
                            checkModel.isValid = NO;
                            if ([uiModel.title isNotEmptyString]) {
                                checkModel.contentStr = [NSString stringWithFormat:@"%@%@",uiModel.placeholder,[uiModel.title deleteBracketsString]];
                            }
                            else
                            {
                                checkModel.contentStr = uiModel.placeholder;
                            }
                            checkModel.indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                            return checkModel;
                        }
                    }
                }
            }
        }
    }
    return checkModel;
}
- (void)upDataModel:(ZLFollowupLastModel *)dataModel planModel:(BSFollowup *)planModel success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    switch (planModel.followUpType.integerValue) {
        case FollowupTypeHypertension:
        {
            ZLFollowupHyUpRequest *upRequest = [[ZLFollowupHyUpRequest alloc]init];
            NSMutableDictionary *dic = [dataModel mj_keyValues];
            ZLFollowupUpModel *upModel = [ZLFollowupUpModel mj_objectWithKeyValues:dic];
            dic = [upModel mj_keyValues];
            upRequest.hyForm = [NSMutableDictionary dictionaryWithDictionary:@{@"hyFollowUpForm":dic,@"followUpPlan":[planModel mj_keyValues]}];
            [upRequest startWithCompletionBlockWithSuccess:success failure:failure];
        }
            break;
        case FollowupTypeDiabetes:
        {
            ZLFollowupDbUpRequest *upRequest = [[ZLFollowupDbUpRequest alloc]init];
            NSMutableDictionary *dic = [dataModel mj_keyValues];
            ZLFollowupUpModel *upModel = [ZLFollowupUpModel mj_objectWithKeyValues:dic];
            dic = [upModel mj_keyValues];
            upRequest.dbForm = [NSMutableDictionary dictionaryWithDictionary:@{@"dbFollowUpForm":dic,@"followUpPlan":[planModel mj_keyValues]}];
            [upRequest startWithCompletionBlockWithSuccess:success failure:failure];
        }
            break;
        default:
            break;
    }
}
- (NSString *)getBmiStringWithDataModel:(ZLFollowupLastModel *)dataModel
{
    if (!dataModel) {
        return nil;
    }
    CGFloat bmi = 0;
    CGFloat nextBmi = 0;
    CGFloat height =  dataModel.height.floatValue/100.0;
    if (dataModel.weight.floatValue > 0 &&  height > 0) {
        bmi  = dataModel.weight.floatValue/pow(height, 2);
        bmi = round(bmi * 10) / 10;
        dataModel.bmi = [NSString stringWithFormat:@"%.2f",bmi];
    }
    if (dataModel.nextWeight.floatValue > 0 &&  height > 0) {
        nextBmi = dataModel.nextWeight.floatValue/pow(height, 2);
        dataModel.nextBmi = [NSString stringWithFormat:@"%.2f",nextBmi];
    }
    NSString *bmiString =  [NSString stringWithFormat:@"%.1f%@%.1f",bmi,kFollowupSeparator,nextBmi];
    return bmiString;
}

@end

@implementation FollowupCheckModel

@end



