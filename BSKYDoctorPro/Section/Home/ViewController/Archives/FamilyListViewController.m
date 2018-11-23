//
//  FamilyListViewController.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FamilyListViewController.h"
#import "CreatFAViewController.h"
#import "ArchiveFamilyListCell.h"
#import "FamilyListModel.h"
#import "ArchiveManagerViewController.h"
#import "ArchiveFamilySearchView.h"
#import "ArchiveFamilyListRequest.h"
#import "ScanViewController.h"
#import "HealthScanRequest.h"
#import "ZLFamilyListRequest.h"
#import "CreatPAViewController.h"

@interface FamilyListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *contentTableView;
@property (nonatomic ,strong)UIButton *addBtn;
@property (nonatomic ,strong)ArchiveFamilySearchView *searchView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,assign)NSInteger pageIndex;
@property (nonatomic ,assign)NSInteger pageSize;
@property (nonatomic ,assign)NSInteger page;
@property (nonatomic ,strong)NSString *searchKey;
@end

@implementation FamilyListViewController

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
    if ([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2) {
        self.title = @"户主档案搜索";
    }else{
        self.title = @"快速建档";
    }
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.contentTableView];
    [self.view addSubview:self.addBtn];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.mas_equalTo(55);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(45);
        make.bottom.equalTo(@0);
    }];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.addBtn.mas_top);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setFrame:CGRectMake(0, self.contentTableView.bottom - 45, self.view.width, 45)];
        if ([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2) {
            [_addBtn setTitle:@"新建户主档案" forState:UIControlStateNormal];
        }else{
            [_addBtn setTitle:@"新建家庭档案" forState:UIControlStateNormal];
        }
        
        [_addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setBackgroundColor:UIColorFromRGB(0x4e7dd3)];
    }
    return _addBtn;
}
- (ArchiveFamilySearchView *)searchView{
    if (!_searchView) {

        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"ArchiveFamilySearchView" owner:self options:nil] firstObject];
        
        Bsky_WeakSelf;
        _searchView.searchBlock = ^(NSString *key){
            Bsky_StrongSelf;
            [self.view endEditing:YES];
            [self searchActionWith:key];
        };
        _searchView.qrBlock = ^(){
            Bsky_StrongSelf;
            [self QRAction];
        };
    }
    return _searchView;
}
- (void)QRAction{
    ScanViewController *scanVC = [[ScanViewController alloc] init];
    Bsky_WeakSelf
    scanVC.block = ^(ScanViewController *vc, NSString *scanCode) {
        Bsky_StrongSelf
        [self getQRCodeInfoWithStr:scanCode];
        [vc.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}
- (void)getQRCodeInfoWithStr:(NSString *)scanCode {
    if ([scanCode isChinese] || [scanCode isIdCard]) {
        self.searchView.searchTextField.text = scanCode;
        [self searchActionWith:scanCode];
    } else {
        
        HealthScanRequest *scanRequest = [[HealthScanRequest alloc]init];
        
        scanRequest.requestModel.ewmsg = scanCode;
        //高血压随访0300701，糖尿病随访030070 ，高糖随访030070
        scanRequest.businessType = ScanBusinessHealthFilesType;
        [MBProgressHUD showHud];
        Bsky_WeakSelf
        [scanRequest startWithCompletionBlockWithSuccess:^(__kindof HealthScanRequest * _Nonnull request)
         {
             [MBProgressHUD hideHud];
             Bsky_StrongSelf
             self.searchView.searchTextField.text = request.responseModel.zjhm;
             [self searchActionWith:request.responseModel.zjhm];
         } failure:^(__kindof HealthScanRequest * _Nonnull request) {
             [MBProgressHUD hideHud];
             [UIView makeToast:scanRequest.msg];
         }];
    }
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchView.height, self.view.width, self.view.height - self.addBtn.height - self.navigationController.navigationBar.bottom - self.searchView.height) style:UITableViewStylePlain];
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
        [_contentTableView registerNib:[ArchiveFamilyListCell nib] forCellReuseIdentifier:[ArchiveFamilyListCell cellIdentifier]];
    }
    return _contentTableView;
}
- (void)addAction{
    if ([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2) {
        CreatPAViewController *vc = [[CreatPAViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        CreatFAViewController *vc = [[CreatFAViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)searchActionWith:(NSString *)key{
    _pageSize = 20;
    _pageIndex = 1;
    _page = 1;
    self.searchKey = key;
    [self initilationListDataWith:self.searchKey pageIndex:_page pageSize:_pageSize];
}
- (void)initilationListDataWith:(NSString *)key pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize{
    if ([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2) {
        [self initilationZLListDataWith:key pageIndex:pageIndex pageSize:pageSize];
    }else{
        [self initilationWJWListDataWith:key pageIndex:pageIndex pageSize:pageSize];
    }
    
    
}
- (void)initilationZLListDataWith:(NSString *)key pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize{
    Bsky_WeakSelf;
    
    ZLFamilyListRequest *request = [[ZLFamilyListRequest alloc] init];
    request.familyCodeOrName = key;
    request.pageIndex = [NSString stringWithFormat:@"%ld",(long)self.page];
    request.pageSize = [NSString stringWithFormat:@"%ld",(long)pageSize];
    [MBProgressHUD showHud];
    
    [request startWithCompletionBlockWithSuccess:^(__kindof ZLFamilyListRequest * _Nonnull request) {
        Bsky_StrongSelf;
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:request.familyListData];
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
    } failure:^(__kindof ArchiveFamilyListRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
        [self.contentTableView.mj_footer endRefreshing];
        [self.contentTableView.mj_header endRefreshing];
    }];
}
- (void)initilationWJWListDataWith:(NSString *)key pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize{
    Bsky_WeakSelf;
    
    ArchiveFamilyListRequest *request = [[ArchiveFamilyListRequest alloc] init];
    request.familyCodeOrName = key;
    request.pageIndex = [NSString stringWithFormat:@"%ld",(long)self.page];
    request.pageSize = [NSString stringWithFormat:@"%ld",(long)pageSize];
    [MBProgressHUD showHud];
    
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveFamilyListRequest * _Nonnull request) {
        Bsky_StrongSelf;
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:request.familyListData];
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
    } failure:^(__kindof ArchiveFamilyListRequest * _Nonnull request) {
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
    ArchiveFamilyListCell *cell = [tableView dequeueReusableCellWithIdentifier:[ArchiveFamilyListCell cellIdentifier] forIndexPath:indexPath];
    FamilyListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell setModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FamilyListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *familyId = nil;
    if ([model isKindOfClass:[ZLFamilyListModel class]]) {
        familyId = [model valueForKey:@"familyId"];
    }else if ([model isKindOfClass:[FamilyListModel class]]){
        familyId = [model valueForKey:@"FamilyID"];
    }
    if (!familyId.length) {
        [UIView makeToast:@"家庭档数据有误!"];
        return;
    }
    ArchiveManagerViewController *vc = [[ArchiveManagerViewController alloc] init];
    
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
@end
