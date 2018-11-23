//
//  FolloupDoctorsViewController.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FolloupDoctorsViewController.h"
#import "BSTextField.h"
#import "FollowupResponsibilityDoctorCell.h"
#import "ResponsibilityDoctorRequest.h"

@interface FolloupDoctorsViewController ()<UITableViewDataSource ,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UIView *searchView;

@property (nonatomic ,strong) BSTextField *textField;

@property (nonatomic ,strong) ResponsibilityDoctorRequest *doctorRequest;

@property (nonatomic ,strong) NSMutableArray *dataList;

@property (nonatomic ,assign) NSUInteger currentPage;

@end

@implementation FolloupDoctorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}

- (void)initView
{
    self.title = @"责任医生选择";
    self.dataList = [NSMutableArray array];
    self.currentPage = 0;
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    [self.tableView.mj_footer beginRefreshing];
}
- (void)loadDoctorData
{
    if (!self.doctorRequest) {
        self.doctorRequest = [[ResponsibilityDoctorRequest alloc]init];
        self.doctorRequest.pageSize = @10;
    }
    self.doctorRequest.medWorkerName = self.textField.text;
    self.doctorRequest.pageIndex = @(self.currentPage);
    Bsky_WeakSelf
    [MBProgressHUD showHud];
    [self.doctorRequest startWithCompletionBlockWithSuccess:^(__kindof ResponsibilityDoctorRequest * _Nonnull request) {
        Bsky_StrongSelf
        [MBProgressHUD hideHud];
        if (request.dataList.count < request.pageSize.integerValue ) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.currentPage == 1) {
            [self.dataList removeAllObjects];
        }
        [self.dataList addObjectsFromArray:request.dataList];
        [self.tableView reloadData];

    } failure:^(__kindof ResponsibilityDoctorRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
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
    UITableViewCell *cell = nil;
    FollowupDoctorModel *model = self.dataList[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:[FollowupResponsibilityDoctorCell cellIdentifier] forIndexPath:indexPath];
    FollowupResponsibilityDoctorCell *tableCell = (FollowupResponsibilityDoctorCell *)cell;
    tableCell.doctorModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowupDoctorModel *model = self.dataList[indexPath.row];
    if (self.didSelectBlock) {
        self.didSelectBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark --- Click Methods

- (void)searchBtnPressed {
    
    [self.view endEditing:YES];
    self.currentPage = 0;
    [self.tableView.mj_footer beginRefreshing];
}

#pragma mark - UI Get

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
        _searchView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        self.textField = [[BSTextField alloc]initWithFrame:CGRectMake(15, 12, _searchView.width-80, 35)];
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField .layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        self.textField.layer.borderWidth = 1.0;
        [self.textField setCornerRadius:5];
        self.textField.placeholder = @"请输入医生姓名精确查找";
        self.textField.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        self.textField.textColor = UIColorFromRGB(0x333333);
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeySearch;
        self.textField.rightViewMode = UITextFieldViewModeNever;
        self.textField.maxNum = 20;
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"diabetes_search_icon"];
        searchIcon.contentMode = UIViewContentModeCenter;
        [searchIcon sizeToFit];
        searchIcon.frame = CGRectMake(0, 0, searchIcon.width+20, self.textField .height);
        self.textField .leftView = searchIcon;
        self.textField .leftViewMode = UITextFieldViewModeAlways;
        [_searchView addSubview:self.textField ];
        
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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchView.bottom, self.view.width, self.view.height - self.searchView.bottom-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[FollowupResponsibilityDoctorCell nib] forCellReuseIdentifier:[FollowupResponsibilityDoctorCell cellIdentifier]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
        Bsky_WeakSelf
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            Bsky_StrongSelf
            self.currentPage++;
            [self loadDoctorData];
        }];
    }
    return _tableView;
}

#pragma mark --- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchBtnPressed];
    return YES;
}

@end
