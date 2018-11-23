//
//  InStationMessageViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/8.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSInStationMsgViewController.h"
#import "IncomeMsgTableViewCell.h"
#import "SystemMsgTableViewCell.h"
#import "BSTotalMessageRequest.h"
#import "BSMsgDetailViewController.h"
#import "BSDeleteMessageRequest.h"

@interface BSInStationMsgViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *totalArr;
@property (nonatomic, strong) BSTotalMessageRequest   *totalRequest;
@property (nonatomic, strong) BSDeleteMessageRequest  *deleteRequest;

@property (nonatomic, assign) NSInteger numMsg;

@end

@implementation BSInStationMsgViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)initData {
    self.title = @"站内信";
    self.totalRequest = [[BSTotalMessageRequest alloc] init];
    self.deleteRequest = [[BSDeleteMessageRequest alloc] init];
    Bsky_WeakSelf
    [self.totalRequest startWithCompletionBlockWithSuccess:^(__kindof BSTotalMessageRequest * _Nonnull request) {
        Bsky_StrongSelf
        self.totalArr = [NSMutableArray arrayWithArray:self.totalRequest.msgArrData];
        self.numMsg = [self.totalRequest.num integerValue];
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull BSTotalMessageRequest) {
    }];
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
        [tableView registerNib:[IncomeMsgTableViewCell nib] forCellReuseIdentifier:[IncomeMsgTableViewCell cellIdentifier]];
        [tableView registerNib:[SystemMsgTableViewCell nib] forCellReuseIdentifier:[SystemMsgTableViewCell cellIdentifier]];

        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    });
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)deleteMsgWithType:(NSString *)type {
    self.deleteRequest.type = type;
    [self.deleteRequest startWithCompletionBlockWithSuccess:^(__kindof BSDeleteMessageRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    } failure:^(__kindof BSDeleteMessageRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (self.totalArr.count == 0) {
        return cell;
    }
    BSMessageModel *model = (BSMessageModel *)self.totalArr[indexPath.row];
    if ([model.type isEqualToString:kMessageSystemType]) {
        cell = [tableView dequeueReusableCellWithIdentifier:[SystemMsgTableViewCell cellIdentifier]];
        [(SystemMsgTableViewCell *)cell setMsgNumber:[NSString stringWithFormat:@"%@",model.total] Time:model.publishDate];
    } else if ([model.type isEqualToString:kMessageIncomeType]) {
        cell = [tableView dequeueReusableCellWithIdentifier:[IncomeMsgTableViewCell cellIdentifier]];
        [(IncomeMsgTableViewCell *)cell setMsgNumber:[NSString stringWithFormat:@"%@",model.total] Time:model.publishDate];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BSMsgDetailViewController *msg_detail = [[BSMsgDetailViewController alloc] init];
    BSMessageModel *model = self.totalArr[indexPath.row];
    if ([model.type isEqualToString:kMessageIncomeType]) {
        msg_detail.type = kMessageIncomeType;
        self.numMsg -= [model.total integerValue];
        model.total = @(0);
        msg_detail.title = @"收入消息";
        [self.navigationController pushViewController:msg_detail animated:YES];
    } else {
        msg_detail.type = kMessageSystemType;
        self.numMsg -= [model.total integerValue];
        model.total = @(0);
        msg_detail.title = @"系统消息";
        [self.navigationController pushViewController:msg_detail animated:YES];
    }
    if (self.block) {
        self.block(self.numMsg);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        BSMessageModel *model = weakSelf.totalArr[indexPath.row];
        [weakSelf deleteMsgWithType:model.type];
        [weakSelf.totalArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

@end
