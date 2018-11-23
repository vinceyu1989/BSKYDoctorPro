//
//  ZLFollowupHistoryListVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFollowupHistoryListVC.h"
#import "FollowupHistoryCell.h"
#import "ZLHistoryBaseRequest.h"
#import "BSH5UrlRequest.h"

@interface ZLFollowupHistoryListVC ()

@property (nonatomic ,strong) ZLHistoryBaseRequest *request;

@property (nonatomic ,assign) NSInteger currentPage;

@property (nonatomic ,strong) NSMutableArray *dataList;

@property (nonatomic ,strong) BSH5UrlRequest *urlRequest;

@end

@implementation ZLFollowupHistoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = @"";
    self.urlRequest = [[BSH5UrlRequest alloc]init];
    switch (self.type) {
        case FollowupTypeHypertension:
            str = @"高血压";
            self.urlRequest.type = @"zlHyperSugar";
            break;
        case FollowupTypeDiabetes:
            str = @"糖尿病";
            self.urlRequest.type = @"zlDiab";
            break;
        default:
            break;
    }
    self.title = [NSString stringWithFormat:@"%@的%@随访记录",self.personName,str];
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.tableView registerNib:[FollowupHistoryCell nib] forCellReuseIdentifier:[FollowupHistoryCell cellIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.currentPage = 0;
    self.dataList = [NSMutableArray array];
    
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage++;
        [self loadData];
    }];
    [self.tableView.mj_footer beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)loadData
{
    if (!self.request) {
        switch (self.type) {
            case FollowupTypeHypertension:
                self.request = [[ZLHyHistoryRequest alloc]init];
                break;
            case FollowupTypeDiabetes:
                self.request = [[ZLDbHistoryRequest alloc]init];
                break;
            default:
                break;
        }
    }
    self.request.pageSize = @10;
    self.request.personId = self.personId;
    self.request.pageIndex = @(self.currentPage);
    Bsky_WeakSelf
    [self.request startWithCompletionBlockWithSuccess:^(__kindof ZLHistoryBaseRequest * _Nonnull request) {
        Bsky_StrongSelf
        if (self.currentPage == 1 && request.dataList.count < 1) {
            [((MJRefreshAutoNormalFooter *)self.tableView.mj_footer) setTitle:@"没有查询到相关数据" forState:MJRefreshStateNoMoreData];
        }
        else
        {
            [((MJRefreshAutoNormalFooter *)self.tableView.mj_footer) setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
        }
        if (request.dataList.count < request.pageSize.integerValue ) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.currentPage == 1) {
            [self.dataList removeAllObjects];
        }
        [self.dataList addObjectsFromArray:request.dataList];
        [self.tableView reloadData];
        
    } failure:^(__kindof ZLHistoryBaseRequest * _Nonnull request) {
        [self.tableView.mj_footer endRefreshing];
        [UIView makeToast:request.msg];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FollowupHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[FollowupHistoryCell cellIdentifier]];
    cell.type = self.type;
    cell.zlModel = self.dataList[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSWebViewController *webVC = [[BSWebViewController alloc]init];
    webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
    webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
    
    ZLFollowupHistoryModel *model = self.dataList[indexPath.row];
    
    NSString * jsStr = [NSString stringWithFormat:@"zlFollowupDetailIos('%@','%@')",model.idField,[BSClientManager sharedInstance].tokenId];
    webVC.ocTojsStr = jsStr;
    
    if (!self.urlRequest.urlString) {
        [MBProgressHUD showHud];
        @weakify(self);
        [self.urlRequest startWithCompletionBlockWithSuccess:^(__kindof BSH5UrlRequest * _Nonnull request)
         {
             [MBProgressHUD hideHud];
             @strongify(self);
             [webVC ba_web_loadURLString:self.urlRequest.urlString];
             [self.navigationController pushViewController:webVC animated:YES];
         } failure:^(__kindof BSH5UrlRequest * _Nonnull request) {
             [MBProgressHUD hideHud];
             [UIView makeToast:request.msg];
         }];
        return;
    }
    [webVC ba_web_loadURLString:self.urlRequest.urlString];
    [self.navigationController pushViewController:webVC animated:YES];
}
@end
