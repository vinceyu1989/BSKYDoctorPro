//
//  ResidentManageVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentManageVC.h"
#import "ResidentListCell.h"
#import "ResidentFilterView.h"
#import "ScanViewController.h"
#import "ResidentHomeVC.h"

#import "ResidentSearchRequest.h"
#import "HealthScanRequest.h"

@interface ResidentManageVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic ,strong) UIView *searchView;

@property (nonatomic ,strong) BSTextField *textField;

@property (nonatomic, strong) UIButton *filterBtn;

@property (nonatomic, strong) ResidentFilterView *filterView;

@property (nonatomic, strong) ResidentSearchRequest * searchRequest;

@property (nonatomic ,assign) NSUInteger currentPage;

@property (nonatomic, strong) HealthScanRequest * scanRequest;

@property (nonatomic, strong) PersonColligationModel * currentModel;

@end

@implementation ResidentManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchRequest = [[ResidentSearchRequest alloc]init];
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.currentModel) {
        NSInteger row = [self.dataList indexOfObject:self.currentModel];
        [self.tableView reloadRow:row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)initView
{
    self.title = @"居民管理";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.filterBtn];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    self.dataList = [NSMutableArray array];
    self.currentPage = 1;
    [self.tableView.mj_footer beginRefreshing];
}
- (void)loadData {
    self.searchRequest.putModel.pageSize = @"10";
    self.searchRequest.putModel.pageIndex = [NSString stringWithFormat:@"%lu",(unsigned long)self.currentPage];
    self.searchRequest.putModel.keyValue = self.textField.text;
    if ([self.searchRequest.putModel.keyValue isNotEmptyString]) {
        self.searchRequest.putModel.keyCode = [self.textField.text isIdCard] ? @"2" : @"1";
        [self.filterView resetBtnPressed:nil];  // 筛选界面置空
    }
    else
    {
        self.searchRequest.putModel.keyCode = nil;
    }
    [MBProgressHUD showHud];
    Bsky_WeakSelf
    [self.searchRequest startWithCompletionBlockWithSuccess:^(ResidentSearchRequest* request) {
        [MBProgressHUD hideHud];
        Bsky_StrongSelf
        if (request.dataList.count < request.putModel.pageSize.integerValue) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.currentPage == 1) {
            [self.dataList removeAllObjects];
        }
        self.currentPage++;
        [self.dataList addObjectsFromArray:self.searchRequest.dataList];
        [self.tableView reloadData];
        if (self.currentPage == 2) {
            [self.tableView scrollToTop];
        }
        
    } failure:^(ResidentSearchRequest* request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResidentListCell *cell = [tableView dequeueReusableCellWithIdentifier:[ResidentListCell cellIdentifier] forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResidentHomeVC *homeVC = [[ResidentHomeVC alloc]init];
    homeVC.infoModel = self.dataList[indexPath.row];
    self.currentModel = homeVC.infoModel;
    [self.navigationController pushViewController:homeVC animated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark --- Click

- (void)filterBtnPressed
{
    [self.textField resignFirstResponder];
    if (!self.filterView) {
        self.filterView = [[ResidentFilterView alloc]init];
        self.filterView.putModel = self.searchRequest.putModel;
        Bsky_WeakSelf
        self.filterView.selectedComplete = ^{
            Bsky_StrongSelf
            self.textField.text = nil;
            [self.textField resignFirstResponder];
            self.currentPage = 1;
            [self.tableView.mj_footer beginRefreshing];
        };
    }
    [self.filterView show];
}
- (void)searchBtnPressed
{
    if ([self checkInfo]) {
        [self.tableView.mj_footer beginRefreshing];
    }
}
- (void)saoButtonPressed {
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    Bsky_WeakSelf
    scanVC.block = ^(ScanViewController *vc, NSString *scanCode) {
        Bsky_StrongSelf
        [vc.navigationController popViewControllerAnimated:YES];
        [self getQRCodeInfoWithStr:scanCode];
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}

#pragma mark ----- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self checkInfo]) {
        [self.tableView.mj_footer beginRefreshing];
    }
    return YES;
}
#pragma mark ---- 内部方法

- (void)getQRCodeInfoWithStr:(NSString *)scanCode {
    if ([scanCode isChinese] || [scanCode isIdCard]) {
        self.textField.text = scanCode;
        if ([self checkInfo]) {
            [self.tableView.mj_footer beginRefreshing];
        }
    } else {
        if (!self.scanRequest) {
            self.scanRequest = [[HealthScanRequest alloc]init];
        }
        self.scanRequest.requestModel.ewmsg = scanCode;
        self.scanRequest.businessType = ScanBusinessHealthFilesType;
        [MBProgressHUD showHud];
        Bsky_WeakSelf
        [self.scanRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request)
         {
             [MBProgressHUD hideHud];
             Bsky_StrongSelf
             self.textField.text = self.scanRequest.responseModel.zjhm;
             if ([self checkInfo]) {
                 [self.tableView.mj_footer beginRefreshing];
             }
         } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
             Bsky_StrongSelf
             [MBProgressHUD hideHud];
             self.textField.text = scanCode;
             [self.tableView.mj_footer beginRefreshing];
         }];
    }
}
- (BOOL)checkInfo
{
    if (self.textField.text.length < 1 ) {
        [UIView makeToast:@"请输入居民姓名或身份证号"];
        return NO;
    }
    if ([self.textField.text isNumText] && ![self.textField.text isIdCard]) {
        [UIView makeToast:@"请输入正确身份证号"];
        return NO;
    }
    [self.textField resignFirstResponder];
    self.currentPage = 1;
    self.searchRequest.putModel.cmKind = nil;
    self.searchRequest.putModel.gender = nil;
    self.searchRequest.putModel.isStatus = nil;
    self.searchRequest.putModel.itemPerfect = nil;
    self.searchRequest.putModel.isPoor = nil;
    self.searchRequest.putModel.isFlowing = nil;
    return YES;
}

#pragma mark - Getter  Setter

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 55)];
        _searchView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        self.textField = [[BSTextField alloc]initWithFrame:CGRectMake(10, 10, _searchView.width-70, 35)];
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField .layer.borderColor = UIColorFromRGB(0xededed).CGColor;
        self.textField.layer.borderWidth = 0.5;
        [self.textField setCornerRadius:5];
        self.textField.placeholder = @"请输入居民姓名、身份证号";
        self.textField.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        self.textField.textColor = UIColorFromRGB(0x333333);
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeySearch;
        self.textField.maxNum = 20;
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"diabetes_search_icon"];
        searchIcon.contentMode = UIViewContentModeCenter;
        [searchIcon sizeToFit];
        searchIcon.frame = CGRectMake(0, 0, searchIcon.width+20, self.textField .height);
        self.textField .leftView = searchIcon;
        self.textField .leftViewMode = UITextFieldViewModeAlways;
        [_searchView addSubview:self.textField];
        
        UIButton* saoButton = [UIButton new];
        [saoButton setImage:[UIImage imageNamed:@"scan_ico"] forState:UIControlStateNormal];
        saoButton.imageView.contentMode = UIViewContentModeCenter;
        [saoButton sizeToFit];
        saoButton.width = saoButton.width+20;
        [saoButton addTarget:self action:@selector(saoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.textField.rightView = saoButton;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(self.textField .right+5, self.textField .y, 45, self.textField .height);
        searchBtn.backgroundColor = RGB(62, 102, 200);
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [searchBtn setCornerRadius:5];
        [searchBtn addTarget:self action:@selector(searchBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_searchView addSubview:searchBtn];
    }
    return _searchView;
}
- (UIButton *)filterBtn
{
    if (!_filterBtn) {
        _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_filterBtn setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
        [_filterBtn addTarget:self action:@selector(filterBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_filterBtn sizeToFit];
    }
    return _filterBtn;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 55, self.view.width, self.view.height-TOP_BAR_HEIGHT-55-SafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 250;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[ResidentListCell nib] forCellReuseIdentifier:[ResidentListCell cellIdentifier]];
        Bsky_WeakSelf
        MJRefreshAutoGifFooter *footerView = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            Bsky_StrongSelf
            [self loadData];
        }];
        // 设置文字
        [footerView setTitle:@"显示更多" forState:MJRefreshStateIdle];
        [footerView setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
        [footerView setTitle:@"暂无更多" forState:MJRefreshStateNoMoreData];
        // 设置字体
        footerView.stateLabel.font = [UIFont systemFontOfSize:14];
        // 设置颜色
        footerView.stateLabel.textColor = UIColorFromRGB(0x0eb2ff);
        // 设置尾部
        _tableView.mj_footer = footerView;
    }
    return _tableView;
}

@end
