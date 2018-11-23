//
//  ResidentHomeVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/19.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentHomeVC.h"
#import "ResidentHomeInfoCell.h"
#import "ResidentSectionCell.h"
#import "ResidentFollowupSectionCell.h"
#import "ResidentFollowupCell.h"
#import "ResidentSignInfoCell.h"
#import "ResidentPhysicalCell.h"
#import "ResidentChineseMedicineCell.h"
#import "ResidentHealthEduCell.h"

#import "FolloupHistoryVC.h"
#import "FollowupAllFormVC.h"
#import "BSHealthTeachVC.h"

#import "ResidentZhongYiRequest.h"
#import "FollowupHyYearCountRequest.h"
#import "FollowupHyInfoAllRequest.h"
#import "FollowupDbYearCountRequest.h"
#import "FollowupDbInfoAllRequest.h"
#import "ResidentPhotoRequest.h"
#import "BSSignContractListRequest.h"
#import "HealthcardApplyRequest.h"
#import "UpdateFAViewController.h"
#import "ArchiveFamilyDetailRequest.h"
#import "ArchivePersonDetailRequest.h"
#import "UpdatePAViewController.h"
#import "ResidentSearchRequest.h"
#import "BSEducationInfoListRequest.h"
#import "BSEducationModel.h"
#import "BSSignTeamsRequest.h"
#import "SignTeamsInfoModel.h"

@interface ResidentHomeVC ()<UITableViewDelegate,UITableViewDataSource,ResidentHomeInfoCellDelegate,ResidentFollowupCellDelegate,ResidentSignInfoCellDelegate,ResidentPhysicalCellDelegate,ResidentChineseMedicineCellDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView  *separatorView;
@property (nonatomic, strong) NSMutableArray * sectionArray;
@property (nonatomic, strong) ResidentFollowupUiModel *gaoUiModel;    // 高血压
@property (nonatomic, strong) ResidentFollowupUiModel *tangUiModel;   // 糖尿病

@property (nonatomic, strong) ResidentZhongYiRequest * zhongYiRequest;
@property (nonatomic, strong) ResidentPhotoRequest * photoRequest;
@property (nonatomic, strong) BSSignTeamsRequest * signTeamRequest;   // 获取签约团队信息
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) BSSignContractListRequest * signRequest;   // 获取签约信息
@property (nonatomic, strong) BSEducationInfoListRequest *eduListRequest;//获取最近一个健康教育

@property (nonatomic, copy) NSString * cmdSignUrl;       // 激活银行卡
@property (nonatomic, copy) NSString * signUrl;
@property (nonatomic, copy) NSString * signDetailUrl;
@property (nonatomic, copy) NSString * signListUrl;
@property (nonatomic, copy) NSString * zyFollowupUrl;
@property (nonatomic, copy) NSString * zyFollowupSearchUrl;

@property (nonatomic, assign) BOOL  needRefreshInfo;

@end

@implementation ResidentHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadPhotoData];
    [self loadZhongYiData];
    [self loadSignData];
    [self loadEducationInfoListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (self.needRefreshInfo) {
        [self loadPersonInfoDataWithAvatar:nil];
        self.needRefreshInfo = NO;
    }
}
- (void)dealloc {
    [self unobserveNotification:kHyFollowupSaveSuccess];
    [self unobserveNotification:kDbFollowupSaveSuccess];
    [self unobserveNotification:kZyFollowupSaveSuccess];
    [self unobserveNotification:kSignSaveSuccess];
    [self unobserveNotification:kHealthEducationSaveSuccess];
}
- (void)initView
{
    self.title = @"居民主页";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.needRefreshInfo = NO;
    self.gaoUiModel = [[ResidentFollowupUiModel alloc]init];
    self.tangUiModel = [[ResidentFollowupUiModel alloc]init];
    self.tableView =  [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-TOP_BAR_HEIGHT-SafeAreaBottomHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 250;
    [self.tableView registerNib:[ResidentHomeInfoCell nib] forCellReuseIdentifier:[ResidentHomeInfoCell cellIdentifier]];
    [self.tableView registerNib:[ResidentSectionCell nib] forCellReuseIdentifier:[ResidentSectionCell cellIdentifier]];
    [self.tableView registerNib:[ResidentFollowupSectionCell nib]  forCellReuseIdentifier:[ResidentFollowupSectionCell cellIdentifier]];
    [self.tableView registerNib:[ResidentFollowupCell nib] forCellReuseIdentifier:[ResidentFollowupCell cellIdentifier]];
    [self.tableView registerNib:[ResidentSignInfoCell nib] forCellReuseIdentifier:[ResidentSignInfoCell cellIdentifier]];
    [self.tableView registerNib:[ResidentPhysicalCell nib] forCellReuseIdentifier:[ResidentPhysicalCell cellIdentifier]];
    [self.tableView registerNib:[ResidentChineseMedicineCell nib] forCellReuseIdentifier:[ResidentChineseMedicineCell cellIdentifier]];
    [self.tableView registerNib:[ResidentHealthEduCell nib] forCellReuseIdentifier:[ResidentHealthEduCell cellIdentifier]];
    
    [self.view addSubview:self.tableView];
    [self observeNotificaiton:kHyFollowupSaveSuccess selector:@selector(loadGaoFollowupData)];
    [self observeNotificaiton:kDbFollowupSaveSuccess selector:@selector(loadTangFollowupData)];
    [self observeNotificaiton:kZyFollowupSaveSuccess selector:@selector(loadZhongYiData)];
    [self observeNotificaiton:kSignSaveSuccess selector:@selector(loadSignData)];
    [self observeNotificaiton:kHealthEducationSaveSuccess selector:@selector(loadEducationInfoListData)];
    
}

#pragma mark ---- 数据请求

- (void)loadPhotoData
{
    if (!self.photoRequest) {
        self.photoRequest = [[ResidentPhotoRequest alloc]init];
    }
    self.photoRequest.personId = self.infoModel.idField;
    Bsky_WeakSelf
    [self.photoRequest startWithCompletionBlockWithSuccess:^(__kindof ResidentPhotoRequest * _Nonnull request) {
        Bsky_StrongSelf
        [self.tableView reloadData];
    } failure:^(__kindof ResidentPhotoRequest * _Nonnull request) {
        
    }];
    
}
- (void)loadZhongYiData
{
    if (!self.zhongYiRequest) {
        self.zhongYiRequest = [[ResidentZhongYiRequest alloc]init];
    }
    self.zhongYiRequest.personId = self.infoModel.idField;
    Bsky_WeakSelf
    [self.zhongYiRequest startWithCompletionBlockWithSuccess:^(__kindof ResidentZhongYiRequest * _Nonnull request) {
        Bsky_StrongSelf
        [self.tableView reloadData];
    } failure:^(__kindof ResidentZhongYiRequest * _Nonnull request) {
        [self.tableView reloadData];
    }];
   [self.tableView reloadData];
}
- (void)loadSignDetailData
{
    if (!self.signRequest) {
        self.signRequest = [[BSSignContractListRequest alloc]init];
    }
    self.signRequest.cardIdOrName = self.infoModel.cardId;
    if (self.teamId.length) {
        self.signRequest.teamId = self.teamId;
    }
    Bsky_WeakSelf
    [self.signRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignContractListRequest * _Nonnull request) {
        Bsky_StrongSelf
        [self.tableView reloadData];
    } failure:^(__kindof BSSignContractListRequest * _Nonnull request) {
        [self.tableView reloadData];
    }];
    [self.tableView reloadData];
}
- (void)loadSignData{
    if (self.teamId.length) {
        
    }else{
        if(!_signTeamRequest){
            _signTeamRequest = [[BSSignTeamsRequest alloc] init];
        }
        Bsky_WeakSelf;
        [_signTeamRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignTeamsRequest * _Nonnull request) {
            Bsky_StrongSelf;
            if (request.teamsData.count) {
                SignTeamsInfoModel *model = request.teamsData.firstObject;
                self.teamId = model.teamId;
            }
            [self loadSignDetailData];
        } failure:^(__kindof BSSignTeamsRequest * _Nonnull request) {
            Bsky_StrongSelf;
            [self loadSignDetailData];
        }];
    }
    
}
- (void)loadGaoFollowupData
{
    FollowupHyYearCountRequest *countRequest = [[FollowupHyYearCountRequest alloc]init];
    countRequest.personId = self.infoModel.idField;
    countRequest.doctorId = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;
    
    FollowupHyInfoAllRequest *timeRequest = [[FollowupHyInfoAllRequest alloc]init];
    timeRequest.personId = self.infoModel.idField;
    timeRequest.lastfollowdate = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[countRequest,timeRequest]];
    Bsky_WeakSelf
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSArray *requests = batchRequest.requestArray;
        FollowupHyYearCountRequest *countRequest = (FollowupHyYearCountRequest *)requests[0];
        FollowupHyInfoAllRequest *timeRequest = (FollowupHyInfoAllRequest *)requests[1];
        Bsky_StrongSelf
        self.gaoUiModel.count = [NSString stringWithFormat:@"%ld",(long)countRequest.count];
        if (![self.gaoUiModel.count isNotEmptyString]) {
            self.gaoUiModel.count = kModelEmptyString;
        }
        if ([timeRequest.lastModel.cmModel.followUpDate isNotEmptyString]) {
          self.gaoUiModel.lastTime = [timeRequest.lastModel.cmModel.followUpDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
        }
        else
        {
            self.gaoUiModel.lastTime = kModelEmptyString;
        }
        if ([timeRequest.lastModel.cmModel.nextFollowUpDate isNotEmptyString]) {
           self.gaoUiModel.nextTime = [timeRequest.lastModel.cmModel.nextFollowUpDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
        }
        else
        {
            self.gaoUiModel.nextTime = kModelEmptyString;
        }
        self.gaoUiModel.isAnimation = NO;
        [self.tableView reloadData];
    } failure:^(YTKBatchRequest *batchRequest) {
        Bsky_StrongSelf
        self.gaoUiModel.isAnimation = NO;
        [self.tableView reloadData];
    }];
}
- (void)loadTangFollowupData
{
    FollowupDbYearCountRequest *countRequest = [[FollowupDbYearCountRequest alloc]init];
    countRequest.personId = self.infoModel.idField;
    countRequest.doctorId = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;
    
    FollowupDbInfoAllRequest *timeRequest = [[FollowupDbInfoAllRequest alloc]init];
    timeRequest.personId = self.infoModel.idField;
    timeRequest.lastfollowdate = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[countRequest,timeRequest]];
    Bsky_WeakSelf
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSArray *requests = batchRequest.requestArray;
        FollowupDbYearCountRequest *countRequest = (FollowupDbYearCountRequest *)requests[0];
        FollowupDbInfoAllRequest *timeRequest = (FollowupDbInfoAllRequest *)requests[1];
        Bsky_StrongSelf
        self.tangUiModel.count = [NSString stringWithFormat:@"%ld",(long)countRequest.count];
        if (![self.tangUiModel.count isNotEmptyString]) {
            self.tangUiModel.count = kModelEmptyString;
        }
        if ([timeRequest.lastModel.cmModel.followUpDate isNotEmptyString]) {
          self.tangUiModel.lastTime = [timeRequest.lastModel.cmModel.followUpDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
        }
        else
        {
            self.tangUiModel.lastTime = kModelEmptyString;
        }
        if ([timeRequest.lastModel.cmModel.nextFollowUpDate isNotEmptyString]) {
           self.tangUiModel.nextTime = [timeRequest.lastModel.cmModel.nextFollowUpDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
        }
        else
        {
            self.tangUiModel.nextTime = kModelEmptyString;
        }
        self.tangUiModel.isAnimation = NO;
        [self.tableView reloadData];
        
    } failure:^(YTKBatchRequest *batchRequest) {
        Bsky_StrongSelf
        self.tangUiModel.isAnimation = NO;
        [self.tableView reloadData];
    }];
}

- (void)loadPersonInfoDataWithAvatar:(NSString *)avatar {
    ResidentSearchRequest *searchRequest = [[ResidentSearchRequest alloc]init];
    searchRequest.putModel.pageSize = @"1";
    searchRequest.putModel.pageIndex = @"1";
    searchRequest.putModel.keyValue = self.infoModel.personCode;
    searchRequest.putModel.keyCode = @"3";
    Bsky_WeakSelf
    [searchRequest startWithCompletionBlockWithSuccess:^(ResidentSearchRequest* request) {
        Bsky_StrongSelf
        PersonColligationModel *model = [request.dataList firstObject];
        for (NSString *key in self.infoModel.getProperties) {
            [self.infoModel setValue:[model valueForKey:key] forKey:key];
        }
        if ([avatar isNotEmptyString]) {
            self.photoRequest.data = avatar;
        }
        [self.tableView reloadData];
    } failure:^(ResidentSearchRequest* request) {
        [UIView makeToast:request.msg];
    }];
}

- (void)loadEducationInfoListData {
    if (!self.eduListRequest) {
        self.eduListRequest = [[BSEducationInfoListRequest alloc] init];
    }
    self.eduListRequest.pageIndex = @(1);
    self.eduListRequest.pageSize = @(1);
    self.eduListRequest.regionCode = self.infoModel.regionCode;
    self.eduListRequest.searchParam = [self.infoModel.personCode isNotEmpty] ? self.infoModel.personCode : self.infoModel.regionCode;
    self.eduListRequest.regionCode = [BSAppManager sharedInstance].currentUser.divisionCode;
    [self.eduListRequest startWithCompletionBlockWithSuccess:^(__kindof BSEducationInfoListRequest * _Nonnull request) {
        if (request.infoListData.count != 0) {
            [self.tableView reloadData];
        }
    } failure:^(__kindof BSEducationInfoListRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
    
}
- (void)applyHealthcard
{
    HealthcardApplyRequest *applyRequest = [[HealthcardApplyRequest alloc]init];
    HealthCardUpModel *upModel = [[HealthCardUpModel alloc]init];
    upModel.divisionCode = [BSAppManager sharedInstance].currentUser.divisionCode;
    upModel.documentNo = self.infoModel.cardId;
    upModel.orgId = [BSAppManager sharedInstance].currentUser.organizationId;
    upModel.phone = self.infoModel.telphone;
    upModel.realName = self.infoModel.name;
    [upModel encryptModel];
    applyRequest.healthCardFrom = [upModel mj_keyValues];
    [MBProgressHUD showHud];
    Bsky_WeakSelf
    [applyRequest startWithCompletionBlockWithSuccess:^(__kindof HealthcardApplyRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        Bsky_StrongSelf
        switch (request.dataModel.healthSate.integerValue) {
            case HealthCardSateSuccess:
                {
                    [UIView makeToast:@"申请健康卡成功,请激活"];
                    self.infoModel.userId = request.dataModel.userId;
                    self.infoModel.healthCardState = [NSString stringWithFormat:@"%lu",(unsigned long)HealthCardStateInactivated];
                    [self.tableView reloadData];
                    [self loadWebVCWithType:kH5CmdSignUrl];
                }
                break;
            case HealthCardSateVerifiedFailure:
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"该用户姓名或身份证信息错误，是否立即完善？" delegate:self cancelButtonTitle:@"暂不完善" otherButtonTitles:@"去完善", nil];
                Bsky_WeakSelf
                alertView.completionBlock = ^(UIAlertView *alertView, NSInteger index) {
                    if (index == 1) {
                        Bsky_StrongSelf
                        [self pushUpdatePAViewController];
                    }
                };
                [alertView show];
            }
                break;
            case HealthCardSateApplyFailure:
            {
                [UIView makeToast:request.dataModel.msg];
            }
                break;
            case HealthCardSateTelRepeat:
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"该手机号已申领电子健康卡，是否修改手机号继续申领？" delegate:self cancelButtonTitle:@"暂不修改" otherButtonTitles:@"去修改", nil];
                Bsky_WeakSelf
                alertView.completionBlock = ^(UIAlertView *alertView, NSInteger index) {
                    if (index == 1) {
                        Bsky_StrongSelf
                        [self pushUpdatePAViewController];
                    }
                };
                [alertView show];
            }
                break;
            default:
                break;
        }
    } failure:^(__kindof HealthcardApplyRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 5;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:[ResidentHomeInfoCell cellIdentifier] forIndexPath:indexPath];
        ResidentHomeInfoCell *customCell = (ResidentHomeInfoCell *)cell;
        customCell.imageDataStr = self.photoRequest.data;
        customCell.model = self.infoModel;
        if (!customCell.delegate) {
            customCell.delegate = self;
        }
        [customCell setSeparatorLeftMargin:0];
    }
    else if(indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:[ResidentSectionCell cellIdentifier] forIndexPath:indexPath];
        ResidentSectionCell *customCell = (ResidentSectionCell *)cell;
        customCell.titleLabel.text = self.sectionArray[indexPath.section - 1];
        [customCell setSeparatorLeftMargin:13];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:[ResidentFollowupSectionCell cellIdentifier] forIndexPath:indexPath];
            ResidentFollowupSectionCell *customCell = (ResidentFollowupSectionCell *)cell;
            customCell.titleLabel.text = @"高血压随访";
            customCell.isExpansion = self.gaoUiModel.isExpansion;
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:[ResidentFollowupCell cellIdentifier] forIndexPath:indexPath];
            ResidentFollowupCell *customCell = (ResidentFollowupCell *)cell;
            customCell.model = self.gaoUiModel;
            if (!customCell.delegate) {
                customCell.delegate = self;
            }
            [customCell setSeparatorLeftMargin:13];
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:[ResidentFollowupSectionCell cellIdentifier] forIndexPath:indexPath];
            ResidentFollowupSectionCell *customCell = (ResidentFollowupSectionCell *)cell;
            customCell.titleLabel.text = @"糖尿病随访";
            customCell.isExpansion = self.tangUiModel.isExpansion;
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:[ResidentFollowupCell cellIdentifier] forIndexPath:indexPath];
            ResidentFollowupCell *customCell = (ResidentFollowupCell *)cell;
            customCell.model = self.tangUiModel;
            if (!customCell.delegate) {
                customCell.delegate = self;
            }
            [customCell setSeparatorLeftMargin:0];
        }
    }
    else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:[ResidentSignInfoCell cellIdentifier] forIndexPath:indexPath];
        ResidentSignInfoCell *customCell = (ResidentSignInfoCell *)cell;
        customCell.dataModel = [self.signRequest.dataList firstObject];
        if (!customCell.delegate) {
            customCell.delegate = self;
        }
        customCell.refreshStatus = self.signRequest.refreshStatus;
        [customCell setSeparatorLeftMargin:0];
    }
    else if (indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:[ResidentPhysicalCell cellIdentifier] forIndexPath:indexPath];
        ResidentPhysicalCell *customCell = (ResidentPhysicalCell *)cell;
        customCell.model = self.infoModel;
        if (!customCell.delegate) {
            customCell.delegate = self;
        }
        customCell.refreshStatus = ResidentRefreshStatusSuccess;
        [customCell setSeparatorLeftMargin:0];
    }
    else if (indexPath.section == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:[ResidentChineseMedicineCell cellIdentifier] forIndexPath:indexPath];
        ResidentChineseMedicineCell *customCell = (ResidentChineseMedicineCell *)cell;
        customCell.model = self.zhongYiRequest.data;
        if (!customCell.delegate) {
            customCell.delegate = self;
        }
        customCell.refreshStatus = self.zhongYiRequest.refreshStatus;
        [customCell setSeparatorLeftMargin:0];
    }
    else if (indexPath.section == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:[ResidentHealthEduCell cellIdentifier] forIndexPath:indexPath];
        ResidentHealthEduCell *customCell = (ResidentHealthEduCell *)cell;
        BSEducationModel *model = self.eduListRequest.infoListData.firstObject;
        customCell.timeLabel.text = [model.activityTime isNotEmpty] ? model.activityTime : kModelEmptyString;
        customCell.eduTypeLabel.text = [model.businessTypeA isNotEmpty] ? model.businessTypeA : kModelEmptyString;
        Bsky_WeakSelf
        customCell.addNewHealthEduBlcok = ^{
            Bsky_StrongSelf
            BSHealthTeachVC *vc = [[BSHealthTeachVC alloc] init];
            BSEducationModel *pushModel = [[BSEducationModel alloc] init];
            pushModel.personId = self.infoModel.idField;
            pushModel.personName = self.infoModel.name;
            vc.model = pushModel;
            [self.navigationController pushViewController:vc animated:YES];
        };
        [customCell setSeparatorLeftMargin:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.separatorView) {
        self.separatorView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self.separatorView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            if (![self.gaoUiModel.count isNotEmptyString]) {
                [self loadGaoFollowupData];
            }
            self.gaoUiModel.isExpansion = !self.gaoUiModel.isExpansion;
            [tableView reloadData];
        }
        else if (indexPath.row == 2)
        {
            if (![self.gaoUiModel.count isNotEmptyString]) {
                self.tangUiModel.isAnimation = YES;
                [self loadGaoFollowupData];
            }
        }
        else if (indexPath.row == 3)
        {
            if (![self.tangUiModel.count isNotEmptyString]) {
                [self loadTangFollowupData];
            }
            self.tangUiModel.isExpansion = !self.tangUiModel.isExpansion;
            [tableView reloadData];
        }
        else if (indexPath.row == 4)
        {
            if (![self.tangUiModel.count isNotEmptyString]) {
                self.tangUiModel.isAnimation = YES;
                [self loadTangFollowupData];
            }
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 1 && self.signRequest.refreshStatus == ResidentRefreshStatusFailure ) {
            [self loadSignData];
        }
    }
    else if (indexPath.section == 4)
    {
        if (indexPath.row == 1 && self.zhongYiRequest.refreshStatus == ResidentRefreshStatusFailure ) {
            [self loadZhongYiData];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return self.gaoUiModel.isExpansion ? UITableViewAutomaticDimension : 0.5;
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        return self.tangUiModel.isExpansion ? UITableViewAutomaticDimension : 0.5;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark ----- Setter Getter

- (NSMutableArray *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray arrayWithObjects:@"随访信息",@"签约信息",@"体检信息",@"中医药健康管理",@"健康教育", nil];
    }
    return _sectionArray;
}
#pragma mark ---- ResidentHomeInfoCellDelegate

- (void)residentHomeInfoCellPhoneBtnPressed:(ResidentHomeInfoCell *)cell
{
    NSString *telStr = [NSString stringWithFormat:@"tel://%@",self.infoModel.telphone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}
- (void)residentHomeInfoCellJiBtnPressed:(ResidentHomeInfoCell *)cell
{
    if (self.infoModel.healthCardState.integerValue == HealthCardStateInactivated) {
        [self loadWebVCWithType:kH5CmdSignUrl];
    }
    else if (self.infoModel.healthCardState.integerValue == HealthCardStateActivated) {
        
    }
    else
    {
        if ([self verificationPersonInfo]) {
            [self applyHealthcard];
        }
    }
}
- (void)residentHomeInfoCellFamilyArchivesBtnPressed:(ResidentHomeInfoCell *)cell
{
    [MBProgressHUD showHud];
    ArchiveFamilyDetailRequest *request = [[ArchiveFamilyDetailRequest alloc] init];
    request.familyId = self.infoModel.familyID;
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveFamilyDetailRequest * _Nonnull request) {
        Bsky_StrongSelf;
        UpdateFAViewController *vc = [[UpdateFAViewController alloc] init];
        vc.detailModel = request.familyModel;
        vc.updateBlock = ^(FamilyArchiveModel *arhciveModel) {
            
        };
        [self.navigationController pushViewController:vc animated:YES];
        [MBProgressHUD hideHud];
    } failure:^(__kindof ArchiveFamilyDetailRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
- (void)residentHomeInfoCellHealthArchivesBtnPressed:(ResidentHomeInfoCell *)cell
{
    [self pushUpdatePAViewController];
}
#pragma mark ---- ResidentFollowupCellDelegate

- (void)residentFollowupCellExamineBtnPressed:(ResidentFollowupCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FolloupHistoryVC *vc = [[FolloupHistoryVC alloc]init];
    vc.personId = self.infoModel.idField;
    vc.personName = self.infoModel.name;
    vc.type = indexPath.row == 2 ? FollowupTypeHypertension : FollowupTypeDiabetes;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)residentFollowupCellAddBtnPressed:(ResidentFollowupCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FollowupAllFormVC *vc = [[FollowupAllFormVC alloc]init];
    vc.planModel = [[BSFollowup alloc]init];
    vc.planModel.gwUserId = self.infoModel.idField;
    vc.planModel.username = self.infoModel.name;
    vc.planModel.phone = self.infoModel.telphone;
    vc.planModel.age = self.infoModel.age;
    vc.planModel.sex = [self.infoModel.gender isEqualToString:@"男"] ? @"1" : @"2";
    vc.planModel.address = self.infoModel.address;
    vc.planModel.followUpType = [NSString stringWithFormat:@"0%ld",indexPath.row == 2 ? FollowupTypeHypertension : FollowupTypeDiabetes];
    vc.planModel.status = @"06001001";
    vc.planModel.userIdCard = self.infoModel.cardId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ---- ResidentSignInfoCellDelegate

- (void)residentSignInfoCellSignBtnPressed:(ResidentSignInfoCell *)cell
{
    if ([self verificationPersonInfo]) {
        [self loadWebVCWithType:kH5ResManagerToSign];
    }
}
- (void)residentSignInfoCellMoreBtnPressed:(ResidentSignInfoCell *)cell
{
    if (self.signRequest.dataList.count > 1) {
        [self loadWebVCWithType:kH5ResManagerToSignList];
    }
    else
    {
        [self loadWebVCWithType:kH5ResManagerToSignCon];
    }
}

#pragma mark ---- ResidentPhysicalCellDelegate

- (void)residentPhysicalCellExamineBtnPressed:(ResidentPhysicalCell *)cell
{
    [UIView makeToast:@"该功能暂未开放"];
}
- (void)residentPhysicalCellPerfectBtnPressed:(ResidentPhysicalCell *)cell
{
    [UIView makeToast:@"该功能暂未开放"];
}
- (void)residentPhysicalCellAddBtnPressed:(ResidentPhysicalCell *)cell
{
    [UIView makeToast:@"该功能暂未开放"];
}

#pragma mark ----  ResidentChineseMedicineCellDelegate

- (void)residentChineseMedicineCellExamineBtnPressed:(ResidentChineseMedicineCell *)cell
{
    if ([self.zhongYiRequest.data.idField isNotEmptyString]) {
        [self loadWebVCWithType:kH5ZyFollowUpSearch];
    }
    else
    {
        [UIView makeToast:@"您还没有中医随访记录"];
    }
}
- (void)residentChineseMedicineCellAddBtnPressed:(ResidentChineseMedicineCell *)cell
{
    [self loadWebVCWithType:kH5ZyFollowUp];
}
- (void)loadWebVCWithType:(NSString *)type
{
    Bsky_WeakSelf
    [self loadUrlStringWithType:type block:^(NSString *urlString) {
        Bsky_StrongSelf
        BSWebViewController *webVC = [[BSWebViewController alloc]init];
        webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
        webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
        if ([type isEqualToString:kH5ZyFollowUp] || [type isEqualToString:kH5ZyFollowUpSearch]) {
            NSString * jsStr = [NSString stringWithFormat:@"ChineseFollowUpIOS('%@','%@','%@')",self.infoModel.idField,self.infoModel.name,self.zhongYiRequest.data.idField];
            webVC.ocTojsStr = jsStr;
        }
        else if ([type isEqualToString:kH5CmdSignUrl])
        {
            self.needRefreshInfo = YES;
            webVC.showNavigationBar = YES;
            urlString = [urlString stringByAppendingFormat:@"&userId=%@",self.infoModel.userId];
        }
        else
        {
            urlString = [urlString stringByAppendingFormat:@"&CardId=%@",[[self.infoModel.cardId encryptCBCStr] urlencode]];
        }
        [webVC ba_web_loadURLString:urlString];
        [self.navigationController pushViewController:webVC animated:YES];
    }];
}
- (void)loadUrlStringWithType:(NSString *)type  block:(void (^)(NSString* urlString))block {
    
    if ([type isEqualToString:kH5CmdSignUrl] && [self.cmdSignUrl isNotEmptyString]) {
        block(self.cmdSignUrl);
        return;
    }
    if ([type isEqualToString:kH5ZyFollowUp] && [self.zyFollowupUrl isNotEmptyString]) {
        block(self.zyFollowupUrl);
        return;
    }
    if ([type isEqualToString:kH5ZyFollowUpSearch] && [self.zyFollowupSearchUrl isNotEmptyString]) {
        block(self.zyFollowupSearchUrl);
        return;
    }
    if ([type isEqualToString:kH5ResManagerToSign] && [self.signUrl isNotEmptyString]) {
        block(self.signUrl);
        return;
    }
    if ([type isEqualToString:kH5ResManagerToSignList] && [self.signListUrl isNotEmptyString]) {
        block(self.signListUrl);
        return;
    }
    if ([type isEqualToString:kH5ResManagerToSignCon] && [self.signDetailUrl isNotEmptyString]) {
        block(self.signDetailUrl);
        return;
    }
    BSH5UrlRequest *urlRequest = [[BSH5UrlRequest alloc]init];
    urlRequest.type = type;
    [MBProgressHUD showHud];
    Bsky_WeakSelf
    [urlRequest startWithCompletionBlockWithSuccess:^(BSH5UrlRequest* request) {
        [MBProgressHUD hideHud];
        Bsky_StrongSelf
        if ([type isEqualToString:kH5CmdSignUrl]) {
            self.cmdSignUrl = request.urlString;
        }
        else if ([type isEqualToString:kH5ZyFollowUp]) {
            self.zyFollowupUrl = request.urlString;
        }
        else if ([type isEqualToString:kH5ZyFollowUpSearch]) {
            self.zyFollowupSearchUrl = request.urlString;
        }
        else if ([type isEqualToString:kH5ResManagerToSign]) {
            self.signUrl = request.urlString;
        }
        else if ([type isEqualToString:kH5ResManagerToSignList]) {
            self.signListUrl = request.urlString;
        }
        else if ([type isEqualToString:kH5ResManagerToSignCon]) {
            self.signDetailUrl = request.urlString;
        }
        if (block) {
            block(request.urlString);
        }
    } failure:^(BSH5UrlRequest* request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}
#pragma mark --- 验证个人信息有效性
- (BOOL)verificationPersonInfo
{
    NSMutableArray *array = [NSMutableArray array];
    if (![self.infoModel.name isNotEmptyString] || [self.infoModel.name isEqualToString:kModelEmptyString]) {
        [array addObject:@"姓名"];
    }
    if (![self.infoModel.telphone isNotEmptyString] || ![self.infoModel.telphone isPhoneNumber])
    {
        [array addObject:@"电话"];
    }
    if (![self.infoModel.cardId isNotEmptyString] || ![self.infoModel.cardId isIdCard])
    {
        [array addObject:@"身份证"];
    }
    if ([array isNotEmptyArray]) {
        NSString *contentStr = @"该档案";
        for (int i = 0; i<array.count; i++) {
            if (i == 0) {
                contentStr = [contentStr stringByAppendingString:array[i]];
            }
            else
            {
                contentStr = [contentStr stringByAppendingFormat:@"、%@",array[i]];
            }
        }
        contentStr = [contentStr stringByAppendingString:@"信息错误，是否立即完善?"];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示信息" message:contentStr delegate:self cancelButtonTitle:@"暂不完善" otherButtonTitles:@"去完善", nil];
        Bsky_WeakSelf
        alertView.completionBlock = ^(UIAlertView *alertView, NSInteger index) {
            if (index == 1) {
                Bsky_StrongSelf
               [self pushUpdatePAViewController];
            }
        };
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark ---- 跳转个人档案编辑

- (void)pushUpdatePAViewController
{
    [MBProgressHUD showHud];
    ArchivePersonDetailRequest *request = [[ArchivePersonDetailRequest alloc] init];
    request.personId = self.infoModel.idField;
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchivePersonDetailRequest * _Nonnull request) {
        Bsky_StrongSelf;
        UpdatePAViewController *vc = [[UpdatePAViewController alloc] init];
        vc.personModel = request.personModel;
        Bsky_WeakSelf
        vc.updateBlock = ^(NSString *photo) {
            Bsky_StrongSelf
            [self loadPersonInfoDataWithAvatar:photo];
        };
        [MBProgressHUD hideHud];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(__kindof ArchivePersonDetailRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}

@end
