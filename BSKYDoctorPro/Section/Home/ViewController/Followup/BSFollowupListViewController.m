//
//  InterviewViewController.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowupListViewController.h"
#import "InterviewTableViewCell.h"
#import "BSFollowupListRequest.h"
#import "FollowupAllFormVC.h"
#import "ZLFollowupFormVC.h"
#import "BSHealthTeachVC.h"

#import "FollowupUpdateDateRequest.h"
#import "FollowupDeleteRequest.h"

@interface BSFollowupListViewController ()<InterviewTableViewCellDelegate>

@property (nonatomic ,strong) BSFollowupListRequest *listRequest;

@property (nonatomic, strong) NSMutableArray *followupList;
@property (nonatomic ,assign) NSInteger currentPage;
@property (nonatomic ,assign) BOOL isDelete;
@property (nonatomic, retain) UIButton *rightButton;

@end

@implementation BSFollowupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.followupList = [NSMutableArray array];
    self.isDelete = NO;
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.currentPage = 0;
    [self.tableView.mj_footer beginRefreshing];
    
}
- (void)initView
{
    self.title = @"随访计划";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.rightButton.enabled = NO;
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.tableView registerNib:[InterviewTableViewCell nib] forCellReuseIdentifier:[InterviewTableViewCell cellIdentifier]];
    self.tableView.estimatedRowHeight = 160;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage++;
        [self loadData];
    }];
}
- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"一键完成" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateDisabled];
        [_rightButton addTarget:self action:@selector(onRightBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton sizeToFit];
    }
    return _rightButton;
}

- (void)updateRightButton{
    self.rightButton.enabled = NO;
    for (BSFollowup* item in self.followupList) {
        if ([item.status isEqualToString:@"06001001"]) {
            self.rightButton.enabled = YES;
            break;
        }
    }
}

#pragma mark -

- (void)loadData {
    if (!self.listRequest) {
        self.listRequest = [[BSFollowupListRequest alloc]init];
        self.listRequest.pageSize = @"10";
        NSString* dateString = [[NSDateFormatter eventDateFormatter] stringFromDate:self.date];
        self.listRequest.followDate = dateString;
    }
    self.listRequest.pageNo = [NSString stringWithFormat:@"%ld",(long)self.currentPage];
    Bsky_WeakSelf
    [self.listRequest startWithCompletionBlockWithSuccess:^(BSFollowupListRequest* request) {
        Bsky_StrongSelf
        if (request.followupList.count < request.pageSize.integerValue) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.isDelete) {
            if (request.followupList.count == request.pageSize.integerValue) {
                [self.followupList addObject:request.followupList.lastObject];
            }
            self.isDelete = NO;
        }
        else
        {
            if (self.currentPage == 1) {
                [self.followupList removeAllObjects];
            }
            [self.followupList addObjectsFromArray:request.followupList];
            [self updateRightButton];
            [self.tableView reloadData];
        }
        
    } failure:^(BSFollowupListRequest* request) {
        Bsky_StrongSelf
        [self.tableView.mj_footer endRefreshing];
        [UIView makeToast:request.msg];
    }];
}

#pragma mark - UI Actions

- (void)onRightBarButtonItem:(id)sender {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"一键完成随访?" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    WS(weakSelf);
    NSString* dateString = [[NSDateFormatter eventDateFormatter] stringFromDate:self.date];
    [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger index) {
        if (index == 1) {
            BSFollowupStatusRequest* request = [BSFollowupStatusRequest new];
            request.date = dateString;
            [MBProgressHUD showHud];
            
            [request startWithCompletionBlockWithSuccess:^(BSFollowupStatusRequest* request) {
                [weakSelf loadData];
                [UIView makeToast:request.msg];
                [MBProgressHUD hideHud];
            } failure:^(BSFollowupStatusRequest* request) {
                [UIView makeToast:request.msg];
                [MBProgressHUD hideHud];
            }];
        }
    }];
    [alert show];
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.followupList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InterviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[InterviewTableViewCell cellIdentifier]];
    if (!cell.delegate) {
        cell.delegate = self;
    }
    cell.followup = self.followupList[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = ({
        UIView* view = [UIView new];
        view.backgroundColor = UIColorFromRGB(0xf7f7f7);
        view;
    });
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark ---- InterviewTableViewCellDelegate

- (void)interviewTableViewCell:(InterviewTableViewCell *)cell clickPhoneNum:(NSString *)phoneNum
{
    NSString *telStr = [NSString stringWithFormat:@"tel://%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}

-(void)interviewTableViewCellDelete:(InterviewTableViewCell *)cell
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否确认删除本条随访计划？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setCompletionBlock:^(UIAlertView *alertView, NSInteger index) {
        if (index == 1) {
            FollowupDeleteRequest *deleteRequest = [[FollowupDeleteRequest alloc]init];
            deleteRequest.planId = [NSString stringWithFormat:@"%@",cell.followup.planId];
            Bsky_WeakSelf
            [MBProgressHUD showHud];
            [deleteRequest startWithCompletionBlockWithSuccess:^(__kindof FollowupDeleteRequest * _Nonnull request) {
                Bsky_StrongSelf
                [MBProgressHUD hideHud];
                [self.followupList removeObject:cell.followup];
                if (self.followupList.count < 1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:indexPath.section];
                    [self.tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationLeft];
                    [self updateRightButton];
                    self.currentPage --;
                    self.isDelete = YES;
                    [self.tableView.mj_footer beginRefreshing];
                }
                
            } failure:^(__kindof FollowupDeleteRequest * _Nonnull request) {
                [MBProgressHUD hideHud];
                [UIView makeToast:request.msg];
            }];
        }
    }];
    [alertView show];
   
}
- (void)interviewTableViewCellModify:(InterviewTableViewCell *)cell dateStr:(NSString *)dateStr
{
    FollowupUpdateDateRequest *updateRequest = [[FollowupUpdateDateRequest alloc]init];
    updateRequest.followdate = dateStr;
    updateRequest.planId = [NSString stringWithFormat:@"%@",cell.followup.planId];
    [MBProgressHUD showHud];
    @weakify(self);
    [updateRequest startWithCompletionBlockWithSuccess:^(__kindof FollowupUpdateDateRequest * _Nonnull request) {
        @strongify(self);
        [MBProgressHUD hideHud];
        cell.followup.followDate = dateStr;
        [self.followupList removeObject:cell.followup];
        if (self.followupList.count < 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self updateRightButton];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSIndexSet *sections = [NSIndexSet indexSetWithIndex:indexPath.section];
            [self.tableView deleteSections:sections withRowAnimation:UITableViewRowAnimationLeft];
        }
    } failure:^(__kindof FollowupUpdateDateRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}

- (void)interviewTableViewCellStart:(InterviewTableViewCell *)cell
{
    NSInteger sysType = [BSAppManager sharedInstance].currentUser.sysType.integerValue;
    if (sysType == InterfaceServerTypeScwjw) {
        FollowupAllFormVC *vc = [[FollowupAllFormVC alloc]init];
        BSFollowup* obj = cell.followup;
        vc.planModel = obj;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sysType == InterfaceServerTypeSczl)
    {
        ZLFollowupFormVC *vc = [[ZLFollowupFormVC alloc]init];
        vc.planModel = cell.followup;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
