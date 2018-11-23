//
//  BSEduTeachModelVC.m
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSEduTeachModelVC.h"
#import "BSEducationModelCell.h"
#import "BSEduHealthModelRequest.h"

@interface BSEduTeachModelVC () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView   *footerView;
@property (nonatomic ,strong) UIView *searchView;
@property (nonatomic ,strong) UITextField *textField;

@property (nonatomic ,strong) NSMutableArray *dataList;
@property (nonatomic ,assign) NSUInteger currentPage;
@property (nonatomic, strong) BSEduHealthModelRequest *contentRequest;

@end

@implementation BSEduTeachModelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    self.dataList = [NSMutableArray array];
    self.currentPage = 0;
    self.contentRequest = [[BSEduHealthModelRequest alloc] init];
}

- (void)initView {
    [self addRightView];
    self.navigationItem.titleView = self.searchView;
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, self.view.width, self.view.height-TOP_BAR_HEIGHT-SafeAreaBottomHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.tableView registerNib:[BSEducationModelCell nib] forCellReuseIdentifier:[BSEducationModelCell cellIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
    [self setRefreshFooterView];
    [self.tableView.mj_footer beginRefreshing];
}

- (void)setRefreshFooterView {
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
    self.tableView.mj_footer = footerView;
    self.tableView.mj_footer.hidden = YES;
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

#pragma mark - private

- (void)loadData {
    self.currentPage++;
    self.contentRequest.title = self.textField.text;
    self.contentRequest.pageIndex = @(self.currentPage);
    self.tableView.mj_footer.hidden = NO;
    Bsky_WeakSelf
    [MBProgressHUD showHud];
    [self.contentRequest startWithCompletionBlockWithSuccess:^(__kindof BSEduHealthModelRequest * _Nonnull request) {
        Bsky_StrongSelf
        [MBProgressHUD hideHud];
        if (request.healthModelData.count < request.pageSize.integerValue ) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.currentPage == 1) {
            [self.dataList removeAllObjects];
        }
        [self.dataList addObjectsFromArray:request.healthModelData];
        [self.tableView reloadData];
    } failure:^(__kindof BSEduHealthModelRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}

- (void)searchBtnPressed {
    if ([self checkInfo]) {
        [self.tableView.mj_footer beginRefreshing];
    }
}

- (BOOL)checkInfo {
    if (self.textField.text.length == 0) {
        [UIView makeToast:@"搜索内容不能为空~"];
        return NO;
    }
    [self.textField resignFirstResponder];
    self.currentPage = 0;
    return YES;
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSEducationModelCell *cell = [tableView dequeueReusableCellWithIdentifier:[BSEducationModelCell cellIdentifier]];
    cell.model = (BSEduHealthContentModel *)self.dataList[indexPath.section];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!self.footerView) {
        self.footerView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self.footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section >= self.dataList.count) {  // 崩溃信息处理
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.block) {
        self.block((BSEduHealthContentModel *)self.dataList[indexPath.section]);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UI Get

- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-130*SCREEN_WIDTH/375.f, NAVIGATION_BAR_HEIGHT)];
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, _searchView.width, 35)];
        self.textField.centerY = _searchView.height/2;
        [self.textField setCornerRadius:5];
        self.textField.backgroundColor = UIColorFromRGB(0xf0f2f5);
        self.textField.placeholder = @"请输入模板标题名称关键字";
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
        [_searchView addSubview:self.textField];
    }
    return _searchView;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self checkInfo]) {
        [self.tableView.mj_footer beginRefreshing];
    }
    return YES;
}

@end
