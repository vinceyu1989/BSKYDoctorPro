//
//  BSMessageViewController.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSMessageViewController.h"
#import "BSSessionListViewController.h"
#import "BSContactViewController.h"
#import "IMSearchResultVC.h"
#import "BSGroupListVC.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESContactAddFriendViewController.h"
#import "NTESSessionViewController.h"
#import "NIMContactSelectViewController.h"
#import "ChineseToPinyin.h"
#import "IMDetailController.h"
#import "IMDataManager.h"
#import "IMAddFriendsViewController.h"

@interface BSMessageViewController () <UIScrollViewDelegate,UISearchResultsUpdating,UISearchControllerDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BSContactViewController *contactViewController;
@property (nonatomic, strong) BSSessionListViewController *sessionListViewController;
@property (nonatomic, strong) BSGroupListVC * groupListVC;
@property (nonatomic, strong) IMDataManager *IMDataManager;
@property (nonatomic, strong) IMSearchResultVC * searchResultVC;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation BSMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.IMDataManager = [IMDataManager dataManager];
}
- (void)dealloc
{
    self.IMDataManager = nil;
}
#pragma mark - 

- (void)setupView {
    
    [self setupNav];
    
    self.searchResultVC = [[IMSearchResultVC alloc]init];
    self.searchResultVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
     // 创建UISearchController, 这里使用当前控制器来展示结果
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:self.searchResultVC];
    // 设置结果更新代理
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.searchController.searchBar.barTintColor = UIColorFromRGB(0xf7f7f7);
    self.searchController.searchBar.tintColor = UIColorFromRGB(0x4e7dd3);
    self.searchController.searchBar.placeholder= @"搜索";
    [self.searchController.searchBar setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7)]];
    //搜索时，背景变模糊
    if (kiOS9Later) {
        self.searchController.obscuresBackgroundDuringPresentation = YES;
    }
    //点击搜索的时候,是否隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = YES;
//    [self.searchController.searchBar setPositionAdjustment:UIOffsetMake(70, 0) forSearchBarIcon:UISearchBarIconSearch];
    //大小
    [self.searchController.searchBar sizeToFit];
    //位置
    [self.view addSubview:self.searchController.searchBar];
    self.definesPresentationContext=YES;
    
// ## scrollView
    NSInteger contentHeight = SCREEN_HEIGHT - self.searchController.searchBar.height-TOP_BAR_HEIGHT - BOTTOM_BAR_HEIGHT;
    
    // 消息列表
    self.sessionListViewController = [[BSSessionListViewController alloc]init];
    self.sessionListViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, contentHeight);
    [self addChildViewController:self.sessionListViewController];
    // 通讯录列表
    self.contactViewController = [BSContactViewController new];
    self.contactViewController.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, contentHeight);
    [self addChildViewController:self.contactViewController];
    
    // 群组列表
    self.groupListVC = [[BSGroupListVC alloc]init];
    self.groupListVC.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, contentHeight);
    [self addChildViewController:self.groupListVC];

    self.scrollView = ({
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.searchController.searchBar.bottom, SCREEN_WIDTH, contentHeight)];
        [self.view addSubview:scrollView];
        [scrollView addSubview:self.sessionListViewController.view];
        [scrollView addSubview:self.contactViewController.view];
        [scrollView addSubview:self.groupListVC.view];
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, contentHeight);
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.directionalLockEnabled = YES;
        scrollView.delegate = self;
        scrollView.scrollEnabled = NO;
        
        scrollView;
    });
}

- (void)setupNav {
    
    self.segmentControl = ({
        UISegmentedControl* segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 120, 32)];
        [segmentControl insertSegmentWithTitle:@"消息" atIndex:0 animated:NO];
        [segmentControl insertSegmentWithTitle:@"通讯录" atIndex:1 animated:NO];
        [segmentControl insertSegmentWithTitle:@"群组" atIndex:2 animated:NO];
        segmentControl.tintColor = UIColorFromRGB(0x4e7dd3);
        segmentControl.selectedSegmentIndex = 0;
        [segmentControl addTarget:self action:@selector(onSegmentControl:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = segmentControl;

        segmentControl;
    });
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"btn_addFriend"] forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    rightBtn.frame = CGRectMake(0, 0, rightBtn.width, 44);
    [rightBtn addTarget:self action:@selector(onRightBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark - UI Actions

- (void)onSegmentControl:(UISegmentedControl*)segmentControl {
    CGFloat pointX = SCREEN_WIDTH * segmentControl.selectedSegmentIndex;
    [UIView animateWithDuration:.4f animations:^{
        self.scrollView.contentOffset = CGPointMake(pointX, self.scrollView.contentOffset.y);
    }];
}

- (void)onRightBarButtonItem:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加好友",@"创建讨论组", nil];
    __weak typeof(self) wself = self;
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        UIViewController *vc;
        switch (index) {
            case 0: {
                IMAddFriendsViewController *add_vc = [[IMAddFriendsViewController alloc] init];
                [wself.navigationController pushViewController:add_vc animated:YES];
            }
                break;
            case 1:{ //创建讨论组
                [wself presentMemberSelector:^(NSArray *uids) {
                    if (!uids.count) {
                        return; //讨论组必须除自己外必须要有一个群成员
                    }
                    NSArray *members = [@[currentUserId] arrayByAddingObjectsFromArray:uids];
                    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
                    option.name       = @"讨论组";
                    option.type       = NIMTeamTypeNormal;
                    [MBProgressHUD showHud];
                    [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError *error, NSString *teamId, NSArray<NSString *> * _Nullable failedUserIds) {
                        [MBProgressHUD hideHud];
                        if (!error) {
                            NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                            [wself.navigationController pushViewController:vc animated:YES];
                        }else{
                            [wself.view makeToast:@"创建失败" duration:2.0 position:CSToastPositionCenter];
                        }
                    }];
                }];
                break;
            }
            default:
                break;
        }
        if (vc) {
            [wself.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.segmentControl.selectedSegmentIndex = (NSInteger)(scrollView.contentOffset.x / SCREEN_WIDTH);
}
#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSString *searchString = [self.searchController.searchBar text];
    NSMutableArray *array = [self getSearchResultWithString:searchString];
    [self.searchResultVC refreshData:array searchStr:searchString];
    
}
#pragma mark --- UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController
{
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -NAVIGATION_BAR_HEIGHT);
    }];
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
    }];
}
#pragma mark --- 内部方法

- (void)presentMemberSelector:(ContactSelectFinishBlock) block{
    NSMutableArray *users = [[NSMutableArray alloc] init];
    //使用内置的好友选择器
    NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
    //获取自己id
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    [users addObject:currentUserId];
    //将自己的id过滤
    config.filterIds = users;
    //需要多选
    config.needMutiSelected = YES;
    //初始化联系人选择器
    NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
    //回调处理
    vc.finshBlock = block;
    [vc show];
}

- (NSMutableArray *)getSearchResultWithString:(NSString *)str
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *userList = [NSMutableArray array];
    NSMutableArray *groupList = [NSMutableArray array];
    NSString *lowStr = @"";
    if (![str includeChinese]) {
        lowStr = [ChineseToPinyin pinyinFromChineseString:str withSpace:NO];
    }
    if ([str isNotEmptyString]) {
        for (NIMUser *user in [[NIMSDK sharedSDK].userManager myFriends]) {
            NSString *name = [self showNameWithUser:user];
            NSString *allStr =[ChineseToPinyin letterPinyinFromChineseString:name];
            if ([name rangeOfString:str].location != NSNotFound || [allStr rangeOfString:lowStr].location != NSNotFound) {
                [userList addObject:user];
            }
        }
//        for (NIMTeam *team in [self.groupListVC fetchTeams]) {
//            NSString *allStr =[ChineseToPinyin letterPinyinFromChineseString:team.teamName];
//            if ([team.teamName  rangeOfString:str].location != NSNotFound || [allStr rangeOfString:lowStr].location != NSNotFound) {
//                [groupList addObject:team];
//            }
//        }
    }
    [array insertObject:userList atIndex:0];
    [array insertObject:groupList atIndex:1];
    return array;
}
- (NSString *)showNameWithUser:(NIMUser *)user
{
    if ([user.alias isNotEmptyString]) {
        return user.alias;
    }
    if ([user.userInfo.nickName isNotEmptyString]) {
        return user.userInfo.nickName;
    }
    return user.userId;
}
@end
