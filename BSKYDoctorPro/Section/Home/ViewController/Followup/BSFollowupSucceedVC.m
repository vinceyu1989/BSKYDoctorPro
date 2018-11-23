//
//  BSFollowupSucceedVC.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/15.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowupSucceedVC.h"
#import "BSFriendVerifyRequest.h"
#import <NIMKit/NIMMessageMaker.h>

@interface BSFollowupSucceedVC ()<NIMUserManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *eduButton;

@property (nonatomic ,strong) BSFriendVerifyRequest *request;

@end

@implementation BSFollowupSucceedVC

+ (instancetype)viewControllerFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}
- (instancetype)init
{
    self = [BSFollowupSucceedVC viewControllerFromStoryboard];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"提交成功";
    [self setupView];
    [self loadData];
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
}
- (void)loadData
{
    self.request = [[BSFriendVerifyRequest alloc]init];
    self.request.idcard = self.idcard;
    self.request.realname = self.realName;
    Bsky_WeakSelf
    [MBProgressHUD showHud];
    [self.request startWithCompletionBlockWithSuccess:^(__kindof BSFriendVerifyRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        Bsky_StrongSelf
        CGPoint backCenter = self.backButton.center;
        if(request.model.isVerified) {
            self.addBtn.hidden = [[NIMSDK sharedSDK].userManager isMyFriend:request.model.mobileNo];
        } else {
            self.addBtn.hidden = YES;
        }
        if (self.addBtn.hidden) {
            self.backButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), backCenter.y);
        } else {
            self.backButton.center = backCenter;
        }
     
      } failure:^(__kindof BSFriendVerifyRequest * _Nonnull request) {
          [MBProgressHUD hideHud];
      }];
}


#pragma mark - 

- (void)setupView {
    self.backButton.layer.borderColor = UIColorFromRGB(0x4e7dd3).CGColor;
    self.backButton.layer.borderWidth = .5f;
    self.backButton.layer.cornerRadius = 5;
    
    self.addBtn.layer.borderColor = UIColorFromRGB(0x4e7dd3).CGColor;
    self.addBtn.layer.borderWidth = .5f;
    self.addBtn.layer.cornerRadius = 5;
    self.addBtn.hidden = YES;
    
    self.eduButton.layer.borderColor = UIColorFromRGB(0x4e7dd3).CGColor;
    self.eduButton.layer.borderWidth = .5f;
    self.eduButton.layer.cornerRadius = 5;
}

#pragma mark - UI Actions 

- (IBAction)onBack:(id)sender {
    if (self.backBlock) {
        self.backBlock();
    }
    if (self.followupType == FollowupTypeHypertension) {
        [self postNotification:kHyFollowupSaveSuccess];
    }
    else if (self.followupType == FollowupTypeDiabetes)
    {
        [self postNotification:kDbFollowupSaveSuccess];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addBtnPressed:(UIButton *)sender {
    
    NIMUserRequest *request = [[NIMUserRequest alloc] init];
    request.userId          = self.request.model.mobileNo;            //封装用户ID
    request.operation       = NIMUserOperationAdd;                    //封装验证方式
    request.message         = @"请求添加好友";                          //封装自定义验
    Bsky_WeakSelf
    [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError * _Nullable error) {
        if (!error) {
            Bsky_StrongSelf
            [UIView makeToast:@"好友添加成功"];
            NIMSession *session = [NIMSession session:[NIMSDK sharedSDK].loginManager.currentAccount  type:NIMSessionTypeP2P];
            NIMMessage *message = [NIMMessageMaker msgWithText:@"我们已经是好友了，现在可以开始聊天了"];
            NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
            setting.historyEnabled = NO;
            setting.roamingEnabled = NO;
            setting.apnsEnabled = NO;
            setting.shouldBeCounted = NO;
            setting.syncEnabled    = NO;
            message.setting = setting;
            [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:nil];
            [self onBack:self.backButton];
        }
    }];
}

- (IBAction)respondseToEduVC:(id)sender {
    if (self.backRootBlock) {
        self.backRootBlock();
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
