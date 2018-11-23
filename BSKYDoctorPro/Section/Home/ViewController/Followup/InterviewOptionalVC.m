//
//  InterviewOptionalVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/5.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "InterviewOptionalVC.h"
#import "InterviewInputModel.h"
#import "InterviewTextInputCell.h"
#import "InterviewSectionCell.h"
#import "InterviewRadioCell.h"
#import "InterviewSignsCell.h"
#import "InterviewBlankCell.h"
#import "InterviewCommitCell.h"
#import "InterviewLifestyleCell.h"
#import "SettingTableViewCell.h"
#import "InterviewMedicateCell.h"
#import "AuxiliaryCheckVC.h"
#import "UIViewController+BackButtonHandler.h"

@interface InterviewOptionalVC ()<InterviewMedicateCellDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,strong) NSMutableArray *inputArray;

@property (nonatomic ,assign) BOOL isLifestyleExpansion;

@property (nonatomic ,strong) InterviewMedicateCell *tempCell;

@property (nonatomic ,strong) AuxiliaryCheckVC *auxiliaryCheckVC;


@end

@implementation InterviewOptionalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}
- (void)initView
{
    switch (self.type) {
        case FollowupTypeHypertension:
            self.title = @"高血压随访";
            break;
        case FollowupTypeDiabetes:
            self.title = @"糖尿病随访";
            break;
        default:
            break;
    }
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.tableView registerNib:[InterviewSectionCell nib] forCellReuseIdentifier:[InterviewSectionCell cellIdentifier]];
    [self.tableView registerNib:[InterviewTextInputCell nib] forCellReuseIdentifier:[InterviewTextInputCell cellIdentifier]];
    [self.tableView registerClass:[InterviewRadioCell class] forCellReuseIdentifier:[InterviewRadioCell cellIdentifier]];
    [self.tableView registerNib:[InterviewSignsCell nib] forCellReuseIdentifier:[InterviewSignsCell cellIdentifier]];
    [self.tableView registerNib:[InterviewBlankCell nib] forCellReuseIdentifier:[InterviewBlankCell cellIdentifier]];
    
    [self.tableView registerNib:[InterviewCommitCell nib] forCellReuseIdentifier:[InterviewCommitCell cellIdentifier]];
    [self.tableView registerNib:[InterviewLifestyleCell nib] forCellReuseIdentifier:[InterviewLifestyleCell cellIdentifier]];
    [self.tableView registerNib:[SettingTableViewCell nib] forCellReuseIdentifier:[SettingTableViewCell cellIdentifier]];
    
    [self.tableView registerNib:[InterviewMedicateCell nib] forCellReuseIdentifier:[InterviewMedicateCell cellIdentifier]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
}
- (void)initData
{
    self.isLifestyleExpansion = YES;
    [self configInputArrayWithLastAllModel];
}
- (NSArray *)inputArray
{
    if (!_inputArray) {
        _inputArray = [NSMutableArray array];
        
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"InterviewOptionalInputModel" ofType:@"json"]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [NSArray array];
        switch (self.type) {
            case FollowupTypeHypertension:
                array = dic[@"hypertension"];
                break;
            case FollowupTypeDiabetes:
                array = dic[@"diabetes"];
                break;
            default:
                break;
        }
        for (NSArray *tempArray in array) {
            NSArray *modelArray = [InterviewInputModel mj_objectArrayWithKeyValuesArray:tempArray];
            [_inputArray addObject:modelArray];
        }
    }
    return _inputArray;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   NSArray *array =  self.inputArray[section];
    switch (section) {
        case 0:  // 非必选项
            return  array.count + 1;
            break;
        case 1:  // 生活方式
            return  self.isLifestyleExpansion ? array.count + 2 : 2;
            break;
        case 2:  // 辅助检查
            return  2;
            break;
        case 3:  // 服药依从性等
            return  array.count + 1;
            break;
        case 4:  // 用药情况
            return  self.upModel.drug.count + 2;
            break;
        case 5:  // 胰岛素
            return self.type == FollowupTypeDiabetes ? self.upModel.insulinDrug.count + 2 : 0;
            break;
        case 6:  // 随访结局
            return  array.count+1;
            break;
        case 7:  // 保存(交互统一)
            return  0;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    NSArray *array =  self.inputArray[indexPath.section];
    
    switch (indexPath.section) {
            
        case 0:
        {
            InterviewInputModel *model = nil;
            if (indexPath.row-1 >= 0) {
               model = array[indexPath.row-1];
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewSectionCell cellIdentifier] forIndexPath:indexPath];
                    InterviewSectionCell *tableCell = (InterviewSectionCell *)cell;
                    tableCell.titleLabel.text = @"非必填项";
                    tableCell.moreIcon.hidden = YES;
                }
                 break;
                    
                default:
                    if ([model.options isNotEmptyArray]) {
                        
                        cell = [tableView dequeueReusableCellWithIdentifier:[InterviewRadioCell cellIdentifier] forIndexPath:indexPath];
                        InterviewRadioCell *tableCell = (InterviewRadioCell *)cell;
                        tableCell.upModel = self.upModel;
                        tableCell.model = model;
                    }
                    else
                    {
                        cell = [tableView dequeueReusableCellWithIdentifier:[InterviewTextInputCell cellIdentifier] forIndexPath:indexPath];
                        InterviewTextInputCell *tableCell = (InterviewTextInputCell *)cell;
                        tableCell.upModel = self.upModel;
                        tableCell.model = model;
                    }
                    break;
            }
        }
            
            break;
        case 1:
        {
            InterviewInputModel *model = nil;
            if (indexPath.row-2 >= 0) {
                model = array[indexPath.row-2];
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewLifestyleCell cellIdentifier] forIndexPath:indexPath];
                    InterviewLifestyleCell *tableCell = (InterviewLifestyleCell *)cell;
                    tableCell.titleLabel.text = @"生活方式";
                    tableCell.icon.image = self.isLifestyleExpansion ? [UIImage imageNamed:@"收起"] : [UIImage imageNamed:@"展开"];
                }
                    break;
                    
                default:
                    if ([model.options isNotEmptyArray]) {
                        
                        cell = [tableView dequeueReusableCellWithIdentifier:[InterviewRadioCell cellIdentifier] forIndexPath:indexPath];
                        InterviewRadioCell *tableCell = (InterviewRadioCell *)cell;
                        tableCell.model = model;
                    }
                    else
                    {
                        cell = [tableView dequeueReusableCellWithIdentifier:[InterviewTextInputCell cellIdentifier] forIndexPath:indexPath];
                        InterviewTextInputCell *tableCell = (InterviewTextInputCell *)cell;
                        tableCell.upModel = self.upModel;
                        tableCell.model = model;
                    }
                    break;
            }
        }
            
            break;
            
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[SettingTableViewCell cellIdentifier] forIndexPath:indexPath];
                    SettingTableViewCell *tableCell = (SettingTableViewCell *)cell;
                    tableCell.titleLabel.text = @"辅助检查";
                }
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
        case 3:
        {
            InterviewInputModel *model = nil;
            if (indexPath.row-1 >= 0) {
                model = array[indexPath.row-1];
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
                }
                    break;
                    
                default:
                    if ([model.options isNotEmptyArray]) {
                        
                        cell = [tableView dequeueReusableCellWithIdentifier:[InterviewRadioCell cellIdentifier] forIndexPath:indexPath];
                        InterviewRadioCell *tableCell = (InterviewRadioCell *)cell;
                        tableCell.model = model;
                    }
                    else
                    {
                        cell = [tableView dequeueReusableCellWithIdentifier:[InterviewTextInputCell cellIdentifier] forIndexPath:indexPath];
                        InterviewTextInputCell *tableCell = (InterviewTextInputCell *)cell;
                        tableCell.upModel = self.upModel;
                        tableCell.model = model;
                    }
                    break;
            }
        }
            
            break;
        case 4:
        {
            Drug *model = nil;
            if (indexPath.row - 2 >= 0) {
                model = self.upModel.drug[indexPath.row-2];
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewLifestyleCell cellIdentifier] forIndexPath:indexPath];
                    InterviewLifestyleCell *tableCell = (InterviewLifestyleCell *)cell;
                    tableCell.titleLabel.text = @"用药情况";
                    tableCell.icon.image = [UIImage imageNamed:@"add_icon_normal"];
                    
                }
                    break;
                    
                default:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewMedicateCell cellIdentifier] forIndexPath:indexPath];
                    InterviewMedicateCell *tableCell = (InterviewMedicateCell *)cell;
                    if (!tableCell.delegate) {
                        tableCell.delegate = self;
                    }
                    tableCell.drug = model;
                    tableCell.insulinDrug = nil;
                }
                    break;
            }
        }
            
            break;
        case 5:
        {
            InsulinDrug *model = nil;
            if (indexPath.row - 2 >= 0) {
                model = self.upModel.insulinDrug[indexPath.row-2];
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewLifestyleCell cellIdentifier] forIndexPath:indexPath];
                    InterviewLifestyleCell *tableCell = (InterviewLifestyleCell *)cell;
                    tableCell.titleLabel.text = @"胰岛素";
                    tableCell.icon.image = [UIImage imageNamed:@"add_icon_normal"];
                    
                }
                    break;
                    
                default:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewMedicateCell cellIdentifier] forIndexPath:indexPath];
                    InterviewMedicateCell *tableCell = (InterviewMedicateCell *)cell;
                    if (!tableCell.delegate) {
                        tableCell.delegate = self;
                    }
                    tableCell.insulinDrug = model;
                    tableCell.drug = nil;
                }
                    break;
            }
        }
            break;
        case 6:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewTextInputCell cellIdentifier] forIndexPath:indexPath];
                    InterviewTextInputCell *tableCell = (InterviewTextInputCell *)cell;
                    InterviewInputModel *model = array[indexPath.row - 1];
                    tableCell.upModel = self.upModel;
                    tableCell.model = model;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 7:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewCommitCell cellIdentifier] forIndexPath:indexPath];
                    InterviewCommitCell *tableCell = (InterviewCommitCell *)cell;
                    tableCell.contentLabel.text = @"保存";
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        self.isLifestyleExpansion = !self.isLifestyleExpansion;
        NSArray *array =  self.inputArray[indexPath.row];
        NSMutableArray *pathArray = [NSMutableArray array];
        for (int i = 2; i<array.count+2; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            [pathArray addObject:path];
        }
        [self.tableView beginUpdates];
        if (!self.isLifestyleExpansion) {
            [self.tableView deleteRowsAtIndexPaths:pathArray withRowAnimation:UITableViewRowAnimationTop];
        }
        else
        {
            [self.tableView insertRowsAtIndexPaths:pathArray withRowAnimation:UITableViewRowAnimationBottom];
        }
        InterviewLifestyleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
         cell.icon.image = self.isLifestyleExpansion ? [UIImage imageNamed:@"收起"] : [UIImage imageNamed:@"展开"];
        [self.tableView endUpdates];
    }
    else if (indexPath.section == 2 && indexPath.row == 1) {
        if (!self.auxiliaryCheckVC) {
            self.auxiliaryCheckVC = [[AuxiliaryCheckVC alloc]init];
        }
        self.auxiliaryCheckVC.upModel = self.upModel;
        [self.navigationController pushViewController:self.auxiliaryCheckVC animated:YES];
    }
    
    else if (indexPath.section == 4 && indexPath.row == 1) {
        
        Drug *medicateModel = [[Drug alloc]init];
        [self.upModel.drug  insertObject:medicateModel atIndex:0];
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:indexPath.section];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    }
    else if (indexPath.section == 5 && indexPath.row == 1) {
        
        InsulinDrug *medicateModel = [[InsulinDrug alloc]init];
        if (!self.upModel.insulinDrug) {
            self.upModel.insulinDrug = [NSMutableArray array];
        }
        [self.upModel.insulinDrug insertObject:medicateModel atIndex:0];
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:indexPath.section];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    }
    else if (indexPath.section == 7 && indexPath.row == 1)
    {
        if ([self checkDurgInfo]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark --- 检查药品信息

- (BOOL)checkDurgInfo
{
    for (Drug *drug in self.upModel.drug) {
        if (![drug.cmDrugName isNotEmptyString] || ![drug.eachDose isNotEmptyString] || ![drug.dailyTimes isNotEmptyString] ||
            ![drug.remark isNotEmptyString]
            ) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请完善药品信息" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.tag = 1301;
            [alertView show];
            return NO;
        }
    }
    for (InsulinDrug *drug in self.upModel.insulinDrug) {
        if (![drug.drugs isNotEmptyString] || drug.eachDose <=0 || ![drug.dailyTimes isNotEmptyString] ||
            ![drug.remark isNotEmptyString]
            ) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请完善胰岛素信息" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.tag = 1301;
            [alertView show];
            return NO;
        }
    }
    return YES;
}

#pragma mark ----- InterviewMedicateCellDelegate

- (void)interviewMedicateCellDelete:(InterviewMedicateCell *)cell
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除本条用药信息?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.tag = 1300;
    [alertView show];
    self.tempCell = cell;   
}
#pragma mark ----- BackButtonHandlerProtocol

-(BOOL)navigationShouldPopOnBackButton
{
    return [self checkDurgInfo];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewDelayedTouchesBeganGestureRecognizer")])
    {
        return [self checkDurgInfo];
    }
    return YES;
}
#pragma mark ----- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1301) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            self.tempCell = nil;
            break;
        default:
        {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:self.tempCell];
            [self.tableView beginUpdates];
            if (indexPath.section == 4) {
                [self.upModel.drug  removeObject:self.tempCell.drug];
            }
            else if (indexPath.section == 5)
            {
                [self.upModel.insulinDrug removeObject:self.tempCell.insulinDrug];
            }
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:self.tempCell]] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
        }
            break;
    }
}
#pragma mark ---- 配置全表单数据
- (void)configInputArrayWithLastAllModel
{
    for (NSArray *array in self.inputArray) {
        for (InterviewInputModel *model in array) {
            if ([model.title isEqualToString:@"足背动脉搏动"])
            {
                model.contentStr = self.upModel.body.dorsalisPedisArteryPulse;
            }
            else if ([model.title isEqualToString:@"视力"])
            {
                if (self.upModel.organ.leftEye && self.upModel.organ.rightEye) {
                    model.contentStr =  [NSString stringWithFormat:@"%@%@%@",self.upModel.organ.leftEye,kFollowupSeparator,self.upModel.organ.rightEye];
                }
            }
            else if ([model.title isEqualToString:@"矫正视力"])
            {
                if (self.upModel.organ.leftEyeVc && self.upModel.organ.rightEyeVc) {
                    model.contentStr =  [NSString stringWithFormat:@"%@%@%@",self.upModel.organ.leftEyeVc,kFollowupSeparator,self.upModel.organ.rightEyeVc];
                }
            }
            else if ([model.title isEqualToString:@"听力"])
            {
                model.contentStr = [NSString stringWithFormat:@"%ld",(long)self.upModel.organ.hearing.integerValue];
            }
            else if ([model.title isEqualToString:@"运动"])
            {
                model.contentStr = [NSString stringWithFormat:@"%ld",(long)self.upModel.organ.motorFunction.integerValue];
            }
            else if ([model.title isEqualToString:@"日饮酒量(两/日)"])
            {
                model.contentStr = [NSString stringWithFormat:@"%@%@%@",self.upModel.lifeStyle.dailyAlcoholIntake,kFollowupSeparator,self.upModel.cmModel.nextDailyAlcohol];
            }
            else if ([model.title isEqualToString:@"日吸烟量(支/日)"])
            {
                model.contentStr = [NSString stringWithFormat:@"%@%@%@",self.upModel.lifeStyle.smoking,kFollowupSeparator,self.upModel.cmModel.nextSmoking];
            }
            else if ([model.title isEqualToString:@"摄盐情况"])
            {
                model.contentStr = self.upModel.cmModel.saltIntake;
            }
            else if ([model.title isEqualToString:@"目标摄盐情况"])
            {
                model.contentStr = self.upModel.cmModel.nextSaltIntake;
            }
            else if ([model.title isEqualToString:@"主食(克/日)"])
            {
                 model.contentStr = [NSString stringWithFormat:@"%@%@%@",self.upModel.cmModel.staple,kFollowupSeparator,self.upModel.cmModel.nextStaple];
            }
            else if ([model.title isEqualToString:@"运动次数(次/周)"])
            {
                model.contentStr = [NSString stringWithFormat:@"%@%@%@",self.upModel.lifeStyle.exerciseWeekTimes,kFollowupSeparator,self.upModel.cmModel.nextExerciseWeekTimes];
            }
            else if ([model.title isEqualToString:@"运动时间(分钟/次)"])
            {
                model.contentStr = [NSString stringWithFormat:@"%@%@%@",self.upModel.lifeStyle.eachExerciseTime,kFollowupSeparator,self.upModel.cmModel.nextExerciseWeekMinute];
            }
            else if ([model.title isEqualToString:@"心理调整"])
            {
                NSNumber *num = self.upModel.cmModel.psychologicalAdjustment;
                model.contentStr = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
            }
            else if ([model.title isEqualToString:@"遵医行为"])
            {
                NSNumber *num = self.upModel.cmModel.complianceBehavior;
                model.contentStr = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
            }
            else if ([model.title isEqualToString:@"服药依从性"])
            {
                NSNumber *num = self.upModel.cmModel.medicationCompliance;
                model.contentStr = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
            }
            else if ([model.title isEqualToString:@"药物不良反应"])
            {
                NSString *num = self.upModel.cmModel.adverseDrugReactions;
                model.contentStr = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
            }
            else if ([model.title isEqualToString:@"低血糖反应"])
            {
                model.contentStr = self.upModel.cmModel.lowBloodSugarReactions;
            }
            else if ([model.title isEqualToString:@"随访结局"])
            {
                model.contentStr = self.upModel.cmModel.followUpRemarks;
            }
            if (![model.contentStr isNotEmptyString]) {
                model.contentStr = @"";
            }
        }
    }
}


@end
