                      //
//  BSFamilySignViewController.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/12/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSSignViewController.h"
#import "SignInputTextCell.h"
#import "SignPersonalInfoCell.h"
#import "SignRemarkCell.h"
#import "SignSignatureCell.h"
#import "SignatureView.h"
#import "BSSignPreviewViewController.h"
#import "SignRefereeViewController.h"
#import "SignTagServicePackVC.h"
#import "UpdatePAViewController.h"
#import "BSSignChannelRequest.h"
#import "BSSignLabelModel.h"
#import "BSSignTeamsRequest.h"
#import "BSSignInfoPushRequest.h"
#import "BSSignInfoDeleteRequest.h"
#import "BSSignTeamMembersRequest.h"
#import "SignResidentInfoModel.h"
#import "SignTeamsInfoModel.h"
#import "SignTeamMembersModel.h"
#import "SignPushPersonInfoModel.h"
#import "BSFamilySignPushRequest.h"
#import "BSFamilySignInfoModel.h"
#import "BSFamilySignPersonModel.h"
#import "SignPersonalPaperTableViewCell.h"
#import "SignSVPackModel.h"
#import "BSSignSuccessViewController.h"
#import <YYCategories/NSData+YYAdd.h>
#import "BjcaSignManager.h"
#import <BSKYCore/BSKYCore.h>

@interface BSSignViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate> {
    CGFloat _multiply;
}

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView      *footerView;
@property (nonatomic, strong) UIButton    *saveBtn;
@property (nonatomic ,strong) NSMutableArray *uiArray;
@property (nonatomic, strong) NSMutableArray *teamData;
@property (nonatomic, strong) NSMutableArray *signChannelArr;
@property (nonatomic ,strong) NSMutableArray *personInfoArr;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *telArr;
@property (nonatomic, strong) NSString       *masterName;
@property (nonatomic, strong) NSString       *teamEmpName;

@property (nonatomic, strong) BSSignTeamsRequest       *teamRequest;
@property (nonatomic, strong) BSSignChannelRequest     *channelRequest;
@property (nonatomic, strong) BSSignTeamMembersRequest *memberRequest;
@property (nonatomic, strong) BSSignInfoDeleteRequest  *deleteRequest;
@property (nonatomic, strong) BSSignInfoPushRequest    *infoRequest;
@property (nonatomic, strong) SignTeamsInfoModel       *teamInfoModel;
@property (nonatomic, strong) SignInfoRequestModel     *signInfoModel;

@property (nonatomic, strong) BSFamilySignPushRequest  *paperPushRequest;
@property (nonatomic, strong) BSFamilySignInfoModel    *paperModel;
@property (nonatomic, strong) BSFamilySignPersonModel  *paperPersonModel;

@property (nonatomic, assign) NSInteger base64Index;
@property (nonatomic, strong) SignTagServicePackVC *service_vc;
@property (nonatomic, strong) NSMutableDictionary  *serverDic;
@property (nonatomic, strong) NSMutableArray       *personcodeArr;
@end

@implementation BSSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)dealloc {
    self.service_vc = nil;
    [self.serverDic removeAllObjects];
    [self unobserveAllNotification];
}

- (void)initData {
    _multiply = SCREEN_WIDTH/375.0;
    self.teamEmpName = [BSAppManager sharedInstance].currentUser.phisInfo.UserName;
    self.teamRequest = [[BSSignTeamsRequest alloc] init];
    self.personInfoArr = [NSMutableArray array];
    self.telArr = [NSMutableArray array];
    self.signInfoModel = [[SignInfoRequestModel alloc] init];
    self.paperModel = [[BSFamilySignInfoModel alloc] init];
    self.paperPersonModel = [[BSFamilySignPersonModel alloc] init];
    self.teamInfoModel = [[SignTeamsInfoModel alloc] init];
    // 签约团队
    [self getDefaultTeamData];
    [self getSignChannel];
    NSString *start = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    NSString *end = [[[NSDate date] dateByAddingYears:1] stringWithFormat:@"yyyy-MM-dd"];
    self.signInfoModel.startTime = self.paperModel.startTime = start;
    self.signInfoModel.endTime = self.paperModel.endTime = end;
}

- (void)initView {
    self.title = @"签约";
    [self.view addSubview:self.tableView];
    
    self.saveBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4e7dd3"]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#273e69"]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(saveBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];;
        btn.titleLabel.font = [UIFont systemFontOfSize:18.0*_multiply];
        [self.view addSubview:btn];

        btn;
    });
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
        make.height.equalTo(@(45*_multiply));
    }];
}

#pragma mark - private
//*<获取团队 >/
- (void)getDefaultTeamData {
    WS(weakSelf);
    [MBProgressHUD showHud];
    [self.teamRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignTeamsRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        if (request.teamsData.count != 0) {
            weakSelf.teamData = [NSMutableArray arrayWithArray:request.teamsData];
            weakSelf.teamInfoModel = (SignTeamsInfoModel *)request.teamsData.firstObject;
            weakSelf.signInfoModel.teamId = weakSelf.paperModel.teamID = weakSelf.teamInfoModel.teamId;
            weakSelf.signInfoModel.teamEmpId = weakSelf.paperModel.teamEmpId = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;
            [weakSelf.tableView reloadData];
            [weakSelf getDefaultTeamMembers];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未加入家庭医生团队,请联系您的团队长在电脑端(基卫系统)将您加入团队！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 1444;
            [alertView show];
        }
    } failure:^(__kindof BSSignTeamsRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}

- (void)getDefaultTeamMembers {
    if (!self.memberRequest) {
        self.memberRequest = [[BSSignTeamMembersRequest alloc] init];
    }
    self.memberRequest.teamId = self.teamInfoModel.teamId;
    Bsky_WeakSelf
    [self.memberRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignTeamMembersRequest * _Nonnull request) {
        Bsky_StrongSelf
        if (request.teamMembersData.count != 0) {
            NSMutableArray *teamArr = [NSMutableArray arrayWithCapacity:request.teamMembersData.count];
            for (int i=0; i<request.teamMembersData.count; i++) {
                SignTeamMembersModel *model = (SignTeamMembersModel *)request.teamMembersData[i];
                NSString *phone = model.phone.length != 0 ? model.phone : @"";
                NSArray *arrs = @[model.memberName,phone];
                [teamArr addObject:arrs];
            }
            self.signInfoModel.teamEmpNames = [teamArr copy];
        }
    } failure:^(__kindof BSSignTeamMembersRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
    }];
}

//*<获取签约渠道 >/
- (void)getSignChannel {
    self.channelRequest = [[BSSignChannelRequest alloc] init];
    Bsky_WeakSelf
    [self.channelRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignChannelRequest * _Nonnull request) {
        Bsky_StrongSelf
        if (request.channelData.count != 0) {
            self.signChannelArr = [NSMutableArray arrayWithArray:request.channelData];
            self.signInfoModel.channel = self.paperModel.channel = @"公卫推荐";
            [self.tableView reloadData];
        }
    } failure:^(__kindof BSSignChannelRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
    }];
}

//*<进入预览 >/
- (void)saveBtnPressed {
    if (self.type == BSPaperSignType) {
        [self paperSignWithPushData];
    } else {
        [self eletronicSignWithPushData];
    }
}
#pragma mark -- 家庭签约
- (void)paperSignWithPushData {

    for (int i = 0; i<self.personInfoArr.count; i++) {
        BSFamilySignPersonModel *model = (BSFamilySignPersonModel *)self.listData[i];
        SignPushPersonInfoModel *info = (SignPushPersonInfoModel *)self.personInfoArr[i];
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:info.contractServices.count];
        for (int j=0; j<info.contractServices.count; j++) {
            SignSVPackModel *dic = (SignSVPackModel *)info.contractServices[j];
            [mutableArr addObject:dic.serviceId];
        }
        model.contractServices = [mutableArr copy];
        [model.contractSmsContent setValue:info.personName forKey:@"personName"];
        [model.contractSmsContent setValue:[BSAppManager sharedInstance].currentUser.organizationName forKey:@"orgName"];
        [model.contractSmsContent setValue:self.teamInfoModel.teamName forKey:@"teamName"];
        [model.contractSmsContent setValue:self.teamEmpName forKey:@"doctorName"];
        NSString *telPhone = [model.contractSmsContent objectForKey:@"personPhone"];
        [telPhone isNumText] ? telPhone : [model.contractSmsContent setValue:@"" forKey:@"personPhone"];
    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    
    if (self.paperModel.teamID.length == 0) {
        [UIView makeToast:@"请选择签约团队"];
    } else if (self.paperModel.channel.length == 0) {
        [UIView makeToast:@"请选择签约渠道"];
    } else if (self.paperModel.teamEmpId.length == 0) {
        [UIView makeToast:@"请选择经办成员(默认团队未包含经办成员)~"];
    } else if (self.listData.count == 0) {
        [UIView makeToast:@"请选择服务对象"];
    } else if (self.paperModel.signPerson.length == 0) {
        [UIView makeToast:@"请添加签约代表人姓名"];
    } else if (![self isSignPerson]) {
        [UIView makeToast:@"服务对象未添加服务包或未上传合同照片"];
    } else if (![self isTimeTrue]) {
         [UIView makeToast:@"结束时间不能小于开始时间！或所选期限过短！"];
    } else {
        if (!self.paperPushRequest) {
            self.paperPushRequest = [[BSFamilySignPushRequest alloc] init];
        }
        // 构造上传数据模型
        self.paperModel.ID = @"";
        NSMutableArray *array = [self.listData mutableCopy];
        [array encryptArray];
        self.paperModel.list = [[NSObject mj_keyValuesArrayWithObjectArray:array] copy];
        [self.paperModel encryptModel];
        self.paperPushRequest.contractInVM = [self.paperModel mj_keyValues];
        WS(weakSelf);
        [MBProgressHUD showHud];
        [self.paperPushRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignInfoPushRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            BSSignSuccessViewController *success = [[BSSignSuccessViewController  alloc] init];
            [success setBlock:^(BSSignSuccessViewController *vc) {
                [vc dismissViewControllerAnimated:NO completion:nil];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
            [weakSelf presentViewController:success animated:YES completion:nil];
        } failure:^(__kindof BSSignInfoPushRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }
}

#pragma mark -- 电子签约
- (void)eletronicSignWithPushData {
    for (int i = 0; i<self.personInfoArr.count; i++) {
        SignPushPersonInfoModel *info = (SignPushPersonInfoModel *)self.personInfoArr[i];
        [info.contractSmsContent setValue:info.personName forKey:@"personName"];
        [info.contractSmsContent setValue:[BSAppManager sharedInstance].currentUser.organizationName forKey:@"orgName"];
        [info.contractSmsContent setValue:self.teamInfoModel.teamName forKey:@"teamName"];
        [info.contractSmsContent setValue:self.teamEmpName forKey:@"doctorName"];
        NSString *telPhone = [info.contractSmsContent objectForKey:@"personPhone"];
        [telPhone isNumText] ? telPhone : [info.contractSmsContent setValue:@"" forKey:@"personPhone"];
    }
    NSMutableArray *array = [NSMutableArray mj_keyValuesArrayWithObjectArray:self.personInfoArr];
    NSArray *newArray = [SignPushPersonInfoModel mj_objectArrayWithKeyValuesArray:array];
    [newArray encryptArray];
    self.signInfoModel.signPersonList = newArray;
    if (self.signInfoModel.teamId.length == 0) {
        [UIView makeToast:@"请选择签约团队"];
    } else if (self.signInfoModel.channel.length == 0) {
        [UIView makeToast:@"请选择签约渠道"];
    } else if (self.signInfoModel.teamEmpId.length == 0) {
        [UIView makeToast:@"请选择经办成员(默认团队可能被更改，请重选经办成员)~"];
    } else if (self.signInfoModel.signPersonList.count == 0) {
        [UIView makeToast:@"请选择服务对象"];
    } else if (self.signInfoModel.signPerson.length == 0) {
        [UIView makeToast:@"请添加签约代表人姓名"];
    } else if (![self isSignPerson]) {
        [UIView makeToast:@"服务对象未添加服务包"];
    } else if (self.signInfoModel.personSignBase64.length == 0) {
        [UIView makeToast:@"请添加居民签名"];
    } else if (![self isTimeTrue]) {
        [UIView makeToast:@"结束时间不能小于开始时间！或所选期限过短！"];
    } else {
        if (!self.infoRequest) {
            self.infoRequest = [[BSSignInfoPushRequest alloc] init];
        }
        if (![self checkISExistsCert]) {
            return;
        }
        // 构造上传数据模型
        SignInfoRequestModel *info = [SignInfoRequestModel mj_objectWithKeyValues:[self.signInfoModel mj_keyValues]];
        for (int i = 0; i<info.signPersonList.count; i++) {
            NSDictionary *model = (NSDictionary *)info.signPersonList[i];
            NSArray *array = (NSArray *)model[@"contractServices"];
            NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:array.count];
            for (int j =0; j<array.count; j++) {
                NSDictionary *dic = (NSDictionary *)array[j];
                [mutableArr addObject:dic[@"serviceId"]];
            }
            [model setValue:mutableArr forKey:@"contractServices"];
        }
        //cbc 加密
//        [info.signPersonList encryptArray];
        //end
        info.signPerson = [info.signPerson encryptCBCStr];
        self.infoRequest.signForm = [info mj_keyValues];
        WS(weakSelf);
        [MBProgressHUD showHud];
        [self.infoRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignInfoPushRequest * _Nonnull request) {
            // 1.获取医生 uniqueId
            [MBProgressHUD hideHud];
            if (request.respondseModelArr.count != 0) {
                SignInfoRespondseModel *model = (SignInfoRespondseModel *)weakSelf.infoRequest.respondseModelArr.firstObject;
                if (model.uniqueId.length != 0) {
                    [weakSelf pushToNextVC];
                }
            }
        } failure:^(__kindof BSSignInfoPushRequest * _Nonnull request) {
            [MBProgressHUD hideHud];
            [UIView makeToast:request.msg];
        }];
    }
}
- (void)pushToNextVC {
    BSSignPreviewViewController *preview_vc = [[BSSignPreviewViewController alloc] init];
    preview_vc.pushInfoModel = self.signInfoModel;
    preview_vc.pushResponseModel = (SignInfoRespondseModel *)self.infoRequest.respondseModelArr.firstObject;
    [preview_vc setTeamNameWithName:self.teamInfoModel.teamName TeamEmpName:self.teamEmpName];
    WS(weakSelf);
    [preview_vc setDeleteBlock:^(BSSignPreviewViewController *vc) {
        if (!weakSelf.deleteRequest) {
            weakSelf.deleteRequest = [[BSSignInfoDeleteRequest alloc] init];
        }
//        NSString *str = @"";
//        for (int i = 0; i<signIdArr.count; i++) {
//            SignInfoRespondseModel *model = (SignInfoRespondseModel *)signIdArr[i];
//            if (i==0) {
//                str = [NSString stringWithFormat:@"%@",model.signId];
//            } else {
//                str = [NSString stringWithFormat:@"%@,%@",str,model.signId];
//            }
//        }
//        if (str.length == 0) {
//            return;
//        }
        weakSelf.deleteRequest.signIds = [NSString stringWithFormat:@"%@",vc.pushResponseModel.signId];
        [weakSelf.deleteRequest startWithCompletionBlockWithSuccess:^(__kindof BSSignInfoDeleteRequest * _Nonnull request) {
            NSLog(@"BSSignInfoDeleteRequest==success==>%@",request.msg);
        } failure:^(__kindof BSSignInfoDeleteRequest * _Nonnull request) {
            NSLog(@"BSSignInfoDeleteRequest==failure==>%@",request.msg);
        }];
        if (!vc.isPopGesture) {
            [vc.navigationController popViewControllerAnimated:YES];
        }
    }];
    [self.navigationController pushViewController:preview_vc animated:YES];
}

- (BOOL)isSignPerson {
    if (self.type == BSPaperSignType) {
        for (BSFamilySignPersonModel *model in self.listData) {
            if (model.tags.count == 0 ||
                model.contractServices.count == 0 ||
                model.attachfile.length == 0) {
                return NO;
            }
        }
        return YES;
    }
    for (SignPushPersonInfoModel *model in self.personInfoArr) {
        if (model.tags.count == 0 || model.contractServices.count == 0) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isTimeTrue {
    NSDate *start = self.type == BSPaperSignType ? [NSDate dateWithString:self.paperModel.startTime format:@"yyyy-MM-dd"] : [NSDate dateWithString:self.signInfoModel.startTime format:@"yyyy-MM-dd"];
    NSDate *end = self.type == BSPaperSignType ? [NSDate dateWithString:self.paperModel.endTime format:@"yyyy-MM-dd"] : [NSDate dateWithString:self.signInfoModel.endTime format:@"yyyy-MM-dd"];
    if (end.year > start.year || (end.month > start.month && end.year == start.year)) {
        return YES;
    }
    return NO;
}

- (BOOL)checkISExistsCert {
    // 判断是否存在证书
    if ([BjcaSignManager existsCert]) {
        return YES;
    } else {
        BjcaSignManager *manager = [BjcaSignManager initWithContainnerVC:self];
        [manager setServerURL:[BSAppManager sharedInstance].signServerType];
        [manager startUrl:[BSAppManager sharedInstance].signClientId pageType:PageTypeDownLoad];
    }
    return NO;
}

#pragma mark - cell event
- (void)handleCellDataWithData:(id)data type:(NSString *)type {
    if ([type isEqualToString:@"签约团队"]) {
        self.teamInfoModel = (SignTeamsInfoModel *)data;
        self.signInfoModel.teamId = self.paperModel.teamID = self.teamInfoModel.teamId;
        self.signInfoModel.teamEmpId = @"";
        [self.tableView reloadData];
    }
    else if ([type isEqualToString:@"签约渠道"]) {
        if (![data isKindOfClass:[BSSignLabelModel class]]) {
            return;
        }
        BSSignLabelModel *model = (BSSignLabelModel *)data;
        self.signInfoModel.channel = self.paperModel.channel = model.dictName;
    } else if ([type isEqualToString:@"经办成员"]) {
        NSArray *info = (NSArray *)data;
        self.teamEmpName = info[0];
        self.signInfoModel.teamEmpId = self.paperModel.teamEmpId = info[1];
        self.signInfoModel.teamEmpNames = (NSArray *)info[2];
    } else if ([type isEqualToString:@"开始时间"]) {
        self.signInfoModel.startTime = self.paperModel.startTime = (NSString *)data;
    } else if ([type isEqualToString:@"结束时间"]) {
        if (self.signInfoModel.startTime.length != 0) {
            NSDate *start= [NSDate dateWithString:self.signInfoModel.startTime format:@"yyyy-MM-dd"];
            NSDate *end= [NSDate dateWithString:self.signInfoModel.endTime format:@"yyyy-MM-dd"];
            if (end.year > start.year || (end.month > start.month && end.year == start.year)) {
                 self.signInfoModel.endTime = self.paperModel.endTime = (NSString *)data;
            } else {
                [UIView makeToast:@"结束时间不能小于开始时间！或所选期限过短！"];
            }
        } else {
            [UIView makeToast:@"请确定开始时间"];
        }
    } else if ([type isEqualToString:@"签约代表"]) {
        self.signInfoModel.signPerson = self.paperModel.signPerson = (NSString *)data;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == BSPaperSignType) {
        return 4;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: case 1:
            {
                NSMutableArray *array = self.uiArray[section];
                return array.count;
            }
            break;
        case 2:
            return self.personInfoArr.count;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    WS(weakSelf);
    switch (indexPath.section) {
        case 0: case 1:
        {
            NSMutableArray *array = self.uiArray[indexPath.section];
            InterviewInputModel *uiModel = array[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:[SignInputTextCell cellIdentifier] forIndexPath:indexPath];
            SignInputTextCell *tableCell = (SignInputTextCell *)cell;
            if (indexPath.section == 0) {
                tableCell.contentTF.moreIcon.hidden = NO;
                if (indexPath.row == 0) {
                    tableCell.teamModel = self.teamInfoModel;
                    tableCell.cellData = self.teamData;
                } else if (indexPath.row == 1) {
                    tableCell.cellData = [NSMutableArray arrayWithArray:self.signChannelArr];
                } else if (indexPath.row == 2)  {
                    uiModel.contentStr = self.teamEmpName;
                    tableCell.teamModel = self.teamInfoModel;
                } else if (indexPath.row == 3)  {
                    tableCell.contentTF.moreIcon.hidden = YES;
                    if (weakSelf.type == BSPaperSignType) {
                        tableCell.contentTF.text = self.paperModel.signPerson.length != 0 ? self.paperModel.signPerson : @"";
                    } else {
                        tableCell.contentTF.text = self.signInfoModel.signPerson.length != 0 ? self.signInfoModel.signPerson : @"";
                    }
                    
                }
            } else if (indexPath.section == 1) {
                tableCell.contentTF.enabled = NO;
            }
            tableCell.uiModel = uiModel;

            [tableCell setBlock:^(id content) {
                [weakSelf handleCellDataWithData:content type:uiModel.title];
            }];
        }
            break;
        case 2:
        {
            if (self.personInfoArr.count == 0) {
                return cell;
            }
            if (self.type == BSPaperSignType) {
                cell = [tableView dequeueReusableCellWithIdentifier:[SignPersonalPaperTableViewCell cellIdentifier] forIndexPath:indexPath];
                cell.tag = indexPath.row + 700;
                SignPersonalPaperTableViewCell *tableCell = (SignPersonalPaperTableViewCell *)cell;
                SignPushPersonInfoModel *model = (SignPushPersonInfoModel *)self.personInfoArr[indexPath.row];
                BSFamilySignPersonModel *baseImage = self.listData[indexPath.row];
                if (baseImage && baseImage.attachfile.length != 0) {
                    [tableCell setUploadImage:[UIImage imageWithBase64Str:baseImage.attachfile]];
                } else {
                    [tableCell setUploadImage:nil];
                }
                [tableCell setModel:model WithMaster:self.masterName phone:self.telArr[indexPath.row]];
                [tableCell setChoosePaperBlock:^(NSInteger index, SignPersonalPaperType event) {
                    NSInteger row = index-700;
                    if (event == SignPersonalPaperTypeMore) {
                        [weakSelf checkServerVCIsExist:row];
                        weakSelf.service_vc = weakSelf.serverDic[@(row)];
                        weakSelf.service_vc.type = weakSelf.type;
                        weakSelf.service_vc.paperChechModel = weakSelf.paperModel;
                        weakSelf.service_vc.code = weakSelf.personcodeArr[row];
                        [weakSelf.service_vc setBlock:^(SignTagServicePackVC *vc) {
                            BSFamilySignPersonModel *paper = (BSFamilySignPersonModel *)weakSelf.listData[row];
                            paper.tags = [vc.selectTagsArray copy];
                            paper.contractServices = [vc.selectPackArray copy];
                            paper.fee = @(vc.packsPrice);
                            SignPushPersonInfoModel *info = (SignPushPersonInfoModel *)weakSelf.personInfoArr[row];
                            info.tags = [vc.selectTagsArray copy];
                            info.contractServices = [vc.selectPackArray copy];
                            info.fee = @(vc.packsPrice);
                            [weakSelf.tableView reloadData];
                            [vc.navigationController popViewControllerAnimated:NO];
                        }];
                        [weakSelf.navigationController pushViewController:weakSelf.service_vc animated:YES];
                    } else if (event == SignPersonalPaperTypeDelete) {
                        [weakSelf.personInfoArr removeObjectAtIndex:row];
                        [weakSelf.telArr removeObjectAtIndex:row];
                        [weakSelf.personcodeArr removeObjectAtIndex:row];
                        weakSelf.service_vc = nil;
                        [weakSelf.serverDic removeObjectForKey:@(row)];
                        [weakSelf.listData removeObjectAtIndex:row];
                        if (indexPath.row == row) {
                            [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
                        }
                        [weakSelf.tableView reloadData];
                    } else if (event == SignPersonalPaperTypeUpload) {
                        weakSelf.base64Index = row;
                        [weakSelf openActionSheetWithCameraPhoto];
                    } else if (event == SignPersonalChangeArchive) {
                        UpdatePAViewController *update_vc = [[UpdatePAViewController alloc] init];
                        SignPushPersonInfoModel *info = (SignPushPersonInfoModel *)weakSelf.personInfoArr[row];
                        update_vc.personId = info.personId;
                        [weakSelf.navigationController pushViewController:update_vc animated:YES];
                    }
                }];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:[SignPersonalInfoCell cellIdentifier] forIndexPath:indexPath];
                cell.tag = indexPath.row + 700;
                SignPersonalInfoCell *tableCell = (SignPersonalInfoCell *)cell;
                SignPushPersonInfoModel *model = (SignPushPersonInfoModel *)self.personInfoArr[indexPath.row];
                [tableCell setModel:model WithMaster:self.masterName phone:self.telArr[indexPath.row]];
                [tableCell setChooseBlock:^(NSInteger index, SignPersonalInfoType event) {
                    NSInteger row = index-700;
                    if (event == SignPersonalInfoTypeMore) {
                        [weakSelf checkServerVCIsExist:row];
                        weakSelf.service_vc = weakSelf.serverDic[@(row)];
                        weakSelf.service_vc.type = weakSelf.type;
                        weakSelf.service_vc.eleCheckModel = weakSelf.signInfoModel;
                        weakSelf.service_vc.code = weakSelf.personcodeArr[row];
                        [weakSelf.service_vc setBlock:^(SignTagServicePackVC *vc) {
                            BSFamilySignPersonModel *paper = (BSFamilySignPersonModel *)weakSelf.listData[row];
                            paper.tags = [vc.selectTagsArray copy];
                            paper.contractServices = [vc.selectPackArray copy];
                            paper.fee = @(vc.packsPrice);
                            SignPushPersonInfoModel *info = (SignPushPersonInfoModel *)weakSelf.personInfoArr[row];
                            info.tags = [vc.selectTagsArray copy];
                            info.contractServices = [vc.selectPackArray copy];
                            info.fee = @(vc.packsPrice);
                            [weakSelf.tableView reloadData];
                            [vc.navigationController popViewControllerAnimated:NO];
                        }];
                        [weakSelf.navigationController pushViewController:weakSelf.service_vc animated:YES];
                    } else if (event == SignPersonalInfoTypeDelete) {
                        [weakSelf.personInfoArr removeObjectAtIndex:row];
                        [weakSelf.telArr removeObjectAtIndex:row];
                        [weakSelf.personcodeArr removeObjectAtIndex:row];
                        weakSelf.service_vc = nil;
                        [weakSelf.serverDic removeObjectForKey:@(row)];
                        [weakSelf.listData removeObjectAtIndex:row];
                        if (indexPath.row == row) {
                            [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
                        }
                        [weakSelf.tableView reloadData];
                    } else if (event == SignPersonalInfoTypeChange) {
                        UpdatePAViewController *update_vc = [[UpdatePAViewController alloc] init];
                        SignPushPersonInfoModel *info = (SignPushPersonInfoModel *)weakSelf.personInfoArr[row];
                        update_vc.personId = info.personId;
                        [weakSelf.navigationController pushViewController:update_vc animated:YES];
                        
                    }
                }];
            }
        }
            break;
        case 3: {
            cell = [tableView dequeueReusableCellWithIdentifier:[SignRemarkCell cellIdentifier] forIndexPath:indexPath];
            SignRemarkCell *tableCell = (SignRemarkCell *)cell;
            [tableCell setTextBlock:^(NSString *text) {
                NSLog(@"备注输入了====>%@",text);
                weakSelf.signInfoModel.remark = weakSelf.paperModel.otheremark = text;
            }];
        }
            break;
        case 4: {
            cell = [tableView dequeueReusableCellWithIdentifier:[SignSignatureCell cellIdentifier] forIndexPath:indexPath];
            SignSignatureCell *tableCell = (SignSignatureCell *)cell;
            [tableCell setImageBlock:^(UIImage *image) {
                NSLog(@"画板签名====>%@",image);
                NSData *data = UIImageJPEGRepresentation(image, 1.0f);
                NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                weakSelf.signInfoModel.personSignBase64 = encodedImageStr;
            }];
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!self.footerView) {
        self.footerView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 2:
            if (self.personInfoArr.count != 0) {
                return 5;
            }
            return 0;
            break;
        default:
            return 10;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == 1) {
        if (self.personInfoArr.count != 0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"该操作将覆盖已选择的服务对象，是否继续" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            WS(weakSelf);
            [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger index) {
                if (index == 1) {
                    [weakSelf pushToRefereeVC];
                }
            }];
            [alert show];
        } else {
            [self pushToRefereeVC];
        }
    }
}
//*<选择签约对象页面 >/
- (void)pushToRefereeVC {
    WS(weakSelf);
    SignRefereeViewController *vc = [[SignRefereeViewController alloc] init];
    vc.type = self.type;
    if (self.type == BSPaperSignType) {
        if (![self.paperModel.teamID isNotEmpty] ||
            ![self.paperModel.startTime isNotEmpty] ||
            ![self.paperModel.endTime isNotEmpty]) {
            [UIView makeToast:@"请优先完善签约团队信息"];
            return;
        }
    } else {
        if (![self.signInfoModel.teamId isNotEmpty] ||
            ![self.signInfoModel.startTime isNotEmpty] ||
            ![self.signInfoModel.endTime isNotEmpty]) {
            [UIView makeToast:@"请优先完善签约团队信息"];
            return;
        }
    }
    vc.paperCheckPacksModel = self.paperModel;
    vc.eleCheckPacksModel = self.signInfoModel;
      
    [vc setBlock:^(SignRefereeViewController *vc,id content,id other) {
        //处理签约对象数据
        weakSelf.masterName = vc.masterName;
        [weakSelf.personInfoArr removeAllObjects];
        [weakSelf.personcodeArr removeAllObjects];
        [weakSelf.serverDic removeAllObjects];
        if ([content isKindOfClass:[NSArray class]] || [content isKindOfClass:[NSMutableArray class]]) {
            [weakSelf.personInfoArr addObjectsFromArray:(NSArray *)content];
        } else if ([content isKindOfClass:[SignPushPersonInfoModel class]]) {
            [weakSelf.personInfoArr addObject:(SignPushPersonInfoModel *)content];
        }
        weakSelf.serverDic = [NSMutableDictionary dictionary];
        [self.telArr removeAllObjects];
        if (other != nil && [other isKindOfClass:[SignTagServicePackVC class]]) {
            [weakSelf.serverDic setObject:(SignTagServicePackVC *)other forKey:@(0)];
            [self.telArr addObject:((SignTagServicePackVC *)other).telPhone];
        } else if (other != nil && [other isKindOfClass:[NSMutableArray class]]) {
            self.telArr = (NSMutableArray *)other;
        }
        weakSelf.personcodeArr = [NSMutableArray arrayWithArray:vc.personCode];
        [weakSelf.listData removeAllObjects];
        weakSelf.listData = [NSMutableArray arrayWithCapacity:weakSelf.personInfoArr.count];
        for (int k=0; k<weakSelf.personInfoArr.count; k++) {
            BSFamilySignPersonModel *model = [[BSFamilySignPersonModel alloc] init];
            SignPushPersonInfoModel *info = (SignPushPersonInfoModel *)weakSelf.personInfoArr[k];
            model.personId = info.personId;
            model.fee = info.fee;
            model.tags = info.tags;
            model.contractServices = info.contractServices;
            model.attachfile = @"";
            if (self.telArr.count > k) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:self.telArr[k] forKey:@"personPhone"];
                model.contractSmsContent = [dic mutableCopy];
                info.contractSmsContent = [dic mutableCopy];
            }
            [weakSelf.listData addObject:model];
        }
        [weakSelf.tableView reloadData];
        [vc.navigationController popViewControllerAnimated:NO];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkServerVCIsExist:(NSInteger)index {
    if (![self.serverDic objectForKey:@(index)]) {
        SignTagServicePackVC *temp = [[SignTagServicePackVC alloc] init];
        [self.serverDic setObject:temp forKey:@(index)];
    }
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 打开相机相册
- (void)openActionSheetWithCameraPhoto {
    //判断设备是否有具有摄像头(相机)功能
    UIActionSheet *actionSheet = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择合同照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    } else {
        actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择合同照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    actionSheet.delegate = self;
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                //来源:相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                //来源:相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 2) return;
        else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    //跳转到相机或者相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.allowsEditing  = YES;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    BSFamilySignPersonModel *model = self.listData[self.base64Index];
    NSData *imageData = [self compressOriginalImageWith:[image imageByScalingAndCroppingForSize:CGSizeMake(1024, 1024)] toMaxDataSizeKBytes:2000];
    model.attachfile = [imageData base64EncodedString];
    [self .tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter  setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-TOP_BAR_HEIGHT-45*_multiply-SafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[SignInputTextCell nib] forCellReuseIdentifier:[SignInputTextCell cellIdentifier]];
        [_tableView registerNib:[SignPersonalInfoCell nib] forCellReuseIdentifier:[SignPersonalInfoCell cellIdentifier]];
        [_tableView registerNib:[SignPersonalPaperTableViewCell nib] forCellReuseIdentifier:[SignPersonalPaperTableViewCell cellIdentifier]];
        [_tableView registerNib:[SignRemarkCell nib] forCellReuseIdentifier:[SignRemarkCell cellIdentifier]];
        [_tableView registerNib:[SignSignatureCell nib] forCellReuseIdentifier:[SignSignatureCell cellIdentifier]];
    }
    return _tableView;
}

- (NSMutableArray *)uiArray {
    if (!_uiArray) {
        _uiArray = [NSMutableArray array];
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SignHomeUI" ofType:@"json"]];
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
        for (int i = 0; i<jsonArray.count; i++) {
            [_uiArray addObject:[InterviewInputModel mj_objectArrayWithKeyValuesArray:jsonArray[i]]];
        }
    }
    return _uiArray;
}

- (NSData *)compressOriginalImageWith:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.1f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

@end
