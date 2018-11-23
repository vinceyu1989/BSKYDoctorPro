//
//  IMDetailController.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/15.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "IMDetailController.h"
#import "IMDetailCell.h"
#import "IMRemarkCell.h"
#import "IMDetailLabelCell.h"
#import "NTESSessionViewController.h"
#import "NTESBundleSetting.h"
#import "IMDetailLabelView.h"
#import "IMDetailRemarkController.h"
#import "IMEXModel.h"
#import "NIMMessageMaker.h"

@interface IMDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *contentTableView;
@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,assign) IMDetailType type;
@property (nonatomic ,assign) IMDetailAccountType accoutType;
@property (nonatomic ,strong) NIMUser *user;
@property (nonatomic ,strong) NSString *remark;
@property (nonatomic ,strong) NSString *exStr;
@end

@implementation IMDetailController
- (instancetype)initWithUser:(NSString *)userId
{
    self = [super init];
    if (self) {
//        _type = type;
        if ([userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
            return nil;
        }
        _type = [[NIMSDK sharedSDK].userManager isMyFriend:userId] ? IMDetailTypeDetail : IMDetailTypeAdd;
        
        if (_type == IMDetailTypeAdd) {
            [self fetchUserWhithUserID:userId];
        }else{
            self.user = [[NIMSDK sharedSDK].userManager userInfo:userId];
            [self updateAccoutType];
        }
        
    }
    return self;
}
- (void)updateAccoutType{
    if (self.user.userInfo.ext) {
        IMEXModel *model = [IMEXModel mj_objectWithKeyValues:[self.user.userInfo.ext mj_JSONObject]];
        if (model.professionType.integerValue == 1) {
            self.accoutType = IMDetailAccountTypeDoctor;
        }else{
            self.accoutType = IMDetailAccountTypePatient;
        }
    }
}
- (void)creatUI{
    self.title = @"个人资料";
    [self.view addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}
- (void)fetchUserWhithUserID:(NSString *)userId{
    Bsky_WeakSelf;
    [MBProgressHUD showHud];
    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId] completion:^(NSArray *users, NSError *error) {
        Bsky_StrongSelf;
        [MBProgressHUD hideHud];
        if (users.count) {
            self.user = users.firstObject;
            [self updateAccoutType];
            [self.contentTableView reloadData];
//            NTESPersonalCardViewController *vc = [[NTESPersonalCardViewController alloc] initWithUserId:userId];
//            [wself.navigationController pushViewController:vc animated:YES];
        }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户不存在" message:@"请检查你输入的帐号是否正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UI
- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_contentTableView setDelegate:self];
        [_contentTableView setDataSource:self];
        [_contentTableView setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
        [_contentTableView setBackgroundView:nil];
        [_contentTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_contentTableView registerNib:[IMDetailCell nib] forCellReuseIdentifier:[IMDetailCell cellIdentifier]];
        [_contentTableView registerNib:[IMDetailLabelCell nib] forCellReuseIdentifier:[IMDetailLabelCell cellIdentifier]];
        [_contentTableView registerNib:[IMRemarkCell nib] forCellReuseIdentifier:[IMRemarkCell cellIdentifier]];
    }
    return _contentTableView;
}
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        if (_type == IMDetailTypeAdd) {
            [_footerView setFrame:CGRectMake(0, 0, self.view.width,100)];
            [_footerView setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addBtn setBackgroundColor:UIColorFromRGB(0x4e7dd3)];
            [addBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
            [addBtn setTitle:@"加为好友" forState:UIControlStateNormal];
            addBtn.layer.cornerRadius = 5.0;
            [_footerView addSubview:addBtn];
            [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50);
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.top.mas_equalTo(20);
            }];
        }else{
            [_footerView setFrame:CGRectMake(0, 0, self.view.width,150)];
            [_footerView setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
            
            UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendBtn setBackgroundColor:UIColorFromRGB(0x4e7dd3)];
            [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
            [sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
            sendBtn.layer.cornerRadius = 5.0;
            [_footerView addSubview:sendBtn];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setBackgroundColor:UIColorFromRGB(0xff9000)];
            [deleteBtn addTarget:self action:@selector(deleteFriend:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setTitle:@"删除好友" forState:UIControlStateNormal];
            deleteBtn.layer.cornerRadius = 5.0;
            [_footerView addSubview:deleteBtn];
            
            
            [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50);
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.top.mas_equalTo(20);
            }];
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50);
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.top.equalTo(sendBtn.mas_bottom).offset(10);
            }];
        }
        
        
    }
    return _footerView;
}
#pragma mark Action
- (void)pushToRemarkVC{
    IMDetailRemarkController *vc = [[IMDetailRemarkController alloc] init];
    Bsky_WeakSelf;
    vc.text = self.user.alias;
    vc.saveBlock = ^(NSString *remark) {
        Bsky_StrongSelf;
        
        if (self.type == IMDetailTypeAdd) {
            self.remark = remark;
            [self.contentTableView reloadData];
        }else{
            self.user.alias = remark;
            [self updateUserFriendInfo:self.user successBolck:nil];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)showLabelView{
    IMDetailLabelView *view = [[IMDetailLabelView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) selectArray:nil value:self.user.ext];
    Bsky_WeakSelf;
    view.block = ^(NSString *value) {
        Bsky_StrongSelf;
        
        NSString *str = [[NSDictionary dictionaryWithObjectsAndKeys:value,@"userLabel", nil] mj_JSONString];
        
        if (self.type == IMDetailTypeAdd) {
            if (value.length) {
                self.exStr = str;
            }else{
                self.exStr = nil;
            }
            [self.contentTableView reloadData];
        }else{
            if (value.length) {
                self.user.ext = str;
                [self updateUserFriendInfo:self.user successBolck:nil];
            }else{
                [UIView makeToast:@"请您先设置标签!"];
            }
            
            
        }
    };
    [view show];
}
- (void)updateUserFriendInfo:(NIMUser *)user successBolck:(UpdateSuccessBlock )block{
    Bsky_WeakSelf;
    [MBProgressHUD showHud];
    [[NIMSDK sharedSDK].userManager updateUser:user completion:^(NSError *error) {
        Bsky_StrongSelf;
        [MBProgressHUD hideHud];
        if (!error) {
            if (self.type == IMDetailTypeDetail) {
                [UIView makeToast:@"用户信息更新成功!"];
            }
            
            [self.contentTableView reloadData];
            if (block) {
                block();
            }
        }else{
            if (self.type == IMDetailTypeDetail) {
                [UIView makeToast:@"用户信息更新失败!"];
            }
        }
    }];
}
- (void)addFriend:(id )sender{
//    UIAlertController *alter = [[UIAlertController alloc] init];
//    Bsky_WeakSelf;
//    UIAlertAction *deletAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    if (_type == IMDetailTypeAdd && _accoutType == IMDetailAccountTypePatient && !self.exStr.length) {
        [UIView makeToast:@"请您先设置标签!"];
        return;
    }
        [MBProgressHUD showHud];
//        Bsky_StrongSelf;
        NIMUserRequest *request = [[NIMUserRequest alloc] init];
        request.userId = self.user.userId;
        request.operation = NIMUserOperationAdd;
        if ([[NTESBundleSetting sharedConfig] needVerifyForFriend]) {
            request.operation = NIMUserOperationRequest;
            request.message = @"请求通过";
        }
        NSString *successText = request.operation == NIMUserOperationAdd ? @"添加成功" : @"请求成功";
        NSString *failedText =  request.operation == NIMUserOperationAdd ? @"添加失败" : @"请求失败";
        
//        __weak typeof(self) wself = self;
        [MBProgressHUD showHud];
        Bsky_WeakSelf;
        [[NIMSDK sharedSDK].userManager requestFriend:request completion:^(NSError *error) {
            [MBProgressHUD hideHud];
            Bsky_StrongSelf;
            if (!error) {
                [UIView makeToast:successText];
                if (request.operation == NIMUserOperationAdd && [self.delegate respondsToSelector:@selector(addFriendSuccess:)]) {
                    [self.delegate addFriendSuccess:self.user];
                }
//                [self.navigationController popViewControllerAnimated:YES];
//                [wself refresh];
                self.user = [[NIMSDK sharedSDK].userManager userInfo:self.user.userId];
                self.user.ext = self.exStr.length ? self.exStr : @"";
                self.user.alias = self.remark.length ? self.remark : @"";
                Bsky_WeakSelf;
                [self updateUserFriendInfo:self.user successBolck:^{
//                    [self sendAction:nil];
                    Bsky_StrongSelf;
                    [self sendMessageAddMessage];
                    
                }];
            }else{
                [UIView makeToast:failedText];
            }
        }];
        
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [alter dismissViewControllerAnimated:YES completion:nil];
//    }];
//    alter.message = @"删除好友后，将同时解除双方的好友关系!";
//    alter.title = @"删除好友";
//    [alter addAction:deletAction];
//    [alter addAction:cancelAction];
//    [self presentViewController:alter animated:YES completion:nil];
    
}
- (void)sendMessageAddMessage{
    NIMSession *session = [NIMSession session:self.user.userId type:NIMSessionTypeP2P];
    NIMMessage *message = [NIMMessageMaker msgWithText:@"我们已经是好友了，现在可以开始聊天了"];
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.historyEnabled = NO;
    setting.roamingEnabled = NO;
    setting.apnsEnabled = NO;
    setting.shouldBeCounted = NO;
    setting.syncEnabled    = NO;
    message.setting = setting;
    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:nil];
    UINavigationController *nav = self.navigationController;
//    NIMSession *session = [NIMSession session:self.user.userId type:NIMSessionTypeP2P];
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:vc animated:YES];
    UIViewController *root = nav.viewControllers[0];
    nav.viewControllers = @[root,vc];
}
- (void)sendAction:(id )sender{
    UINavigationController *nav = self.navigationController;
    NIMSession *session = [NIMSession session:self.user.userId type:NIMSessionTypeP2P];
    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:vc animated:YES];
    UIViewController *root = nav.viewControllers[0];
    nav.viewControllers = @[root,vc];
}
- (void)deleteFriend:(id )sender{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"删除好友" message:@"删除好友后，将同时解除双方的好友关系!" preferredStyle:UIAlertControllerStyleAlert];
    Bsky_WeakSelf;
    UIAlertAction *deletAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHud];
        Bsky_StrongSelf;
        NSString *userId = [self.user userId];
        Bsky_WeakSelf;
        [[NIMSDK sharedSDK].userManager deleteFriend:userId completion:^(NSError *error) {
            Bsky_StrongSelf;
            [MBProgressHUD hideHud];
            if (!error) {
//                [_contacts removeGroupMember:contactItem];
                if (self.delegate && [self.delegate respondsToSelector:@selector(delectFriendSuccess:)]) {
                    [self.delegate delectFriendSuccess:self.user];
                }
                [UIView makeToast:@"删除成功"];
                [self cleanSession];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [UIView makeToast:@"删除失败"];
            }
        }];
        
      }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alter dismissViewControllerAnimated:YES completion:nil];
    }];
    
//    alter.message = @"删除好友后，将同时解除双方的好友关系!";
//    alter.title = @"删除好友";
    [alter addAction:deletAction];
    [alter addAction:cancelAction];
    [self presentViewController:alter animated:YES completion:nil];
}
- (void)cleanSession{
    BOOL removeRecentSession = [NTESBundleSetting sharedConfig].removeSessionWhenDeleteMessages;
    BOOL removeTable = [NTESBundleSetting sharedConfig].dropTableWhenDeleteMessages;
    NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
    option.removeSession = removeRecentSession;
    option.removeTable = removeTable;
    NIMSession *session = [NIMSession session:self.user.userId type:NIMSessionTypeP2P];
    [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:session
                                                                option:option];
}
#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.accoutType == IMDetailAccountTypePatient && !indexPath.row) {
            [self showLabelView];
        }else{
            [self pushToRemarkVC];
        }
    }
}
- (UITableViewCell *)initlationCellWithIndexPath:(NSIndexPath *)index{
    if (!index.section) {
        IMDetailCell *cell = [self.contentTableView dequeueReusableCellWithIdentifier:[IMDetailCell cellIdentifier] forIndexPath:index];
        cell.user = self.user != nil ? self.user : self.friendUser;
        return cell;
    }else{
        if (self.accoutType == IMDetailAccountTypeDoctor) {
            IMRemarkCell *cell = [self.contentTableView dequeueReusableCellWithIdentifier:[IMRemarkCell cellIdentifier] forIndexPath:index];
            if (self.type == IMDetailTypeAdd) {
                cell.remark = self.remark;
            }else{
                cell.remark = self.user.alias;
            }
            
            return cell;
        }else{
            if (!index.row) {
                IMDetailLabelCell *cell = [self.contentTableView dequeueReusableCellWithIdentifier:[IMDetailLabelCell cellIdentifier] forIndexPath:index];
                
                if (self.type == IMDetailTypeAdd) {
                    NIMUser *user = [[NIMUser alloc] init];
                    user.ext = self.exStr;
                    cell.user = user;
                }else{
                    cell.user = self.user;
                }
                return cell;
            }else{
                IMRemarkCell *cell = [self.contentTableView dequeueReusableCellWithIdentifier:[IMRemarkCell cellIdentifier] forIndexPath:index];
                if (self.type == IMDetailTypeAdd) {
                    cell.remark = self.remark;
                }else{
                    cell.remark = self.user.alias;
                }
                return cell;
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self initlationCellWithIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
//    IMDetailCell *cell = [self.contentTableView dequeueReusableCellWithIdentifier:[IMDetailCell cellIdentifier] forIndexPath:indexPath];
////    cell.remark = self.user.alias;
//    return cell;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section) {
        if (_accoutType == IMDetailAccountTypePatient) {
            return 2;
        }else{
            return 1;
        }
    }else{
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section) {
//        return nil;
        return self.footerView;
    }else{
        return nil;
    }
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section) {
//        return 10;
        return self.footerView.height;
    }else{
        return 10.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
