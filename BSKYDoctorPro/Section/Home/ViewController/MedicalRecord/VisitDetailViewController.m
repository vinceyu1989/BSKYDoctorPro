//
//  VisitDetailViewController.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "VisitDetailViewController.h"
#import "VisitDetailModel.h"
#import "VisitDetailBaseCell.h"
#import "VisitDetailRecordCell.h"
#import "VisitDetailRequest.h"

@interface VisitDetailViewController ()
@property (nonatomic ,strong)UITableView *contentTableView;
@property (nonatomic ,strong) VisitDetailModel *detailModel;
@end

@implementation VisitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self refreshData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.contentTableView reloadData];
}
- (void)creatUI{
    self.title = @"就诊详情";
    
    [self.view addSubview:self.contentTableView];
    
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshData{
    VisitDetailRequest *request = [[VisitDetailRequest alloc] init];
    request.mzId = self.model.listId;
    [MBProgressHUD showHud];
    
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof VisitDetailRequest * _Nonnull request) {
        Bsky_StrongSelf;
        self.detailModel = request.model;
        [self.contentTableView reloadData];
        
        if(self.contentTableView.mj_header.refreshing)
        {
            [self.contentTableView.mj_header endRefreshing];
        }
        
        [MBProgressHUD hideHud];
    } failure:^(__kindof VisitDetailRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
        [self.contentTableView.mj_header endRefreshing];
    }];
}
- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom) style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundColor = [UIColor clearColor];
        _contentTableView.backgroundView = nil;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        Bsky_WeakSelf;
        _contentTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            Bsky_StrongSelf;
            [self refreshData];
        }];
        [_contentTableView registerNib:[VisitDetailRecordCell nib] forCellReuseIdentifier:[VisitDetailRecordCell cellIdentifier]];
        [_contentTableView registerNib:[VisitDetailBaseCell nib] forCellReuseIdentifier:[VisitDetailBaseCell cellIdentifier]];
    }
    return _contentTableView;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark TableViewDelegate and DataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        VisitDetailRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[VisitDetailRecordCell cellIdentifier] forIndexPath:indexPath];
        [cell setModel:self.detailModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        VisitDetailBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[VisitDetailBaseCell cellIdentifier] forIndexPath:indexPath];
        [cell setModel:self.detailModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

@end
