//
//  BSGroupListVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/5/14.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSGroupListVC.h"
#import "NTESSessionViewController.h"
#import "BSContactCell.h"
#import <NIMKit/NIMNormalTeamCardViewController.h>

@interface BSGroupListVC ()<NIMTeamManagerDelegate,BSContactCellDelegate,NIMLoginManagerDelegate>

@property (strong, nonatomic) NSMutableArray *myTeams;

@end

@implementation BSGroupListVC

- (void)dealloc{
    [[NIMSDK sharedSDK].teamManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTeams = [self fetchTeams];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[BSContactCell nib] forCellReuseIdentifier:[BSContactCell cellIdentifier]];
    [[NIMSDK sharedSDK].teamManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
}
- (void)refresh
{
    self.myTeams = [self fetchTeams];
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myTeams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSContactCell *cell = [tableView dequeueReusableCellWithIdentifier:[BSContactCell cellIdentifier]];
    NIMTeam *team = [self.myTeams objectAtIndex:indexPath.row];
    cell.team = team;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NIMTeam *team = [self.myTeams objectAtIndex:indexPath.row];
    NIMSession *session = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)fetchTeams{
    NSMutableArray *myTeams = [[NSMutableArray alloc]init];
    for (NIMTeam *team in [NIMSDK sharedSDK].teamManager.allMyTeams) {
        if (team.type == NIMTeamTypeNormal) {
            [myTeams addObject:team];
        }
    }
    return myTeams;
}

- (void)onTeamUpdated:(NIMTeam *)team{
    if (team.type == NIMTeamTypeNormal) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}

- (void)onTeamRemoved:(NIMTeam *)team{
    if (team.type == NIMTeamTypeNormal) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}

- (void)onTeamAdded:(NIMTeam *)team{
    if (team.type == NIMTeamTypeNormal) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}

#pragma mark ---- BSContactCellDelegate

- (void)bsContactCell:(BSContactCell *)cell onPressAvatar:(NSString *)memberId
{
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:memberId];
    NIMNormalTeamCardViewController *vc = [[NIMNormalTeamCardViewController alloc] initWithTeam:team];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK && self.isViewLoaded) {
        [self refresh];
    }
}

@end
