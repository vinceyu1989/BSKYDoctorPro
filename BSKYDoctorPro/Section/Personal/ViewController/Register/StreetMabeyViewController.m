//
//  StreetMabeyViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "StreetMabeyViewController.h"
#import "StreetOrganRequest.h"

static NSString *identifier = @"StreetMabeyTableViewCell";

@interface StreetMabeyViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) StreetOrganRequest *streetRequest;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation StreetMabeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择医疗机构";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    self.currentPage = 0;
    self.streetRequest = [[StreetOrganRequest alloc] init];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"#ededed"]];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
    }];
    
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage++;
        [self loadData];
    }];
    [self.tableView.mj_footer beginRefreshing];
}

- (void)loadData {
    self.streetRequest.divisionId = _model.divisionId;
    self.streetRequest.pageSize = @"10";
    self.streetRequest.pageNo = [NSString stringWithFormat:@"%@",@(self.currentPage)];
    WS(weakSelf);
    [self.streetRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (weakSelf.streetRequest.streetData.count != 0) {
            [weakSelf.tableView.mj_footer endRefreshing];
            if (weakSelf.currentPage <= 1) {
                [_dataSource removeAllObjects];
            }
            [_dataSource addObjectsFromArray:weakSelf.streetRequest.streetData];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"#4e7dd3"];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    if (_dataSource.count != 0) {
        DivisionCodeModel *model = _dataSource[indexPath.row];
        cell.textLabel.text = model.divisionName;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithHexString:@"#effaff"];
    UILabel *label = [[UILabel alloc] init];
    label.text = _model.divisionName;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#4e7dd3"];
    [label sizeToFit];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.centerX.equalTo(view.mas_centerX).offset(-20);
    }];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.bounds = CGRectMake(0, 0, 25, 25);
    imageView.image = [UIImage imageNamed:@"ico切换"];
    imageView.contentMode = UIViewContentModeCenter;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.equalTo(label.mas_right).offset(7.5);
    }];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DivisionCodeModel *model = _dataSource[indexPath.row];
    if (self.block) {
        self.block(self, model);
    }
}

- (void)setModel:(DivisionCodeModel *)model {
    _model = model;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

@end
