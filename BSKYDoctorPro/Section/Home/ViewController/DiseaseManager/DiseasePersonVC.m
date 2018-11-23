//
//  DiseasePersonVC.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "DiseasePersonVC.h"
#import "ScanViewController.h"
#import "SignTagServicePackVC.h"
#import "SignSingleTableView.h"
#import "SignFamilyTableView.h"
#import "HMSegmentedControl.h"
#import "SignFamilyPersonView.h"
#import "HealthScanRequest.h"
#import "BSSignFamilyArchiveRequest.h"
#import "BSSignFamilyMemberRequest.h"
#import "BSSignResidentInfoRequest.h"
#import "SignResidentInfoModel.h"
#import "SignFamilyMembersModel.h"
#import "SignPushPersonInfoModel.h"
#import "BSSignCheckSignStatus.h"

typedef void (^completeBlock)(BOOL isSign);

@interface DiseasePersonVC ()<UITextFieldDelegate, SingleTableDelegate, FamilyTableDelegate, FamilyPersonViewDelegate>{
    NSString *_temMaster;
}
@property (nonatomic, strong) UIView               *searchView;
@property (nonatomic, strong) UITextField          *textField;
@property (nonatomic, strong) HMSegmentedControl   *segmentControl;
@property (nonatomic, strong) SignSingleTableView  *singleTableView;
@property (nonatomic, strong) HealthScanRequest     *scanRequest;
@property (nonatomic, strong) BSSignCheckSignStatus *checkStatusRequest;
@property (nonatomic, strong) BSSignResidentInfoRequest  *personInfoRequest;


@property (nonatomic, assign) NSInteger personIndex;
@property (nonatomic, assign) NSInteger familyIndex;
@end

@implementation DiseasePersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    self.scanRequest = [[HealthScanRequest alloc] init];
    self.personInfoRequest = [[BSSignResidentInfoRequest alloc] init];
//    self.familyInfoRequest = [[BSSignFamilyArchiveRequest alloc] init];
    self.checkStatusRequest = [[BSSignCheckSignStatus alloc] init];
    self.personIndex = 0;
    self.familyIndex = 0;
    _temMaster = @"";
}

- (void)initView {
    
    [self addRightView];
    self.navigationItem.titleView = self.searchView;
//    [self.view addSubview:self.segmentControl];
//    [self.view addSubview:self.srollView];
    
    self.singleTableView = [[SignSingleTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - SafeAreaBottomHeight) style:UITableViewStylePlain];
    self.singleTableView.myDelegate = self;
//    self.familyTableView = [[SignFamilyTableView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.srollView.height) style:UITableViewStylePlain];
//    self.familyTableView.myDelegate = self;
    [self.view addSubview:self.singleTableView];
//    [self.srollView addSubview:self.familyTableView];
    Bsky_WeakSelf
//    [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
//        Bsky_StrongSelf
//        self.srollView.contentOffset = CGPointMake(self.view.width*index, 0);
//    }];
    
//    [self addContraint];
    
    self.singleTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        Bsky_StrongSelf
        self.personIndex++;
        [self requestToInfo];
    }];
    self.singleTableView.mj_footer.hidden = YES;
//    self.familyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        Bsky_StrongSelf
//        self.familyIndex++;
//        [self requestToInfo];
//    }];
    self.singleTableView.mj_footer.hidden = YES;
}

- (void)addRightView {
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 45, 35);
    [searchBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4e7dd3"]] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#273e69"]] forState:UIControlStateDisabled];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchBtn setCornerRadius:5];
    [searchBtn addTarget:self action:@selector(searchBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
}

- (void)addContraint {
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}
#pragma mark - button pressed

- (void)onScanPressed {
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    Bsky_WeakSelf
    scanVC.block = ^(ScanViewController *vc, NSString *scanCode) {
        Bsky_StrongSelf
        [vc.navigationController popViewControllerAnimated:YES];
        [self getQRCodeInfoWithStr:scanCode];
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)searchBtnPressed {
    [self.textField resignFirstResponder];
    [self beginToRequest];
}

#pragma mark - pravite
//*<扫码处理 >/
- (void)getQRCodeInfoWithStr:(NSString *)scanCode {
    if ([scanCode isChinese]) {
        self.textField.text = scanCode;
        [self beginToRequest];
    } else {
        if (!self.scanRequest) {
            self.scanRequest = [[HealthScanRequest alloc]init];
        }
        self.scanRequest.requestModel.ewmsg = scanCode;
        //高血压随访0300701，糖尿病随访030070 ，高糖随访030070
        self.scanRequest.businessType = ScanBusinessHomeDoctorType;
        [MBProgressHUD showHud];
        Bsky_WeakSelf
        [self.scanRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request)
         {
             [MBProgressHUD hideHud];
             Bsky_StrongSelf
             self.textField.text = self.scanRequest.responseModel.zjhm;
             [self beginToRequest];
         } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
             [MBProgressHUD hideHud];
             [UIView makeToast:self.scanRequest.msg];
         }];
    }
}
//*<开始刷新数据 >/
- (void)beginToRequest {
//    self.segmentControl.selectedSegmentIndex == 0 ? (self.personIndex=0) : (self.familyIndex=0);
    self.personIndex=0;
    [self.singleTableView.mj_footer beginRefreshing];
//    self.segmentControl.selectedSegmentIndex == 0 ?  [self.singleTableView.mj_footer beginRefreshing] : [self.familyTableView.mj_footer beginRefreshing];
}
//*<数据请求 >/
- (void)requestToInfo {
    WS(weakSelf);
    if (self.textField.text.length == 0) {
        [self.singleTableView.mj_footer endRefreshing];
//        self.segmentControl.selectedSegmentIndex == 0 ?  [self.singleTableView.mj_footer endRefreshing] : [self.familyTableView.mj_footer endRefreshing];
        self.personIndex=0;
//        self.segmentControl.selectedSegmentIndex == 0 ? (self.personIndex=0) : (self.familyIndex=0);
        [UIView makeToast:@"请输入搜索内容~"];
        return;
    }
    [MBProgressHUD showHud];
    if (self.segmentControl.selectedSegmentIndex == 0) {
        self.singleTableView.mj_footer.hidden = NO;
        self.personInfoRequest.nameOrIdcard = self.textField.text;
        self.personInfoRequest.pageIndex = @(self.personIndex);
        [self.personInfoRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            if (weakSelf.personInfoRequest.residentInfosData.count != 0) {
                [weakSelf.singleTableView.mj_footer endRefreshing];
                if (weakSelf.personIndex <= 1) {
                    [weakSelf.singleTableView.tableData removeAllObjects];
                }
                [weakSelf.singleTableView.tableData addObjectsFromArray:weakSelf.personInfoRequest.residentInfosData];
                [weakSelf.singleTableView reloadData];
            } else {
                [weakSelf.singleTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [weakSelf.singleTableView.mj_footer endRefreshing];
        }];
    }
}
//*<检查是否签约 >/
- (void)checkSignInfoStatusWithIdcard:(NSString *)idCard complete:(completeBlock)block {
    self.checkStatusRequest.cardIds = idCard;
    [self.checkStatusRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignCheckSignStatus * _Nonnull request) {
        if (request.signStatusArr.count != 0) {
            SignCheckSignStatusRespondse *model = (SignCheckSignStatusRespondse *)request.signStatusArr.firstObject;
            BOOL isSign = [model.hasSigned boolValue];
            block(isSign);
        } else {
            block(NO);
        }
    } failure:^(__kindof BSSignCheckSignStatus * _Nonnull request) {
        block(NO);
    }];
}

//- (void)setPaperCheckPacksModel:(BSFamilySignInfoModel *)paperCheckPacksModel {
//    _paperCheckPacksModel = paperCheckPacksModel;
//}
//- (void)setEleCheckPacksModel:(SignInfoRequestModel *)eleCheckPacksModel {
//    _eleCheckPacksModel = eleCheckPacksModel;
//}
#pragma mark - table delegate
//*<服务包选择 >/
- (void)didSelectedSingleCellWithIndex:(NSInteger)index {
    _temMaster = @"";
    SignResidentInfoModel *temp = (SignResidentInfoModel *)self.singleTableView.tableData[index];

//    Bsky_WeakSelf
    if (self.selectBlock) {
        self.selectBlock(temp);
    }
    [self.navigationController popViewControllerAnimated:YES];
//    SignTagServicePackVC *service_vc = [[SignTagServicePackVC alloc] init];
//    service_vc.type = self.type;
//    service_vc.code = temp.code;
//    service_vc.paperChechModel = self.paperCheckPacksModel;
//    service_vc.eleCheckModel = self.eleCheckPacksModel;
//    [service_vc setBlock:^(SignTagServicePackVC *vc) {
//        Bsky_StrongSelf
//        SignPushPersonInfoModel *model = [[SignPushPersonInfoModel alloc] init];
//        model.tags = [vc.selectTagsArray copy];
//        model.contractServices = [vc.selectPackArray copy];
//        model.fee = @(vc.packsPrice);
//        SignResidentInfoModel *info = (SignResidentInfoModel *)self.singleTableView.tableData[index];
//        model.personAge = info.age;
//        model.personId = info.personId;
//        model.personIdcard = info.idcard;
//        model.personName = info.name;
//        if ([info.sex containsString:@"男"]) {
//            model.personSex = @"男";
//        } else if ([info.sex containsString:@"女"]) {
//            model.personSex = @"女";
//        }
//        [vc.navigationController popViewControllerAnimated:NO];
//        self.personCode = [NSMutableArray arrayWithCapacity:1];
//        [self.personCode addObject:vc.code];
//        if (self.block) {
//            self.block(self,model,vc);
//        }
//    }];
//    [self.navigationController pushViewController:service_vc animated:YES];
}
////*<签约家庭弹窗 >/
//- (void)didSelectedFamilyCellWithIndex:(NSInteger)index {
//    if (!self.familyShowView) {
//        self.familyShowView = [[SignFamilyPersonView alloc] init];
//        self.familyShowView.delegate = self;
//        self.familyShowView.model = (SignFamilyArchiveModel *)self.familyTableView.tableData[index];
//    }
//    [self.familyShowView showView];
//}
//
//#pragma mark - SignFamilyPersonView Delegate
////*<签约家庭弹窗选择人员 >/
//- (void)chooseFamilyPersonNum:(NSArray *)modelArr {
//    _temMaster = self.familyShowView.model.masterName;
//    [self dismissFamilyView];
//    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:modelArr.count];
//    NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:modelArr.count];
//    self.personCode = [NSMutableArray arrayWithCapacity:modelArr.count];
//    for (int i = 0; i<modelArr.count; i++) {
//        SignPushPersonInfoModel *model = [[SignPushPersonInfoModel alloc] init];
//        SignFamilyMembersModel *info = (SignFamilyMembersModel *)modelArr[i];
//        model.personAge = info.age;
//        model.personId = info.personId;
//        model.personIdcard = info.cardID;
//        model.personName = info.name;
//        if ([info.genderCode containsString:@"男"]) {
//            model.personSex = @"男";
//        } else if ([info.genderCode containsString:@"女"]) {
//            model.personSex = @"女";
//        }
//        [arr addObject:model];
//        [arr1 addObject:[info.telphone isNotEmpty] ? info.telphone : @""];
//        [self.personCode addObject:[info.personCode isNotEmpty] ? info.personCode : @""];
//    }
//    if (self.block) {
//        self.block(self,arr,arr1);
//    }
//}
//*<签约家庭弹窗消失 >/
//- (void)dismissFamilyView {
//    self.familyShowView.delegate = nil;
//    self.familyShowView.model = nil;
//    self.familyShowView = nil;
//}

#pragma mark - textField delegate
//*<键盘搜索 >/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self beginToRequest];
    return YES;
}

#pragma mark - setter getter

- (NSString *)masterName {
    return _temMaster;
}

- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-130*SCREEN_WIDTH/375.f, NAVIGATION_BAR_HEIGHT)];
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, _searchView.width, 35)];
        self.textField.centerY = _searchView.height/2;
        [self.textField setCornerRadius:5];
        self.textField.backgroundColor = UIColorFromRGB(0xf0f2f5);
        self.textField.placeholder = @"请输入居民姓名";
        self.textField.font = [UIFont systemFontOfSize:13];
        self.textField.textColor = UIColorFromRGB(0x333333);
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeySearch;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;  // 取消自动纠错
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"diabetes_search_icon"];
        searchIcon.contentMode = UIViewContentModeCenter;
        [searchIcon sizeToFit];
        searchIcon.frame = CGRectMake(0, 0, searchIcon.width+20, self.textField.height);
        self.textField.leftView = searchIcon;
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *saoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *sao = [UIImage imageNamed:@"scan_ico"];
        [saoButton setImage:sao forState:UIControlStateNormal];
        [saoButton sizeToFit];
        saoButton.frame = CGRectMake(0, 0, saoButton.width+20, self.textField.height);
        saoButton.imageView.contentMode = UIViewContentModeCenter;
        [saoButton addTarget:self action:@selector(onScanPressed) forControlEvents:UIControlEventTouchUpInside];
        self.textField.rightView = saoButton;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
        [_searchView addSubview:self.textField];
    }
    return _searchView;
}

//-(HMSegmentedControl *)segmentControl{
//    if (_segmentControl == nil) {
//        _segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectZero];
//        _segmentControl.sectionTitles = @[@"签约个人", @"签约家庭"];
//        NSDictionary *titleStyle = @{ NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"], NSFontAttributeName:[UIFont systemFontOfSize:15] };
//        NSDictionary *titleSelectStyle = @{ NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#4e7dd3"], NSFontAttributeName:[UIFont systemFontOfSize:15] };
//        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//        _segmentControl.selectionIndicatorHeight = 2;
//        _segmentControl.selectionIndicatorColor = [UIColor colorWithHexString:@"#4e7dd3"];
//        _segmentControl.titleTextAttributes = titleStyle;
//        _segmentControl.selectedTitleTextAttributes = titleSelectStyle;
//        _segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
//        _segmentControl.selectedSegmentIndex = 0;
//    }
//    return _segmentControl;
//}

//- (UIScrollView *)srollView {
//    if (!_srollView) {
//        _srollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.width, self.view.height - 60 - SafeAreaBottomHeight)];
//        _srollView.showsVerticalScrollIndicator = NO;
//        _srollView.showsHorizontalScrollIndicator = NO;
//        _srollView.pagingEnabled = YES;
//        _srollView.directionalLockEnabled = YES;
//        _srollView.scrollEnabled = NO;
//        _srollView.contentSize = CGSizeMake(self.view.width*2, self.view.height - 60 - SafeAreaBottomHeight);
//    }
//    return _srollView;
//}

@end
