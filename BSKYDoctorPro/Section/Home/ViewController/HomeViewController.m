//
//  HomeViewController.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/15.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GridItemModel.h"
#import "HomeMenuView.h"
#import "HomeHeadBtn.h"
#import "TeamPickerView.h"
#import "BSGongWeiViewController.h"
#import "BSAppUpdateView.h"
#import "BSInStationMsgViewController.h"
#import "BSFollowupViewController.h"
#import "BSServiceLogViewController.h"
#import "ScanViewController.h"
#import "BSSignChooseViewController.h"
#import "CreatFAViewController.h"
#import "ResidentManageVC.h"
#import "FamilyListViewController.h"
#import "HealthScanRequest.h"
#import "ZLAccountVerifyRequest.h"
#import "ZLAccountBindingVC.h"
#import "BSTotalMessageRequest.h"
#import "BSSignViewController.h"
#import "BSHomeWorkRemindRequest.h"
#import "BSDiseaseManagerVC.h"
#import "BskyBaseNetConfig.h"
#import "PatientListViewController.h"
#import "BSShareViewController.h"
#import "BSGiveTreatmentVC.h"
#import "PEController.h"

@interface HomeViewController ()<HomeMenuViewDelegate>

@property (weak, nonatomic) IBOutlet HomeMenuView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *QRBtn;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *messageImage;
@property (weak, nonatomic) IBOutlet UILabel *numMessageLabel;

@property (nonatomic, weak) IBOutlet UILabel *signedCountValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *followUpCountValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *putOnRecordCountValueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTopLayoutConstraint;

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, copy) NSString *tuanduiUrlString;             // 团队管理
@property (nonatomic ,copy) NSString *signListUrlString;            // 签约列表
@property (nonatomic ,copy) NSString *familySignUrlString;          // 家庭签约
@property (nonatomic ,copy) NSString *zyFollowUpUrlString;          // 中医随访
@property (nonatomic ,copy) NSString *remindWorkUrlString;          //工作提醒

@property (nonatomic ,strong) BSH5UrlRequest     *urlRequest;
@property (nonatomic, strong) HealthScanRequest *scanRequest;
@property (nonatomic, strong) BSTotalMessageRequest *totalMsgRequest;

@property (nonatomic, assign) NSInteger requestIndex;

@end

@implementation HomeViewController

+ (instancetype)viewControllerFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}
// 状态栏处理
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMesssgeView];
    [self observeNotificaiton:LoginSuccessNotification selector:@selector(chageTitle)];
    [self observeNotificaiton:LogoutNotification selector:@selector(logout)];
    [self observeNotificaiton:AuditChangeNotification selector:@selector(auditChang)];
    [self observeNotificaiton:kPhisInfoUpdate selector:@selector(updateWorkRemind)];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateWorkRemind];
    [self updateStaticTitle];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)dealloc {
    [self unobserveAllNotification];
}

#pragma mark - Notifier
- (void)logout {
    self.tuanduiUrlString = nil;
    self.signListUrlString = nil;
    self.familySignUrlString = nil;
    self.zyFollowUpUrlString = nil;
    self.remindWorkUrlString = nil;
    self.signedCountValueLabel.text = @"-";
    self.followUpCountValueLabel.text = @"-";
    self.putOnRecordCountValueLabel.text = @"-";
}

- (void)chageTitle {
    
    self.requestIndex = 0;
    [self loadData];
    [self.titleBtn setTitle:[BSAppManager sharedInstance].currentUser.organizationName forState:UIControlStateNormal];
}
//工作提醒红点
- (void)updateWorkRemind{
    if (![BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID.length || ![BSAppManager sharedInstance].currentUser.phisInfo.OrgId.length) {
        return;
    }
    BSHomeWorkRemindRequest *request = [[BSHomeWorkRemindRequest alloc] init];
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof BSHomeWorkRemindRequest * _Nonnull request) {
        Bsky_StrongSelf;
        [self.contentView setRedPointIndex:6 on:request.remind];
    } failure:^(__kindof BSHomeWorkRemindRequest * _Nonnull request) {
        
    }];
}
- (void)initMesssgeView {
    
    self.numMessageLabel.backgroundColor = [UIColor redColor];
    self.numMessageLabel.textColor = [UIColor whiteColor];
    self.numMessageLabel.layer.cornerRadius = 8;
    self.numMessageLabel.layer.masksToBounds = YES;
    self.numMessageLabel.font = [UIFont systemFontOfSize:15];
    self.numMessageLabel.hidden = YES;
    
    self.totalMsgRequest = [[BSTotalMessageRequest alloc] init];
    Bsky_WeakSelf
    [self.totalMsgRequest startWithCompletionBlockWithSuccess:^(__kindof BSTotalMessageRequest * _Nonnull request) {
        Bsky_StrongSelf
        self.numMessageLabel.text = self.totalMsgRequest.num;
        self.numMessageLabel.hidden = [self.totalMsgRequest.num integerValue]>0 ? NO : YES;
    } failure:^(__kindof BSTotalMessageRequest * _Nonnull request) {
        NSLog(@"error request is ....%@",request);
        NSLog(@"error is ......%@",request.error.localizedDescription);
    }];
}

- (void)isHiddenMessageView:(BOOL)isHidden {
    self.messageImage.hidden = isHidden;
    self.messageBtn.hidden = isHidden;
}
#pragma mark - initData
- (void)setupView {
    [self.titleBtn addTarget:self action:@selector(titleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.titleBtn.userInteractionEnabled = NO;  // 取消
    [self.QRBtn addTarget:self action:@selector(QBBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    self.bgTopLayoutConstraint.constant = - STATUS_BAR_HEIGHT;
    
    [self.view insertSubview:self.shadowView belowSubview:self.contentView];
    self.contentView.bounds = self.shadowView.bounds;
    [self.contentView setCornerRadius:5];
    
    [self updateContentView];
} 
//首页统计的数据 现改过页面刷新时调一次，登录成功时调一次
- (void)loadData {
    self.requestIndex++;
    [self updateStaticTitle];
//    if (self.requestIndex > 3) {
//        return;
//    }
//    WS(weakSelf);
//    BSHomeStatisticRequest* request = [[BSHomeStatisticRequest alloc]init];
//    [request startWithCompletionBlockWithSuccess:^(BSHomeStatisticRequest* request) {
//        weakSelf.signedCountValueLabel.text = request.signedCount;
//        weakSelf.followUpCountValueLabel.text = request.followUpCount;
//        weakSelf.putOnRecordCountValueLabel.text = request.putOnRecordCount;
//    } failure:^(BSHomeStatisticRequest* request) {
//        [weakSelf loadData];
//    }];
}
//非登录时调用数据统计接口
- (void)updateStaticTitle{
    if (!self.requestIndex) {
        return;
    }
    BSHomeStatisticRequest* request = [[BSHomeStatisticRequest alloc]init];
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(BSHomeStatisticRequest* request) {
        Bsky_StrongSelf;
        self.signedCountValueLabel.text = request.signedCount;
        self.followUpCountValueLabel.text = request.followUpCount;
        self.putOnRecordCountValueLabel.text = request.putOnRecordCount;
    } failure:^(BSHomeStatisticRequest* request) {
        
    }];
}
#pragma mark - UI Actions

- (void)titleBtnPressed
{
    TeamPickerView *pickerView = [[TeamPickerView alloc]init];
    
    NSArray *items = @[@"随便测试",@"安顺达所",@"安顺达所大所大大",@"事大事大所大",@"安顺达所大所"];
    [pickerView setItems:items title:@"请选择团队" defaultStr:self.titleBtn.titleLabel.text];
    [pickerView show];
    
    Bsky_WeakSelf
    pickerView.selectedIndex = ^(NSInteger index){
        Bsky_StrongSelf
        [self.titleBtn setTitle:items[index] forState:UIControlStateNormal];
    };
}

- (void)QBBtnPressed {
    
    self.scanRequest = [[HealthScanRequest alloc] init];
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        ScanViewController *scan = [[ScanViewController alloc] init];
        scan.block = ^(ScanViewController *vc, NSString *scanCode) {
            [vc.navigationController popViewControllerAnimated:YES];
        };
        [self.navigationController pushViewController:scan animated:YES];
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (IBAction)onMessage:(id)sender {
    
    WS(weakSelf);
    BSInStationMsgViewController *vc = [[BSInStationMsgViewController alloc]init];
    vc.block = ^(NSInteger msgNum) {
        weakSelf.numMessageLabel.text = [NSString stringWithFormat:@"%ld",msgNum];
        if (msgNum <= 0) {
            weakSelf.numMessageLabel.hidden = YES;
        } else {
            weakSelf.numMessageLabel.hidden = NO;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)signUserBtnPressed:(UIButton *)sender {
    if (![self.signedCountValueLabel.text isNumText] || self.signedCountValueLabel.text.integerValue < 1) {
        [UIView makeToast:@"暂无签约数据，请签约成功后重新查询！"];
        return;
    }
    Bsky_WeakSelf
    [MBProgressHUD showHud];
    [self checkAccountStatusWithBlock:^(BOOL reject) {
        [MBProgressHUD hideHud];
        Bsky_StrongSelf
        if (!reject) {
            BSWebViewController *webVC = [[BSWebViewController alloc]init];
            webVC.showNavigationBar = NO;
            webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
            webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
            if (!self.signListUrlString) {
                [self loadUrlStringWithType:kSignListUrlType block:^(NSString *urlString) {
                    Bsky_StrongSelf
                    [webVC ba_web_loadURLString:self.signListUrlString];
                    [self.navigationController pushViewController:webVC animated:YES];
                }];
            }else {
                [webVC ba_web_loadURLString:self.signListUrlString];
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
    }];
}
- (IBAction)followupCountBtnPressed:(UIButton *)sender {
    if ([BSAppManager sharedInstance].isAudit == NO) {
        [UIView makeToast:@"该功能暂未开放"];
    }
}
- (IBAction)filingBtnPressed:(UIButton *)sender {
    if ([BSAppManager sharedInstance].isAudit == NO) {
        [UIView makeToast:@"该功能暂未开放"];
    }
}
#pragma mark - Setter Getter

- (UIView *)shadowView
{
    if (!_shadowView) {
        UIImage *image = [UIImage imageNamed:@"BG"];
        CGRect shadowViewFrame = CGRectMake(20, image.size.height - 9, SCREEN_WIDTH - 40, SCREEN_HEIGHT - BOTTOM_BAR_HEIGHT - 20 - image.size.height + 9);
        _shadowView = [[UIView alloc]initWithFrame:shadowViewFrame];
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeZero;
        _shadowView.layer.shadowOpacity = 0.5;
        _shadowView.layer.shadowRadius = 3;
        _shadowView.layer.masksToBounds = NO;
        _shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_shadowView.bounds cornerRadius:0].CGPath;
    }
    return _shadowView;
}

#pragma mark - PrivateMethod
- (void)homeMenuView:(HomeMenuView *)menuView selectItemAtIndex:(NSInteger)index
{
    if (![BSAppManager sharedInstance].currentUser) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:@"animated"];
        return;
    }
    if (index <= 11) {
        [self doSelectWithIndex:index];
//        [self checkAccountStatusWithBlock:^(BOOL reject) {
//            if (!reject) {
//                [weakSelf doSelectWithIndex:index];
//            }
//        }];
    }
    else
    {
        [UIView makeToast:@"该功能暂未开放"];
    }
}

- (void)doSelectWithIndex:(NSInteger)index {
    [self umEventStatics:index];
    switch (index) {
        case 0: {
//            BSSignViewController *vc = [[BSSignViewController alloc]init];
//            vc.type = BSPaperSignType;
            BSSignChooseViewController *vc = [[BSSignChooseViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: {
            BSFollowupViewController *vc = [[BSFollowupViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            FamilyListViewController *vc = [[FamilyListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3: {
            ResidentManageVC *vc = [[ResidentManageVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11: {
            BSServiceLogViewController *vc = [[BSServiceLogViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            Bsky_WeakSelf
            BSWebViewController *webVC = [[BSWebViewController alloc]init];
            webVC.showNavigationBar = NO;
            webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
            webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
            if (!self.tuanduiUrlString) {
                [self loadUrlStringWithType:kTuanDuiUrlType block:^(NSString *urlString) {
                    Bsky_StrongSelf
                    [webVC ba_web_loadURLString:self.tuanduiUrlString];
                    [self.navigationController pushViewController:webVC animated:YES];
                }];
            } else {
                [webVC ba_web_loadURLString:self.tuanduiUrlString];
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
            break;
        case 6: {
            //工作提醒
            Bsky_WeakSelf
            BSWebViewController *webVC = [[BSWebViewController alloc]init];
            webVC.showNavigationBar = NO;
            webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
            webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
            if (!self.remindWorkUrlString) {
                [self loadUrlStringWithType:kWorkRemindUrlType block:^(NSString *urlString) {
                    Bsky_StrongSelf
                    [webVC ba_web_loadURLString:self.remindWorkUrlString];
                    [self.navigationController pushViewController:webVC animated:YES];
                }];
            } else {
                [webVC ba_web_loadURLString:self.remindWorkUrlString];
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
            break;
        case 7: {
            //慢病管理
            BSDiseaseManagerVC *vc = [[BSDiseaseManagerVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8: {
            //中医随访
            Bsky_WeakSelf
            BSWebViewController *webVC = [[BSWebViewController alloc]init];
            webVC.showNavigationBar = NO;
            webVC.ba_web_progressTintColor = UIColorFromRGB(0x599dff);
            webVC.ba_web_progressTrackTintColor = [UIColor whiteColor];
            if (!self.zyFollowUpUrlString) {
                [self loadUrlStringWithType:kZYFollowUpUrlType block:^(NSString *urlString) {
                    Bsky_StrongSelf
                    [webVC ba_web_loadURLString:self.zyFollowUpUrlString];
                    [self.navigationController pushViewController:webVC animated:YES];
                }];
            } else {
                [webVC ba_web_loadURLString:self.zyFollowUpUrlString];
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
            break;
        case 9: {
            //诊疗记录
            BSGiveTreatmentVC *vc = [[BSGiveTreatmentVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10: {
            //就诊记录
            PatientListViewController *vc = [[PatientListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4: {
            //无纸化体检
            PEController *pe = [[PEController alloc] init];
            [self.navigationController pushViewController:pe animated:YES];
            
        }
            break;
        default:
            break;
    }
}

- (void)loadUrlStringWithType:(NSString *)type  block:(void (^)(NSString* urlString))block {
    if (!self.urlRequest) {
        self.urlRequest = [[BSH5UrlRequest alloc]init];
    }
    self.urlRequest.type = type;
    BSUser* user = [BSAppManager sharedInstance].currentUser;
    if (!user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
        return;
    }
    Bsky_WeakSelf
    [self.urlRequest startWithCompletionBlockWithSuccess:^(BSH5UrlRequest* request) {
        Bsky_StrongSelf
        if ([request.type isEqualToString:kTuanDuiUrlType]) {
            self.tuanduiUrlString = request.urlString;
        }
        else if ([request.type isEqualToString:kSignListUrlType]) {
            self.signListUrlString = request.urlString;
        }else if ([request.type isEqualToString:kZYFollowUpUrlType]) {
            self.zyFollowUpUrlString = request.urlString;
        }else if ([request.type isEqualToString:kWorkRemindUrlType]) {
            self.remindWorkUrlString = request.urlString;
        }
        if (block) {
            block(request.urlString);
        }
    } failure:^(BSH5UrlRequest* request) {
        [UIView makeToast:request.msg];
    }];
}

#pragma mark --- 检查账号状态(公卫，中联,...)

- (void)checkAccountStatusWithBlock:(void (^)(BOOL reject))block {
    
    NSInteger sysType = [BSAppManager sharedInstance].currentUser.sysType.integerValue;
    
    if (sysType == InterfaceServerTypeScwjw) {
        BSVerifyStatusRequest* request = [BSVerifyStatusRequest new];
        [MBProgressHUD showHud];
        Bsky_WeakSelf
        [request startWithCompletionBlockWithSuccess:^(__kindof BSVerifyStatusRequest * _Nonnull request) {
            Bsky_StrongSelf
            if (request.verifyStatus == PhisVerifyStatusSuccess) {
                BSDoctorPhisRequest* request = [BSDoctorPhisRequest new];
                [request startWithCompletionBlockWithSuccess:^(BSDoctorPhisRequest* request) {
                    [MBProgressHUD hideHud];
                    block(NO);
                } failure:^(BSDoctorPhisRequest* request) {
                    [MBProgressHUD hideHud];
                    block(YES);
                }];
            }
            else if (request.verifyStatus == PhisVerifyStatusNonactivated || request.verifyStatus == PhisVerifyStatusProcessing)
            {
                [MBProgressHUD hideHud];
                [UIView makeToast:request.verifyMessage];
                block(YES);
            }
            else
            {
                [MBProgressHUD hideHud];
                [UIView makeToast:request.verifyMessage];
                BSGongWeiViewController *vc = [[BSGongWeiViewController alloc]init];
                vc.verifyStatus = request.verifyStatus;
                [self.navigationController pushViewController:vc animated:YES];
                block(YES);
            }
        } failure:^(__kindof BSVerifyStatusRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
            block(YES);
        }];
    }
    else if (sysType == InterfaceServerTypeSczl)
    {
        ZLAccountVerifyRequest * request = [[ZLAccountVerifyRequest alloc]init];
        [MBProgressHUD showHud];
        Bsky_WeakSelf
        [request startWithCompletionBlockWithSuccess:^(__kindof ZLAccountVerifyRequest * _Nonnull request) {
            Bsky_StrongSelf
            [MBProgressHUD hideHud];
            if ([BSAppManager sharedInstance].currentUser.zlAccountInfo) {
                 block(NO);
            }
            else
            {
                ZLAccountBindingVC *vc = [[ZLAccountBindingVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                block(YES);
            }
        } failure:^(__kindof ZLAccountVerifyRequest * _Nonnull request) {
            Bsky_StrongSelf
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
            ZLAccountBindingVC *vc = [[ZLAccountBindingVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            block(YES);
            
        }];
    }
}
#pragma mark - 审核
- (void)auditChang {
    [self updateContentView];
    [self.view layoutIfNeeded];
}

- (void)updateContentView {
    [self isHiddenMessageView:[BSAppManager sharedInstance].isAudit];
    NSMutableArray *titleArray = [NSMutableArray arrayWithArray:@[@"家庭签约",@"随访",@"快速建档",@"居民管理",@"无纸化体检",@"团队管理",@"工作提醒",@"慢病建档",@"中医随访",@"诊疗记录",@"就诊记录",@"服务日志"]];
    if ([BSAppManager sharedInstance].isAudit) {
        [titleArray removeObjectsInRange:NSMakeRange(6, 6)];
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<titleArray.count; i++) {
        GridItemModel *model = [[GridItemModel alloc]init];
        model.title = titleArray[i];
        NSString *imageStr = nil;
        if (i <= 11) {
            imageStr = [NSString stringWithFormat:@"ico%d",i+1];
        }
        else
        {
            imageStr = [NSString stringWithFormat:@"ico%d_un",i+1];
        }
        model.imageStr = imageStr;
        [array addObject:model];
    }
    [self.contentView.modelArray removeAllObjects];
    if (!self.contentView.delegate ) {
        self.contentView.delegate = self;
    }
    self.contentView.modelArray = [NSMutableArray arrayWithArray:array];
}
#pragma mark - 菜单点击事件统计
- (void)umEventStatics:(NSUInteger )tag{
    if ([BskyBaseNetConfig sharedInstance].type == AppType_Test || [BskyBaseNetConfig sharedInstance].type == AppType_Dev) {
        return;
    }
    NSDictionary *dic = nil;
    switch (tag) {
        case 0:
        {
            dic = @{@"name":@"家庭签约"};
            [MobClick event:kUMFamilySignEvent];
        }
            break;
        case 1:
        {
            dic = @{@"name":@"随访"};
            [MobClick event:kUMFollowupEvent];
        }
            break;
        case 2:
        {
            dic = @{@"name":@"快速建档"};
            [MobClick event:kUMCreateArchiveEvent];
        }
            break;
        case 3:
        {
            dic = @{@"name":@"居民管理"};
            [MobClick event:kUMResidentManageEvent];
        }
            break;
        case 11:
        {
            dic = @{@"name":@"服务日志"};
            [MobClick event:kUMServiceLogEvent];
        }
            break;
        case 5:
        {
            dic = @{@"name":@"团队管理"};
            [MobClick event:kUMTeamManageEvent];
        }
            break;
        case 6:
        {
            dic = @{@"name":@"工作提醒"};
            [MobClick event:kUMWorkRemindEvent];
        }
            break;
        case 7:
        {
            dic = @{@"name":@"慢病建档"};
            [MobClick event:kUMNCDAchiveEvent];
        }
            break;
        case 8:
        {
            dic = @{@"name":@"中医随访"};
            [MobClick event:kUMZYFollowupEvent];
        }
            break;
        case 9:
        {
            dic = @{@"name":@"诊疗记录"};
            [MobClick event:kUMDiagnosisRecordEvent];
        }
            break;
        case 10:
        {
            dic = @{@"name":@"就诊记录"};
            [MobClick event:kUMMedicalRecordEvent];
        }
            break;
        case 4:
        {
            dic = @{@"name":@"无纸化体检"};
            [MobClick event:kUMMedicalRecordEvent];
        }
            break;
        default:
            break;
    }
    [MobClick event:@"um_home_statics" attributes:(NSDictionary *)dic];
}
@end
