//
//  FollowupAllFormVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/23.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupAllFormVC.h"
#import "AllFormsHistoryCell.h"
#import "InterviewInputModel.h"
#import "AllFormsInputTextCell.h"
#import "AllFormsSymptomCell.h"
#import "AllFormsSectionCell.h"
#import "InterviewBlankCell.h"
#import "AllFormsWrapRadioCell.h"
#import "AllFormsRadioCell.h"
#import "AllFormsRadioAndTextCell.h"
#import "AllFormsAddDrugCell.h"
#import "InterviewMedicateCell.h"
#import "FolloupHistoryVC.h"
#import "AuxiliaryCheckVC.h"
#import "UIViewController+BackButtonHandler.h"
#import "InterviewRequiredVC.h"
#import "BSFollowupSucceedVC.h"
#import "FolloupDoctorsViewController.h"

#import "FollowupUpModel.h"
#import "FollowupLastInfoBaseRequest.h"
#import "YearCountBaseRequest.h"
#import "FollowupUpRequest.h"
#import <YYCategories/NSDate+YYAdd.h>
#import "FollowupFormsTool.h"

@interface FollowupAllFormVC ()<UITableViewDelegate,UITableViewDataSource,AllFormsAddDrugCellDelegate,InterviewMedicateCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,strong) HMSegmentedControl *segmentedControl;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,copy) NSArray *sectionArray;        // section title 数组

@property (nonatomic ,strong) NSMutableArray *uiArray;    // 布局UI的数组

@property (nonatomic ,assign) BOOL isScroll;    // 是否滚动

@property (nonatomic ,strong) UIView *footerView;

@property (nonatomic ,strong) UIButton *rightBtn;  // 右边按钮;

@property (nonatomic ,strong) InterviewMedicateCell *tempCell;

@property (nonatomic ,strong) NSIndexPath *bmiIndexPath;   // bmiIndexPath

@property (nonatomic ,strong) AuxiliaryCheckVC *auxiliaryCheckVC;

@property (nonatomic ,strong) InterviewRequiredVC *oldVersionVC;  // 旧版

@property (nonatomic, strong) FolloupDoctorsViewController *doctorsVC;  // 随访医生列表VC

@property (nonatomic ,assign) NSInteger count;   //年度随访次数

@property (nonatomic ,strong) FollowupUpModel *upModel;   // 全表单数据和上传数据

@property (nonatomic ,strong) FollowupUpRequest *upRequest;

@end

@implementation FollowupAllFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUpModelAndConfigDefault];  // 初始化upModel和配置默认数据
    [self initView];
    [self initLastData];    // 上次随访数据
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isScroll = NO;
    if (kiOS9Later) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
- (void)dealloc
{
    [self.tableView unobserveNotification:kAllFormsBmiNeedRefresh];
}
- (void)initView
{
    switch (self.planModel.followUpType.integerValue) {
        case FollowupTypeHypertension:
            self.title = @"高血压随访";
            break;
        case FollowupTypeDiabetes:
            self.title = @"糖尿病随访";
            break;
        case FollowupTypeGaoTang:
            self.title = @"高糖合并随访";
            break;
        default:
            break;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.tableView];
    [self observeNotificaiton:kAllFormsBmiNeedRefresh selector:@selector(reloadBmiCell)];
}
#pragma mark ---- 数据请求
- (void)initLastData
{
    Bsky_WeakSelf
    [MBProgressHUD showHud];
    [FollowupFormsTool initLastDataWithPlanModel:self.planModel success:^(__kindof FollowupLastInfoBaseRequest * _Nonnull request) {
        Bsky_StrongSelf
        if (request.lastModel) { // 非空判断
            self.upModel = request.lastModel;
            self.upModel.type = @(self.planModel.followUpType.integerValue);
            [self configUIArrayWithLastAllModel];
            [self.tableView reloadData];
        }
        [self initLastCount];    // 请求随访次数
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
        [MBProgressHUD hideHud];
    } failure:^(__kindof YearCountBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
    }];
}
#pragma mark ------ Setter Getter
- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"基本信息",@"症状",@"体征",@"生活方式",@"辅助检查",@"药物相关",@"随访分类"]];
        _segmentedControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0x4e7dd3)};
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _segmentedControl.height-1, _segmentedControl.width, 1)];
        line.backgroundColor = UIColorFromRGB(0xededed);
        [_segmentedControl addSubview:line];
    }
    return _segmentedControl;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.segmentedControl.bottom, self.view.width, self.view.height - self.segmentedControl.bottom-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[AllFormsHistoryCell nib] forCellReuseIdentifier:[AllFormsHistoryCell cellIdentifier]];
        [_tableView registerNib:[AllFormsSectionCell nib] forCellReuseIdentifier:[AllFormsSectionCell cellIdentifier]];
        [_tableView registerNib:[AllFormsInputTextCell nib] forCellReuseIdentifier:[AllFormsInputTextCell cellIdentifier]];
        [_tableView registerClass:[AllFormsSymptomCell class] forCellReuseIdentifier:[AllFormsSymptomCell cellIdentifier]];
        [_tableView registerNib:[InterviewBlankCell nib] forCellReuseIdentifier:[InterviewBlankCell cellIdentifier]];
        [_tableView registerClass:[AllFormsWrapRadioCell class] forCellReuseIdentifier:[AllFormsWrapRadioCell cellIdentifier]];
        [_tableView registerNib:[AllFormsAddDrugCell nib] forCellReuseIdentifier:[AllFormsAddDrugCell cellIdentifier]];
        [_tableView registerClass:[AllFormsRadioCell class] forCellReuseIdentifier:[AllFormsRadioCell cellIdentifier]];
        [_tableView registerClass:[AllFormsRadioAndTextCell class] forCellReuseIdentifier:[AllFormsRadioAndTextCell cellIdentifier]];
        [_tableView registerNib:[InterviewMedicateCell nib] forCellReuseIdentifier:[InterviewMedicateCell cellIdentifier]];
    }
    return _tableView;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_rightBtn addTarget:self action:@selector(rightBarButtonItenAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn sizeToFit];
    }
    return _rightBtn;
}
- (InterviewRequiredVC *)oldVersionVC
{
    if (!_oldVersionVC) {
        _oldVersionVC = [[InterviewRequiredVC alloc]init];
        _oldVersionVC.planModel = self.planModel;
        [self addChildViewController:self.oldVersionVC];
        _oldVersionVC.view.frame = self.view.bounds;
    }
    return _oldVersionVC;
}
- (NSMutableArray *)uiArray
{
    if (!_uiArray) {
        _uiArray = [NSMutableArray array];
        NSString *str = @"AllFormsDbModel";
        switch (self.planModel.followUpType.integerValue) {
            case FollowupTypeHypertension:
                str = @"AllFormsHyModel";
                break;
            case FollowupTypeDiabetes:
                str = @"AllFormsDbModel";
                break;
            case FollowupTypeGaoTang:
                str = @"AllFormsGtModel";
                break;
            default:
                break;
        }
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:str ofType:@"json"]];
        NSDictionary *uiDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
        self.sectionArray =  @[@"基本信息",@"症状(多选)",@"体征",@"生活方式指导",@"辅助检查",@"药物相关",@"随访分类"];
        for (int i = 0; i<self.sectionArray.count; i++) {
            NSString *key = self.sectionArray[i];
            NSMutableArray *array = [InterviewInputModel mj_objectArrayWithKeyValuesArray:uiDic[key]];
            [_uiArray addObject:array];
        }
    }
    return _uiArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1+self.uiArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    else
    {
        NSArray *array = self.uiArray[section-1];
        return array.count+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:[AllFormsHistoryCell cellIdentifier] forIndexPath:indexPath];
        AllFormsHistoryCell *tableCell = (AllFormsHistoryCell *)cell;
        NSString *str = self.planModel.followUpType.integerValue == FollowupTypeGaoTang ? kModelEmptyString : [NSString stringWithFormat:@"%ld",(long)self.count];
        tableCell.countLabel.text = [NSString stringWithFormat:@"已随访的次数为：%@次",str];
    }
    else
    {
        NSArray *array = self.uiArray[indexPath.section-1];
        if (indexPath.row == 0) {  // 第一行titleCell
            cell = [tableView dequeueReusableCellWithIdentifier:[AllFormsSectionCell cellIdentifier] forIndexPath:indexPath];
            AllFormsSectionCell *tableCell = (AllFormsSectionCell *)cell;
            tableCell.upModel = self.upModel;
            tableCell.titleStr = self.sectionArray[indexPath.section-1];
            if (array.count < 1) {
                tableCell.clickImageView.hidden = NO;
            }
        }
        else
        {
            InterviewInputModel *uiModel = array[indexPath.row-1];
            if ([uiModel.title isEqualToString:@"症状(多选)"]) {
                cell = [tableView dequeueReusableCellWithIdentifier:[AllFormsSymptomCell cellIdentifier] forIndexPath:indexPath];
                AllFormsSymptomCell *tableCell = (AllFormsSymptomCell *)cell;
                tableCell.upModel = self.upModel;
                tableCell.model = uiModel;
            }
           else if ([uiModel.title isEqualToString:@"药物不良反应"] || [uiModel.title isEqualToString:@"随访结局(非必填)"]) {
                cell = [tableView dequeueReusableCellWithIdentifier:[AllFormsRadioAndTextCell cellIdentifier] forIndexPath:indexPath];
                AllFormsRadioAndTextCell *tableCell = (AllFormsRadioAndTextCell *)cell;
                tableCell.model = uiModel;
                tableCell.upModel = self.upModel;
            }
           else if ([uiModel.title containsString:@"用药情况"] || [uiModel.title isEqualToString:@"胰岛素"] ) {
               cell = [tableView dequeueReusableCellWithIdentifier:[AllFormsAddDrugCell cellIdentifier] forIndexPath:indexPath];
               AllFormsAddDrugCell *tableCell = (AllFormsAddDrugCell *)cell;
               tableCell.titleLabel.text = uiModel.title;
               if (!tableCell.delegate) {
                   tableCell.delegate = self;
               }
           }
           else if ([uiModel.title isEqualToString:@"空白"]) {
               cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
           }
           else if ([uiModel.title containsString:kFollowupAddMedicate] ) {
               cell = [tableView dequeueReusableCellWithIdentifier:[InterviewMedicateCell cellIdentifier] forIndexPath:indexPath];
               InterviewMedicateCell *tableCell = (InterviewMedicateCell *)cell;
               if (!tableCell.delegate) {
                   tableCell.delegate = self;
               }
               tableCell.model = uiModel;
           }
            else if ([uiModel.title isEqualToString:@"随访分类"]) {
                cell = [tableView dequeueReusableCellWithIdentifier:[AllFormsWrapRadioCell cellIdentifier] forIndexPath:indexPath];
                AllFormsWrapRadioCell *tableCell = (AllFormsWrapRadioCell *)cell;
                tableCell.model = uiModel;
                tableCell.upModel = self.upModel;
            }
            else if (uiModel.options)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[AllFormsRadioCell cellIdentifier] forIndexPath:indexPath];
                AllFormsRadioCell *tableCell = (AllFormsRadioCell *)cell;
                tableCell.model = uiModel;
                tableCell.upModel = self.upModel;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[AllFormsInputTextCell cellIdentifier] forIndexPath:indexPath];
                AllFormsInputTextCell *tableCell = (AllFormsInputTextCell *)cell;
                if ([uiModel.title isEqualToString:@"体质指数(BMI)"]) {
                    uiModel.contentStr = [FollowupFormsTool getBmiStringWithUpModel:self.upModel];
                    self.bmiIndexPath = indexPath;
                }
                tableCell.model = uiModel;
                tableCell.upModel = self.upModel;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.footerView) {
        self.footerView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self.footerView;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}
#pragma mark ---- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        FolloupHistoryVC *vc = [[FolloupHistoryVC alloc]init];
        vc.personId = self.planModel.gwUserId;
        vc.type = self.planModel.followUpType.integerValue;
        vc.personName = self.planModel.username;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        if (self.planModel.followUpType.integerValue == FollowupTypeGaoTang) {
            return;
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定切换?" message:@"本表单所填内容将会清空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1302;
        [alertView show];
    }
    else if (indexPath.section == 1 && indexPath.row == 4) {
        if (!self.doctorsVC) {
            self.doctorsVC = [[FolloupDoctorsViewController alloc]init];
            Bsky_WeakSelf
            self.doctorsVC.didSelectBlock = ^(FollowupDoctorModel *doctorModel) {
                Bsky_StrongSelf
                NSArray *array = self.uiArray[indexPath.section-1];
                InterviewInputModel *uiModel = array[indexPath.row-1];
                uiModel.contentStr = doctorModel.employeeName;
                self.upModel.cmModel.doctorId = doctorModel.employeeId;
                self.upModel.cmModel.doctorName = doctorModel.employeeName;
                [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            };
        }
        [self.navigationController pushViewController:self.doctorsVC animated:YES];
    }
    else if (indexPath.section == 5) {
        NSArray *array = self.uiArray[indexPath.section-1];
        if (indexPath.row == array.count) {
            if (!self.auxiliaryCheckVC) {
                self.auxiliaryCheckVC = [[AuxiliaryCheckVC alloc]init];
            }
            self.auxiliaryCheckVC.upModel = self.upModel;
            self.auxiliaryCheckVC.isTang = !(self.planModel.followUpType.integerValue == FollowupTypeDiabetes || self.planModel.followUpType.integerValue == FollowupTypeGaoTang);
            [self.navigationController pushViewController:self.auxiliaryCheckVC animated:YES];
        }
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    if (self.isScroll) {
        NSIndexPath *topVisibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
        self.segmentedControl.selectedSegmentIndex = topVisibleIndexPath.section-1 >= 0 ? topVisibleIndexPath.section-1 : 0;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if (self.isScroll) {
        NSIndexPath *topVisibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
        self.segmentedControl.selectedSegmentIndex = topVisibleIndexPath.section-1 >= 0 ? topVisibleIndexPath.section-1 : 0;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    self.isScroll = YES;
}
#pragma mark --- rightBarButtonItenAction 保存或者历史记录

- (void)rightBarButtonItenAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"历史记录"]) {
        FolloupHistoryVC *vc = [[FolloupHistoryVC alloc]init];
        vc.personId = self.planModel.gwUserId;
        vc.type = self.planModel.followUpType.integerValue;
        vc.personName = self.planModel.username;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self.view endEditing:YES];
        if (![FollowupFormsTool checkDurgInfoWithUpModel:self.upModel]) {
            return;
        }
        NSString *json = [FollowupFormsTool checkUpModel:self.upModel planModel:self.planModel];
        if (!json) {
            return;
        }
        if (self.upModel.labora.glycatedHemoglobin &&
            !self.upModel.labora.examDate &&
            (self.planModel.followUpType.integerValue == FollowupTypeDiabetes ||
             self.planModel.followUpType.integerValue == FollowupTypeGaoTang))
        {
            [UIView makeToast:@"请填写糖化血红蛋白检查日期"];
            return;
        }
        if (!self.upRequest) {
            self.upRequest = [[FollowupUpRequest alloc]init];
        }
        self.upRequest.followUp = json;
        self.upRequest.followUp = [self.upRequest.followUp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        BSFollowup *tempModel = [BSFollowup mj_objectWithKeyValues:[self.planModel mj_keyValues]];
        [tempModel encryptModel];
        self.upRequest.followupPlan = [tempModel mj_JSONString];
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
                [self.navigationController popViewControllerAnimated:NO];
            };
            __block NSString *recID = request.ret[@"id"];
            vc.backRootBlock = ^{
                if (self.backAllBlock) {
                    self.backAllBlock(recID);
                }
                [self.navigationController popViewControllerAnimated:NO];
            };
            [self presentViewController:vc animated:YES completion:nil];
            
        } failure:^(__kindof FollowupUpRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }
}
#pragma mark ----- HMSegmentedControl Click
- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender
{
    NSInteger index = sender.selectedSegmentIndex + 1;
    if (sender.selectedSegmentIndex == 0) {
        index = index - 1;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    CGRect frame = [self.tableView rectForSection:indexPath.section];
    self.isScroll = NO;
    [self.tableView setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
}
#pragma mark ---- AllFormsAddDrugCellDelegate  添加药品

- (void)allFormsAddDrugCellAddClick:(AllFormsAddDrugCell *)cell
{
    InterviewInputModel *uiModel = [[InterviewInputModel alloc]init];
    if ([cell.titleLabel.text isEqualToString:@"用药情况"]) {
        Drug *medicateModel = [[Drug alloc]init];
        [self.upModel.drug addObject:medicateModel];
        uiModel.title = kFollowupAddMedicateP;
        uiModel.object = medicateModel;
    }
    else if ([cell.titleLabel.text isEqualToString:@"高血压用药情况"]) {
        Drug *medicateModel = [[Drug alloc]init];
        [self.upModel.drugUseList addObject:medicateModel];
        uiModel.title = kFollowupAddMedicateG;
        uiModel.object = medicateModel;
    }
    else if ([cell.titleLabel.text isEqualToString:@"糖尿病用药情况"]) {
        Drug *medicateModel = [[Drug alloc]init];
        [self.upModel.diabetesUseList addObject:medicateModel];
        uiModel.title = kFollowupAddMedicateT;
        uiModel.object = medicateModel;
    }
    else if ([cell.titleLabel.text isEqualToString:@"胰岛素"]) {
        InsulinDrug *medicateModel = [[InsulinDrug alloc]init];
        [self.upModel.insulinDrug addObject:medicateModel];
        uiModel.title = kFollowupAddMedicateY;
        uiModel.object = medicateModel;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableArray *array = self.uiArray[indexPath.section-1];
    [array insertObject:uiModel atIndex:indexPath.row];
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}
#pragma mark ----- InterviewMedicateCellDelegate 删除药品
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
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定退出?" message:@"内容尚未保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1301;
    [alertView show];
    return NO;
}
#pragma mark ------ UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewDelayedTouchesBeganGestureRecognizer")])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定退出?" message:@"内容尚未保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1301;
        [alertView show];
        return NO;
    }
    return YES;
}
#pragma mark ----- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1300) {
        
        switch (buttonIndex) {
            case 0:
                self.tempCell = nil;
                break;
            default:
            {
                if ([self.tempCell.model.title isEqualToString:kFollowupAddMedicateP]) {
                    [self.upModel.drug  removeObject:self.tempCell.model.object];  // 普通
                }
                else if ([self.tempCell.model.title isEqualToString:kFollowupAddMedicateG])
                {
                    [self.upModel.drugUseList removeObject:self.tempCell.model.object]; // 高血压
                }
                else if ([self.tempCell.model.title isEqualToString:kFollowupAddMedicateT])
                {
                    [self.upModel.diabetesUseList removeObject:self.tempCell.model.object]; // 糖尿病
                }
                else if ([self.tempCell.model.title isEqualToString:kFollowupAddMedicateY])
                {
                    [self.upModel.insulinDrug removeObject:self.tempCell.model.object];  // 胰岛素
                }
                NSMutableArray *array = self.uiArray[5];
                for (InterviewInputModel *uiModel in array) {
                    if (uiModel.object == self.tempCell.model.object) {
                        [array removeObject:uiModel];
                        break;
                    }
                }
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:self.tempCell]] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
            }
                break;
        }
    }
    if (alertView.tag == 1301) {
        switch (buttonIndex) {
            case 0:
                break;
            default:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        }
    }
    else if (alertView.tag == 1302)
    {
        switch (buttonIndex) {
            case 0:
                break;
            default:
            {
                [self.view addSubview:self.oldVersionVC.view];
                [self.rightBtn setTitle:@"历史记录" forState:UIControlStateNormal];
                [self.rightBtn sizeToFit];
                Bsky_WeakSelf
                self.oldVersionVC.switchBlock = ^{
                    Bsky_StrongSelf
                    [self.oldVersionVC.view removeFromSuperview];
                    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
                    [self.rightBtn sizeToFit];
                };
            }
                break;
        }
    }
}
#pragma mark ---- 刷新次数
- (void)reloadTimesCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark --- 配置默认随访数据
- (void)initUpModelAndConfigDefault
{
    self.count = 0;
    if (!self.upModel) {
        self.upModel = [[FollowupUpModel alloc]init];
        self.upModel.type = @(self.planModel.followUpType.integerValue);
    }
    for (int i = 0; i<self.uiArray.count; i++) {
        NSMutableArray *array = self.uiArray[i];
         [FollowupFormsTool configDefaultUIArray:array lastModel:self.upModel planModel:self.planModel];
    }
}
#pragma mark ---- 配置上次全表单数据
- (void)configUIArrayWithLastAllModel
{
    for (int i = 0; i<self.uiArray.count; i++) {
        NSMutableArray *array = self.uiArray[i];
        [FollowupFormsTool configUIArray:array lastModel:self.upModel planModel:self.planModel];
    }
}
#pragma mark --- 体质指数
- (void)reloadBmiCell
{
    [self.tableView reloadRowAtIndexPath:self.bmiIndexPath withRowAnimation:UITableViewRowAnimationNone];
}

@end
