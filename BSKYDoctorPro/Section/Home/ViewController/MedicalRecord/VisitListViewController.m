//
//  VisitListViewController.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "VisitListViewController.h"
#import "VisitListRequest.h"
#import "VisitListModel.h"
#import "VisitListCell.h"
#import "VisitDetailViewController.h"

@interface VisitListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *contentTableView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@end


@implementation VisitListViewController

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
    self.title = @"就诊记录";
    
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
    VisitListRequest *request = [[VisitListRequest alloc] init];
    request.personId = self.model.personId;
    [MBProgressHUD showHud];
    
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof VisitListRequest * _Nonnull request) {
        Bsky_StrongSelf;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:request.listArray];
        [self.contentTableView reloadData];
        
        if(self.contentTableView.mj_header.refreshing)
        {
            [self.contentTableView.mj_header endRefreshing];
        }
        
        if ([self.dataArray count]) {
            NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.contentTableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [MBProgressHUD hideHud];
    } failure:^(__kindof VisitListRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
        [self.contentTableView.mj_header endRefreshing];
    }];
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
        [_contentTableView registerNib:[VisitListCell nib] forCellReuseIdentifier:[VisitListCell cellIdentifier]];
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
    return [self.dataArray count];
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VisitListCell *cell = [tableView dequeueReusableCellWithIdentifier:[VisitListCell cellIdentifier] forIndexPath:indexPath];
    VisitListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell setModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VisitListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *familyId = model.listId;
    if (!familyId.length) {
        [UIView makeToast:@"就诊记录数据有误!"];
        return;
    }
    VisitDetailViewController *vc = [[VisitDetailViewController alloc] init];
    
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

@end
