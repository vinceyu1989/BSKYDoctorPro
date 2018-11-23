//
//  ArchiveManagerViewController.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "ArchiveManagerViewController.h"
#import "ArchiveManagerCell.h"
#import "CreatPAViewController.h"
#import "ArchiveFamilyMemberRequest.h"
#import "ZLMemberListRequest.h"


@interface ArchiveManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *contentTableView;
@property (nonatomic ,strong)UIButton *addBtn;
@end

@implementation ArchiveManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getFamilyMemberArray];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)getZLFamilyMemberArray:(NSString *)familyId{
    ZLMemberListRequest *request = [[ZLMemberListRequest alloc] init];
    request.familyID = familyId;
    //    request.familyID = @"C4CB83C9B53540FD86B52E09E9BB836F";
    Bsky_WeakSelf;
    [MBProgressHUD showHud];
    
    [request startWithCompletionBlockWithSuccess:^(__kindof ZLMemberListRequest * _Nonnull request) {
        Bsky_StrongSelf;
        [self.memberArray removeAllObjects];
//        ZLFamilyMemberListModel *masterModel = [[ZLFamilyMemberListModel alloc] init];
//        ZLFamilyListModel *familyModel = (ZLFamilyListModel *)self.model;
//        masterModel.personId = familyModel.masterId;
//        masterModel.name = familyModel.masterName;
//        masterModel.telPhone =familyModel.telNumber;
//        [self.memberArray addObject:masterModel];
        [self.memberArray addObjectsFromArray:request.dataArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentTableView reloadData];
        });
        [self.contentTableView.mj_header endRefreshing];
        [MBProgressHUD hideHud];
    } failure:^(__kindof ArchiveFamilyMemberRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [self.contentTableView.mj_header endRefreshing];
        [MBProgressHUD hideHud];
    }];
}
- (void)getWJWFamilyMemberArray:(NSString *)familyId{
    ArchiveFamilyMemberRequest *request = [[ArchiveFamilyMemberRequest alloc] init];
    request.familyID = familyId;
    //    request.familyID = @"C4CB83C9B53540FD86B52E09E9BB836F";
    Bsky_WeakSelf;
    [MBProgressHUD showHud];
    
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveFamilyMemberRequest * _Nonnull request) {
        Bsky_StrongSelf;
        [self.memberArray removeAllObjects];
        [self.memberArray addObjectsFromArray:request.dataArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentTableView reloadData];
        });
        [self.contentTableView.mj_header endRefreshing];
        [MBProgressHUD hideHud];
    } failure:^(__kindof ArchiveFamilyMemberRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [self.contentTableView.mj_header endRefreshing];
        [MBProgressHUD hideHud];
    }];
}
- (void)getFamilyMemberArray{
    if ([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2) {
        [self getZLFamilyMemberArray:[self.model valueForKey:@"familyId"]];
    }else{
        [self getWJWFamilyMemberArray:[self.model valueForKey:@"FamilyID"]];
    }
}
- (NSMutableArray *)memberArray{
    if (!_memberArray) {
        _memberArray = [[NSMutableArray alloc] init];
    }
    return _memberArray;
}
- (void)creatUI{
    self.title = @"家庭信息";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.view addSubview:self.contentTableView];
    [self.view addSubview:self.addBtn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];    
        [_addBtn setFrame:CGRectMake(0, self.contentTableView.bottom - 45, self.view.width, 45)];
        
        [_addBtn setTitle:@"新建家庭成员" forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setBackgroundColor:UIColorFromRGB(0x4e7dd3)];
    }
    return _addBtn;
}
- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.addBtn.height - self.navigationController.navigationBar.bottom) style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundColor = [UIColor clearColor];
        _contentTableView.backgroundView = nil;
        Bsky_WeakSelf;
        _contentTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            Bsky_StrongSelf;
            [self getFamilyMemberArray];
        }];
        [_contentTableView registerNib:[ArchiveManagerCell nib] forCellReuseIdentifier:[ArchiveManagerCell cellIdentifier]];
    }
    return _contentTableView;
}
- (void)addAction{
    
    CreatPAViewController *vc = [[CreatPAViewController alloc] init];
    vc.familyModel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
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
    if ([self.memberArray count]) {
        return 2;
    }else{
        return 1;
    }
} 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArchiveManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:[ArchiveManagerCell cellIdentifier] forIndexPath:indexPath];
    if (!indexPath.section) {
        cell.model = self.model;
    }else{
        cell.listModel = self.model;
        cell.dataArray = self.memberArray;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (!section) {
//        return 0.1;
//    }else{
        return 10;
//    }
   
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
@end
