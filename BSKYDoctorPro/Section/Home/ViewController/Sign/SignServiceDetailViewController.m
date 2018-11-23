//
//  SignServiceDetailViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignServiceDetailViewController.h"
#import "SignServiceDetailTopCell.h"
#import "SignServiceDetailCell.h"
#import "BSSignSVPackDetailRequest.h"
#import "SignSVPackContentModel.h"

@interface SignServiceDetailViewController () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat _multiply;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;

@property (nonatomic, strong) BSSignSVPackDetailRequest *SVPackDetailRequest;

@end

@implementation SignServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    
    self.title = @"服务包详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _multiply = SCREEN_WIDTH/375.0;
    self.tableView = ({
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.backgroundColor = [UIColor whiteColor];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 120;
        table.rowHeight = UITableViewAutomaticDimension;
        table.layer.cornerRadius = 5;
        table.layer.masksToBounds = YES;
        table.showsVerticalScrollIndicator = NO;
        table.showsHorizontalScrollIndicator = NO;
        table.tableFooterView = [UIView new];
        [table registerNib:[SignServiceDetailTopCell nib] forCellReuseIdentifier:[SignServiceDetailTopCell cellIdentifier]];
        [table registerNib:[SignServiceDetailCell nib] forCellReuseIdentifier:[SignServiceDetailCell cellIdentifier]];
       
        table;
    });
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-SafeAreaBottomHeight);
    }];
    [self getServerDetailInfoRequest];
}

- (void)getServerDetailInfoRequest {
    self.SVPackDetailRequest = [[BSSignSVPackDetailRequest alloc] init];
    self.SVPackDetailRequest.servicePackId = _model.serviceId;
    [self.SVPackDetailRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignSVPackDetailRequest * _Nonnull request) {
        if (request.SVPackData.count != 0) {
            self.tableData = [NSMutableArray arrayWithArray:request.SVPackData];
            [self.tableView reloadData];
        }
    } failure:^(__kindof BSSignSVPackDetailRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:[SignServiceDetailTopCell cellIdentifier]];
        SignServiceDetailTopCell *tableCell = (SignServiceDetailTopCell *)cell;
        tableCell.model = self.model;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[SignServiceDetailCell cellIdentifier]];
        SignServiceDetailCell *tableCell = (SignServiceDetailCell *)cell;
        SignSVPackContentModel *model = (SignSVPackContentModel *)self.tableData[indexPath.row-1];
        tableCell.model = model;
    }
    return cell;
}


- (void)setModel:(SignSVPackModel *)model {
    _model = model;
}

@end
