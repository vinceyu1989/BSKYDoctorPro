//
//  ArchiveManagerCell.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveManagerCell.h"
#import "FamilyListModel.h"
#import "FamilyInfoView.h"
#import "FamilyMemberCell.h"
#import "AppDelegate.h"
#import "BSH5UrlRequest.h"
#import "ArchiveFamilyDetailRequest.h"
#import "UpdateFAViewController.h"


@interface ArchiveManagerCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@property (weak, nonatomic) IBOutlet UIView *subContentView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic ,strong) FamilyInfoView *infoView;
@property (nonatomic ,strong) UITableView *contentTableView;
@property (nonatomic ,strong) UIView *underLineView;
@property (nonatomic ,strong) UIView *updateLineView;
@end

@implementation ArchiveManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self);
//        make.left.mas_equalTo(10);
//        make.right.mas_equalTo(-10);
//    }];
    self.infoView.code.textColor = UIColorFromRGB(0x666666);
    self.infoView.address.textColor = UIColorFromRGB(0x666666);
    self.infoView.name.textColor = UIColorFromRGB(0x666666);
    self.infoView.nameTItle.textColor = UIColorFromRGB(0x666666);
    self.infoView.codeTitle.textColor = UIColorFromRGB(0x666666);
    self.infoView.addressTitle.textColor = UIColorFromRGB(0x666666);
    self.infoView.tel.textColor = UIColorFromRGB(0x666666);
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
    }];
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(id)model{
    _model = model;
    self.title.text = @"家庭档案";
    [self layoutIfNeeded];
    [self.contentTableView removeFromSuperview];
    [self.subContentView addSubview:self.infoView];
    [self.infoView setModel:model];
    self.checkBtn.hidden = NO;
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.subContentView);
    }];
    self.contentView.layer.cornerRadius = 0;
    self.contentView.layer.borderWidth = 0;
//    self.contentView.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
    if ([BSAppManager sharedInstance].currentUser.sysType.integerValue != 2){
        self.updateBtn.hidden = NO;
    }else{
        self.updateBtn.hidden = YES;
    }
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = [dataArray copy];
    self.checkBtn.hidden = YES;
    self.title.text = @"家庭成员";
    [self.infoView removeFromSuperview];
    [self.subContentView addSubview:self.contentTableView];
    [self.contentTableView reloadData];
    [self layoutIfNeeded];
    self.updateBtn.hidden = YES;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.contentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.subContentView);
        make.height.mas_equalTo(self.contentTableView.contentSize.height);
    }];
}
- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:self.subContentView.bounds style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.scrollEnabled = NO;
        _contentTableView.backgroundColor = [UIColor clearColor];
        _contentTableView.backgroundView = nil;
        _contentTableView.separatorInset = UIEdgeInsetsMake(0,15, 0, 15);
        [_contentTableView registerNib:[FamilyMemberCell nib] forCellReuseIdentifier:[FamilyMemberCell cellIdentifier]];
    }
    return _contentTableView;
}
- (FamilyInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[[NSBundle mainBundle] loadNibNamed:@"FamilyInfoView" owner:nil options:nil] firstObject];
    }
    return _infoView;
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
    ArchiveFamilyDetailRequest *request = [[ArchiveFamilyDetailRequest alloc] init];
    request.familyId = [self.model valueForKey:@"FamilyID"];
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveFamilyDetailRequest * _Nonnull request) {
        
        UpdateFAViewController *vc = [[UpdateFAViewController alloc] init];
        vc.detailModel = request.familyModel;
        vc.listModel = self.model;
        AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *viewController = (UITabBarController *)deleate.window.rootViewController;
        UINavigationController *nav = [viewController.viewControllers firstObject];
        [nav pushViewController:vc animated:YES];
        [MBProgressHUD hideHud];
    } failure:^(__kindof ArchiveFamilyDetailRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
- (void)wjwCheck{
    [MBProgressHUD showHud];
    BSH5UrlRequest *request = [[BSH5UrlRequest alloc] init];
    request.type = @"zyFamilyArchives";
    [request startWithCompletionBlockWithSuccess:^(__kindof BSH5UrlRequest * _Nonnull request) {
        
        BSWebViewController *web = [[BSWebViewController alloc] init];
        web.showNavigationBar = NO;
        web.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
        web.ba_web_progressTrackTintColor = [UIColor whiteColor];
        NSString *url = [NSString stringWithFormat:@"%@&familyID=%@",request.urlString,[self.model valueForKey:@"FamilyID"]];
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
    request.type = @"zlFamily";
    [request startWithCompletionBlockWithSuccess:^(__kindof BSH5UrlRequest * _Nonnull request) {
        
        BSWebViewController *web = [[BSWebViewController alloc] init];
        web.showNavigationBar = NO;
        web.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
        web.ba_web_progressTrackTintColor = [UIColor whiteColor];
        NSString *url = request.urlString;
        NSString * jsStr = [NSString stringWithFormat:@"zlFamilyarchivesInfoIos('%@','%@')",[_model valueForKey:@"familyId"],[BSClientManager sharedInstance].tokenId];
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
#pragma mark Delegate & DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FamilyMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:[FamilyMemberCell cellIdentifier] forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    cell.listModel = self.listModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"coutn is .....%d",[self.dataArray count]);
    return [self.dataArray count];
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

@end
