//
//  IMAddFriendsViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/5/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMAddFriendsViewController.h"
#import "BSContactCell.h"
#import "BSGetFriendsListRequest.h"
#import "IMFriendInfoModel.h"
#import "IMDetailController.h"

@interface IMAddFriendsViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    CGFloat _fitWidth;
}

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton    *searchButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger   currentPage;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) BSGetFriendsListRequest *searchRequest;
@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UILabel *emptyLabel;
@end

@implementation IMAddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    self.title = @"添加好友";
    self.currentPage = 0;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _fitWidth = SCREEN_WIDTH/375.f;
    self.tableData = [NSMutableArray array];
    self.searchRequest = [[BSGetFriendsListRequest alloc] init];
}

- (void)initView {
    
    UIView *textView = [[UIView alloc] init];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.height.equalTo(@45.f);
    }];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *searchImage = [UIImage imageNamed:@"icon_search_gray"];
    [self.searchButton setImage:searchImage forState:UIControlStateNormal];
    [self.searchButton setImage:[UIImage imageNamed:@"icon_search_blue"] forState:UIControlStateDisabled];
    [self.searchButton addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textView.mas_right).offset(-15.f);
        make.centerY.equalTo(textView.mas_centerY);
        make.size.equalTo(@(searchImage.size));
    }];
    
    self.searchTextField = [self setTextFieldWithKeyboardType:UIKeyboardTypeDefault TextAlignment:NSTextAlignmentLeft AttrbuteString:@"请输入姓名\\手机号"];
    self.searchTextField.delegate = self;
    [textView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textView.mas_left).offset(15.f);
        make.right.equalTo(self.searchButton.mas_left).offset(-5.f);
        make.top.equalTo(textView.mas_top);
        make.height.equalTo(@45.f);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.tableView.sectionIndexColor = UIColorFromRGB(0x333333);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = UIColorFromRGB(0xededed);
    self.tableView.estimatedRowHeight = 55;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[BSContactCell nib] forCellReuseIdentifier:@"BSContactCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.searchTextField.mas_bottom).offset(15);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    WS(weakSelf);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf searchRequestMothod];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self isHiddenEmptyImage:YES];
}

- (void)beginSearch {
    [self.searchTextField resignFirstResponder];
    self.currentPage = 1;
    [self.tableData removeAllObjects];
    [self searchRequestMothod];
    self.tableView.mj_footer.hidden = NO;
}

- (void)searchRequestMothod {
    if (self.searchTextField.text.length != 0) {
        NSLog(@"开始搜索");
        self.searchRequest.codeStr = self.searchTextField.text;
        self.searchRequest.pageNo = [NSString stringWithFormat:@"%ld",self.currentPage];
        self.searchRequest.pageSize = @"20";
        [MBProgressHUD showHud];
        Bsky_WeakSelf
        [self.searchRequest startWithCompletionBlockWithSuccess:^(__kindof BSGetFriendsListRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            Bsky_StrongSelf
            if (self.currentPage <= 1) {
                [self.tableData removeAllObjects];
            }
            [self.tableData addObjectsFromArray:request.searchData];
            [self.tableView reloadData];
            [self isHiddenEmptyImage:self.tableData.count > 0];
            if (request.searchData.count < request.pageSize.integerValue) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableData.count == 1) {
                [self pushToPersonalDetailVC:0];
            }
        } failure:^(__kindof BSGetFriendsListRequest * _Nonnull request) {
            [UIView makeToast:request.msg];
            [MBProgressHUD hideHud];
        }];
    } else {
        [UIView makeToast:@"搜索内容不能为空"];
    }
}
- (void)pushToPersonalDetailVC:(NSInteger )index{
    if (index >= self.tableData.count) {
        return;
    }
    IMFriendInfoModel *model = [self.tableData objectAtIndex:index];
    IMDetailController *vc = [[IMDetailController alloc] initWithUser:model.accid];
    vc.friendUser = model;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)isHiddenEmptyImage:(BOOL)hidden {
    self.emptyImageView.hidden = hidden;
    self.emptyLabel.hidden = hidden;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self beginSearch];
    return YES;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSContactCell *cell = [tableView dequeueReusableCellWithIdentifier:[BSContactCell cellIdentifier]];
    if (self.tableData.count != 0) {
        cell.model = (IMFriendInfoModel *)self.tableData[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToPersonalDetailVC:indexPath.row];
}
#pragma mark - Private
//*<统一配置 >/
- (UITextField *)setTextFieldWithKeyboardType:(UIKeyboardType)keyboardType TextAlignment:(NSTextAlignment)textAlignment AttrbuteString:(NSString *)attrbuteString {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:15*_fitWidth];
    textField.attributedPlaceholder = [self setAttrbuteString:attrbuteString];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = keyboardType;
    textField.returnKeyType = UIReturnKeySearch;
    textField.textColor = [UIColor colorWithHexString:@"#000000"];
    textField.textAlignment = textAlignment;
    return textField;
}

- (NSMutableAttributedString *)setAttrbuteString:(NSString *)str {
    NSMutableAttributedString *acountTPlaceholder = [[NSMutableAttributedString alloc]initWithString:str];
    [acountTPlaceholder addAttribute:NSForegroundColorAttributeName
                               value:UIColorFromRGB(0xcccccc)
                               range:NSMakeRange(0, str.length)];
    return acountTPlaceholder;
}

- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_bg"]];
        [_emptyImageView sizeToFit];
        _emptyImageView.bounds = CGRectMake(0, 0, 90, 90);
        _emptyImageView.center = CGPointMake(self.view.width/2, (self.view.height-TOP_BAR_HEIGHT-45.f)/2);
        
        self.emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_emptyImageView.frame)+15.f, self.view.width, 20)];
        self.emptyLabel.text = @"没有查询到相关数据!";
        self.emptyLabel.textAlignment = NSTextAlignmentCenter;
        self.emptyLabel.font = [UIFont systemFontOfSize:15.f];
        self.emptyLabel.textColor = UIColorFromRGB(0xcccccc);
        [self.view addSubview:_emptyImageView];
        [self.view addSubview:self.emptyLabel];
    }
    return _emptyImageView;
}

@end
