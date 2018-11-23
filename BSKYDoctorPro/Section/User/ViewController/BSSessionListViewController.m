//
//  BSSessionListViewController.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSSessionListViewController.h"
#import "BSTabBarController.h"
#import "NTESSessionViewController.h"
#import "NIMAvatarImageView.h"
#import "IMSearchResultVC.h"
#import "NTESRobotCardViewController.h"
#import "NIMNormalTeamCardViewController.h"
#import "NIMAdvancedTeamCardViewController.h"
#import "BSContactCell.h"
#import "IMDetailController.h"
#import "NTESLinkAttachment.h"
#import "NTESSessionUtil.h"

@interface BSSessionListViewController ()

@property (nonatomic ,strong) UIImageView *emptyImageView;

@end

@implementation BSSessionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)refresh
{
    [self.recentSessions removeAllObjects];
    [self.recentSessions addObjectsFromArray:[NIMSDK sharedSDK].conversationManager.allRecentSessions];
    [super refresh];
    self.emptyImageView.hidden = self.recentSessions.count > 0;
}
#pragma mark -

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath
{
    NTESSessionViewController *viewController = [[NTESSessionViewController alloc] initWithSession:recent.session];
    [self.parentViewController.navigationController pushViewController:viewController animated:YES];
}
- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath
{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        UIViewController *vc;
        if ([[NIMSDK sharedSDK].robotManager isValidRobot:recent.session.sessionId])
        {
            vc = [[NTESRobotCardViewController alloc] initWithUserId:recent.session.sessionId];
        }
        else
        {
            vc = [[IMDetailController alloc]initWithUser:recent.session.sessionId];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (recent.session.sessionType == NIMSessionTypeTeam)
    {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        UIViewController *vc;
        if (team.type == NIMTeamTypeNormal) {
            vc = [[NIMNormalTeamCardViewController alloc] initWithTeam:team];
        }else if(team.type == NIMTeamTypeAdvanced){
            vc = [[NIMAdvancedTeamCardViewController alloc] initWithTeam:team];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"messages_list_empty_bg"]];
        [_emptyImageView sizeToFit];
        _emptyImageView.bounds = CGRectMake(0, 0, self.view.width, self.view.width * (_emptyImageView.height/_emptyImageView.width));
        _emptyImageView.center = CGPointMake(self.view.width/2, (self.view.height-TOP_BAR_HEIGHT)/2);
        [self.view addSubview:_emptyImageView];
    }
    return _emptyImageView;
}
#pragma mark --- NIMLoginManagerDelegate

- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK && self.isViewLoaded) {
        [self refresh];
    }
}
- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent{
    NSAttributedString *content;
    if (recent.lastMessage.messageType == NIMMessageTypeCustom)
    {
        NIMCustomObject *object = recent.lastMessage.messageObject;
        NSString *text = @"";
        if ([object.attachment isKindOfClass:[NTESLinkAttachment class]]) {
            text = @"[患者资料]";
        }
        else
        {
            text = @"[未知消息]";
        }
        if (recent.session.sessionType != NIMSessionTypeP2P)
        {
            NSString *nickName = [NTESSessionUtil showNick:recent.lastMessage.from inSession:recent.lastMessage.session];
            text =  nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
        }
        content = [[NSAttributedString alloc] initWithString:text];
    }
    else
    {
        content = [super contentForRecentSession:recent];
    }
    NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithAttributedString:content];
//    [super checkNeedAtTip:recent content:attContent];
//    [super checkOnlineState:recent content:attContent];
    return attContent;
}
@end
