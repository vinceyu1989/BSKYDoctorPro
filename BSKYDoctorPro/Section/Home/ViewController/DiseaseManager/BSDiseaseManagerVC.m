//
//  BSDiseaseManagerVC.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/8/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSDiseaseManagerVC.h"
#import "EBDropdownListView.h"
#import "BSDiseaseInfoCell.h"
#import "BSDiseaseListRequest.h"
#import "FolloupHistoryVC.h"
#import "BSShareViewController.h"
#import "DiseaseCreatVC.h"

@interface BSDiseaseManagerVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) EBDropdownListView   *downView;
@property (nonatomic, strong) UITextField   *searchTextField;
@property (nonatomic, strong) UIButton      *searchBtn;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, assign) NSInteger     infoIndex;
@property (nonatomic, strong) NSString      *buildTypeStr;
@property (nonatomic, strong) NSMutableArray*listDataArr;
@property (nonatomic, strong) BSDiseaseListRequest *request;
@property (nonatomic ,strong) UIBarButtonItem *saveBtn;
@property (nonatomic ,strong) BSShareViewController *shareVC;
@end

@implementation BSDiseaseManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    self.title = @"慢病名册";
    self.infoIndex = 0;
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.request = [[BSDiseaseListRequest alloc] init];
    self.listDataArr = [NSMutableArray array];
    self.request.regionID = [BSAppManager sharedInstance].currentUser.divisionCode;
    self.request.pageSize = @(10);
    self.buildTypeStr = @"高血压";
}

- (void)initView {
    
    self.navigationItem.rightBarButtonItem = self.saveBtn;
    
    self.downView = [[EBDropdownListView alloc] initWithDataSource:@[@"高血压",@"糖尿病",@"精神病",@"结核病",@"COPD"]];
    self.downView.backgroundColor = [UIColor whiteColor];
    self.downView.frame = CGRectMake(10, 10, 100, 35);
    self.downView.selectedIndex = 0;
    [self.downView setViewBorder:0.5 borderColor:[UIColor whiteColor] cornerRadius:5];
    WS(weakSelf);
    [self.downView setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView, NSString *selectStr) {
        weakSelf.buildTypeStr = selectStr;
    }];
    [self.view addSubview:self.downView];
    
    self.searchTextField = [[UITextField alloc] init];
    [self.searchTextField setCornerRadius:5];
    self.searchTextField.backgroundColor = UIColorFromRGB(0xffffff);
    self.searchTextField.placeholder = @"请输入居民姓名";
    self.searchTextField.font = [UIFont systemFontOfSize:13];
    self.searchTextField.textColor = UIColorFromRGB(0x333333);
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"icon_search_disease"];
    searchIcon.contentMode = UIViewContentModeCenter;
    [searchIcon sizeToFit];
    searchIcon.frame = CGRectMake(0, 0, searchIcon.width+20, self.searchTextField.height);
    self.searchTextField.leftView = searchIcon;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.searchTextField];
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4e7dd3"]] forState:UIControlStateNormal];
    [self.searchBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#273e69"]] forState:UIControlStateDisabled];
    [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.searchBtn setCornerRadius:5];
    [self.searchBtn addTarget:self action:@selector(onSearchPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBtn];
    
    [self.view addSubview:self.tableView];
    [self addConstrait];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestToInfo];
    }];
    [self.tableView.mj_footer beginRefreshing];
}

- (void)addConstrait {
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@35);
    }];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downView.mas_right).offset(10);
        make.right.equalTo(self.searchBtn.mas_left).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.height.equalTo(@35);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.searchTextField.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - press
- (void)requestToInfo {
    self.infoIndex++;
    self.request.buildType = self.buildTypeStr;
    self.request.pageIndex = @(self.infoIndex);
    self.request.keyValue = [self.searchTextField.text isNotEmptyString] ? self.searchTextField.text : @"";
    WS(weakSelf);
    [MBProgressHUD showHud];
    [self.request startWithCompletionBlockWithSuccess:^(__kindof BSDiseaseListRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        if (request.listData.count != 0) {
            [weakSelf.tableView.mj_footer endRefreshing];
            if (weakSelf.infoIndex <= 1) {
                [weakSelf.listDataArr removeAllObjects];
            }
            [weakSelf.listDataArr addObjectsFromArray:request.listData];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(__kindof BSDiseaseListRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
- (void)pushShareVC{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"新增" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    Bsky_WeakSelf;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"高血压" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Bsky_StrongSelf;
        DiseaseCreatVC *diseaseVC = [[DiseaseCreatVC alloc] init];
        diseaseVC.type = DiseaseArchivesCreateTypeGXY;
        [self.navigationController pushViewController:diseaseVC animated:YES];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [vc addAction:action3];
//    [vc addAction:action2];
//    [vc addAction:action1];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)onSearchPressed {
    [self.searchTextField resignFirstResponder];
    self.infoIndex = 0;
    [self.tableView.mj_footer beginRefreshing];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField resignFirstResponder];
    self.infoIndex = 0;
    [self.tableView.mj_footer beginRefreshing];
    return YES;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSDiseaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[BSDiseaseInfoCell cellIdentifier] forIndexPath:indexPath];
    if (self.listDataArr.count != 0) {
        cell.model = self.listDataArr[indexPath.row];
        WS(weakSelf);
        [cell setBlock:^(BSDiseaseInfoModel *model, NSString *type) {
            if ([type isEqualToString:@"电话"]) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.Telphone];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [weakSelf.view addSubview:callWebview];
            } else {
                FolloupHistoryVC *vc = [FolloupHistoryVC new];
                if ([weakSelf.buildTypeStr isEqualToString:@"高血压"]) {
                    vc.type = FollowupTypeHypertension;
                } else if ([weakSelf.buildTypeStr isEqualToString:@"糖尿病"]) {
                    vc.type = FollowupTypeDiabetes;
                } else {
                    [UIView makeToast:@"该病暂无随访记录"];
                    return ;
                }
                vc.personId = model.PERSON_ID;
                vc.personName = model.NAME;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return cell;
}

#pragma mark - setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _tableView.estimatedRowHeight = 180;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[BSDiseaseInfoCell nib] forCellReuseIdentifier:[BSDiseaseInfoCell cellIdentifier]];
    }
    return _tableView;
}
- (UIBarButtonItem *)saveBtn{
    if (!_saveBtn) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.backgroundColor = [UIColor clearColor];
        rightButton.frame = CGRectMake(0, 0, 100, 40);
        [rightButton setTitle:@"+添加名册" forState:UIControlStateNormal];
        [rightButton setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
        rightButton.tintColor = [UIColor clearColor];
        rightButton.autoresizesSubviews = YES;
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        rightButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        [rightButton addTarget:self action:@selector(pushShareVC) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return _saveBtn;
    
    
    
}
- (BSShareViewController *)shareVC{
    if (!_shareVC) {
        _shareVC = [[BSShareViewController alloc] init];
//        [_shareVC.view setFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        Bsky_WeakSelf;
        _shareVC.block = ^{
            Bsky_StrongSelf;
//            [self.shareVC.view removeFromSuperview];
        };
    }
    return _shareVC;
}
@end
