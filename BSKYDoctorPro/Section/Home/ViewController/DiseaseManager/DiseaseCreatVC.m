//
//  DiseaseCreatVC.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "DiseaseCreatVC.h"
#import "ArchiveDiseaseDataManager.h"
#import "BSArchiveModel.h"
#import "ArchiveDiseaseModel.h"
#import "ArchiveDiseaseTableView.h"
#import "ArchiveChronicDiseaseRequest.h"
#import "NSDate+BSAdd.h"
#import "PersonHistoryModel.h"

@interface DiseaseCreatVC ()<UINavigationControllerDelegate>
@property (nonatomic ,strong) ArchiveDiseaseDataManager *dataManager;
@property (nonatomic ,strong) ArchiveDiseaseTableView *contentTableView;
@property (nonatomic ,strong) UIBarButtonItem *saveBtn;
@property (nonatomic ,strong) ArchiveDiseaseModel *diseaseModel;
@end

@implementation DiseaseCreatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    [MBProgressHUD showHud];
    
    [[BSAppManager sharedInstance] initDiseaseSuccess:^(__kindof BSBaseRequest * _Nonnull request) {
        
        [MBProgressHUD hideHud];
    } failure:^(__kindof BSBaseRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
    [self initInfo];
}
- (void)initInfo{
    //    self.dataManager.dataDic = [BSAppManager sharedInstance].dataDic;
    for (BSArchiveModel *bsModel in self.dataManager.diseaseUIdata.content) {
        if ([bsModel.code isEqualToString:@"diagnosisDate"] || [bsModel.code isEqualToString:@"recordDate"]) {
            bsModel.contentStr = bsModel.value = [NSDate currentDateStringWithFormat:@"yyyy-MM-dd"];
        }else if([bsModel.code isEqualToString:@"doctorID"]){
            bsModel.value = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;;
            bsModel.contentStr = [BSAppManager sharedInstance].currentUser.phisInfo.UserName;;
        }else if(bsModel.type == ArchiveModelTypeSelect){
            ArchiveSelectOptionModel *option = bsModel.selectModel.options.firstObject;
            bsModel.value = option.value;
        }
    }

}
//- (NSDictionary *)dictInfoToDic:(NSArray *)data{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    for (BSDictModel *model in data) {
//        [dic setObject:model.dictList forKey:model.type];
//    }
//    return dic;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)creatUI{
    self.title = @"新建档案";
    self.navigationItem.rightBarButtonItem = self.saveBtn;
    
    [self.view addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
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
- (ArchiveDiseaseTableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[ArchiveDiseaseTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom) style:UITableViewStylePlain withModel:self.dataManager];
    }
    return _contentTableView;
}
- (UIBarButtonItem *)saveBtn{
    if (!_saveBtn) {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.backgroundColor = [UIColor clearColor];
        rightButton.frame = CGRectMake(0, 0, 45, 40);
        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [rightButton setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
        rightButton.tintColor = [UIColor clearColor];
        rightButton.autoresizesSubviews = YES;
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        rightButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        [rightButton addTarget:self action:@selector(saveDataToServer) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return _saveBtn;
    
    
    
}
- (ArchiveDiseaseDataManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [ArchiveDiseaseDataManager dataManager];
    }
    return _dataManager;
}
- (ArchiveDiseaseModel *)initlationArchivModel{
    ArchiveDiseaseModel *model = [[ArchiveDiseaseModel alloc] init];
    NSArray *array = [model.cmPerson attributeList];
    for (BSArchiveModel *bsModel in self.dataManager.diseaseUIdata.content) {
        if ([bsModel.code isEqualToString:@"bp"]) {
            NSString *value = bsModel.value;
            NSArray *array = [value componentsSeparatedByString:@"|"];
            if (array.count >= 2) {
                model.examBody.rightDbp = [array objectAtIndex:1];
                model.examBody.rightSbp = array.firstObject;
            }
            
        }else if ([bsModel.code isEqualToString:@"doctorID"]){
            model.cmPerson.doctorID = bsModel.value;
            model.cmPerson.doctorName = bsModel.contentStr;
        }else if ([bsModel.code isEqualToString:@"clinicalComplications"]){
            model.cmHyLevel.clinicalComplications = bsModel.value;
        }else if ([bsModel.code isEqualToString:@"hyLevel"]){
            model.cmHyLevel.hyLevel = bsModel.value;
        }else if ([bsModel.code isEqualToString:@"otherRiskFactors"]){
            model.cmHyLevel.otherRiskFactors = bsModel.value;
        }else if ([bsModel.code isEqualToString:@"targetOrganDamage"]){
            model.cmHyLevel.targetOrganDamage = bsModel.value;
        }else if ([bsModel.code isEqualToString:@"personTel"]){
            model.personTel = bsModel.value;
        }else{
            if ([array containsObject:bsModel.code] && bsModel.value.length) {
                [model.cmPerson setValue:bsModel.value forKey:bsModel.code];
            }
        }
    }
    model.cmPerson.userID = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;
    model.cmPerson.userName = [BSAppManager sharedInstance].currentUser.phisInfo.UserName;
    model.cmPerson.orgID = [BSAppManager sharedInstance].currentUser.phisInfo.OrgId;
    switch (self.type) {
        case DiseaseArchivesCreateTypeGXY:{
            model.buildType = @"高血压";
            DiseaseModel *disease = [[BSAppManager sharedInstance].diseaseDic objectForKey:@"高血压"];
            model.cmPerson.diseaseKindID = disease.diseaseId;
        }
            break;
            
        default:
            break;
    }
    return model;
}
- (NSString *)checkModelNomal{
    NSString *str = nil;
    if (!self.diseaseModel.cmPerson.userID.length || !self.diseaseModel.cmPerson.userName.length || !self.diseaseModel.cmPerson.orgID.length) {
        return @"获取个人信息失败!";
    }
    if (!self.diseaseModel.cmPerson.personID.length) {
        return @"请选择居民!";
    }
    
    if (!self.diseaseModel.cmPerson.doctorID.length || !self.diseaseModel.cmPerson.doctorName.length) {
        return @"请选择责任医生!";
    }
    if (!self.diseaseModel.personTel.length) {
        return @"请输入联系电话!";
    }
    if (!self.diseaseModel.cmHyLevel.hyLevel.length) {
        return @"请选择血压分级!";
    }
    if (!self.diseaseModel.cmHyLevel.clinicalComplications.length) {
        return @"请选择临床并发症!";
    }
    if (!self.diseaseModel.cmHyLevel.otherRiskFactors.length) {
        return @"请选择其他危险因素!";
    }
    if (!self.diseaseModel.cmHyLevel.targetOrganDamage.length) {
        return @"请选择靶器官损害!";
    }
    if (!self.diseaseModel.examBody.rightDbp.length || !self.diseaseModel.examBody.rightSbp.length) {
        return @"请选择血压(mmHg)!";
    }
    if (!self.diseaseModel.cmPerson.diagnosisDate.length) {
        return @"请选择确症日期!";
    }
    if (!self.diseaseModel.cmPerson.recordDate.length) {
        return @"请选择建档日期!";
    }
    return str;
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
- (void)saveDataToServer{
    self.diseaseModel = [self initlationArchivModel];
    
    NSString *message = [self checkModelNomal];
    if (message.length) {
        [UIView makeToast:message];
        return;
    }
    
    
    Bsky_WeakSelf;
    [MBProgressHUD showHud];
    ArchiveChronicDiseaseRequest *request = [[ArchiveChronicDiseaseRequest alloc] init];
    ArchiveDiseaseModel *tempModel = [ArchiveDiseaseModel mj_objectWithKeyValues:[self.diseaseModel mj_keyValues]];
//    NSString *json = [self.diseaseModel mj_JSONString];
    [tempModel encryptModel];
    request.dataDic = [tempModel mj_keyValues];
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveChronicDiseaseRequest * _Nonnull request) {
        Bsky_StrongSelf;
        [MBProgressHUD hideHud];
        if (request.diseaseArchiveId.length) {
            [self.navigationController popViewControllerAnimated:YES];
            [UIView makeToast:@"保存成功"];
        }else{
            [UIView makeToast:@"保存失败"];
        }
        
    } failure:^(__kindof ArchiveChronicDiseaseRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
#pragma mark ----- BackButtonHandlerProtocol
- (void)backAction{
    if (self.diseaseModel.cmPerson.personID.length) {
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
        if (self.navigationController != nil && !self.diseaseModel.cmPerson.personID.length) {
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
    [ArchiveDiseaseDataManager dellocManager];
}

@end
