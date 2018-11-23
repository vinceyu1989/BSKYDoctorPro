//
//  BSMsgDetailViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/8.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSMsgDetailViewController.h"
#import "MyIncomeViewController.h"
#import "MsgTimeTableViewCell.h"
#import "MsgContentTableViewCell.h"
#import "SystemContentTableViewCell.h"
#import "BSListMessageRequest.h"
#import "BSMessageClearReadRequest.h"
#import "BSMessageModel.h"
#import "BSFollowupListViewController.h"

@interface BSMsgDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger       currentPage;

@property (nonatomic, strong) BSListMessageRequest      *listMsgRequest;
@property (nonatomic, strong) BSMessageClearReadRequest *clearReadRequest;

@end

@implementation BSMsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self updateReadMsg];
}

- (void)initData {
    self.listMsgRequest = [[BSListMessageRequest  alloc] init];
    self.clearReadRequest = [[BSMessageClearReadRequest alloc] init];
    self.listMsgRequest.type = self.type;
    self.clearReadRequest.type = self.type;
    self.dataSource = [NSMutableArray array];
    self.currentPage = 0;
}

- (void)initView {
    self.tableView = ({
        UITableView* tableView = [UITableView new];
        tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self.view addSubview:tableView];
        tableView.estimatedRowHeight = 75;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        [tableView registerNib:[MsgTimeTableViewCell nib] forCellReuseIdentifier:[MsgTimeTableViewCell cellIdentifier]];
        [tableView registerNib:[MsgContentTableViewCell nib] forCellReuseIdentifier:[MsgContentTableViewCell cellIdentifier]];
        [tableView registerNib:[SystemContentTableViewCell nib] forCellReuseIdentifier:[SystemContentTableViewCell cellIdentifier]];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    });
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(-5);
        make.left.right.bottom.equalTo(self.view);
    }];
    Bsky_WeakSelf
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        Bsky_StrongSelf;
        self.currentPage++;
        [self loadData];
    }];
    [self.tableView.mj_footer beginRefreshing];
}

#pragma mark - private mothod
- (void)setType:(NSString *)type {
    _type = type;
}

- (void)loadData {
    WS(weakSelf);
    self.listMsgRequest.pageNo = @(self.currentPage);
    [self.listMsgRequest startWithCompletionBlockWithSuccess:^(__kindof BSListMessageRequest * _Nonnull request) {
        if (weakSelf.listMsgRequest.msgListData.count != 0) {
            if (weakSelf.listMsgRequest.msgListData.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
            if (weakSelf.currentPage <= 1) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:weakSelf.listMsgRequest.msgListData];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(__kindof BSListMessageRequest * _Nonnull request) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
//*<更新已读消息 >/
- (void)updateReadMsg {
    [self.clearReadRequest startWithCompletionBlockWithSuccess:^(__kindof BSMessageClearReadRequest * _Nonnull request) {
    } failure:^(__kindof BSMessageClearReadRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (self.dataSource == 0) return cell;
    BSMessageModel *model = self.dataSource[indexPath.section];
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:[MsgTimeTableViewCell cellIdentifier]];
        [(MsgTimeTableViewCell *)cell setMsgTimeInfo:model.publishDate];
    } else {
        if ([_type isEqualToString:kMessageIncomeType]) {
            cell = [tableView dequeueReusableCellWithIdentifier:[MsgContentTableViewCell cellIdentifier]];
            [(MsgContentTableViewCell *)cell setContentStr:model.newsContent];
            Bsky_WeakSelf
            [(MsgContentTableViewCell *)cell setBlock:^{//跳转我的收入页面
                Bsky_StrongSelf
                MyIncomeViewController *income_vc = [[MyIncomeViewController alloc] init];
                [self.navigationController pushViewController:income_vc animated:YES];
            }];
        } else if ([_type isEqualToString:kMessageSystemType]){
            cell = [tableView dequeueReusableCellWithIdentifier:[SystemContentTableViewCell cellIdentifier]];
             [(SystemContentTableViewCell *)cell setContentStr:model.newsContent];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1 && [_type isEqualToString:kMessageSystemType]) {
        BSFollowupListViewController *vc = [[BSFollowupListViewController alloc]init];
        vc.date = [NSDate date];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
