//
//  FollowupFormsTool.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/4.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupFormsTool.h"
#import "InterviewInputModel.h"
#import "FollowupDbInfoAllRequest.h"
#import "FollowupHyInfoAllRequest.h"
#import "FollowupGtInfoAllRequest.h"
#import "FollowupDbYearCountRequest.h"
#import "FollowupHyYearCountRequest.h"

@implementation FollowupFormsTool

+ (void)initLastDataWithPlanModel:(BSFollowup *)planModel success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    switch (planModel.followUpType.integerValue) {
        case FollowupTypeHypertension:
        {
            FollowupHyInfoAllRequest *infoAllRequest = [[FollowupHyInfoAllRequest alloc]init];
            infoAllRequest.personId = planModel.gwUserId;
            infoAllRequest.lastfollowdate = planModel.lastFollowDate;
            [infoAllRequest startWithCompletionBlockWithSuccess:success failure:failure];
        }
            break;
        case FollowupTypeDiabetes:
        {
            FollowupDbInfoAllRequest *infoAllRequest = [[FollowupDbInfoAllRequest alloc]init];
            infoAllRequest.personId = planModel.gwUserId;
            infoAllRequest.lastfollowdate = planModel.lastFollowDate;
            [infoAllRequest startWithCompletionBlockWithSuccess:success failure:failure];
        }
            break;
        case FollowupTypeGaoTang:
        {
            FollowupGtInfoAllRequest *infoAllRequest = [[FollowupGtInfoAllRequest alloc]init];
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
+ (void)initLastCountWithPlanModel:(BSFollowup *)planModel success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    switch (planModel.followUpType.integerValue) {
        case FollowupTypeHypertension:
        {
            FollowupHyYearCountRequest *countRequest = [[FollowupHyYearCountRequest alloc]init];
            countRequest.personId = planModel.gwUserId;
            countRequest.doctorId = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;
            [countRequest startWithCompletionBlockWithSuccess:success failure:failure];
        }
            break;
        case FollowupTypeDiabetes:
        {
            FollowupDbYearCountRequest *countRequest = [[FollowupDbYearCountRequest alloc]init];
            countRequest.personId = planModel.gwUserId;
            countRequest.doctorId = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;
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

+(void)configDefaultUIArray:(NSMutableArray *)uiArray lastModel:(FollowupUpModel *)upModel planModel:(BSFollowup *)planModel
{
    for (InterviewInputModel *model in uiArray) {
        if ([model.title isEqualToString:@"随访时间"]) {
            NSString *str = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
            model.contentStr = str;
            planModel.lastFollowDate = str;
            upModel.cmModel.followUpDate = str;
        }
        else if ([model.title isEqualToString:@"下次随访时间"])
        {
            NSString *str = [[[NSDate date] dateByAddingMonths:3] stringWithFormat:@"yyyy-MM-dd"];
            model.contentStr = str;
            planModel.followDate = str;
            upModel.cmModel.nextFollowUpDate = str;
        }
        else if ([model.title isEqualToString:@"随访医生"]) {
            BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
            upModel.cmModel.doctorId = info.EmployeeID;
            upModel.cmModel.doctorName = info.UserName;
            model.contentStr = info.UserName;
        }
        else if ([model.title isEqualToString:@"随访分类"])
        {
            model.contentStr = @"1";
            upModel.cmModel.fuClassification = @1;
        }
    }
}

+ (void)configUIArray:(NSMutableArray *)uiArray lastModel:(FollowupUpModel *)upModel planModel:(BSFollowup *)planModel
{
    if (!uiArray || uiArray.count < 1 || !upModel || !planModel) {   // 非空判断
        return;
    }
    for (int j = 0; j<uiArray.count; j++) {
        InterviewInputModel *model = uiArray[j];
        if ([model.title isEqualToString:@"随访时间"]) {
            NSString *str = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
            model.contentStr = str;
            planModel.lastFollowDate = str;
            upModel.cmModel.followUpDate = str;
        }
        else if ([model.title isEqualToString:@"下次随访时间"])
        {
            NSString *str = [[[NSDate date] dateByAddingMonths:3] stringWithFormat:@"yyyy-MM-dd"];
            model.contentStr = str;
            planModel.followDate = str;
            upModel.cmModel.nextFollowUpDate = str;
        }
        else if ([model.title isEqualToString:@"随访方式"])
        {
            model.contentStr = upModel.cmModel.wayUp;
        }
        else if ([model.title isEqualToString:@"随访医生"])
        {
            BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
            upModel.cmModel.doctorId = info.EmployeeID;
            upModel.cmModel.doctorName = info.UserName;
            model.contentStr = info.UserName;
        }
        else if ([model.title isEqualToString:@"症状(多选)"]) {
            model.contentStr =  [NSString stringWithFormat:@"%@",upModel.cmModel.symptom];
            model.object = planModel.followUpType;
            model.placeholder = [[self class] getOtherSymptomStrWithUpModel:upModel];
        }
        else if ([model.title isEqualToString:@"心率(次/分钟)"])
        {
            if (upModel.type.integerValue == FollowupTypeGaoTang) {
                model.contentStr =  [NSString stringWithFormat:@"%@%@%@",upModel.body.heartRate,kFollowupSeparator,upModel.cmModel.nextHeartRate];
            }
            else
            {
                 model.contentStr =  [NSString stringWithFormat:@"%@",upModel.body.heartRate];
            }
        }
        else if ([model.title isEqualToString:@"血压(mmHg)"])
        {
            model.contentStr = [NSString stringWithFormat:@"收缩压%@%@舒张压%@",upModel.body.rightSbp,kFollowupSeparator,upModel.body.rightDbp];
        }
        else if ([model.title isEqualToString:@"身高(cm)"])
        {
            if (upModel.body.height) {
                model.contentStr = [NSString stringWithFormat:@"%.f", upModel.body.height.floatValue];
            }
        }
        else if ([model.title isEqualToString:@"体重(kg)"])
        {
            if (upModel.body.weight) {
                model.contentStr = [NSString stringWithFormat:@"%.1f",upModel.body.weight.floatValue];
            }
        }
        else if ([model.title isEqualToString:@"目标体重(kg)"])
        {
            model.contentStr =  [NSString stringWithFormat:@"%@",upModel.cmModel.nextWeight];
        }
        else if ([model.title isEqualToString:@"空腹血糖值(mmol/L)"])
        {
            if (upModel.labora.fastingBloodGlucose.integerValue > 0) {
                model.contentStr =  [NSString stringWithFormat:@"%.2f",upModel.labora.fastingBloodGlucose.floatValue];
            }
            else
            {
                upModel.labora.fastingBloodGlucose = nil;
            }
        }
        else if ([model.title isEqualToString:@"餐后血糖值(mmol/L)"])
        {
            if (upModel.labora.postprandialBloodGlucose.integerValue > 0) {
                model.contentStr =  [NSString stringWithFormat:@"%.2f",upModel.labora.postprandialBloodGlucose.floatValue];
            }
            else
            {
                upModel.labora.postprandialBloodGlucose = nil;
            }
        }
        else if ([model.title isEqualToString:@"随机血糖值(mmol/L)"])
        {
            if (upModel.labora.randomBloodGlucose.integerValue > 0) {
                model.contentStr =  [NSString stringWithFormat:@"%.2f",upModel.labora.randomBloodGlucose.floatValue];
            }
            else
            {
                upModel.labora.randomBloodGlucose = nil;
            }
        }
        else if ([model.title isEqualToString:@"糖化血红蛋白(%)"])
        {
            if (upModel.labora.glycatedHemoglobin.integerValue > 0) {
                model.contentStr =  [NSString stringWithFormat:@"%.2f",upModel.labora.glycatedHemoglobin.floatValue];
            }
            else
            {
                upModel.labora.glycatedHemoglobin = nil;
            }
        }
        else if ([model.title isEqualToString:@"检查日期"])
        {
            model.contentStr = [upModel.labora.examDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
        }
        else if ([model.title isEqualToString:@"足背动脉搏动"])
        {
            model.contentStr = upModel.body.dorsalisPedisArteryPulse;
        }
        else if ([model.title isEqualToString:@"视力"])
        {
            if (upModel.organ.leftEye && upModel.organ.rightEye) {
                model.contentStr =  [NSString stringWithFormat:@"%@%@%@",upModel.organ.leftEye,kFollowupSeparator,upModel.organ.rightEye];
            }
        }
        else if ([model.title isEqualToString:@"矫正视力"])
        {
            if (upModel.organ.leftEyeVc && upModel.organ.rightEyeVc) {
                model.contentStr =  [NSString stringWithFormat:@"%@%@%@",upModel.organ.leftEyeVc,kFollowupSeparator,upModel.organ.rightEyeVc];
            }
        }
        else if ([model.title isEqualToString:@"听力"])
        {
            model.contentStr = [NSString stringWithFormat:@"%ld",(long)upModel.organ.hearing.integerValue];
        }
        else if ([model.title isEqualToString:@"运动"])
        {
            model.contentStr = [NSString stringWithFormat:@"%ld",(long)upModel.organ.motorFunction.integerValue];
        }
        else if ([model.title isEqualToString:@"日饮酒量(两/日)"])
        {
            model.contentStr = [NSString stringWithFormat:@"%@%@%@",upModel.lifeStyle.dailyAlcoholIntake,kFollowupSeparator,upModel.cmModel.nextDailyAlcohol];
        }
        else if ([model.title isEqualToString:@"日吸烟量(支/日)"])
        {
            model.contentStr = [NSString stringWithFormat:@"%@%@%@",upModel.lifeStyle.smoking,kFollowupSeparator,upModel.cmModel.nextSmoking];
        }
        else if ([model.title isEqualToString:@"主食(克/日)"])
        {
            model.contentStr = [NSString stringWithFormat:@"%@%@%@",upModel.cmModel.staple,kFollowupSeparator,upModel.cmModel.nextStaple];
        }
        else if ([model.title isEqualToString:@"摄盐情况"])
        {
            model.contentStr = upModel.cmModel.saltIntake;
        }
        else if ([model.title isEqualToString:@"目标摄盐情况"])
        {
            model.contentStr = upModel.cmModel.nextSaltIntake;
        }
        else if ([model.title isEqualToString:@"运动次数(次/周)"])
        {
            model.contentStr = [NSString stringWithFormat:@"%@%@%@",upModel.lifeStyle.exerciseWeekTimes,kFollowupSeparator,upModel.cmModel.nextExerciseWeekTimes];
        }
        else if ([model.title isEqualToString:@"运动时间(分钟/次)"])
        {
            model.contentStr = [NSString stringWithFormat:@"%@%@%@",upModel.lifeStyle.eachExerciseTime,kFollowupSeparator,upModel.cmModel.nextExerciseWeekMinute];
        }
        else if ([model.title isEqualToString:@"心理调整"])
        {
            NSNumber *num = upModel.cmModel.psychologicalAdjustment;
            model.contentStr = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
        }
        else if ([model.title isEqualToString:@"遵医行为"])
        {
            NSNumber *num = upModel.cmModel.complianceBehavior;
            model.contentStr = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
        }
        else if ([model.title isEqualToString:@"服药依从性"])
        {
            NSNumber *num = upModel.cmModel.medicationCompliance;
            model.contentStr = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
        }
        else if ([model.title isEqualToString:@"高血压服药依从性"])
        {
            NSNumber *num = upModel.cmModel.hyMedicationCompliance;
            model.contentStr = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
        }
        else if ([model.title isEqualToString:@"糖尿病服药依从性"])
        {
            NSNumber *num = upModel.cmModel.dbMedicationCompliance;
            model.contentStr = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
        }
        else if ([model.title isEqualToString:@"药物不良反应"])
        {
            model.contentStr = upModel.cmModel.adverseDrugReactions;
            model.object = [[self class] getAdverseDrugReactionsStrWithUpModel:upModel];
        }
        else if ([model.title isEqualToString:@"低血糖反应"])
        {
            model.contentStr = upModel.cmModel.lowBloodSugarReactions;
        }
        else if ([model.title isEqualToString:@"用药情况"])
        {
            for (int k = 0; k<upModel.drug.count; k++) {
                InterviewInputModel *uiModel = [[InterviewInputModel alloc]init];
                uiModel.title = kFollowupAddMedicateP;
                uiModel.object = upModel.drug[k];
                [uiArray insertObject:uiModel atIndex:j+1+k];
            }
        }
        else if ([model.title isEqualToString:@"高血压用药情况"])
        {
            for (int k = 0; k<upModel.drugUseList.count; k++) {
                InterviewInputModel *uiModel = [[InterviewInputModel alloc]init];
                uiModel.title = kFollowupAddMedicateG;
                uiModel.object = upModel.drugUseList[k];
                [uiArray insertObject:uiModel atIndex:j+1+k];
            }
        }
        else if ([model.title isEqualToString:@"糖尿病用药情况"])
        {
            for (int k = 0; k<upModel.diabetesUseList.count; k++) {
                InterviewInputModel *uiModel = [[InterviewInputModel alloc]init];
                uiModel.title = kFollowupAddMedicateT;
                uiModel.object = upModel.diabetesUseList[k];
                [uiArray insertObject:uiModel atIndex:j+1+k];
            }
        }
        else if ([model.title isEqualToString:@"胰岛素"])
        {
            for (int k = 0; k<upModel.insulinDrug.count; k++) {
                InterviewInputModel *uiModel = [[InterviewInputModel alloc]init];
                uiModel.title = kFollowupAddMedicateY;
                uiModel.object = upModel.insulinDrug[k];
                [uiArray insertObject:uiModel atIndex:j+1+k];
            }
        }
        else if ([model.title isEqualToString:@"随访分类"])
        {
            NSNumber *num = upModel.cmModel.fuClassification;
            if (num.integerValue > 0) {
                model.contentStr = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
            }
            else
            {
                model.contentStr = @"1";
                upModel.cmModel.fuClassification = @1;
            }
        }
        else if ([model.title isEqualToString:@"随访结局(非必填)"])
        {
            model.object = upModel.cmModel.followUpRemarks;
        }
        if (!model.contentStr) {
            model.contentStr = @"";
        }
    }
}
+ (NSString *)getOtherSymptomStrWithUpModel:(FollowupUpModel *)upModel
{
    for (Other *otherModel in upModel.other) {
        if ([otherModel.attrName isEqualToString:@"Symptom"]) {
            return otherModel.otherText;
        }
    }
    return nil;
}
+ (NSString *)getAdverseDrugReactionsStrWithUpModel:(FollowupUpModel *)upModel
{
    for (Other *otherModel in upModel.other) {
        if ([otherModel.attrName isEqualToString:@"AdverseDrugReactions"]) {
            return otherModel.otherText;
        }
    }
    return nil;
}

+ (NSString *)checkUpModel:(FollowupUpModel *)upModel planModel:(BSFollowup *)planModel
{
    upModel.cmModel.personId = planModel.gwUserId;
    
    upModel.orgId = [BSAppManager sharedInstance].currentUser.phisInfo.OrgId;
    upModel.cmModel.userId = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;
    
    planModel.followDate = upModel.cmModel.nextFollowUpDate;
    planModel.lastFollowDate = upModel.cmModel.followUpDate;
    planModel.doctorId = [BSAppManager sharedInstance].currentUser.userId;
    // 症状判断
    BOOL isHaveSymptom = NO;
    for (Other *other in upModel.other) {
        if ([other.attrName isEqualToString:@"Symptom"]) {
            isHaveSymptom = YES;
            break;
        }
    }
    // 非空判断
    NSString *json = nil;
    
    if (!upModel.cmModel.followUpDate)
    {
        [UIView makeToast:@"请选择随访时间"];
    }
    else if (!upModel.cmModel.nextFollowUpDate)
    {
        [UIView makeToast:@"请选择下次随访时间"];
    }
    else if (!upModel.cmModel.wayUp)
    {
        [UIView makeToast:@"请选择随访方式"];
    }
    else if (upModel.cmModel.symptom.integerValue < 1 && !isHaveSymptom)
    {
        [UIView makeToast:@"请选择症状"];
    }
    else if (!upModel.body.heartRate && planModel.followUpType.integerValue == FollowupTypeHypertension)
    {
        [UIView makeToast:@"请选择心率"];
    }
    else if (!upModel.body.leftDbp && !upModel.body.rightDbp)
    {
        [UIView makeToast:@"请选择血压"];
    }
    else if (!upModel.body.height)
    {
        [UIView makeToast:@"请选择身高"];
    }
    else if (!upModel.body.weight)
    {
        [UIView makeToast:@"请填写体重"];
    }
    else if (!upModel.cmModel.nextWeight)
    {
        [UIView makeToast:@"请填写目标体重"];
    }
    else if ((!upModel.labora.fastingBloodGlucose &&
              (planModel.followUpType.integerValue == FollowupTypeDiabetes ||
               planModel.followUpType.integerValue == FollowupTypeGaoTang))
             && (!upModel.labora.postprandialBloodGlucose &&
                 (planModel.followUpType.integerValue == FollowupTypeDiabetes ||
                  planModel.followUpType.integerValue == FollowupTypeGaoTang))
             &&(!upModel.labora.randomBloodGlucose &&
                (planModel.followUpType.integerValue == FollowupTypeDiabetes ||
                 planModel.followUpType.integerValue == FollowupTypeGaoTang)))
    {
        [UIView makeToast:@"请餐后、空腹、随机血糖值至少选填一项"];
    }
    else if (upModel.labora.postprandialBloodGlucose &&
             (upModel.labora.postprandialBloodGlucose.integerValue < 1 ||
              upModel.labora.postprandialBloodGlucose.integerValue > 30) &&
            (planModel.followUpType.integerValue == FollowupTypeDiabetes || planModel.followUpType.integerValue == FollowupTypeGaoTang))
    {
        [UIView makeToast:@"餐后血糖值请填写1-30范围内"];
    }
    else if (!upModel.cmModel.fuClassification)
    {
        [UIView makeToast:@"请选择随访分类"];
    }
    else if (!upModel.cmModel.doctorName)
    {
        [UIView makeToast:@"请选择随访医生"];
    }
    else
    {
        upModel.type = nil; //  把不需要的数据置空
        NSMutableDictionary *dic = [upModel mj_keyValues];
        NSString *key = nil;
        switch (planModel.followUpType.integerValue) {
            case FollowupTypeHypertension:
            {
                key = @"cmHyper";
                if (dic[@"insulinDrug"]) {
                    [dic removeObjectForKey:@"insulinDrug"];
                }
            }
                break;
            case FollowupTypeDiabetes:
            {
                key = @"cmDiab";
            }
                break;
            case FollowupTypeGaoTang:
            {
                key = @"cmHyDb";
                if (dic[@"diabetesUseList"]) {
                    [dic setObject:dic[@"diabetesUseList"] forKey:@"diabetesuse"];
                    [dic removeObjectForKey:@"diabetesUseList"];
                }
                if (dic[@"drugUseList"]) {
                    [dic setObject:dic[@"drugUseList"] forKey:@"drugJson"];
                    [dic removeObjectForKey:@"drugUseList"];
                }
                if (dic[@"drug"]) {
                    [dic removeObjectForKey:@"drug"];
                }
            }
                break;
            default:
                break;
        }
        [dic setObject:dic[@"cmModel"] forKey:key];
        [dic removeObjectForKey:@"cmModel"];
//        for (NSString *dicKey in dic.allKeys) {     // 删除空值
//            if ([dicKey isEqualToString:@"lifeStyle"] || [dicKey isEqualToString:@"organ"]) {
//
//            }
//            else
//            {
//                NSObject *obj = dic[dicKey];
//                if (!obj) {
//                    [dic removeObjectForKey:dicKey];
//                }
//                else if ([obj isString] && ([(NSString *)obj length] < 1))
//                {
//                    [dic removeObjectForKey:dicKey];
//                }
//                else if ([obj isArray] && ([(NSArray *)obj count] < 1))
//                {
//                    [dic removeObjectForKey:dicKey];
//                }
//                else if ([obj isDictionary] && ([((NSDictionary *)obj).allKeys count] < 1))
//                {
//                    [dic removeObjectForKey:dicKey];
//                }
//            }
//        }
        json = dic.mj_JSONString;
        [MobClick event:@"SubmitFollowup"];  // 友盟统计
    }
    return json;
}
+ (NSString *)getBmiStringWithUpModel:(FollowupUpModel *)upModel
{
    if (!upModel) {
        return nil;
    }
    CGFloat bmi = 0;
    CGFloat nextBmi = 0;
    CGFloat height =  upModel.body.height.floatValue/100.0;
    if (upModel.body.weight.floatValue > 0 &&  height > 0) {
        bmi  = upModel.body.weight.floatValue/pow(height, 2);
        bmi = round(bmi * 10) / 10;
        upModel.body.bmi = @(bmi);
    }
    if (upModel.cmModel.nextWeight.floatValue > 0 &&  height > 0) {
        nextBmi = upModel.cmModel.nextWeight.floatValue/pow(height, 2);
    }
    else if (upModel.cmModel.nextWeight.floatValue > 0 &&  height > 0)
    {
        nextBmi = upModel.cmModel.nextWeight.floatValue/pow(height, 2);
    }
    NSString *bmiString =  [NSString stringWithFormat:@"%.1f%@%.1f",bmi,kFollowupSeparator,nextBmi];
    return bmiString;
}
+ (BOOL)checkDurgInfoWithUpModel:(FollowupUpModel *)upModel
{
    for (Drug *drug in upModel.drug) {
        if (![drug.cmDrugName isNotEmptyString] || ![drug.eachDose isNotEmptyString] || ![drug.dailyTimes isNotEmptyString] ||
            ![drug.remark isNotEmptyString]
            ) {
            [UIView makeToast:@"请完善药品信息"];
            return NO;
        }
    }
    for (Drug *drug in upModel.drugUseList) {
        if (![drug.cmDrugName isNotEmptyString] || ![drug.eachDose isNotEmptyString] || ![drug.dailyTimes isNotEmptyString] ||
            ![drug.remark isNotEmptyString]
            ) {
            [UIView makeToast:@"请完善高血压药品信息"];
            return NO;
        }
    }
    for (Drug *drug in upModel.diabetesUseList) {
        if (![drug.cmDrugName isNotEmptyString] || ![drug.eachDose isNotEmptyString] || ![drug.dailyTimes isNotEmptyString] ||
            ![drug.remark isNotEmptyString]
            ) {
            [UIView makeToast:@"请完善糖尿病药品信息"];
            return NO;
        }
    }
    for (InsulinDrug *drug in upModel.insulinDrug) {
        if (![drug.drugs isNotEmptyString] || drug.eachDose <=0 || ![drug.dailyTimes isNotEmptyString] ||
            ![drug.remark isNotEmptyString]
            ) {
            [UIView makeToast:@"请完善胰岛素信息"];
            return NO;
        }
    }
    return YES;
}

@end
