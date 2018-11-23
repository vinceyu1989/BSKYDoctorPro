//
//  CreatPAViewController.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "CreatPAViewController.h"
#import "ArchivePickerTableViewCell.h"
#import "PersonBaseInfoModel.h"
#import "BSDictModel.h"
#import "BSFormsDicRequest.h"
#import "FamilyListModel.h"
#import "ArchiveFamilyListRequest.h"
#import "ArchiveSavePBInfoRequest.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "ArchiveFamilyRequest.h"
#import "ArchiveUpdatePBinfoRequest.h"
#import "ArchiveFamilyDataManager.h"
#import "ZLPersonTableView.h"
#import "DiseaseViewController.h"
#import "ZLCreatPersionRequest.h"
#import "ZLDiseaseModel.h"
#import "ArchiveSuccessView.h"

@interface CreatPAViewController ()

@end

const NSString *identify = @"C";

@interface CreatPAViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic ,strong) HMSegmentedControl *segmentedControl;
@property (nonatomic ,strong) NSArray *sectionTitleArray;
@property (nonatomic ,strong) UIBarButtonItem *saveBtn;
@property (nonatomic ,strong) PersonBaseInfoModel *recodePerson;
@property (nonatomic ,strong) PersonBaseInfoModel *currentPerson;
@property (nonatomic ,strong) ZLPersonTableView *zlTableView;
@property (nonatomic ,assign) NSUInteger zlDiseaseNum;
@property (nonatomic ,assign) NSUInteger zlFamilyFNum;
@property (nonatomic ,assign) NSUInteger zlFamilyMNum;
@property (nonatomic ,assign) NSUInteger zlFamilyBSNum;
@property (nonatomic ,assign) NSUInteger zlFamilySDNum;
@property (nonatomic ,assign) NSUInteger zlBloodNum;
@property (nonatomic ,assign) NSUInteger zlTraumaNum;
@property (nonatomic ,assign) NSUInteger zlSurgeryNum;
@property (nonatomic ,assign) NSUInteger zlDisabilityNum;
@end

@implementation CreatPAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    [self getArchiveDict];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (kiOS9Later) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
- (void)getArchiveDict{
    if([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2){
        [self getZLArchiveDict];
    }else{
        [self getWJWArchiveDict];
    }
}
- (void)getWJWArchiveDict{
    [MBProgressHUD showHud];
    Bsky_WeakSelf;
    [self.dataManager initWJWArchiveDatasuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        Bsky_StrongSelf;
        BSFormsDicRequest *formRequest = (BSFormsDicRequest *)request;
        [self initWJWDictInfo:formRequest.dictArray];
        [self.bsTableView reloadData];
        [MBProgressHUD hideHud];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
    }];
}
- (void)getZLArchiveDict{
    [MBProgressHUD showHud];
    Bsky_WeakSelf;
    [self.dataManager initZLArchiveDatasuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        Bsky_StrongSelf;
        BSFormsDicRequest *formRequest = (BSFormsDicRequest *)request;
        [self initZLDictInfo:formRequest.dictArray];
        [self.zlTableView reloadData];
        [MBProgressHUD hideHud];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
    }];
}
- (NSDictionary *)dictInfoToDic:(NSArray *)data{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (BSDictModel *model in data) {
        [dic setObject:model.dictList forKey:model.type];
    }
    return dic;
}
- (void)initZLDictInfo:(NSArray *)data{
    NSArray *array = [self.dataManager.zlPersonUIModel attributeList];
    self.dataManager.dataDic = [self dictInfoToDic:data];
    for (NSString *str in array) {
        ArchiveModel *model = [self.dataManager.zlPersonUIModel valueForKey:str];
        for (BSArchiveModel *bsModel in model.content) {
            if (bsModel.type == ArchiveModelTypeSelect || bsModel.type == ArchiveModelTypeSlectAndTextView || bsModel.type == ArchiveModelTypeSlectOnLine || bsModel.type == ArchiveModelTypeCustomPicker || bsModel.type == ArchiveModelTypeTextField || bsModel.type == ArchiveModelTypeDatePicker) {
                if (bsModel.sourceCode.length) {
                    if (bsModel.type == ArchiveModelTypeCustomPicker || bsModel.type == ArchiveModelTypeCustomOptionsPicker) {
                        ArchivePickerModel *picker = [[ArchivePickerModel alloc] init];
                        NSArray *options = [self.dataManager.dataDic objectForKey:bsModel.sourceCode];
                        [picker setValue:options forKey:@"options"];
                        bsModel.pickerModel = picker;
                    }else if (bsModel.type == ArchiveModelTypeSelect || bsModel.type == ArchiveModelTypeSlectOnLine || bsModel.type == ArchiveModelTypeSlectAndTextView){
                        NSArray *options = [self.dataManager.dataDic objectForKey:bsModel.sourceCode];
                        if (bsModel.selectModel) {
                            [bsModel.selectModel setValue:options forKey:@"options"];
                        }else{
                            ArchiveSelectModel *select = [[ArchiveSelectModel alloc] init];
                            
                            [select setValue:options forKey:@"options"];
                            bsModel.selectModel = select;
                        }
                        
                    }
//                    if ([bsModel.code isEqualToString:@"nation"]) {
//                        ArchivePickerModel *picker = [[ArchivePickerModel alloc] init];
//                        NSArray *options = [self.dataManager.dataDic objectForKey:@"gw_nation"];
//                        [picker setValue:options forKey:@"options"];
//                        bsModel.pickerModel = picker;
//                    }
//                    if ([bsModel.code isEqualToString:@"HouseholderRelationship"]) {
//                        ArchivePickerModel *picker = [[ArchivePickerModel alloc] init];
//                        NSArray *options = [self.dataManager.dataDic objectForKey:@"gw_relationship_with_holder"];
//                        self.dataManager.memberShipArray = options;
//                        [picker setValue:options forKey:@"options"];
//                        bsModel.pickerModel = picker;
//                        bsModel.contentStr = [[options firstObject] valueForKey:@"lebel"];
//                        bsModel.value = [[options firstObject] valueForKey:@"value"];
//                        if (self.archiveFamilyModel) {
//                            bsModel.canEdit = NO;
//                        }
                    
//                    }
                }else if([bsModel.code isEqualToString:@"registrationDate"]){
                    // 实例化NSDateFormatter
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    // 设置日期格式
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    // 获取当前日期
                    NSDate *currentDate = [NSDate date];
                    NSString *currentDateString = [formatter stringFromDate:currentDate];
                    bsModel.contentStr = currentDateString;
                    bsModel.value = currentDateString;
                }else if ([bsModel.code isEqualToString:@"CurrentAddress"] || [bsModel.code isEqualToString:@"ResidenceAddress"]){
                    if (self.familyModel) {
                        bsModel.contentStr = self.familyModel.FamilyAddress;
                        bsModel.value = self.familyModel.FamilyAddress;
                    }else if (self.archiveFamilyModel){
                        bsModel.contentStr = self.archiveFamilyModel.FamilyAddress;
                        bsModel.value = self.archiveFamilyModel.FamilyAddress;
                    }
                }if([bsModel.code isEqualToString:@"socialRelation"]){
                    if (!self.familyModel) {
                        bsModel.contentStr = @"本人或户主";
                        bsModel.value = @"0";
                        bsModel.canEdit = 0;
                        bsModel.type = ArchiveModelTypeLabel;
                    }
                }
                
            }else if ([bsModel.code isEqualToString:@"buildDoctorId"] || [bsModel.code isEqualToString:@"responsibleDoctorId"]){
                bsModel.value = [BSAppManager sharedInstance].currentUser.zlAccountInfo.employeeId;
                bsModel.contentStr = [BSAppManager sharedInstance].currentUser.zlAccountInfo.employeeName;
            }
        }
    }
}
- (void)initWJWDictInfo:(NSArray *)data{
    NSArray *array = [self.dataManager.dataModel attributeList];
//    self.dataManager.dataDic = [self dictInfoToDic:data];
    for (NSString *str in array) {
        ArchiveModel *model = [self.dataManager.dataModel valueForKey:str];
        for (BSArchiveModel *bsModel in model.content) {
            if (bsModel.type == ArchiveModelTypeSelect || bsModel.type == ArchiveModelTypeSlectAndTextView || bsModel.type == ArchiveModelTypeSlectOnLine || bsModel.type == ArchiveModelTypeCustomPicker || bsModel.type == ArchiveModelTypeTextField || bsModel.type == ArchiveModelTypeDatePicker || bsModel.type == ArchiveModelTypeControllerPicker) {
                if (bsModel.type == ArchiveModelTypeSelect || bsModel.type == ArchiveModelTypeSlectOnLine || bsModel.type == ArchiveModelTypeSlectAndTextView) {
                    if (bsModel.sourceCode.length) {
                        bsModel.selectModel.options = [self.dataManager.dataDic objectForKey:bsModel.sourceCode];
                    }
                }
                if (bsModel.type == ArchiveModelTypeCustomPicker) {
                    if ([bsModel.code isEqualToString:@"NationCode"]) {
                        ArchivePickerModel *picker = [[ArchivePickerModel alloc] init];
                        NSArray *options = [self.dataManager.dataDic objectForKey:@"gw_nation"];
                        [picker setValue:options forKey:@"options"];
                        bsModel.pickerModel = picker;
                    }
                    if ([bsModel.code isEqualToString:@"HouseholderRelationship"]) {
                        ArchivePickerModel *picker = [[ArchivePickerModel alloc] init];
                        NSArray *options = [self.dataManager.dataDic objectForKey:@"gw_relationship_with_holder"];
                        self.dataManager.memberShipArray = options;
                        [picker setValue:options forKey:@"options"];
                        bsModel.pickerModel = picker;
                        if (self.archiveFamilyModel) {
                            bsModel.contentStr = [[options firstObject] valueForKey:@"lebel"];
                            bsModel.value = [[options firstObject] valueForKey:@"value"];
                            bsModel.canEdit = NO;
                        }
                        
                    }
                }else if([bsModel.code isEqualToString:@"BuildDate"]){
                    // 实例化NSDateFormatter
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    // 设置日期格式
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    // 获取当前日期
                    NSDate *currentDate = [NSDate date];
                    NSString *currentDateString = [formatter stringFromDate:currentDate];
                    bsModel.contentStr = currentDateString;
                    bsModel.value = currentDateString;
                }else if ([bsModel.code isEqualToString:@"CurrentAddress"] || [bsModel.code isEqualToString:@"ResidenceAddress"]){
                    if (self.familyModel) {
                        NSString *resultStr = [self.familyModel.FamilyAddress stringByReplacingOccurrencesOfString:@">" withString:@""];
                        resultStr = [resultStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                        bsModel.contentStr = resultStr;
                        bsModel.value = resultStr;
                    }else if (self.archiveFamilyModel){
                        NSString *resultStr = [self.archiveFamilyModel.FamilyAddress stringByReplacingOccurrencesOfString:@">" withString:@""];
                        resultStr = [resultStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                        bsModel.contentStr = resultStr;
                        bsModel.value = resultStr;
                    }
                } else if (bsModel.type == ArchiveModelTypeControllerPicker && [bsModel.code isEqualToString:@"ResponsibilityDoctor"]){
                    BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
                    bsModel.contentStr = info.UserName;
                    bsModel.value = info.EmployeeID;
                }
                
            }
        }
    }
}
- (void)creatUI{
    if([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2){
        [self creatZLUI];
    }else{
        [self creatWJWUI];
    }
    
    
    
}
- (void)creatWJWUI{
    self.title = @"快速建档";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.navigationItem.rightBarButtonItem = self.saveBtn;
    
    [self.view addSubview:self.segmentedControl];
    
    
    [self.view addSubview:self.bsTableView];
}
- (void)creatZLUI{
    self.title = @"快速建档";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.navigationItem.rightBarButtonItem = self.saveBtn;
    
    [self.view addSubview:self.segmentedControl];
    
    
    [self.view addSubview:self.zlTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 方法
//保存数据
- (void)saveZLDataToServer{
    
    
    [self.view endEditing:YES];
    [self initilationZLPersonModel];
    if (!self.zlPersonModel.personInfo.buildDoctorId.length) {
        [self srollToCellWithCellCode:@"buildDoctorId"];
        [UIView makeToast:@"请完善建档人信息!"];
        return;
    }
    if (!self.zlPersonModel.personInfo.socialRelation.length && self.familyModel) {
        [self srollToCellWithCellCode:@"socialRelation"];
        [UIView makeToast:@"请完善社会关系信息!"];
        return;
    }
    if (!self.zlPersonModel.personInfo.city.length || !self.zlPersonModel.personInfo.committee.length || !self.zlPersonModel.personInfo.district.length || !self.zlPersonModel.personInfo.province.length) {
        [self srollToCellWithCellCode:@"province,city,district"];
        [UIView makeToast:@"请完善现住址信息!"];
        return;
    }
    if (!self.zlPersonModel.personInfo.registerCity.length || !self.zlPersonModel.personInfo.registerCommittee.length || !self.zlPersonModel.personInfo.registerDistrict.length || !self.zlPersonModel.personInfo.registerProvince.length) {
        [self srollToCellWithCellCode:@"registerProvince,registerCity,registerDistrict"];
        [UIView makeToast:@"请完善户籍住址信息!"];
        return;
    }
    if (!self.zlPersonModel.personInfo.name.length) {
        [self srollToCellWithCellCode:@"name"];
        [UIView makeToast:@"请完善姓名信息!"];
        return;
    }
    if (!self.zlPersonModel.personInfo.dateOfBirth.length) {
        [self srollToCellWithCellCode:@"dateOfBirth"];
        [UIView makeToast:@"请完善出生日期信息!"];
        return;
    }
    if (!self.zlPersonModel.personInfo.cardId.length) {
        [self srollToCellWithCellCode:@"cardId"];
        [UIView makeToast:@"请完善身份证信息!"];
        return;
    }
    if (!self.zlPersonModel.personInfo.telPhone.length) {
        [self srollToCellWithCellCode:@"telPhone"];
        [UIView makeToast:@"请完善本人电话信息!"];
        return;
    }
    if (!self.zlPersonModel.personInfo.responsibleDoctor.length || !self.zlPersonModel.personInfo.responsibleDoctorId.length) {
        [self srollToCellWithCellCode:@"responsibleDoctorId"];
        [UIView makeToast:@"请完善责任医生信息!"];
        return;
    }
    [self saveZLPersonToServer];
    
}
- (void)srollToCellWithCellCode:(NSString *)code{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code contains %@",code]; // code不是随便写的, 是模型中的属性; contains是包含后面%@这个字符串
    NSArray *array = self.dataManager.zlPersonUIModel.personInfo.content;
    NSArray *resultCities = [array filteredArrayUsingPredicate:predicate];
    if (resultCities.count) {
        BSArchiveModel *bsModel = resultCities.firstObject;
        NSUInteger index = [array indexOfObject:bsModel];
        [self.zlTableView scrollToRow:index inSection:0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
- (void)pushToSuccessView{
    ArchiveSuccessView *view = [[ArchiveSuccessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    [view show];
}
- (void)saveZLPersonToServer{
    ZLCreatPersionRequest *request = [[ZLCreatPersionRequest alloc] init];
    request.residentForm = [self.zlPersonModel mj_keyValues];
    NSString *str = [self.zlPersonModel mj_JSONString];
//    return;
    [MBProgressHUD showHud];
    [request startWithCompletionBlockWithSuccess:^(__kindof ZLCreatPersionRequest * _Nonnull request) {
        [UIView makeToast:@"保存成功"];
        [MBProgressHUD hideHud];
        [self pushToSuccessView];
    } failure:^(__kindof ZLCreatPersionRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
- (void)saveWJWDataToServer{
    [self.view endEditing:YES];
    [self initilationPersonModel];
    
    if (!self.personModel.Name.length) {
        [UIView makeToast:@"请完善姓名信息!"];
        return;
    }
    if (!self.personModel.GenderCode) {
        [UIView makeToast:@"请完善性别信息!"];
        return;
    }
    if (!self.personModel.BirthDay.length) {
        [UIView makeToast:@"请完善出生日期信息!"];
        return;
    }
    if (!self.personModel.CardID.length) {
        [UIView makeToast:@"请完善身份证信息!"];
        return;
    }
    if (!self.personModel.WorkOrgName.length) {
        [UIView makeToast:@"请完善工作单位信息!"];
        return;
    }
    if (!self.personModel.PersonTel.length) {
        [UIView makeToast:@"请完善个人电话信息!"];
        return;
    }
    if (!self.personModel.CurrentAddress.length) {
        [UIView makeToast:@"请完善现住地信息!"];
        return;
    }
    if (!self.personModel.ResidenceAddress.length) {
        [UIView makeToast:@"请完善户籍地址信息!"];
        return;
    }
    if (!self.personModel.HouseholderRelationship) {
        [UIView makeToast:@"请完善与户主的关系!"];
        return;
    }
    if (!self.personModel.ResType) {
        [UIView makeToast:@"请完善户口类别信息!"];
        return;
    }
    if (!self.personModel.NationCode) {
        [UIView makeToast:@"请完善民族信息!"];
        return;
    }
    if (!self.personModel.ResponsibilityID) {
        [UIView makeToast:@"请完善责任医生信息!"];
        return;
    }
    
    if (self.bsTableView.superview) {
        if (self.archiveFamilyModel && !self.archiveFamilyModel.ID.length) {
            [self saveFamilyAndPersonInfoToServer];
        }else{
            
            self.personModel.RegionID = self.familyModel.RegionID;
            if (self.archiveFamilyModel && self.archiveFamilyModel.ID.length) {
                self.personModel.FamilyID = self.archiveFamilyModel.ID;
            }else{
                self.personModel.FamilyID = self.familyModel.FamilyID;
            }
            if (self.archiveFamilyModel && [ArchiveFamilyDataManager dataManager].regionCode.length) {
                self.personModel.RegionCode = [ArchiveFamilyDataManager dataManager].regionCode;
            }else{
                self.personModel.RegionCode = self.familyModel.RegionCode;
            }
            
            [self saveBaseInfoToServer];
        }
        
    }
}
- (void)saveDataToServer{
    if ([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2) {
        [self saveZLDataToServer];
    }else{
        [self saveWJWDataToServer];
    }
}
- (void)popToViewContoller{
    if (!self.archiveFamilyModel) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([self.navigationController.viewControllers count] > 2) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        
    }
}
- (void)saveFamilyAndPersonInfoToServer{
    PersonBaseInfoModel *model = self.personModel;
    self.archiveFamilyModel.MasterCardID = model.CardID;
    self.archiveFamilyModel.MasterName = model.Name;
    self.archiveFamilyModel.BuildDate = model.BuildDate;
    ArchiveFamilyRequest *request = [[ArchiveFamilyRequest alloc] init];
//    NSString *jsonstr = [self.archiveFamilyModel mj_JSONString];
    id object = [self.archiveFamilyModel mj_keyValues];
    FamilyArchiveModel *encryptModel = [FamilyArchiveModel mj_objectWithKeyValues:object];
    [encryptModel encryptModel];
    request.familyArchiveInVM = [encryptModel mj_keyValues];
    [MBProgressHUD showHud];
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveFamilyRequest * _Nonnull request) {
        Bsky_StrongSelf;
        self.archiveFamilyModel = request.familyModel;
        [ArchiveFamilyDataManager dataManager].familyModel = request.familyModel;
        self.personModel.RegionID = self.archiveFamilyModel.RegionID;
        
        self.personModel.FamilyID = self.archiveFamilyModel.ID;
        
        self.personModel.RegionCode =[ArchiveFamilyDataManager dataManager].regionCode;
        [UIView makeToast:@"家庭档保存成功!"];
        [MBProgressHUD hideHud];
        [self saveBaseInfoToServer];
    } failure:^(__kindof ArchiveFamilyRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
- (void)saveBaseInfoToServer{
    
    [MBProgressHUD showHud];
    if (self.personModel.ID) {
        ArchiveUpdatePBinfoRequest *request = [[ArchiveUpdatePBinfoRequest alloc] init];
        request.residentInVM = [self.personModel mj_keyValues];
        NSString *str = [self.personModel mj_JSONString];
        Bsky_WeakSelf;
        [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveUpdatePBinfoRequest * _Nonnull request) {
            Bsky_StrongSelf;
            [UIView makeToast:@"个人档更新成功!"];
            [ArchivePersonDataManager dataManager].personBaseInof = request.infoModel;
            self.personModel.ID = request.infoModel.ID;
            self.recodePerson = self.currentPerson;
            [MBProgressHUD hideHud];
        } failure:^(__kindof ArchiveUpdatePBinfoRequest * _Nonnull request) {
            [UIView makeToast:request.msg];
            [MBProgressHUD hideHud];
        }];
    }else{
        Bsky_WeakSelf;
        [self.dataManager savePersonBaseInfoWithModel:self.personModel success:^(__kindof ArchiveSavePBInfoRequest * _Nonnull request) {
            Bsky_StrongSelf;
            [UIView makeToast:@"个人档保存成功!"];
            [ArchivePersonDataManager dataManager].personBaseInof = request.infoModel;
            self.personModel.ID = request.infoModel.ID;
            self.recodePerson = self.currentPerson;
            [MBProgressHUD hideHud];
        } failure:^(__kindof ArchiveSavePBInfoRequest * _Nonnull request) {
            [UIView makeToast:request.msg];
            [MBProgressHUD hideHud];
        }];
    }
    
    
}
- (PersonBaseInfoModel *)initilationPersonModel{
    
    self.personModel = [self savePerson];
    return self.personModel;
}
- (ZLPersonModel *)initilationZLPersonModel{
    
    [self saveZLPerson];
    self.zlPersonModel.personInfo.buildOrgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
    self.zlPersonModel.personInfo.buildOrg = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
    self.zlPersonModel.personInfo.manageOrgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
    self.zlPersonModel.personInfo.manageOrg = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
    if ([self.familyModel isKindOfClass:[ZLFamilyListModel class]]) {
        [self.zlPersonModel.personInfo setValue:[self.familyModel valueForKey:@"familyId"] forKey:@"familyId"];
    }
    return self.zlPersonModel;
}
- (void)saveZLPerson{
    self.zlPersonModel = [[ZLPersonModel alloc] init];
    self.zlPersonModel.environment = [[Environment alloc] init];
    self.zlPersonModel.otherInfo = [[OtherInfo alloc] init];
    self.zlPersonModel.personInfo = [[PersonInfo alloc] init];
    [self saveZLTableInfoToPersonModel:self.zlPersonModel];

}
- (void)handleZLAdress:(ZLPersonModel *)bsPerson keyStr:(NSString *)keyStr valueStr:(NSString *)valueStr{
    NSArray *keys = [keyStr componentsSeparatedByString:@","];
    NSArray *values = [valueStr componentsSeparatedByString:@","];
    for (NSInteger i = 0 ; i < keys.count ; i ++) {
        NSString *key = [keys objectAtIndex:i];
        if (i < values.count) {
            NSString *value = [values objectAtIndex:i];
            [bsPerson.personInfo setValue:value forKey:key];
        }
    }
}
- (void)initializeZLSaveNum{
    self.zlBloodNum = 1;
    self.zlTraumaNum = 1;
    self.zlSurgeryNum = 1;
    self.zlDiseaseNum = 12;
    self.zlFamilyFNum = 11;
    self.zlFamilyMNum = 11;
    self.zlFamilyBSNum = 11;
    self.zlFamilySDNum = 11;
    self.zlDisabilityNum = 1;
}
- (void)saveZLTableInfoToPersonModel:(ZLPersonModel *)bsPerson{
    NSMutableArray *array = [self.dataManager.zlPersonUIModel attributeList];
    NSMutableString *addressStr = [[NSMutableString alloc] init];
    NSMutableString *registerAddressStr = [[NSMutableString alloc] init];
    NSMutableArray *historyArray = [[NSMutableArray alloc] init];
    [self initializeZLSaveNum];
    for (NSString *str in array) {
        ArchiveModel *mode = [self.dataManager.zlPersonUIModel valueForKey:str];
        for (BSArchiveModel *bsModel in mode.content) {
            id value = nil;
            if (bsModel.value.length) {
                value = bsModel.value;
            }else if (bsModel.contentStr.length){
                value = bsModel.contentStr;
            }
            if ([bsModel.code isEqualToString:@"photo"]) {
                bsPerson.photo = bsModel.value;
            }else if ([bsModel.code isEqualToString:@"responsibleDoctorId"]) {
                bsPerson.personInfo.responsibleDoctorId = bsModel.value;
                bsPerson.personInfo.responsibleDoctor = bsModel.contentStr;
            }else if ([bsModel.code isEqualToString:@"buildDoctorId"]) {
                bsPerson.personInfo.buildDoctorId = bsModel.value;
                bsPerson.personInfo.buildDoctor = bsModel.contentStr;
            }else if ([bsModel.code isEqualToString:@"province,city,district"]) {
                [self handleZLAdress:bsPerson keyStr:bsModel.code valueStr:bsModel.value];
                [addressStr appendString:bsModel.contentStr];
            }else if ([bsModel.code isEqualToString:@"township,committee"]) {
                [self handleZLAdress:bsPerson keyStr:bsModel.code valueStr:bsModel.value];
                [addressStr appendString:bsModel.contentStr];
            }else if ([bsModel.code isEqualToString:@"registerProvince,registerCity,registerDistrict"]) {
                [self handleZLAdress:bsPerson keyStr:bsModel.code valueStr:bsModel.value];
                [registerAddressStr appendString:bsModel.contentStr];
            }else if ([bsModel.code isEqualToString:@"registerTownship,registerCommittee"]) {
                [self handleZLAdress:bsPerson keyStr:bsModel.code valueStr:bsModel.value];
                [registerAddressStr appendString:bsModel.contentStr];
            }else if ([bsModel.code isEqualToString:@"medicalPayment"]){
//                NSString *strValue = (NSString *)value;
                NSUInteger count = 1;
                if ([bsModel.selectModel.selectArray containsObject:bsModel.selectModel.options.lastObject]){
                    bsPerson.otherInfo.medicalPaymentOther = bsModel.contentStr;
                    count = 2;
                }
                if ([bsModel.selectModel.selectArray count]){
                    NSMutableString *payStr = [[NSMutableString alloc] init];
                    for (NSInteger i = 0 ; i < bsModel.selectModel.selectArray.count ; i ++){
                        ArchiveSelectOptionModel *select = [bsModel.selectModel.selectArray objectAtIndex:i];
                        NSString *title = select.title;
                        if (![title containsString:@"其他"]) {
                        
                            [payStr appendString:title];
                        }
                        if (i < bsModel.selectModel.selectArray.count - 1){
                            [payStr appendString:@","];
                        }
                    }
                    [bsPerson.otherInfo setValue:payStr forKey:bsModel.code];
                }
            }else if ([bsModel.code isEqualToString:@"exposure"]){
                
                NSMutableString *payStr = [[NSMutableString alloc] init];
                for (NSInteger i = 0 ; i < bsModel.selectModel.selectArray.count ; i ++){
                    ArchiveSelectOptionModel *select = [bsModel.selectModel.selectArray objectAtIndex:i];
                    NSString *title = select.title;
                    if (![title containsString:@"其他"]) {
                        
                        [payStr appendString:title];
                    }
                    if (i < bsModel.selectModel.selectArray.count - 1){
                        [payStr appendString:@","];
                    }
                }
                [bsPerson.otherInfo setValue:payStr forKey:bsModel.code];
            }else if ([bsModel.code isEqualToString:@"geneticDisease"]){
                if ([bsModel.selectModel.options count]) {
                    ZLDiseaseModel *disease = bsModel.selectModel.options.firstObject;
                    self.zlPersonModel.otherInfo.hasHereditaryDisease = @"2";
                    self.zlPersonModel.otherInfo.hereditaryDisease = disease.name;
                }
            }else if ([bsModel.code isEqualToString:@"drugAllergy"]){
                if ([bsModel.selectModel.selectArray count]) {
                    self.zlPersonModel.otherInfo.drugAllergy = [self handleMutilableArrayToStr:bsModel.selectModel.selectArray attribute:@"title" includeOther:NO];
                    if ([bsModel.selectModel.others count]) {
                        self.zlPersonModel.otherInfo.drugAllergyOther = [self handleMutilableArrayToStr:bsModel.selectModel.others attribute:@"value" includeOther:NO   ];
                    }
                }
                
            }else{
                if (![value length] && bsModel.type != ArchiveModelTypeAddSubCell) {
                    continue;
                }
                if (bsModel.upModelName.length) {
                    [[bsPerson valueForKey:bsModel.upModelName] setValue:value forKey:bsModel.code];
                    continue;
                }
                if ([str isEqualToString:@"personInfo"]) {
                    [bsPerson.personInfo setValue:value forKey:bsModel.code];
                } else if ([str isEqualToString:@"otherInfo"]) {
                    [bsPerson.otherInfo setValue:value forKey:bsModel.code];
                } else if ([str isEqualToString:@"medicalHistoryInfo"]) {
//                    [bsPerson. setValue:value forKey:bsModel.code];
                    [self handleZLHistoryModel:bsModel history:historyArray];
                } else if ([str isEqualToString:@"pastHistory"]) {
//                    [bsPerson setValue:value forKey:bsModel.code];
                    [self handleZLHistoryModel:bsModel history:historyArray];
                } else if ([str isEqualToString:@"familyHistory"]) {
//                    [bsPerson setValue:value forKey:bsModel.code];
                    [self handleZLHistoryModel:bsModel history:historyArray];
                } else if ([str isEqualToString:@"environment"]) {
                     NSString *strValue = (NSString *)value;
                    if ([strValue isKindOfClass:[NSString class]] && [strValue isNumText] && [strValue length] == 8 && [bsModel.selectModel.selectArray count]){
                        ArchiveSelectOptionModel *select = bsModel.selectModel.selectArray.firstObject;
                        [bsPerson.environment setValue:select.title forKey:bsModel.code];
        
                    }else{
                         [bsPerson.environment setValue:value forKey:bsModel.code];
                    }
                    
                }
                
            }
            
            
        }
    }
    bsPerson.personInfo.address = addressStr.length ? addressStr : nil;
    bsPerson.personInfo.registerAddress = registerAddressStr.length ? registerAddressStr : nil;
    bsPerson.history = historyArray;
//    self.zlPersonModel = [PersonBaseInfoModel mj_objectWithKeyValues:[bsPerson mj_keyValues]];
}
- (NSString *)handleMutilableArrayToStr:(NSArray *)array attribute:(NSString *)attribute includeOther:(BOOL )include{
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (NSInteger i = 0 ; i < array.count ; i ++) {
        ArchiveSelectOptionModel *option = [array objectAtIndex:i];
        NSString *value = [option valueForKey:attribute];
        if (!include) {
            if ([option.title isEqualToString:@"其他"]) {
                NSString *subStr = [resultStr substringWithRange:NSMakeRange(0, resultStr.length - 1)];
                resultStr = [NSMutableString stringWithFormat:subStr];
            }else{
                [resultStr appendString:value];
                if (i != array.count - 1) {
                    [resultStr appendString:@","];
                }
            }
        }else{
            [resultStr appendString:value];
            if (i != array.count - 1) {
                [resultStr appendString:@","];
            }
        }
    }
    return resultStr;
}
- (void)handleZLHistoryCodeDic{
    if (![ArchivePersonDataManager dataManager].zlHistoryCodeSet.count && self.dataManager.dataDic.count) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSArray *array = [self.dataManager.dataDic objectForKey:@"zl_previous_project_type"];
        for (ArchiveSelectOptionModel *option in array) {
            [dic setObject:option forKey:option.value];
        }
        self.dataManager.zlHistoryCodeSet = dic;
    }
}
- (void)handleZLHistoryModel:(BSArchiveModel *)model history:(NSMutableArray *)array;{
    [self handleZLHistoryCodeDic];
    if ([model.code isEqualToString:@"bloodHistory"]){
        if (model.type == ArchiveModelTypeAddSubCell) {
            ZLHistoryModel *historyModel = [[ZLHistoryModel alloc] init];
            ArchiveSelectOptionModel *option = [self.dataManager.zlHistoryCodeSet objectForKey:@"07"];
            historyModel.projectCode = option.value;
            historyModel.projectName = option.title;
            historyModel.orgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
            historyModel.orgName = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
            for (BSArchiveModel *bsmodel in model.addModel.adds) {
                [historyModel setValue:bsmodel.value forKey:bsmodel.code];
            }
            historyModel.saveNum = [NSString stringWithFormat:@"%lu",(unsigned long)self.zlBloodNum ++];
            [array addObject:historyModel];
        }
    } else if ([model.code isEqualToString:@"familyHistory"]){
        if (model.type == ArchiveModelTypeAddSubCell) {
            BSArchiveModel *relationModel = model.addModel.adds.firstObject;
            ArchiveSelectOptionModel *dic = relationModel.pickerModel.selectOption;
            BSArchiveModel *diseaseModel = model.addModel.adds.lastObject;
            for (ArchiveSelectOptionModel *option in diseaseModel.selectModel.selectArray) {
                if (![option.title containsString:@"其他"]) {
                    ZLHistoryModel *historyModel = [[ZLHistoryModel alloc] init];
                    ArchiveSelectOptionModel *progect = [self.dataManager.zlHistoryCodeSet objectForKey:dic.value];
                    historyModel.projectCode = progect.value;
                    historyModel.projectName = progect.title;
                    historyModel.resultCode = option.standardCode;
                    historyModel.resultValue = option.title;
                    historyModel.orgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
                    historyModel.orgName = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
                    historyModel.saveNum = option.value;
                    [array addObject:historyModel];
                }
            }
            for (ZLDiseaseModel *disease in diseaseModel.selectModel.others) {
                ZLHistoryModel *historyModel = [[ZLHistoryModel alloc] init];
                ArchiveSelectOptionModel *progect = [self.dataManager.zlHistoryCodeSet objectForKey:dic.value];
                historyModel.projectCode = progect.value;
                historyModel.projectName = progect.title;
                historyModel.resultCode = disease.code;
                historyModel.resultValue = disease.name;
                historyModel.orgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
                historyModel.orgName = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
                switch (dic.value.intValue) {
                    case 8:
                        historyModel.saveNum = [NSString stringWithFormat:@"%lu",self.zlFamilyFNum ++];
                        break;
                    case 9:
                        historyModel.saveNum = [NSString stringWithFormat:@"%lu",self.zlFamilyMNum ++];
                        break;
                    case 10:
                        historyModel.saveNum = [NSString stringWithFormat:@"%lu",self.zlFamilyBSNum ++];
                        break;
                    case 11:
                        historyModel.saveNum = [NSString stringWithFormat:@"%lu",self.zlFamilySDNum ++];
                        break;
                    default:
                        break;
                }
                [array addObject:historyModel];
            }
        }
    } else if ([model.code isEqualToString:@"traumaHistory"]){
        if (model.type == ArchiveModelTypeAddSubCell) {
            
            ZLHistoryModel *historyModel = [[ZLHistoryModel alloc] init];
            ArchiveSelectOptionModel *option = [self.dataManager.zlHistoryCodeSet objectForKey:@"16"];
            historyModel.projectCode = option.value;
            historyModel.projectName = option.title;
            historyModel.orgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
            historyModel.orgName = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
            for (BSArchiveModel *bsmodel in model.addModel.adds) {
                [historyModel setValue:bsmodel.value forKey:bsmodel.code];
            }
            historyModel.saveNum = [NSString stringWithFormat:@"%lu",self.zlTraumaNum ++];
            [array addObject:historyModel];
            
        }
    } else if ([model.code isEqualToString:@"surgeryHistory"]){
        if (model.type == ArchiveModelTypeAddSubCell) {
            
            ZLHistoryModel *historyModel = [[ZLHistoryModel alloc] init];
            ArchiveSelectOptionModel *option = [self.dataManager.zlHistoryCodeSet objectForKey:@"06"];
            historyModel.projectCode = option.value;
            historyModel.projectName = option.title;
            historyModel.orgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
            historyModel.orgName = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
            for (BSArchiveModel *bsmodel in model.addModel.adds) {
                [historyModel setValue:bsmodel.value forKey:bsmodel.code];
            }
            historyModel.saveNum = [NSString stringWithFormat:@"%lu",self.zlSurgeryNum ++];
            [array addObject:historyModel];
            
        }
    } else if ([model.code isEqualToString:@"diseaseHistoryEspecial"]){
        if (model.type == ArchiveModelTypeAddSubCell) {
            ZLHistoryModel *historyModel = [[ZLHistoryModel alloc] init];
            ArchiveSelectOptionModel *option = [self.dataManager.zlHistoryCodeSet objectForKey:@"05"];
            historyModel.projectCode = option.value;
            historyModel.projectName = option.title;
            historyModel.orgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
            historyModel.orgName = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
            NSMutableString *describe = [[NSMutableString alloc] init];
            for (BSArchiveModel *bsmodel in model.addModel.adds) {
                if ([bsmodel.code isEqualToString:@"diseaseDiscrebe"]) {
                    if (bsmodel.value.length) {
                        [describe appendString:[NSString stringWithFormat:@":%@",bsmodel.value]];
                    }
                }else if ([bsmodel.code isEqualToString:@"dateStart"]){
                    [historyModel setValue:bsmodel.value forKey:bsmodel.code];
                }else if ([bsmodel.code isEqualToString:@"diseaseKindId"]){
                    ArchiveSelectOptionModel *select = bsmodel.pickerModel.selectOption;
                    [describe appendString:select.title];
                    historyModel.resultCode = select.standardCode;
                    historyModel.saveNum = select.value;
                }
            }
            historyModel.resultValue = describe;
//            historyModel.saveNum = [NSString stringWithFormat:@"%lu",(unsigned long)self.zlDiseaseNum ++];
            [array addObject:historyModel];
        }
    } else if ([model.code isEqualToString:@"diseaseHistoryOther"]){
        if (model.type == ArchiveModelTypeAddSubCell) {
            ZLHistoryModel *historyModel = [[ZLHistoryModel alloc] init];
            ArchiveSelectOptionModel *option = [self.dataManager.zlHistoryCodeSet objectForKey:@"05"];
            historyModel.projectCode = option.value;
            historyModel.projectName = option.title;
            historyModel.orgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
            historyModel.orgName = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
            for (BSArchiveModel *bsmodel in model.addModel.adds) {
                if ([bsmodel.code isEqualToString:@"diseaseDiscrebe"]) {
                    
                    historyModel.resultValue = bsmodel.contentStr;
                    historyModel.resultCode = bsmodel.value;
                }else if ([bsmodel.code isEqualToString:@"dateStart"]){
                    [historyModel setValue:bsmodel.value forKey:bsmodel.code];
                }
            }
            historyModel.saveNum = [NSString stringWithFormat:@"%lu",(unsigned long)self.zlDiseaseNum ++];
            [array addObject:historyModel];
        }
    } else if ([model.code isEqualToString:@"diseaseHistory"]){
        if (model.type == ArchiveModelTypeAddSubCell) {
           
            ZLHistoryModel *historyModel = [[ZLHistoryModel alloc] init];
            ArchiveSelectOptionModel *option = [self.dataManager.zlHistoryCodeSet objectForKey:@"05"];
            historyModel.projectCode = option.value;
            historyModel.projectName = option.title;
            historyModel.orgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
            historyModel.orgName = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
            for (BSArchiveModel *bsmodel in model.addModel.adds) {
                if ([bsmodel.code isEqualToString:@"diseaseKindId"]) {
                    ArchiveSelectOptionModel *select = bsmodel.pickerModel.selectOption;
                    historyModel.resultValue = select.title;
                    historyModel.resultCode = select.standardCode;
                    historyModel.saveNum = select.value;
                }else{
                    [historyModel setValue:bsmodel.value forKey:bsmodel.code];
                }
            }
            
            [array addObject:historyModel];
            
        }
    } else if ([model.code isEqualToString:@"disability"]){
        for (ArchiveSelectOptionModel *sub in model.selectModel.selectArray) {
            if (![sub.title containsString:@"其他"]) {
                ZLHistoryModel *historyModel = [[ZLHistoryModel alloc] init];
                ArchiveSelectOptionModel *option = [self.dataManager.zlHistoryCodeSet objectForKey:@"14"];
                historyModel.projectCode = option.value;
                historyModel.projectName = option.title;
                historyModel.orgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
                historyModel.orgName = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
                historyModel.resultValue = sub.title;
                historyModel.saveNum = sub.value;
                [array addObject:historyModel];
            }else{
                if (model.contentStr.length) {
                    ZLHistoryModel *historyModel = [[ZLHistoryModel alloc] init];
                    ArchiveSelectOptionModel *option = [self.dataManager.zlHistoryCodeSet objectForKey:@"14"];
                    historyModel.projectCode = option.value;
                    historyModel.projectName = option.title;
                    historyModel.orgId = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgId;
                    historyModel.orgName = [BSAppManager sharedInstance].currentUser.zlAccountInfo.orgName;
                    historyModel.resultValue = model.contentStr;
                    historyModel.saveNum = sub.value;
                    [array addObject:historyModel];
                }
                
            }
        }
//        if (model.contentStr.length){
        
//        }
    } else {
        
    }
}
- (PersonBaseInfoModel *)savePerson{
    NSMutableArray *array = [self.dataManager.dataModel attributeList];
    PersonBaseInfoModel *bsPerson = [[PersonBaseInfoModel alloc] init];
    [self saveTableInfoToPersonModel:bsPerson];
    //    UIImage *image = [UIImage imageNamed:@"persion"];
    //    NSData *imageData = UIImageJPEGRepresentation(image,1);
    //    NSString * base64 = [imageData base64EncodedString];
    //
    //    if (!bsPerson.Photo.length) {
    //        bsPerson.Photo = base64;
    //    }
    //
    //    bsPerson.Photo = base64;
    //    bsPerson.Name = @"贱贱熊1号";
    //    bsPerson.PersonTel = @"123456789012";
    //    bsPerson.CardID = @"230826197506100535";
    //    bsPerson.FamilyID = @"C4CB83C9B53540FD86B52E09E9BB836F";
    //    bsPerson.GenderCode = [NSNumber numberWithInteger:1];
    //    bsPerson.BirthDay = @"1989-12-15";
    //    bsPerson.CustomNumber = @"123";
    //    bsPerson.RegionID = @"00F49E6C953F4F6F940F77AE4D7E886B";
    //    bsPerson.RegionCode = @"51041110620026";
    if (self.personModel.ID.length) {
        bsPerson.ID = self.personModel.ID;
    }
    BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
    bsPerson.BuildOrgID = info.OrgId;
    bsPerson.PUserID = info.EmployeeID;
    bsPerson.PUserName = [NSString stringWithString:info.UserName];
    bsPerson.BuildEmployeeID = info.EmployeeID;
    bsPerson.BuildEmployeeName = [NSString stringWithString:info.UserName];
    NSDate *date = [NSDate date];
    bsPerson.CustomNumber = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
    return bsPerson;
}
- (void)saveTableInfoToPersonModel:(PersonBaseInfoModel *)bsPerson{
    NSMutableArray *array = [self.dataManager.dataModel attributeList];
    for (NSString *str in array) {
        ArchiveModel *mode = [self.dataManager.dataModel valueForKey:str];
        for (BSArchiveModel *bsModel in mode.content) {
            id value = nil;
            if (bsModel.value.length) {
                value = bsModel.value;
            }else if (bsModel.contentStr.length){
                value = bsModel.contentStr;
            }
            if ([bsModel.code isEqualToString:@"BloodType"] || [bsModel.code isEqualToString:@"Disability"]|| [bsModel.code isEqualToString:@"DrugAllergyHistory"]|| [bsModel.code isEqualToString:@"Drinkingwater"]|| [bsModel.code isEqualToString:@"EducationCode"]|| [bsModel.code isEqualToString:@"FuelType"]|| [bsModel.code isEqualToString:@"GenderCode"]|| [bsModel.code isEqualToString:@"HouseholderRelationship"]|| [bsModel.code isEqualToString:@"HukouInd"]|| [bsModel.code isEqualToString:@"IsFlowing"]|| [bsModel.code isEqualToString:@"JobCode"]|| [bsModel.code isEqualToString:@"KitchenExhaust"]|| [bsModel.code isEqualToString:@"LivestockColumn"]|| [bsModel.code isEqualToString:@"MarryStatus"]|| [bsModel.code isEqualToString:@"PaymentWaystring"]|| [bsModel.code isEqualToString:@"ResType"]|| [bsModel.code isEqualToString:@"RhBlood"]|| [bsModel.code isEqualToString:@"Toilet"]|| [bsModel.code isEqualToString:@"ExposureHistory"]) {
                if (bsModel.type == ArchiveModelTypeSlectAndTextView ) {
                    ArchiveSelectOptionModel *lastOptionValue = [bsModel.selectModel.options lastObject];
                    if ([lastOptionValue.value integerValue] & [value integerValue]) {
                        if (bsModel.contentStr.length) {
                            [bsPerson setValue:bsModel.contentStr forKey:[NSString stringWithFormat:@"Other%@",bsModel.code]];
                        }
                    }
                }
                if ([value length]) {
                    value = [NSNumber numberWithInteger:[value integerValue]];
                }
                
                
            }
            [bsPerson setValue:value forKey:bsModel.code];
            if ([bsModel.code isEqualToString:@"ResponsibilityDoctor"]) {
                bsPerson.ResponsibilityID = bsModel.value;
                bsPerson.ResponsibilityDoctor = bsModel.contentStr;
            }else{
                [bsPerson setValue:value forKey:bsModel.code];
            }
            
            
        }
    }
    self.currentPerson = [PersonBaseInfoModel mj_objectWithKeyValues:[bsPerson mj_keyValues]];
}
- (void)saveHistoryToServer{
    
}
//选择器改变
- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender
{
    if([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2){
        [self ZLSegmentedControlChangedValue:sender];
    }else{
        [self WJWSegmentedControlChangedValue:sender];
    }
    
}
- (void)WJWSegmentedControlChangedValue:(HMSegmentedControl *)sender{
    NSInteger index = sender.selectedSegmentIndex;
    //    if (1){
    if (self.personModel.ID.length) {
        if (index == 0) {
            self.navigationItem.rightBarButtonItem = self.saveBtn;
            [self.hyTableView removeFromSuperview];
            [self.view addSubview:self.bsTableView];
        }else if (index == 1){
            self.navigationItem.rightBarButtonItem = nil;
            [self.bsTableView removeFromSuperview];
            [self.view addSubview:self.hyTableView];
        }
    }else{
        self.segmentedControl.selectedSegmentIndex = 0;
        [UIView makeToast:@"请完善并保存基本信息!"];
        
    }
}
- (void)ZLSegmentedControlChangedValue:(HMSegmentedControl *)sender{
    NSInteger index = sender.selectedSegmentIndex;
//    if (sender.selectedSegmentIndex == 0) {
//        index = index - 1;
//    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    CGRect frame = [self.zlTableView rectForSection:indexPath.section];
    [self.zlTableView setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
}
#pragma mark 懒加载
- (ArchiveBSInfoTableView *)bsTableView{
    if (!_bsTableView) {
        _bsTableView = [[ArchiveBSInfoTableView alloc]initWithFrame:CGRectMake(0, self.segmentedControl.bottom, self.view.width, SCREEN_HEIGHT - self.segmentedControl.bottom-TOP_BAR_HEIGHT) style:UITableViewStylePlain withModel:self.dataManager];
    }
    return _bsTableView;
}
- (ZLPersonTableView *)zlTableView{
    if (!_zlTableView) {
        _zlTableView = [[ZLPersonTableView alloc]initWithFrame:CGRectMake(0, self.segmentedControl.bottom, self.view.width, SCREEN_HEIGHT - self.segmentedControl.bottom-TOP_BAR_HEIGHT) style:UITableViewStylePlain withModel:self.dataManager];
        Bsky_WeakSelf;
        _zlTableView.scrollBlock = ^(NSUInteger index) {
            Bsky_StrongSelf;
            [self.segmentedControl setSelectedSegmentIndex:index animated:YES]; ;
        };
    }
    return _zlTableView;
}
- (ArchivePersonHistoryTableView *)hyTableView{
    if (!_hyTableView) {
        _hyTableView = [[ArchivePersonHistoryTableView alloc]initWithFrame:CGRectMake(0, self.segmentedControl.bottom, self.view.width, SCREEN_HEIGHT - self.segmentedControl.bottom-TOP_BAR_HEIGHT) style:UITableViewStylePlain withModel:self.dataManager];
    }
    return _hyTableView;
}
- (ArchivePersonDataManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [ArchivePersonDataManager dataManager];
    }
    return _dataManager;
}
- (NSArray *)sectionTitleArray{
    if (!_sectionTitleArray) {
        
        _sectionTitleArray = @[self.dataManager.zlPersonUIModel.personInfo.contentStr,self.dataManager.zlPersonUIModel.otherInfo.contentStr,self.dataManager.zlPersonUIModel.medicalHistoryInfo.contentStr,self.dataManager.zlPersonUIModel.pastHistory.contentStr,self.dataManager.zlPersonUIModel.familyHistory.contentStr,self.dataManager.zlPersonUIModel.environment.contentStr];
    }
    return _sectionTitleArray;
}
- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        if([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2){
            [self creatZLSegmentControl];
        }else{
            [self creatWJWSegmentControl];
        }
        _segmentedControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0x4e7dd3)};
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        
        _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _segmentedControl.height-1, _segmentedControl.width, 1)];
        line.backgroundColor = UIColorFromRGB(0xededed);
        _segmentedControl.selectionIndicatorHeight = 3.0f;  // 线的高度
        _segmentedControl.selectionIndicatorColor = UIColorFromRGB(0x4e7dd3);  //线条的颜色
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe; //线充满整个长度
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown; //线的位置
        [_segmentedControl addSubview:line];
    }
    return _segmentedControl;
}
- (void)creatWJWSegmentControl{
    _segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"基本信息",@"个人既往史"]];
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
}
- (void)creatZLSegmentControl{
    _segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:self.sectionTitleArray];
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
}
#pragma mark UI subviews
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
#pragma mark ----- BackButtonHandlerProtocol
- (void)backAction{
    BOOL isSame = [self checkTableDataChange];
    if (isSame && self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self alterViewAppear];
    }
}
- (void)alterViewAppear{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定退出?" message:@"内容尚未保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1301;
    [alertView show];
}
- (BOOL )checkTableDataChange{
    PersonBaseInfoModel *bsmodel = [[PersonBaseInfoModel alloc] init];
    [self saveTableInfoToPersonModel:bsmodel];
    if (!self.recodePerson) {
        return NO;
    }else{
        NSArray *array = [bsmodel attributeList];
        BOOL isSame = YES;
        for (NSString *str in array) {
            id value = [bsmodel valueForKey:str];
            id value2 = [self.recodePerson valueForKey:str];
            if ([value isKindOfClass:[NSNumber class]] || [value2 isKindOfClass:[NSNumber class]]) {
                NSNumber *currentValue = value ? value : value2;
                if (!([currentValue isEqual:value2] && [currentValue isEqual:value])) {
                    isSame = NO;
                    break;
                }
            }else{
                if (!([value2 length] == 0 && [value length] == 0) && ![value isEqual:value2]) {
                    //                if (![value isEqual:value2]) {
                    NSLog(@"不一样的属性。。。%@",str);
                    isSame = NO;
                    break;
                    //                }
                }
            }
            
           
        }
         return isSame;
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
        if (self.navigationController != nil && ![self checkTableDataChange]) {
            [self alterViewAppear];
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
- (void)dealloc{
    [ArchivePersonDataManager dellocManager];
}
@end
