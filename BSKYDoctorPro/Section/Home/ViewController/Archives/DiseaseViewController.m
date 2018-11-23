//
//  DiseaseViewController.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "DiseaseViewController.h"
#import "ArchiveFamilySearchView.h"
#import "ArchiveFamilySearchView.h"
#import "DiseaseResultTableView.h"
#import "DiseaseSelectedCollectionView.h"
#import "ZLDiseaseRequest.h"
#import "ZLDiseaseModel.h"

@interface DiseaseViewController ()
@property (nonatomic ,strong)UIBarButtonItem *saveBtn;
@property (nonatomic ,strong)ArchiveFamilySearchView *searchView;

@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)DiseaseResultTableView *resultTableView;
@property (nonatomic ,strong)DiseaseSelectedCollectionView *selectedCollectionView;
@property (nonatomic ,strong)UIView *selectedView;
@property (nonatomic ,strong)UILabel *selectedTitleLabel;
@property (nonatomic ,assign)NSUInteger page;
@property (nonatomic ,assign)NSUInteger pageSize;
@property (nonatomic ,strong)NSString *searchKey;
@end

@implementation DiseaseViewController

- (void)viewDidLoad {
    self.title = @"疾病选择";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatDiseaseUI];
    self.pageSize = 20;
    self.page = 1;
}
- (void)searchDisease:(NSString *)key withSize:(NSUInteger )size{
    ZLDiseaseRequest *request = [[ZLDiseaseRequest alloc] init];
    request.pageSize = size;
    request.searchKey = key;
    request.pageIndex = self.page;
    self.searchKey = key;
    [MBProgressHUD showHud];
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ZLDiseaseRequest * _Nonnull request) {
        
        Bsky_StrongSelf;
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:request.dataArray];
        self.resultTableView.dataArray = self.dataArray;
        if (self.resultTableView.hidden) {
            [self searchSuccessView];
        }
        if (self.page == 1) {
            self.resultTableView.contentOffset = CGPointMake(0, 0);
            [self.resultTableView.mj_footer resetNoMoreData];
        }
        if(self.resultTableView.mj_header.refreshing)
        {
            [self.resultTableView.mj_header endRefreshing];
            [self.resultTableView.mj_footer resetNoMoreData];
        }
        
        if (self.dataArray.count % 20 == 0 && self.dataArray.count) {
            [self.resultTableView.mj_footer endRefreshing];
        }else{
            
            [self.resultTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [MBProgressHUD hideHud];
    } failure:^(__kindof ZLDiseaseRequest * _Nonnull request) {
        if(self.resultTableView.mj_header.refreshing)[self.resultTableView.mj_header endRefreshing];
        if(self.resultTableView.mj_footer.refreshing)[self.resultTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}
- (void)firstUI{
    self.selectedView.hidden = YES;
    self.resultTableView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)onlyHaveSelectViewUI{
    self.selectedView.hidden = NO;
    self.resultTableView.hidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
}
- (void)searchSuccessView{
    self.selectedView.hidden = NO;
    self.resultTableView.hidden = NO;
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
}
- (void)creatDiseaseUI{
    
    self.navigationItem.rightBarButtonItem = self.saveBtn;
    [self.view addSubview:self.searchView];
    
    [self.view addSubview:self.selectedView];
    self.selectedView.backgroundColor = [UIColor whiteColor];
    self.selectedTitleLabel.text = @"已选疾病";
    self.selectedTitleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectedView addSubview:self.selectedTitleLabel];
    [self.selectedView addSubview:self.selectedCollectionView];
    [self.view addSubview:self.resultTableView];
    self.selectedCollectionView.selectedArray = self.selectedArray;
    if (self.selectedArray.count) {
        [self onlyHaveSelectViewUI];
    }else{
        [self firstUI];
    }
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.mas_equalTo(55);
    }];
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.searchView.mas_bottom);
        make.height.mas_equalTo(130);
    }];
    [self.selectedTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.height.equalTo(@15);
        make.right.equalTo(@-15);
    }];
    [self.selectedCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectedTitleLabel.mas_bottom).offset(15);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.selectedView.mas_bottom).offset(-15);
    }];
    [self.resultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectedView.mas_bottom).offset(10);
        make.right.left.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)reloadSelectedCollection{
    
}
- (void)saveDataToServer{
    if (self.block) {
        self.block(self.selectedArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)selectAction:(NSIndexPath *)indexPath{
    ZLDiseaseModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([self.selectedArray containsObject:model]){
        return;
    }
    if (self.selectCount > 0){
        if ([self.selectedArray count] >= self.selectCount){
            NSUInteger count = self.selectedArray.count - self.selectCount;
            for (NSInteger i = 0; i <= count; i ++) {
                [self.selectedArray removeObjectAtIndex:i];
            }
        }
    }
    [self.selectedArray addObject:model];
    self.selectedCollectionView.selectedArray = self.selectedArray;
}
- (void)deleteAction{
    
}
- (void)searchAction{
    
}
#pragma mark 懒加载
- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}
- (UIBarButtonItem *)saveBtn{
    if (!_saveBtn) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.backgroundColor = [UIColor clearColor];
        rightButton.frame = CGRectMake(0, 0, 45, 40);
        [rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [rightButton setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
        rightButton.tintColor = [UIColor clearColor];
        rightButton.autoresizesSubviews = YES;
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        rightButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        [rightButton addTarget:self action:@selector(saveDataToServer) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return _saveBtn;
    
    
    
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (ArchiveFamilySearchView *)searchView{
    if (!_searchView) {
        
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"ArchiveFamilySearchView" owner:self options:nil] firstObject];
        _searchView.hasQR = NO;
        _searchView.placeholder = @"请输入疾病/编码/名称/拼音码搜索";
        Bsky_WeakSelf;
        _searchView.searchBlock = ^(NSString *key){
            Bsky_StrongSelf;
            self.page = 1;
            [self searchDisease:key withSize:self.pageSize];
            [self.view endEditing:YES];
        };
    }
    return _searchView;
}
- (UIView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[UIView alloc] init];
    }
    return _selectedView;
}
- (UILabel *)selectedTitleLabel{
    if (!_selectedTitleLabel) {
        _selectedTitleLabel = [[UILabel alloc] init];
        _selectedTitleLabel.font = [UIFont systemFontOfSize:14];
        _selectedTitleLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _selectedTitleLabel;
}
- (DiseaseSelectedCollectionView *)selectedCollectionView{
    if (!_selectedCollectionView) {
        _selectedCollectionView = [[DiseaseSelectedCollectionView alloc] initWithFrame:CGRectZero];
    }
    return _selectedCollectionView;
}
- (DiseaseResultTableView *)resultTableView{
    if (!_resultTableView) {
        _resultTableView = [[DiseaseResultTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        Bsky_WeakSelf;
        _resultTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            Bsky_StrongSelf;
            self.page = 1;
            [self searchDisease:self.searchKey withSize:self.pageSize];
        }];
        _resultTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            Bsky_StrongSelf;
            self.page ++;
            [self searchDisease:self.searchKey withSize:self.pageSize];
        }];
        _resultTableView.selectBlock = ^(NSIndexPath *indexPath) {
            Bsky_StrongSelf;
            [self selectAction:indexPath];
        };
    }
    return _resultTableView;
}
@end
