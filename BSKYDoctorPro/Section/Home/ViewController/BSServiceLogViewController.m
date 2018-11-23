//
//  BSServiceLogViewController.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/31.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSServiceLogViewController.h"
#import "BSServiceLogView.h"

@interface BSServiceLogViewController () <BSServiceLogViewDataSource>

@property (nonatomic, retain) BSServiceLogView *serviceLogView;
@property (nonatomic, retain) NSArray *serviceLogList;

@end

@implementation BSServiceLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务日志";
    [self setupView];
}

#pragma mark -

- (void)setupView {
    self.serviceLogView = ({
        BSServiceLogView* view = [BSServiceLogView new];
        view.dataSource = self;
        [self.view addSubview:view];
        
        view;
    });
    [self.serviceLogView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    Bsky_WeakSelf
    self.serviceLogView.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        Bsky_StrongSelf
        [self loadData];
    }];
    [self.serviceLogView.tableView.mj_footer beginRefreshing];
}

- (void)loadData {
    Bsky_WeakSelf
    [MBProgressHUD showHud];
    BSServiceLogRequest* request = [BSServiceLogRequest new];
    [request startWithCompletionBlockWithSuccess:^(__kindof BSServiceLogRequest * _Nonnull request) {
        Bsky_StrongSelf
        [MBProgressHUD hideHud];
        if ([request.serviceLogList isEmptyArray]) {
            [((MJRefreshAutoNormalFooter *)self.serviceLogView.tableView.mj_footer) setTitle:@"没有查询到相关数据" forState:MJRefreshStateNoMoreData];
        }
        else
        {
            [((MJRefreshAutoNormalFooter *)self.serviceLogView.tableView.mj_footer) setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
        }
        [self.serviceLogView.tableView.mj_footer endRefreshingWithNoMoreData];
        self.serviceLogList = request.serviceLogList;
        [self.serviceLogView reloadData];
    } failure:^(__kindof BSServiceLogRequest * _Nonnull request) {
        Bsky_StrongSelf
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
        [self.serviceLogView.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

#pragma mark - BSServiceLogViewDataSource

- (NSInteger)numberOfserviceLogInView:(BSServiceLogView*)serviceLogView {
    return self.serviceLogList.count;
}

- (BSServiceLog*)servieLogForIndex:(NSInteger)index {
    return self.serviceLogList[index];
}

@end
