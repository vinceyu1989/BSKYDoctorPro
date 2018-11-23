//
//  InterviewRequiredVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/4.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "InterviewRequiredVC.h"
#import "InterviewTextInputCell.h"
#import "InterviewSectionCell.h"
#import "InterviewRadioCell.h"
#import "InterviewSignsCell.h"
#import "InterviewBlankCell.h"
#import "InterviewHeadCell.h"
#import "InterviewCommitCell.h"
#import "SettingTableViewCell.h"
#import "FollowupSymptomCell.h"
#import "InterviewOptionalVC.h"
#import "BSFollowupSucceedVC.h"
#import "UIViewController+BackButtonHandler.h"
#import "FolloupHistoryVC.h"
#import "FolloupDoctorsViewController.h"

#import "FollowupUpModel.h"
#import "FollowupLastInfoBaseRequest.h"
#import "YearCountBaseRequest.h"
#import "FollowupUpRequest.h"
#import <YYCategories/NSDate+YYAdd.h>
#import "FollowupFormsTool.h"

@interface InterviewRequiredVC ()<UIAlertViewDelegate>

@property (nonatomic ,copy)   NSArray *inputArray;

@property (nonatomic ,assign) NSInteger count;   //年度随访次数

@property (nonatomic ,strong) NSIndexPath *bmiIndexPath;   // bmiIndexPath

@property (nonatomic ,strong) FollowupUpModel *upModel;   // 全表单数据和上传数据

@property (nonatomic ,strong) FollowupUpRequest *upRequest;

@property (nonatomic ,strong) InterviewOptionalVC *optionalVC;

@property (nonatomic, strong) FolloupDoctorsViewController *doctorsVC;  // 随访医生列表VC

@end

@implementation InterviewRequiredVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    self.upModel = [[FollowupUpModel alloc]init];
    [self configInputArrayWithDefault];   // 配置默认数据
    [self initView];
    [self initLastData];    // 上次随访全表单数据
    [self initLastCount];    // 请求随访次数
}
- (void)dealloc
{
    [self.tableView unobserveNotification:kFollowupBmiNeedRefresh];
}
- (void)initView
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"历史记录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.tableView registerNib:[InterviewSectionCell nib] forCellReuseIdentifier:[InterviewSectionCell cellIdentifier]];
    [self.tableView registerNib:[InterviewTextInputCell nib] forCellReuseIdentifier:[InterviewTextInputCell cellIdentifier]];
    [self.tableView registerClass:[InterviewRadioCell class] forCellReuseIdentifier:[InterviewRadioCell cellIdentifier]];
    [self.tableView registerClass:[FollowupSymptomCell class] forCellReuseIdentifier:[FollowupSymptomCell cellIdentifier]];
    [self.tableView registerNib:[InterviewSignsCell nib] forCellReuseIdentifier:[InterviewSignsCell cellIdentifier]];
     [self.tableView registerNib:[SettingTableViewCell nib] forCellReuseIdentifier:[SettingTableViewCell cellIdentifier]];
    [self.tableView registerNib:[InterviewBlankCell nib] forCellReuseIdentifier:[InterviewBlankCell cellIdentifier]];
    [self.tableView registerNib:[InterviewHeadCell nib] forCellReuseIdentifier:[InterviewHeadCell cellIdentifier]];
    [self.tableView registerNib:[InterviewCommitCell nib] forCellReuseIdentifier:[InterviewCommitCell cellIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self observeNotificaiton:kFollowupBmiNeedRefresh selector:@selector(reloadBmiCell)];
}
- (void)initLastData
{
    Bsky_WeakSelf
    [MBProgressHUD showHud];
    [FollowupFormsTool initLastDataWithPlanModel:self.planModel success:^(__kindof FollowupLastInfoBaseRequest * _Nonnull request) {
        Bsky_StrongSelf
        if (request.lastModel) { // 非空判断
            self.upModel = request.lastModel;
            [self configInputArrayWithLastAllModel];
            [self.tableView reloadData];
        }
        [MBProgressHUD hideHud];
    } failure:^(__kindof FollowupLastInfoBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}

- (void)initLastCount
{
    Bsky_WeakSelf
    [FollowupFormsTool initLastCountWithPlanModel:self.planModel success:^(__kindof YearCountBaseRequest * _Nonnull request) {
        Bsky_StrongSelf
        self.count = request.count;
        [self reloadTimesCell];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
#pragma mark --- Setter Getter
- (NSArray *)inputArray
{
    if (!_inputArray) {
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"InterviewInputModel" ofType:@"json"]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
        NSString *str = @"diabetes";
    
        switch (self.planModel.followUpType.integerValue) {
            case FollowupTypeDiabetes:
                str = @"diabetes";
                break;
            case FollowupTypeHypertension:
                str = @"hypertension";
                break;
            default:
                break;
        }
        NSArray *array = dic[str];
        _inputArray = [InterviewInputModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _inputArray;
}
#pragma mark --- rightBarButtonItenAction

- (void)rightBarButtonItenAction
{
    FolloupHistoryVC *vc = [[FolloupHistoryVC alloc]init];
    vc.personId = self.planModel.gwUserId;
    vc.type = self.planModel.followUpType.integerValue;
    vc.personName = self.planModel.username;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:               // 必填项
            return 7;
            break;
        case 1:              // 体征
            return self.inputArray.count-2;
            break;
        case 2:           // 非必填项
            return 4;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewHeadCell cellIdentifier] forIndexPath:indexPath];
                    InterviewHeadCell *tableCell = (InterviewHeadCell *)cell;
                    tableCell.countLabel.text = [NSString stringWithFormat:@"%ld次",(long)self.count];
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewSectionCell cellIdentifier] forIndexPath:indexPath];
                    InterviewSectionCell *tableCell = (InterviewSectionCell *)cell;
                    tableCell.titleLabel.text = @"必填项";
                    tableCell.moreIcon.hidden = YES;
                    tableCell.switchLabel.hidden = NO;
                }
                    break;
                case 2: case 3:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewTextInputCell cellIdentifier] forIndexPath:indexPath];
                    InterviewTextInputCell *tableCell = (InterviewTextInputCell *)cell;
                    tableCell.upModel = self.upModel;
                    tableCell.model = self.inputArray[indexPath.row-2];
                }
                    break;
                case 4: case 5:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewRadioCell cellIdentifier] forIndexPath:indexPath];
                    InterviewRadioCell *tableCell = (InterviewRadioCell *)cell;
                    tableCell.upModel = self.upModel;
                    tableCell.model = self.inputArray[indexPath.row-2];
                    
                }
                    break;
                case 6:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[FollowupSymptomCell cellIdentifier] forIndexPath:indexPath];
                    FollowupSymptomCell *tableCell = (FollowupSymptomCell *)cell;
                    tableCell.type = self.planModel.followUpType.integerValue;
                    tableCell.contentIndex = self.upModel.cmModel.symptom.integerValue;
                    tableCell.otherStr = [FollowupFormsTool getOtherSymptomStrWithUpModel:self.upModel];
                    Bsky_WeakSelf
                    tableCell.contentBlock = ^(NSString *otherStr, NSInteger contentIndex) {
                        Bsky_StrongSelf
                        self.upModel.cmModel.symptom = @(contentIndex);
                        if ([otherStr isNotEmptyString]) {
                            [self addOtherModelWithStr:otherStr];
                        }
                    };
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewSignsCell cellIdentifier] forIndexPath:indexPath];
                }
                    break;
                    
                default:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewTextInputCell cellIdentifier] forIndexPath:indexPath];
                    InterviewTextInputCell *tableCell = (InterviewTextInputCell *)cell;
                    tableCell.upModel = self.upModel;
                    InterviewInputModel *model = self.inputArray[indexPath.row+2];
                    if ([model.title isEqualToString:@"体质指数(BMI)"]) {
                        model.contentStr = [FollowupFormsTool getBmiStringWithUpModel:self.upModel];
                        self.bmiIndexPath = indexPath;
                    }
                    tableCell.model = model;
                }
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0: case 2:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewSectionCell cellIdentifier] forIndexPath:indexPath];
                    InterviewSectionCell *tableCell = (InterviewSectionCell *)cell;
                    tableCell.titleLabel.text = @"非必填项";
                    tableCell.moreIcon.hidden = NO;
                    tableCell.switchLabel.hidden = YES;
                }
                    break;
                case 3:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:[InterviewCommitCell cellIdentifier] forIndexPath:indexPath];
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
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (self.view.superview && self.switchBlock) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定切换?" message:@"本表单所填内容将会清空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 1302;
            [alertView show];
        }
    }
    else if (indexPath.section == 1)
    {
        InterviewInputModel *uiModel = self.inputArray[indexPath.row+2];
        if ([uiModel.title isEqualToString:@"随访医生"]) {
            if (!self.doctorsVC) {
                self.doctorsVC = [[FolloupDoctorsViewController alloc]init];
                Bsky_WeakSelf
                self.doctorsVC.didSelectBlock = ^(FollowupDoctorModel *doctorModel) {
                    Bsky_StrongSelf
                    uiModel.contentStr = doctorModel.employeeName;
                    self.upModel.cmModel.doctorId = doctorModel.employeeId;
                    self.upModel.cmModel.doctorName = doctorModel.employeeName;
                    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                };
            }
            [self.navigationController pushViewController:self.doctorsVC animated:YES];
        }
    }
    else if (indexPath.section == 2 && indexPath.row == 1) {
        if (!self.optionalVC) {
             self.optionalVC = [[InterviewOptionalVC alloc]init];
        }
        self.optionalVC.upModel = self.upModel;
        self.optionalVC.type = self.planModel.followUpType.integerValue;
        [self.navigationController pushViewController:self.optionalVC  animated:YES];
        return;
    }
    
   else if (indexPath.section == 2 && indexPath.row == 3) {
       
       [self.view endEditing:YES];
       NSString *json = [FollowupFormsTool checkUpModel:self.upModel planModel:self.planModel];
       if (!json) {
           return;
       }
       if (!self.upRequest) {
           self.upRequest = [[FollowupUpRequest alloc]init];
       }
       self.upRequest.followUp = json;
       self.upRequest.followUp = [self.upRequest.followUp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       
       self.upRequest.followupPlan = [self.planModel mj_JSONString];
       self.upRequest.followupPlan = [self.upRequest.followupPlan stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       [MBProgressHUD showHud];
       Bsky_WeakSelf;
       [self.upRequest startWithCompletionBlockWithSuccess:^(__kindof FollowupUpRequest * _Nonnull request) {
           [MBProgressHUD hideHud];
           Bsky_StrongSelf;
           BSFollowupSucceedVC *vc = [[BSFollowupSucceedVC alloc]init];
           vc.idcard = self.planModel.userIdCard;
           vc.realName = self.planModel.username;
           vc.followupType = self.planModel.followUpType.integerValue;
           vc.backBlock = ^{
               [self.navigationController popViewControllerAnimated:YES];
           };
           [self presentViewController:vc animated:YES completion:nil];
           
       } failure:^(__kindof FollowupUpRequest * _Nonnull request) {
           [MBProgressHUD hideHud];
           [UIView makeToast:request.msg];
       }];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark ---- 刷新次数
- (void)reloadTimesCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark --- 体质指数
- (void)reloadBmiCell
{
    [self.tableView reloadRowAtIndexPath:self.bmiIndexPath withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark --- 配置默认随访数据
- (void)configInputArrayWithDefault
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.inputArray];
    [FollowupFormsTool configDefaultUIArray:array lastModel:self.upModel planModel:self.planModel];
}
#pragma mark ---- 配置上次全表单数据
- (void)configInputArrayWithLastAllModel
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.inputArray];
    [FollowupFormsTool configUIArray:array lastModel:self.upModel planModel:self.planModel];
}
#pragma mark ----- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1302) {
        switch (buttonIndex) {
            case 0:
                break;
            default:
            {
                self.switchBlock();
            }
                break;
        }
    }
}

#pragma mark ----- 添加OtherModel
- (void)addOtherModelWithStr:(NSString *)str
{
    BOOL isHave = NO;
    NSInteger index = -1;
    for (Other *otherModel in self.upModel.other) {
        if ([otherModel.attrName isEqualToString:@"Symptom"]) {
            if (!str || str.length < 1) {
                index = [self.upModel.other indexOfObject:otherModel];
            }
            else
            {
                otherModel.otherText = str;
            }
            isHave = YES;
            break;
        }
    }
    if (index >= 0) {
        [self.upModel.other removeObjectAtIndex:index];
    }
    if (!isHave && str.length > 0) {
        Other *otherModel = [[Other alloc]init];
        otherModel.attrName = @"Symptom";
        otherModel.otherText = str;
        [self.upModel.other addObject:otherModel];
    }
}

@end
