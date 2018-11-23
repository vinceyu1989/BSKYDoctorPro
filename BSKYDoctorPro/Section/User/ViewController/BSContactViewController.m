//
//  BSContactViewController.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSContactViewController.h"
#import "NTESSessionUtil.h"
#import "NTESSessionViewController.h"
#import "NTESContactUtilItem.h"
#import "NTESContactDefines.h"
#import "NTESGroupedContacts.h"
#import "UIView+Toast.h"
#import "NTESCustomNotificationDB.h"
#import "NTESNotificationCenter.h"
#import "UIActionSheet+NTESBlock.h"
#import "UIAlertView+NTESBlock.h"
#import "SVProgressHUD.h"
#import "NTESContactUtilCell.h"
#import "NTESContactDataCell.h"
#import "NTESUserUtil.h"
#import "BSContactCell.h"
#import "IMDetailController.h"
#import "IMDataManager.h"

@interface BSContactViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
NIMUserManagerDelegate,
NIMSystemNotificationManagerDelegate,
NTESContactUtilCellDelegate,
NIMLoginManagerDelegate,
NIMEventSubscribeManagerDelegate,
BSContactCellDelegate
>
@property (nonatomic, strong) NTESGroupedContacts * contacts;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * datas;

@end

@implementation BSContactViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[IMDataManager dataManager] getLabelOptionDicBlock:^{
        [self.tableView reloadData];
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.delegate       = self;
    self.tableView.dataSource     = self;
    [self.tableView registerNib:[BSContactCell nib] forCellReuseIdentifier:[BSContactCell cellIdentifier]];
    UIEdgeInsets separatorInset   = self.tableView.separatorInset;
    separatorInset.right          = 0;
    self.tableView.separatorInset = separatorInset;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    
    [self prepareData];
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
}

- (void)prepareData{
    self.contacts = [[NTESGroupedContacts alloc] init];
    self.datas = [[NIMSDK sharedSDK].userManager myFriends];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
    if ([contactItem respondsToSelector:@selector(selName)] && [contactItem selName].length) {
        SEL sel = NSSelectorFromString([contactItem selName]);
        SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:nil]);
    }
    else if (contactItem.vcName.length) {
        Class clazz = NSClassFromString(contactItem.vcName);
        UIViewController * vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([contactItem respondsToSelector:@selector(userId)]){
        NSString * friendId   = contactItem.userId;
        [self enterPersonalCard:friendId];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contacts memberCountOfGroup:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.contacts groupCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BSContactCell *cell = [tableView dequeueReusableCellWithIdentifier:[BSContactCell cellIdentifier] forIndexPath:indexPath];
    id<NTESGroupMemberProtocol> contactItem = [self.contacts memberOfIndex:indexPath];
    NIMUser *user = nil;
    for (NIMUser *tempUser in self.datas) {
        if ([tempUser.userId isEqualToString:[contactItem memberId]]) {
            user = tempUser;
            break;
        }
    }
    cell.user = user;
    cell.delegate = self;
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.contacts titleOfGroup:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.contacts.sortedGroupTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index + 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除好友" message:@"删除好友后，将同时解除双方的好友关系" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        Bsky_WeakSelf
        [alert showAlertWithCompletionHandler:^(NSInteger index) {
            Bsky_StrongSelf
            if (index == 1) {
                [self deleteFriendWithIndexPath:indexPath];
            }
        }];
    }
}
- (void)deleteFriendWithIndexPath:(NSIndexPath *)indexPath
{
    id<NTESContactItem,NTESGroupMemberProtocol> contactItem = (id<NTESContactItem,NTESGroupMemberProtocol>)[self.contacts memberOfIndex:indexPath];
    NSString *userId = [contactItem userId];
    Bsky_WeakSelf
    [SVProgressHUD show];
    [[NIMSDK sharedSDK].userManager deleteFriend:userId completion:^(NSError *error) {
        [SVProgressHUD dismiss];
        Bsky_StrongSelf
        if (!error) {
            [self.contacts removeGroupMember:contactItem];
        }else{
            [self.view makeToast:@"删除失败"duration:2.0f position:CSToastPositionCenter];
        }
    }];
}
#pragma mark -- BSContactCellDelegate

- (void)bsContactCell:(BSContactCell *)cell onPressAvatar:(NSString *)memberId
{
    [self enterPersonalCard:memberId];
}
#pragma mark - NTESContactUtilCellDelegate
- (void)onPressUtilImage:(NSString *)content{
    [self.view makeToast:[NSString stringWithFormat:@"点我干嘛 我是<%@>",content] duration:2.0 position:CSToastPositionCenter];
}

#pragma mark - NIMContactSelectDelegate
- (void)didFinishedSelect:(NSArray *)selectedContacts{
    
}

#pragma mark - NIMSDK Delegate
- (void)onSystemNotificationCountChanged:(NSInteger)unreadCount
{
    [self refresh];
}

- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK && self.isViewLoaded) {
        [self refresh];
    }
}

- (void)onUserInfoChanged:(NIMUser *)user
{
    [self refresh];
}

- (void)onFriendChanged:(NIMUser *)user{
    [self refresh];
}

- (void)onBlackListChanged
{
    [self refresh];
}

- (void)onMuteListChanged
{
    [self refresh];
}

- (void)refresh
{
    [self prepareData];
    [self.tableView reloadData];
}

#pragma mark - NIMEventSubscribeManagerDelegate

- (void)onRecvSubscribeEvents:(NSArray *)events
{
    NSMutableSet *ids = [[NSMutableSet alloc] init];
    for (NIMSubscribeEvent *event in events) {
        [ids addObject:event.from];
    }
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        
        id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
        if([contactItem respondsToSelector:@selector(userId)]){
            NSString * friendId   = contactItem.userId;
            if ([ids containsObject:friendId]) {
                [indexPaths addObject:indexPath];
            }
        }
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Private
- (void)enterPersonalCard:(NSString *)userId{
    IMDetailController *vc = [[IMDetailController alloc] initWithUser:userId];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
