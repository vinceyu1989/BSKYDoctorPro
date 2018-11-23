//
//  FamilyMemberCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "FamilyMemberCell.h"
#import "AppDelegate.h"
#import "UpdatePAViewController.h"
#import "ArchivePersonDetailRequest.h"

@interface FamilyMemberCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (nonatomic ,strong) UIView *underLineView;
@property (nonatomic ,strong) UIView *updateLineView;
@end

@implementation FamilyMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.checkBtn addSubview:self.underLineView];
    
    [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.checkBtn);
        make.left.right.equalTo(self.checkBtn);
        make.height.mas_equalTo(0.5);
    }];
    if ([BSAppManager sharedInstance].currentUser.sysType.integerValue != 2) {
        [self.updateBtn addSubview:self.updateLineView];
        [self.updateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.updateBtn);
            make.left.right.equalTo(self.updateBtn);
            make.height.mas_equalTo(0.5);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIView *)underLineView{
    if (!_underLineView) {
        _underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _underLineView.backgroundColor = UIColorFromRGB(0x4e7dd3);
    }
    return _underLineView;
}
- (UIView *)updateLineView{
    if (!_updateLineView) {
        _updateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _updateLineView.backgroundColor = UIColorFromRGB(0x4e7dd3);
    }
    return _updateLineView;
}
- (void)setModel:(FamilyMemberListModel *)model{
    _model = model;
    if([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2){
        ZLFamilyMemberListModel *member = (ZLFamilyMemberListModel *)model;
        self.name.text = member.name;
        self.updateBtn.hidden = YES;
        self.tel.text = [member.telPhone secretStrFromPhoneStr];
    }else{
        self.name.text = model.Name;
        self.updateBtn.hidden = NO;
        self.tel.text = [model.CardID secretStrFromIdentityCard];
    }
}
- (IBAction)checkAction:(id)sender {
    if ([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2) {
        [self zlCheck];
    }else{
        [self wjwCheck];
    }
    
}
- (IBAction)updateAction:(id)sender {
    [MBProgressHUD showHud];
    ArchivePersonDetailRequest *request = [[ArchivePersonDetailRequest alloc] init];
    request.personId = self.model.PersonId;
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchivePersonDetailRequest * _Nonnull request) {
        Bsky_StrongSelf;
        UpdatePAViewController *vc = [[UpdatePAViewController alloc] init];
        vc.personModel = request.personModel;
        vc.listModel = self.listModel;
        AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *viewController = (UITabBarController *)deleate.window.rootViewController;
        UINavigationController *nav = [viewController.viewControllers firstObject];
        [nav pushViewController:vc animated:YES];
        [MBProgressHUD hideHud];
    } failure:^(__kindof ArchivePersonDetailRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
- (void)wjwCheck{
    [MBProgressHUD showHud];
    BSH5UrlRequest *request = [[BSH5UrlRequest alloc] init];
    request.type = @"zyPersonArchive";
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof BSH5UrlRequest * _Nonnull request) {
        Bsky_StrongSelf;
        BSWebViewController *web = [[BSWebViewController alloc] init];
        web.showNavigationBar = NO;
        web.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
        web.ba_web_progressTrackTintColor = [UIColor whiteColor];
        NSString *url = [NSString stringWithFormat:@"%@&personalID=%@",request.urlString,[self.model valueForKey:@"PersonId"]];
        [web ba_web_loadURLString:url];
        AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *viewController = (UITabBarController *)deleate.window.rootViewController;
        UINavigationController *nav = [viewController.viewControllers firstObject];
        [nav pushViewController:web animated:YES];
        [MBProgressHUD hideHud];
    } failure:^(__kindof BSH5UrlRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
- (void)zlCheck{
    [MBProgressHUD showHud];
    BSH5UrlRequest *request = [[BSH5UrlRequest alloc] init];
    request.type = @"zlPersonal";
    [request startWithCompletionBlockWithSuccess:^(__kindof BSH5UrlRequest * _Nonnull request) {
        BSWebViewController *web = [[BSWebViewController alloc] init];
        web.showNavigationBar = NO;
        web.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
        web.ba_web_progressTrackTintColor = [UIColor whiteColor];
        NSString *url = request.urlString;
        NSString * jsStr = [NSString stringWithFormat:@"zlPersondetailIos('%@','%@')",[_model valueForKey:@"cardId"],[BSClientManager sharedInstance].tokenId];
        web.ocTojsStr = jsStr;
        [web ba_web_loadURLString:url];
        AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate; 
        UITabBarController *viewController = (UITabBarController *)deleate.window.rootViewController;
        UINavigationController *nav = [viewController.viewControllers firstObject];
        [nav pushViewController:web animated:YES];
        [MBProgressHUD hideHud];
    } failure:^(__kindof BSH5UrlRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
@end
