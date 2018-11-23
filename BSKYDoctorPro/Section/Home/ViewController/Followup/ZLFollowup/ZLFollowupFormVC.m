//
//  ZLFollowupFormVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/26.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFollowupFormVC.h"
#import "AllFormsHistoryCell.h"
#import "FormSectionCell.h"
#import "FormInputTextCell.h"
#import "FormChoicesAndOtherCell.h"
#import "FormSingleRadioCell.h"
#import "FormSingleRadioAndOtherCell.h"
#import "FormWrapRadioCell.h"
#import "FormBoldTitleCell.h"
#import "ZLFormDrugCell.h"
#import "InterviewBlankCell.h"

#import "ZLFollowupLastInfoBaseRequest.h"
#import "YearCountBaseRequest.h"
#import "ZLFollowupLastModel.h"
#import "ZLDoctorListVC.h"
#import "ZLFollowupFormVM.h"
#import "ZLFollowupHistoryListVC.h"
#import "BSFollowupSucceedVC.h"

@interface ZLFollowupFormVC ()<UITableViewDelegate,UITableViewDataSource,FormBaseCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,strong) HMSegmentedControl *segmentedControl;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *uiArray;    // 布局UI的数组

@property (nonatomic ,strong) UIView *footerView;

@property (nonatomic, strong) UIAlertView * backAlertView;

@property (nonatomic ,assign) NSInteger count;   //年度随访次数

@property (nonatomic ,assign) BOOL isScroll;    // 是否滚动

@property (nonatomic, strong) ZLFollowupLastModel * dataModel;

@property (nonatomic, strong) ZLDoctorListVC *doctorsVC;  // 随访医生列表VC

@end

@implementation ZLFollowupFormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUpModelAndConfigDefault];  // 初始化upModel和配置默认数据
    [self initView];
    [self initLastData];    // 上次随访数据和随访次数
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isScroll = NO;
    if (kiOS9Later) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
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
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.tableView];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [saveBtn addTarget:self action:@selector(rightBarButtonItenAction:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
}

#pragma mark ---- 数据请求
- (void)initLastData
{
    Bsky_WeakSelf
    [MBProgressHUD showHud];
    [[ZLFollowupFormVM sharedInstance]getLastDataWithPlanModel:self.planModel success:^(__kindof ZLFollowupLastInfoBaseRequest * _Nonnull request) {
        Bsky_StrongSelf
        if (request.lastModel) { // 非空判断
            self.dataModel = request.lastModel;
            self.dataModel.type = self.planModel.followUpType.integerValue;
            [self configUIArrayWithLastAllModel];
            [self.tableView reloadData];
        }
        [self initLastCount];    // 请求随访次数
    } failure:^(__kindof ZLFollowupLastInfoBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}
- (void)initLastCount
{
    Bsky_WeakSelf
    [[ZLFollowupFormVM sharedInstance]getYearCountWithPlanModel:self.planModel success:^(__kindof YearCountBaseRequest * _Nonnull request) {
        Bsky_StrongSelf
        [MBProgressHUD hideHud];
        self.count = request.count;
        [self.tableView reloadData];
    } failure:^(__kindof YearCountBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
    }];
}

#pragma mark ----- Click
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

#pragma mark ----- 保存操作
- (void)rightBarButtonItenAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    FollowupCheckModel *checkModel = [[ZLFollowupFormVM sharedInstance]checkDataModel:self.dataModel planModel:self.planModel uiArray:self.uiArray];
    if (!checkModel.isValid) {
        [UIView makeToast:checkModel.contentStr];
        [self.tableView scrollToRow:checkModel.indexPath.row inSection:checkModel.indexPath.section+1 atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
    {
        Bsky_WeakSelf
        [MBProgressHUD showHud];
        [[ZLFollowupFormVM sharedInstance]upDataModel:self.dataModel planModel:self.planModel success:^(__kindof BSBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            Bsky_StrongSelf
            BSFollowupSucceedVC *vc = [[BSFollowupSucceedVC alloc]init];
            vc.idcard = self.planModel.userIdCard;
            vc.realName = self.planModel.username;
            vc.followupType = self.planModel.followUpType.integerValue;
            vc.backBlock = ^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            vc.backRootBlock = ^{
                Bsky_StrongSelf
                if (self.backFPBlock) {
                   self.backFPBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self presentViewController:vc animated:YES completion:nil];
            
        } failure:^(__kindof BSBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }
}
#pragma mark --- 配置默认随访数据
- (void)initUpModelAndConfigDefault
{
    self.count = 0;
    if (!self.dataModel) {
        self.dataModel = [[ZLFollowupLastModel alloc]init];
        self.dataModel.drugList = [NSMutableArray array];
        self.dataModel.type = self.planModel.followUpType.integerValue;
    }
    [[ZLFollowupFormVM sharedInstance]configDefaultUIArray:self.uiArray lastModel:self.dataModel planModel:self.planModel];
}
#pragma mark ---- 配置上次全表单数据
- (void)configUIArrayWithLastAllModel
{
    [[ZLFollowupFormVM sharedInstance]configUIArray:self.uiArray lastModel:self.dataModel planModel:self.planModel];
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
        return array.count;
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
        InterviewInputModel *uiModel = array[indexPath.row];
        switch (uiModel.type) {
            case 0: case 2: case 3: case 5: case 7:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[FormInputTextCell cellIdentifier] forIndexPath:indexPath];
                FormInputTextCell *tableCell = (FormInputTextCell *)cell;
                tableCell.uiModel = uiModel;
            }
                break;
            case 1:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[FormSingleRadioCell cellIdentifier] forIndexPath:indexPath];
                FormSingleRadioCell *tableCell = (FormSingleRadioCell *)cell;
                tableCell.uiModel = uiModel;
            }
                break;
            case 4:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[FormChoicesAndOtherCell cellIdentifier] forIndexPath:indexPath];
                FormChoicesAndOtherCell *tableCell = (FormChoicesAndOtherCell *)cell;
                tableCell.uiModel = uiModel;
            }
                break;
            case 6:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[FormWrapRadioCell cellIdentifier] forIndexPath:indexPath];
                FormWrapRadioCell *tableCell = (FormWrapRadioCell *)cell;
                tableCell.uiModel = uiModel;
            }
                break;
            case 8:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[FormSingleRadioAndOtherCell cellIdentifier] forIndexPath:indexPath];
                FormSingleRadioAndOtherCell *tableCell = (FormSingleRadioAndOtherCell *)cell;
                tableCell.uiModel = uiModel;
            }
                break;
            case 9:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[FormSectionCell cellIdentifier] forIndexPath:indexPath];
                FormSectionCell *tableCell = (FormSectionCell *)cell;
                tableCell.uiModel = uiModel;
            }
                break;
            case 10:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[FormBoldTitleCell cellIdentifier] forIndexPath:indexPath];
                FormBoldTitleCell *tableCell = (FormBoldTitleCell *)cell;
                tableCell.uiModel = uiModel;
            }
                break;
            case 11:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[ZLFormDrugCell cellIdentifier] forIndexPath:indexPath];
                ZLFormDrugCell *tableCell = (ZLFormDrugCell *)cell;
                tableCell.uiModel = uiModel;
            }
                break;
            case 12:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:[InterviewBlankCell cellIdentifier] forIndexPath:indexPath];
            }
                break;
                
            default:
                break;
        }
        if (indexPath.row == array.count - 1 || indexPath.row == 0) {
            [cell setSeparatorLeftMargin:0];
        }
        else
        {
            [cell setSeparatorLeftMargin:15];
        }
        if ([cell isKindOfClass:[FormBaseCell class]]) {
            FormBaseCell *tableCell = (FormBaseCell *)cell;
            if (!tableCell.delegate) {
                tableCell.delegate = self;
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        ZLFollowupHistoryListVC *vc = [[ZLFollowupHistoryListVC alloc]init];
        vc.personId = self.planModel.gwUserId;
        vc.personName = self.planModel.username;
        vc.type = self.planModel.followUpType.integerValue;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    self.isScroll = YES;
}
#pragma mark ----- FormBaseCellDelegate

- (void)formBaseCell:(FormBaseCell *)cell configData:(InterviewInputModel *)uiModel
{
    [[ZLFollowupFormVM sharedInstance]configDataModel:self.dataModel baseCell:cell uiModel:uiModel];
    
    if ([uiModel.title containsString:@"身高"] || [uiModel.title containsString:@"体重"]) {
        for (InterviewInputModel *bmiUIModel in self.uiArray[2]) {
            if ([bmiUIModel.title containsString:@"BMI"]) {
                bmiUIModel.contentStr = [[ZLFollowupFormVM sharedInstance]getBmiStringWithDataModel:self.dataModel];
                [self.tableView reloadData];
                break;
            }
        }
    }
    else if ([uiModel.title isEqualToString:@"随访时间"])
    {
        self.planModel.lastFollowDate = self.dataModel.followUpDate;
    }
    else if ([uiModel.title isEqualToString:@"下次随访时间"])
    {
        self.planModel.followDate = self.dataModel.nextFollowUpDate;
    }
    else if ([uiModel.title containsString:@"随访医生"])
    {
        if (!self.doctorsVC) {
            self.doctorsVC = [[ZLDoctorListVC alloc]init];
            Bsky_WeakSelf
            self.doctorsVC.didSelectBlock = ^(ZLDoctorModel *doctorModel) {
                Bsky_StrongSelf
                uiModel.contentStr = doctorModel.name;
                self.dataModel.followUpDoctorId = doctorModel.doctorId;
                self.dataModel.registrant = doctorModel.doctorId;
                [self.tableView reloadData];
            };
        }
        [self.navigationController pushViewController:self.doctorsVC animated:YES];
    }
    else if ([uiModel.title containsString:@"用药情况"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSMutableArray *array  = self.uiArray[indexPath.section - 1];
        InterviewInputModel *uiModel = [[InterviewInputModel alloc]init];
        uiModel.type = BSFormCellTypeDrug;
        uiModel.object = [[ZLDrugModel alloc]init];
        [self.dataModel.drugList insertObject:uiModel.object atIndex:0];
        [array insertObject:uiModel atIndex:indexPath.row + 1];
        [self.tableView beginUpdates];
        [self.tableView insertRow:indexPath.row + 1 inSection:indexPath.section withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
    else if (uiModel.type == BSFormCellTypeDrug)
    {
        [self deleteMedicateCellDelete:cell];
    }
}
#pragma mark ----- InterviewMedicateCellDelegate 删除药品
- (void)deleteMedicateCellDelete:(FormBaseCell *)cell
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除本条用药信息?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    Bsky_WeakSelf
    alertView.completionBlock = ^(UIAlertView *alertView, NSInteger index) {
        if (index == 1) {
            Bsky_StrongSelf
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSMutableArray *array  = self.uiArray[indexPath.section - 1];
            [array removeObject:cell.uiModel];
            [self.dataModel.drugList removeObject:cell.uiModel.object];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
        }
    };
    [alertView show];
}
#pragma mark ----- BackButtonHandlerProtocol

-(BOOL)navigationShouldPopOnBackButton
{
    [self.backAlertView show];
    return NO;
}
#pragma mark ------ UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewDelayedTouchesBeganGestureRecognizer")])
    {
        [self.backAlertView show];
        return NO;
    }
    return YES;
}

#pragma mark ------ Setter Getter
- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"基本信息",@"症状",@"体征",@"生活方式",@"辅助检查",@"药物相关",@"用药情况",@"随访分类",@"转诊"]];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.segmentedControl.bottom, self.view.width, self.view.height - self.segmentedControl.bottom-TOP_BAR_HEIGHT-SafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[AllFormsHistoryCell nib] forCellReuseIdentifier:[AllFormsHistoryCell cellIdentifier]];
        [_tableView registerNib:[FormSectionCell nib] forCellReuseIdentifier:[FormSectionCell cellIdentifier]];
        [_tableView registerNib:[FormInputTextCell nib] forCellReuseIdentifier:[FormInputTextCell cellIdentifier]];
        [_tableView registerNib:[FormBoldTitleCell nib] forCellReuseIdentifier:[FormBoldTitleCell cellIdentifier]];
        [_tableView registerClass:[FormChoicesAndOtherCell class] forCellReuseIdentifier:[FormChoicesAndOtherCell cellIdentifier]];
        [_tableView registerClass:[FormSingleRadioCell class] forCellReuseIdentifier:[FormSingleRadioCell cellIdentifier]];
        [_tableView registerClass:[FormSingleRadioAndOtherCell class] forCellReuseIdentifier:[FormSingleRadioAndOtherCell cellIdentifier]];
        [_tableView registerClass:[FormWrapRadioCell class] forCellReuseIdentifier:[FormWrapRadioCell cellIdentifier]];
        [_tableView registerNib:[ZLFormDrugCell nib] forCellReuseIdentifier:[ZLFormDrugCell cellIdentifier]];
        [_tableView registerNib:[InterviewBlankCell nib] forCellReuseIdentifier:[InterviewBlankCell cellIdentifier]];
    }
    return _tableView;
}
- (UIAlertView *)backAlertView
{
    if (!_backAlertView) {
        _backAlertView = [[UIAlertView alloc]initWithTitle:@"确定退出?" message:@"内容尚未保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        Bsky_WeakSelf
        _backAlertView.completionBlock = ^(UIAlertView *alertView, NSInteger index) {
            if (index == 1) {
                Bsky_StrongSelf
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
    }
    return _backAlertView;
}
- (NSMutableArray *)uiArray
{
    if (!_uiArray) {
        _uiArray = [NSMutableArray array];
        NSString *str = nil;
        switch (self.planModel.followUpType.integerValue) {
            case FollowupTypeHypertension:
                str = @"ZLFormsHyModel";
                break;
            case FollowupTypeDiabetes:
                str = @"ZLFormsDbModel";
                break;
            case FollowupTypeGaoTang:
                str = @"ZLFormsGtModel";
                break;
            default:
                break;
        }
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:str ofType:@"json"]];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
        for (int i = 0; i<jsonArray.count; i++) {
            NSMutableArray *array = [InterviewInputModel mj_objectArrayWithKeyValuesArray:jsonArray[i]];
            [_uiArray addObject:array];
        }
    }
    return _uiArray;
}
@end
