//
//  ZLSearchPersonalVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLSearchPersonalVC.h"
#import "DiabetesTableViewCell.h"
#import "ZLFollowupFormVC.h"
#import "ZLSearchPersonalRequest.h"
#import <YYCategories/NSDate+YYAdd.h>
#import "FollowupAllFormVC.h"
#import "ScanViewController.h"
#import "HealthScanRequest.h"

@interface ZLSearchPersonalVC ()<UITableViewDataSource ,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UIView   *footerView;

@property (nonatomic ,strong) UIView *searchView;

@property (nonatomic ,strong) UITextField *textField;

@property (nonatomic ,strong) ZLSearchPersonalRequest *request;

@property (nonatomic ,strong) NSMutableArray *dataList;
@property (nonatomic ,assign) NSUInteger currentPage;

@property (nonatomic, strong) HealthScanRequest *scanRequest;

@end

@implementation ZLSearchPersonalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        case FollowupTypeGaoTang:
            self.title = @"高糖合并随访";
            break;
        default:
            break;
    }
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.view addSubview:self.searchView];
    self.dataList = [NSMutableArray array];
    self.currentPage = 0;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchView.bottom, self.view.width, self.view.height - self.searchView.bottom-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.tableView registerNib:[DiabetesTableViewCell nib] forCellReuseIdentifier:[DiabetesTableViewCell cellIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
    [self setRefreshFooterView];
}
- (void)setRefreshFooterView
{
    @weakify(self);
    MJRefreshAutoGifFooter *footerView = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
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

#pragma mark -

- (void)loadData {
    if (!self.request) {
        self.request = [ZLSearchPersonalRequest new];
    }
    self.currentPage++;
    self.request.personalParam = self.textField.text;
    self.request.pageIndex = [NSString stringWithFormat:@"%lu",(unsigned long)self.currentPage];
    self.request.pageSize = @"10";
    [MBProgressHUD showHud];
    @weakify(self);
    [self.request startWithCompletionBlockWithSuccess:^(ZLSearchPersonalRequest* request) {
        [MBProgressHUD hideHud];
        @strongify(self);
        self.tableView.mj_footer.hidden = NO;
        if (request.dataList.count < request.pageSize.integerValue ) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.currentPage == 1) {
            [self.dataList removeAllObjects];
        }
        [self.dataList addObjectsFromArray:self.request.dataList];
        [self.tableView reloadData];
        
    } failure:^(ZLSearchPersonalRequest* request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
    }];
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
    self.currentPage = 0;
    return YES;
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiabetesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DiabetesTableViewCell cellIdentifier]];
    cell.zlModel = self.dataList[indexPath.section];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!self.footerView) {
        self.footerView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self.footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.section >= self.dataList.count) {  // 崩溃信息处理
        return;
    }
    ZLSearchPersonalModel *model = self.dataList[indexPath.section];
    BSFollowup *followupPlan = [self configFollowupPlanModelWithFollowupUserSearchModel:model];
    ZLFollowupFormVC *vc = [[ZLFollowupFormVC alloc]init];
    vc.planModel = followupPlan;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (BSFollowup *)configFollowupPlanModelWithFollowupUserSearchModel:(ZLSearchPersonalModel*)model {
    
    BSFollowup *followupPlan = [[BSFollowup alloc]init];
    switch (self.type) {
        case FollowupTypeHypertension:
            followupPlan.followUpType = @"06002001";
            break;
        case FollowupTypeDiabetes:
            followupPlan.followUpType = @"06002002";
            break;
        case FollowupTypeGaoTang:
            followupPlan.followUpType = @"06002003";
            break;
        default:
            break;
    }
    followupPlan.age = model.age;
    followupPlan.followDate = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    followupPlan.gwUserId = model.idField;
    followupPlan.phone = model.tel;
    followupPlan.sex = model.gender;
    followupPlan.status = @"06001001";
    followupPlan.address = model.address;
    followupPlan.username = model.name;
    followupPlan.userIdCard = model.cardId;
    followupPlan.lastFollowDate = [[NSDate date]stringWithFormat:@"yyyy-MM-dd"];
    
    return followupPlan;
}

#pragma mark - UI Get

- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
        _searchView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 12, _searchView.width-80, 35)];
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField .layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        self.textField.layer.borderWidth = 1.0;
        [self.textField setCornerRadius:5];
        self.textField.placeholder = @"请输入居民姓名、身份证号";
        self.textField.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        self.textField.textColor = UIColorFromRGB(0x333333);
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeySearch;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;  // 取消自动纠错
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification" object:self.textField];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"diabetes_search_icon"];
        searchIcon.contentMode = UIViewContentModeCenter;
        [searchIcon sizeToFit];
        searchIcon.frame = CGRectMake(0, 0, searchIcon.width+20, self.textField .height);
        self.textField .leftView = searchIcon;
        self.textField .leftViewMode = UITextFieldViewModeAlways;
        [_searchView addSubview:self.textField ];
        
        UIButton* saoButton = [UIButton new];
        [saoButton setImage:[UIImage imageNamed:@"scan_ico"] forState:UIControlStateNormal];
        saoButton.imageView.contentMode = UIViewContentModeCenter;
        [saoButton sizeToFit];
        saoButton.width = saoButton.width+20;
        [saoButton addTarget:self action:@selector(onSao:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)onSao:(id)sender {
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    Bsky_WeakSelf
    scanVC.block = ^(ScanViewController *vc, NSString *scanCode) {
        Bsky_StrongSelf
        [vc.navigationController popViewControllerAnimated:YES];
        [self getQRCodeInfoWithStr:scanCode];
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}

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
        //高血压随访0300701，糖尿病随访030070 ，高糖随访030070
        self.scanRequest.businessType = self.type == FollowupTypeHypertension ? ScanBusinessEHVisitType : ScanBusinessDMVisitType;
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
             [MBProgressHUD hideHud];
             [UIView makeToast:self.scanRequest.msg];
         }];
    }
}
- (void)searchBtnPressed {
    if ([self checkInfo]) {
        [self.tableView.mj_footer beginRefreshing];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self checkInfo]) {
        [self.tableView.mj_footer beginRefreshing];
    }
    return YES;
}

-(void)textFieldEditChanged:(NSNotification *)obj {
    if (obj.object != self.textField) {
        return;
    }
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 20) {
                textField.text = [toBeString substringToIndex:20];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况   else{
    if (toBeString.length > 20) {
        textField.text = [toBeString substringToIndex:20];
    }
}
@end
