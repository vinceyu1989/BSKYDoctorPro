//
//  CreatFAViewController.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "CreatFAViewController.h"
#import "ArchiveFamilyTableView.h"
#import "ArchiveFamilyRequest.h"
#import "FamilyArchiveModel.h"
#import "ArchiveFamilyRequest.h"
#import "CreatPAViewController.h"
#import "BSFormsDicRequest.h"
#import "BSDictModel.h"


@interface CreatFAViewController ()
@property (nonatomic ,strong)UIButton *nextBtn;
@property (nonatomic ,strong)FamilyArchiveModel *familyModel;
@property (nonatomic ,strong)NSMutableDictionary *keyValueDic;
@end

@implementation CreatFAViewController

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
//    self.dataManager.dataDic = [BSAppManager sharedInstance].dataDic;
    for (BSArchiveModel *bsModel in self.dataManager.familyUIdata.content) {
        if (bsModel.type == ArchiveModelTypeSelect || bsModel.type == ArchiveModelTypeSlectOnLine || bsModel.type == ArchiveModelTypeSlectAndTextView) {
            if (bsModel.sourceCode.length) {
                bsModel.selectModel.options = [self.dataManager.dataDic objectForKey:bsModel.sourceCode];
            }
        }
    }
    
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
    self.title = @"新建家庭档案";

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
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setFrame:CGRectMake(0, self.contentTableView.bottom - 45, self.view.width, 45)];
        
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setBackgroundColor:UIColorFromRGB(0x4e7dd3)];
    }
    return _nextBtn;
}
- (ArchiveFamilyTableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[ArchiveFamilyTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.nextBtn.height - self.navigationController.navigationBar.bottom) style:UITableViewStylePlain withModel:self.dataManager];
    }
    return _contentTableView;
}

- (ArchiveFamilyDataManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [ArchiveFamilyDataManager dataManager];
    }
    return _dataManager;
}
- (void)nextAction{
    
    
    
    FamilyArchiveModel *model = [self initlationFamilyArchivModel];
    if (!self.familyModel.MemberCount.integerValue) {
        [UIView makeToast:@"请填写正确的家庭成员人数!"];
        return;
    }
    if (!self.familyModel.CurrentCount.integerValue) {
        [UIView makeToast:@"请填写正确的现住人口数!"];
        return;
    }   
    if (!self.familyModel.FamilyAddress.length) {
        [UIView makeToast:@"请填写家庭地址!"];
        return;
    }
    if (!self.familyModel.FamilyTel.integerValue) {
        [UIView makeToast:@"请填写电话号码!"];
        return;
    }
    if (!self.familyModel.RegionID.length) {
        [UIView makeToast:@"请选择行政区划!"];
        return;
    }
    CreatPAViewController *vc = [[CreatPAViewController alloc] init];
    vc.archiveFamilyModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (FamilyArchiveModel *)initlationFamilyArchivModel{
    self.familyModel = [[FamilyArchiveModel alloc] init];
    [self anilistMyClass:[FamilyArchiveModel class]];
    for (BSArchiveModel *model in self.dataManager.familyUIdata.content) {
        NSString *attr = [_keyValueDic objectForKey:model.code];
        if ([attr isEqualToString:[NSString stringWithUTF8String:object_getClassName([NSNumber class])]]) {
            if (model.value.length) {
                [self.familyModel setValue:[NSNumber numberWithInteger:model.value.integerValue] forKey:model.code];
            }
            
        }else{
            if ([model.code isEqualToString:@"Position"]) {
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
    BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
    self.familyModel.BuildEmployeeID = info.EmployeeID;
    self.familyModel.BuildOrgID = info.OrgId;
    
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
            return NO;
        }
        
        
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
@end
