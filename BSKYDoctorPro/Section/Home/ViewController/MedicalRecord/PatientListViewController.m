//
//  PatientListViewController.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "PatientListViewController.h"
#import "ArchiveFamilySearchView.h"
#import "PatientListModel.h"
#import "PatientListCell.h"
#import "VisitListViewController.h"
#import "PatientListRequest.h"
#import "VisitDetailViewController.h"

@interface PatientListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *contentTableView;
@property (nonatomic ,strong)ArchiveFamilySearchView *searchView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,assign)NSInteger pageIndex;
@property (nonatomic ,assign)NSInteger pageSize;
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,strong)NSString *searchKey;
@end

@implementation PatientListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self searchActionWith:@""];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.contentTableView reloadData];
}
- (void)creatUI{
    self.title = @"就诊记录";
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.contentTableView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.mas_equalTo(55);
    }];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (ArchiveFamilySearchView *)searchView{
    if (!_searchView) {
        
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"ArchiveFamilySearchView" owner:self options:nil] firstObject];
        
        Bsky_WeakSelf;
        _searchView.hasQR = NO;
        _searchView.placeholder = @"请输入姓名/门诊号";
        _searchView.searchBlock = ^(NSString *key){
            Bsky_StrongSelf;
            [self.view endEditing:YES];
            [self searchActionWith:key];
        };
        _searchView.qrBlock = ^(){
        };
    }
    return _searchView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchView.height, self.view.width, self.view.height - self.navigationController.navigationBar.bottom - self.searchView.height) style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundColor = [UIColor clearColor];
        _contentTableView.backgroundView = nil;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        Bsky_WeakSelf;
        _contentTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [self searchActionWith:self.searchKey];
        }];
        _contentTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            Bsky_StrongSelf;
            self.page ++;
            [self initilationListDataWith:self.searchKey pageIndex:self.page pageSize:self.pageSize];
        }];
        [_contentTableView registerNib:[PatientListCell nib] forCellReuseIdentifier:[PatientListCell cellIdentifier]];
    }
    return _contentTableView;
}
- (void)searchActionWith:(NSString *)key{
    _pageSize = 20;
    _pageIndex = 1;
    _page = 1;
    self.searchKey = key;
    [self initilationListDataWith:self.searchKey pageIndex:_page pageSize:_pageSize];
}
- (void)initilationListDataWith:(NSString *)key pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize{
    [self initilationWJWListDataWith:key pageIndex:pageIndex pageSize:pageSize];
}
- (void)initilationWJWListDataWith:(NSString *)key pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize{
    Bsky_WeakSelf;
    
    PatientListRequest *request = [[PatientListRequest alloc] init];
    request.key = key;
    request.pageIndex = [NSString stringWithFormat:@"%ld",(long)self.page];
    request.pageSize = [NSString stringWithFormat:@"%ld",(long)pageSize];
    [MBProgressHUD showHud];
    
    [request startWithCompletionBlockWithSuccess:^(__kindof PatientListRequest * _Nonnull request) {
        Bsky_StrongSelf;
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:request.listArray];
        [self.contentTableView reloadData];
        
        if(self.contentTableView.mj_header.refreshing)
        {
            [self.contentTableView.mj_header endRefreshing];
            [self.contentTableView.mj_footer resetNoMoreData];
        }
        
        if (self.page == 1) {
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                self.contentTableView.contentOffset = CGPointMake(0, 0);
            //            });
            //            self.contentTableView.contentOffset = CGPointMake(0, 0);
            
            [self.contentTableView.mj_footer resetNoMoreData];
            //            [self.contentTableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            if ([self.dataArray count]) {
                NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.contentTableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        if (self.dataArray.count % 20 == 0 && self.dataArray.count) {
            [self.contentTableView.mj_footer endRefreshing];
        }else{
            
            [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [MBProgressHUD hideHud];
    } failure:^(__kindof PatientListRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
        [self.contentTableView.mj_footer endRefreshing];
        [self.contentTableView.mj_header endRefreshing];
    }];
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
    PatientListCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientListCell cellIdentifier] forIndexPath:indexPath];
    PatientListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell setModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PatientListModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    NSString *familyId = model.personId;
//    if (!familyId.length) {
//        [UIView makeToast:@"就诊记录数据有误!"];
//        return;
//    }
//    VisitListViewController *vc = [[VisitListViewController alloc] init];
//
//    vc.model = model;
//    [self.navigationController pushViewController:vc animated:YES];
    PatientListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *familyId = model.listId;
    if (!familyId.length) {
        [UIView makeToast:@"就诊记录数据有误!"];
        return;
    }
    VisitDetailViewController *vc = [[VisitDetailViewController alloc] init];
    
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 134;
}
@end
