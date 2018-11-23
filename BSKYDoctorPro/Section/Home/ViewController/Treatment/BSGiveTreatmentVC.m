//
//  BSGiveTreatmentVC.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/9/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSGiveTreatmentVC.h"
#import "BSGiveTreatmentCell.h"
#import "BSTreatmentRequest.h"
#import "BSStreatmentModel.h"

@interface BSGiveTreatmentVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger index;

@end

@implementation BSGiveTreatmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.title = @"诊疗记录";
    self.dataArr = [NSMutableArray array];
    
    self.index = 0;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    WS(weakSelf);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.index++;
        [weakSelf requestToInfo];
    }];
    [self.tableView.mj_footer beginRefreshing];
}

- (void)requestToInfo {
    BSTreatmentRequest *request = [[BSTreatmentRequest alloc] init];
    request.pageIndex = @(self.index);
    WS(weakSelf);
    [MBProgressHUD showHud];
    [request startWithCompletionBlockWithSuccess:^(__kindof BSTreatmentRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        if (request.dataList.count != 0) {
            [weakSelf.tableView.mj_footer endRefreshing];
            if (weakSelf.index <= 1) {
                [weakSelf.dataArr removeAllObjects];
            }
            [weakSelf.dataArr addObjectsFromArray:request.dataList];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(__kindof BSTreatmentRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSGiveTreatmentCell *cell = [tableView dequeueReusableCellWithIdentifier:[BSGiveTreatmentCell cellIdentifier] forIndexPath:indexPath];
    if (self.dataArr.count != 0) {
        cell.model = (BSStreatmentModel *)self.dataArr[indexPath.row];
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
        _tableView.estimatedRowHeight = 140;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[BSGiveTreatmentCell nib] forCellReuseIdentifier:[BSGiveTreatmentCell cellIdentifier]];
    }
    return _tableView;
}

@end
