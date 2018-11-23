//
//  UpdateFAViewController.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/4/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "UpdateFAViewController.h"
#import "ArchiveFamilyTableView.h"
#import "ArchiveFamilyRequest.h"
#import "FamilyArchiveModel.h"
#import "ArchiveFamilyRequest.h"
#import "CreatPAViewController.h"
#import "BSFormsDicRequest.h"
#import "BSDictModel.h"
#import "ArchiveUpdateFamilyRequest.h"
#import "ArchiveSuccessView.h"

@interface UpdateFAViewController ()
@property (nonatomic ,strong)NSMutableDictionary *keyValueDic;
@property (nonatomic ,strong) UIButton *nextBtn;
@end

@implementation UpdateFAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self getWJWFamilyDict];
}
- (void)getWJWFamilyDict{
    [MBProgressHUD showHud];
    [[ArchiveFamilyDataManager dataManager] initWJWArchiveDatasuccess:^(__kindof  BSFormsDicRequest * _Nonnull request) {
        [self initWJWDictInfo:request.dictArray];
        [self.contentTableView reloadData];
        [MBProgressHUD hideHud];
    } failure:^(__kindof BSFormsDicRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
- (void)initWJWDictInfo:(NSArray *)data{
//    self.dataManager.dataDic = [self dictInfoToDic:data];
    for (BSArchiveModel *bsModel in self.dataManager.familyUIdata.content) {
        NSString *value = [NSString stringWithFormat:@"%@",[self.detailModel valueForKey:bsModel.code]];
        if (bsModel.type == ArchiveModelTypeSelect || bsModel.type == ArchiveModelTypeSlectOnLine || bsModel.type == ArchiveModelTypeSlectAndTextView) {
            if (bsModel.sourceCode.length) {
                bsModel.selectModel.options = [self.dataManager.dataDic objectForKey:bsModel.sourceCode];
            }
            if ([bsModel.code isEqualToString:@"HaveIcebox"]) {
                bsModel.value = [NSString stringWithFormat:@"%d",self.detailModel.HaveIcebox.boolValue];
            }else if ([bsModel.code isEqualToString:@"Position"]){
                for (ArchiveSelectOptionModel *model in bsModel.selectModel.options) {
                    if ([model.title containsString:self.detailModel.Position]) {
                        bsModel.contentStr = model.title;
                        bsModel.value = model.value;
                        break;
                    }
                }
            }else if ([bsModel.code isEqualToString:@"Remark"]){
                bsModel.contentStr = self.detailModel.Remark;
            }else{
                if (value.length) {
                    bsModel.value = value;
                }
            }
            
            
        }else{
            if ([bsModel.code isEqualToString:@"RegionID"]) {
                NSString *resultStr = [self.detailModel.RegionName stringByReplacingOccurrencesOfString:@">" withString:@""];
                resultStr = [resultStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                bsModel.contentStr = resultStr;
                bsModel.value = self.detailModel.RegionID;
//                bsModel.value
            }else if ([bsModel.code isEqualToString:@"FamilyAddress"]){
                NSString *resultStr = [value stringByReplacingOccurrencesOfString:@">" withString:@""];
                resultStr = [resultStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                bsModel.contentStr = resultStr;
                bsModel.value = resultStr;
            }else{
                if (value.length) {
                    bsModel.value = value;
                    bsModel.contentStr = value;
                }
            }
            
        }
    }
    
}

- (void)pushToSuccessView{
    ArchiveSuccessView *view = [[ArchiveSuccessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    Bsky_WeakSelf;
    view.backBlock = ^{
        Bsky_StrongSelf;
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    [view show];
}
- (NSDictionary *)dictInfoToDic:(NSArray *)data{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (BSDictModel *model in data) {
        [dic setObject:model.dictList forKey:model.type];
    }
    return dic;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)creatUI{
    self.title = @"编辑家庭档案";
    
//    self.navigationItem.rightBarButtonItem = self.saveBtn;
    [self.view addSubview:self.contentTableView];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.right.equalTo(@0);
        make.height.equalTo(@45);
    }];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nextBtn.mas_top);
        make.left.right.equalTo(@0);
        make.top.equalTo(@0);
    }];
//    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.left.right.equalTo(@0);
//        make.top.equalTo(@0);
//    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (ArchiveFamilyTableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[ArchiveFamilyTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom) style:UITableViewStylePlain withModel:self.dataManager];
    }
    return _contentTableView;
}

- (ArchiveFamilyDataManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [ArchiveFamilyDataManager dataManager];
    }
    return _dataManager;
}
//- (UIBarButtonItem *)saveBtn{
//    if (!_saveBtn) {
//        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        rightButton.backgroundColor = [UIColor clearColor];
//        rightButton.frame = CGRectMake(0, 0, 45, 40);
//        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
//        [rightButton setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
//        rightButton.tintColor = [UIColor clearColor];
//        rightButton.autoresizesSubviews = YES;
//        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        rightButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
//        [rightButton addTarget:self action:@selector(saveDataToServer) forControlEvents:UIControlEventTouchUpInside];
//        _saveBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    }
//    return _saveBtn;
//
//
//
//}
- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setFrame:CGRectMake(0, self.contentTableView.bottom - 45, self.view.width, 45)];
        
        [_nextBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(saveDataToServer) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setBackgroundColor:UIColorFromRGB(0x4e7dd3)];
    }
    return _nextBtn;
}
- (void)saveDataToServer{
    [self.view endEditing:YES];
    
//    if (!self.detailModel.FamilyId.length || !self.detailModel.MasterName.length || !self.detailModel.MasterCardID.length) {
//        [UIView makeToast:@"户主信息有误，请更新户主信息!"];
//        return;
//    }
    if (!self.detailModel.MasterCardID.length) {
        [UIView makeToast:@"户主身份证号码不能为空!"];
        return;
    }
    if (!self.detailModel.MasterName.length) {
        [UIView makeToast:@"户主姓名不能为空!"];
        return;
    }
    if (!self.detailModel.FamilyId.length) {
        [UIView makeToast:@"家庭档ID不能为空!"];
        return;
    }
    
    
//    FamilyArchiveModel *model = [self initlationFamilyArchivModel];
    
    NSString *wrongCode = [self handleTextFieldWithFamilyModel];
    if (wrongCode.length) {
        [self srollToCellWithCellCode:wrongCode];
        return;
    }
    self.familyModel.MasterCardID = self.detailModel.MasterCardID;
    self.familyModel.MasterName = self.detailModel.MasterName;
    self.familyModel.ID = self.detailModel.FamilyId;
    if (!self.detailModel.BuildEmployeeID.length || !self.detailModel.BuildOrgID.length) {
        BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
        self.familyModel.BuildEmployeeID = info.EmployeeID;
        self.familyModel.BuildOrgID = info.OrgId;
    }else{
        self.familyModel.BuildEmployeeID = self.detailModel.BuildEmployeeID;
        self.familyModel.BuildOrgID = self.detailModel.BuildOrgID;
    }
    if (self.detailModel.BuildDate.length) {
//        NSString *resultStr = [self.detailModel.BuildDate substringWithRange:NSMakeRange(6, self.detailModel.BuildDate.length - 8)];
        self.familyModel.BuildDate = self.detailModel.BuildDate ;
    }else{
        self.familyModel.BuildDate = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    }
    
    ArchiveUpdateFamilyRequest *request = [[ArchiveUpdateFamilyRequest alloc] init];
//    NSString *json = [self.familyModel mj_JSONString];
    FamilyArchiveModel *tempModel = [FamilyArchiveModel mj_objectWithKeyValues:[self.familyModel mj_keyValues]];
    [tempModel encryptModel];
    request.familyArchiveInVM = [tempModel mj_keyValues];
    [MBProgressHUD showHud];
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveUpdateFamilyRequest * _Nonnull request) {
        Bsky_StrongSelf;
        
        if (self.updateBlock) {
            self.updateBlock(request.familyModel);
        }
        self.listModel.TelNumber = request.familyModel.FamilyTel;
        self.listModel.FamilyAddress = request.familyModel.FamilyAddress;
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD hideHud];
    } failure:^(__kindof ArchiveUpdateFamilyRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
- (FamilyArchiveModel *)initlationFamilyArchivModel{
    self.familyModel = [[FamilyArchiveModel alloc] init];
    [self anilistMyClass:[FamilyArchiveModel class]];
    for (BSArchiveModel *model in self.dataManager.familyUIdata.content) {
        NSString *attr = [_keyValueDic objectForKey:model.code];
        if ([attr isEqualToString:[NSString stringWithUTF8String:object_getClassName([NSNumber class])]]) {
            if (model.value.length && [model.value isNumText]) {
                [self.familyModel setValue:[NSNumber numberWithInteger:model.value.integerValue] forKey:model.code];
            }
            
        }else{
            if ([model.code isEqualToString:@"Position"] || [model.code isEqualToString:@"Remark"]) {
                [self.familyModel setValue:model.contentStr forKey:model.code];
            }else{
                [self.familyModel setValue:model.value forKey:model.code];
            }
            
            
        }
        
        
    }
    if (self.familyModel.HaveIcebox.boolValue) {
        self.familyModel.HaveIcebox = @"true";
    }else{
        self.familyModel.HaveIcebox = @"false";
    }
//    BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
    
    
    //    self.savePersonHistoryModel.personId = person.ID;
    
    return self.familyModel;
}
- (void)anilistMyClass:(Class)className{
    u_int count;
    objc_property_t * properties  = class_copyPropertyList(className, &count);
    self.keyValueDic = [[NSMutableDictionary alloc] initWithCapacity:count];
    for (int i=0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *attr = [NSString stringWithUTF8String:property_getAttributes(property)];
        NSString *subStr = [[attr componentsSeparatedByString:@","] firstObject];
        NSString *needStr = [[subStr componentsSeparatedByString:@"\""] objectAtIndex:1];
        
        [_keyValueDic setObject:needStr forKey:[NSString stringWithUTF8String:property_getName(property)]];
        //        NSLog(@"%s-->%s",property_getAttributes(property),property_getName(property));
    }
    free(properties);
}
- (void)requstWithSuccess:(BOOL )sender msg:(NSString *)msg{
    [MBProgressHUD hideHud];
    if (sender) {
        [UIView makeToast:msg];
    }else{
        [UIView makeToast:msg];
    }
    //    [self clearAddUIModel];
    //    [self removeFromSuperview];
}
#pragma mark ----- BackButtonHandlerProtocol
- (void)backAction{
    if ([ArchiveFamilyDataManager dataManager].familyModel.ID.length) {
        if (self.navigationController != nil) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定退出?" message:@"内容尚未保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1301;
        [alertView show];
        
    }
}
-(BOOL)navigationShouldPopOnBackButton
{
    [self backAction];
    return NO;
}
#pragma mark ------ UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewDelayedTouchesBeganGestureRecognizer")])
    {
        if (self.navigationController != nil && ![ArchiveFamilyDataManager dataManager].familyModel.ID.length) {
            [self backAction];
        }
        return NO;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1301) {
        switch (buttonIndex) {
            case 0:
                break;
            default:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
        }
    }
}
- (void)dealloc
{
    [ArchiveFamilyDataManager dellocManager];
}
-(NSString *)handleTextFieldWithFamilyModel{
    NSString *returnStr = nil;
    NSString *toaskStr = nil;
    if (!self.familyModel.FamilyAddress.length) {
        returnStr = returnStr.length ? returnStr : @"FamilyAddress";
        toaskStr = toaskStr.length ? toaskStr : @"请填写家庭地址!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.familyModel.RegionID.length) {
        returnStr = returnStr.length ? returnStr : @"RegionID";
        toaskStr = toaskStr.length ? toaskStr : @"请选择行政区划!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    NSString *member = [NSString stringWithFormat:@"%@",self.familyModel.MemberCount];
    if (![member isNumText]) {
        returnStr = returnStr.length ? returnStr : @"MemberCount";
        toaskStr = toaskStr.length ? toaskStr : @"请输入有效数据!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }else{
    if (member.integerValue > 20 || member.integerValue < 0) {
        returnStr = returnStr.length ? returnStr : @"MemberCount";
        toaskStr = toaskStr.length ? toaskStr : @"请填写家庭地址!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    }
    NSString *current = [NSString stringWithFormat:@"%@",self.familyModel.CurrentCount];
    if (![current isNumText]) {
        returnStr = returnStr.length ? returnStr : @"CurrentCount";
        toaskStr = toaskStr.length ? toaskStr : @"请输入有效数据!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }else{
    if (current.integerValue > 20 || member.integerValue < 0) {
        returnStr = returnStr.length ? returnStr : @"CurrentCount";
        toaskStr = toaskStr.length ? toaskStr : @"请输入有效数据!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    }
    NSString *houseArea = [NSString stringWithFormat:@"%@",self.familyModel.HouseArea];
    if (self.familyModel.HouseArea != nil && ![houseArea isPureInt] && ![houseArea isPureFloat]) {
        returnStr = returnStr.length ? returnStr : @"HouseArea";
        toaskStr = toaskStr.length ? toaskStr : @"请输入有效数据!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    NSString *familyTel = self.familyModel.FamilyTel;


    if (![familyTel isPhoneNumber] || !familyTel.length) {
        returnStr = returnStr.length ? returnStr : @"FamilyTel";
        toaskStr = toaskStr.length ? toaskStr : @"请输入有效手机号码!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
//    NSString *remark = [NSString stringWithFormat:@"%@",self.familyModel.Remark];

//    if (remark.length > 200) {
//        [UIView makeToast:@"请输入200个字符以下的备注!"];
//        self.familyModel.Remark = [remark substringWithRange:NSMakeRange(0, 200)];
//    }
    NSString *customNum = self.familyModel.CustomNumber;

    if ([customNum includeChinese] && customNum.length) {
        returnStr = returnStr.length ? returnStr : @"CustomNumber";
        toaskStr = toaskStr.length ? toaskStr : @"编号只能由字符和数字组成!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (toaskStr.length) {
        [UIView makeToast:toaskStr];
    }
    return returnStr;
}
- (void)srollToCellWithCellCode:(NSString *)code{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code contains %@",code]; // code不是随便写的, 是模型中的属性; contains是包含后面%@这个字符串
    NSArray *array = self.dataManager.familyUIdata.content;
    NSArray *resultCities = [array filteredArrayUsingPredicate:predicate];
    if (resultCities.count) {
        BSArchiveModel *bsModel = resultCities.firstObject;
        NSUInteger index = [array indexOfObject:bsModel];
        [self.contentTableView scrollToRow:index inSection:0 atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self excuteCellAnimation:[NSIndexPath indexPathForRow:index inSection:0]];
    }
}
- (void)excuteCellAnimation:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self.contentTableView cellForRowAtIndexPath:indexPath];
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = [NSNumber numberWithFloat:-5];
    shake.toValue = [NSNumber numberWithFloat:5];
    shake.duration = 0.1;//执行时间
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 2;//次数
    [cell.layer addAnimation:shake forKey:@"shakeAnimation"];
}
@end
