//
//  IMSearchResultVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/5/14.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMSearchResultVC.h"
#import "IMSearchSectionCell.h"
#import "BSContactCell.h"
#import "IMSearchMoreCell.h"
#import "NTESSessionViewController.h"
#import "IMDetailController.h"
#import "NIMNormalTeamCardViewController.h"

@interface IMSearchResultVC ()<UITableViewDelegate,UITableViewDataSource,BSContactCellDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * array;

@property (nonatomic, copy) NSString * searchStr;

@property (nonatomic ,strong) UIView *footerView;

@end

@implementation IMSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [NSMutableArray array];
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.view addSubview:self.tableView];
}
- (void)refreshData:(NSMutableArray *)array searchStr:(NSString *)searchStr
{
    [self.array removeAllObjects];
    [self.array addObjectsFromArray:array];
    self.searchStr = searchStr;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *array = self.array[section];
//    if (array.count > 3) {
//        return 5;
//    }
//    else
    if (array.count > 0)
    {
       return array.count+1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:[IMSearchSectionCell cellIdentifier] forIndexPath:indexPath];
        IMSearchSectionCell *tableCell = (IMSearchSectionCell *)cell;
        tableCell.titleLabel.text = indexPath.section == 0 ? @"联系人" : @"讨论组";
    }
    else if (indexPath.row > 0)
    {
        NSMutableArray *array = self.array[indexPath.section];
        cell = [tableView dequeueReusableCellWithIdentifier:[BSContactCell cellIdentifier] forIndexPath:indexPath];
        BSContactCell *tableCell = (BSContactCell *)cell;
        if (indexPath.section == 0) {
            tableCell.user = (NIMUser *)array[indexPath.row -1];
        }
        else if (indexPath.section == 1)
        {
            tableCell.team = (NIMTeam *)array[indexPath.row -1];
        }
        tableCell.delegate = self;
    }
//    else if (indexPath.row == 4)
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:[IMSearchMoreCell cellIdentifier] forIndexPath:indexPath];
//        IMSearchMoreCell *tableCell = (IMSearchMoreCell *)cell;
//        tableCell.titleLabel.text = indexPath.section == 0 ? @"查看更多联系人" : @"查看更多讨论组";
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.footerView) {
        self.footerView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self.footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSMutableArray *array = self.array[section];
    if ([array isNotEmptyArray]) {
        return 10;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0)
    {
        NSMutableArray *array = self.array[indexPath.section];
        NIMSession *session = nil;
        if (indexPath.section == 0) {
            NIMUser *user = array[indexPath.row - 1];
            session = [NIMSession session:user.userId type:NIMSessionTypeP2P];
        }
        else if (indexPath.section == 1)
        {
            NIMTeam *team = array[indexPath.row - 1];
            session = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
        }
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        [self.presentingViewController.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark ---- BSContactCellDelegate
- (void)bsContactCell:(BSContactCell *)cell onPressAvatar:(NSString *)memberId
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        IMDetailController *vc = [[IMDetailController alloc] initWithUser:memberId];
        [self.presentingViewController.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1)
    {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:memberId];
        NIMNormalTeamCardViewController *vc = [[NIMNormalTeamCardViewController alloc] initWithTeam:team];
        [self.presentingViewController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --- Setter Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[IMSearchSectionCell nib] forCellReuseIdentifier:[IMSearchSectionCell cellIdentifier]];
        [_tableView registerNib:[BSContactCell nib] forCellReuseIdentifier:[BSContactCell cellIdentifier]];
        [_tableView registerNib:[IMSearchMoreCell nib] forCellReuseIdentifier:[IMSearchMoreCell cellIdentifier]];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

@end
