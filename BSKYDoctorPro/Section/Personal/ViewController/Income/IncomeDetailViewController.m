//
//  IncomeDetailViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IncomeDetailViewController.h"
#import "IncomeDetailTableViewCell.h"
#import "BSBankIncomeDetailRequest.h"
#import "BSBankIncomeDetailModel.h"

@interface IncomeDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *detailData;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) BSBankIncomeDetailRequest *detailRequest;

@end

@implementation IncomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    self.title = @"收入明细";
    self.currentPage = 0;
    self.detailData = [NSMutableArray array];
    self.detailRequest = [[BSBankIncomeDetailRequest alloc] init];
}

- (void)initView {
    self.tableView = ({
        UITableView* tableView = [UITableView new];
        tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self.view addSubview:tableView];
        tableView.estimatedRowHeight = 70;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorColor = UIColorFromRGB(0xededed);
        tableView.tableFooterView = [UIView new];
        [tableView registerNib:[IncomeDetailTableViewCell nib] forCellReuseIdentifier:[IncomeDetailTableViewCell cellIdentifier]];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    });
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    Bsky_WeakSelf
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        Bsky_StrongSelf;
        self.currentPage++;
        [self loadData];
    }];
    [self.tableView.mj_footer beginRefreshing];
}

- (void)loadData {
    WS(weakSelf);
    self.detailRequest.pageNo = @(self.currentPage);
    [self.detailRequest startWithCompletionBlockWithSuccess:^(__kindof BSBankIncomeDetailRequest * _Nonnull request) {
        if (weakSelf.detailRequest.incomeDetailData.count != 0) {
            if (weakSelf.detailRequest.incomeDetailData.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            if (weakSelf.currentPage <= 1) {
                [self.detailData removeAllObjects];
            }
            [self.detailData addObjectsFromArray:weakSelf.detailRequest.incomeDetailData];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(__kindof BSBankIncomeDetailRequest * _Nonnull request) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (self.detailData.count == 0) return cell;
    cell = [tableView dequeueReusableCellWithIdentifier:[IncomeDetailTableViewCell cellIdentifier]];
    [(IncomeDetailTableViewCell *)cell updateCellData:(BSBankIncomeDetailModel *)self.detailData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        BSMsgDetailViewController *msg_detail = [[BSMsgDetailViewController alloc] init];
//        [self.navigationController pushViewController:msg_detail animated:YES];
//    }
}


@end
