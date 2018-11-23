//
//  ArchivePersonDataManager.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "ArchivePersonDataManager.h"
#import "BSFormsDicRequest.h"
#import "ArchiveFamilyListRequest.h"
#import "PersonBaseInfoModel.h"
#import "ArchiveSavePBInfoRequest.h"
#import "BSDiseaseLibaryRequest.h"
#import "ArchiveFamilyMemberRequest.h"
#import "ArchiveDivisionRequest.h"
#import "ArchiveDivisionModel.h"
#import "BSDictModel.h"

@interface ArchivePersonDataManager ()
@property (nonatomic ,strong) BSFormsDicRequest *baseDicRequest;          

@end

@implementation ArchivePersonDataManager

static ArchivePersonDataManager *_instance;

+ (ArchivePersonDataManager *)dataManager{
    if (_instance == nil) {
        _instance = [[ArchivePersonDataManager alloc] init];
    }
    
    return _instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        if([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2){
            [self initZLPersonModel];
            [self initZLHistoryAddModel];
            [self getProvinceDict:@"51"];
        }else{
            [self initHistoryAddModel];
            [self initDataModel];
            [self initHistoryModel];
            [self getDiseaseLabary];
            [self getFamilyMemberList];
        }
        
        
    }
    return self;
}
//计委疾病史，家庭史排重
- (NSMutableArray *)historySelectFamily{
    if (!_historySelectFamily) {
        _historySelectFamily = [[NSMutableArray alloc] init];
    }
    return _historySelectFamily;
}
- (NSMutableArray *)historySelectDisease{
    if (!_historySelectDisease) {
        _historySelectDisease = [[NSMutableArray alloc] init];
    }
    return _historySelectDisease;
}
- (void)replaceHistorySelectFamily:(NSString *)old new:(NSString *)new{
    if (old == nil) {
        [self.historySelectFamily addObject:new];
    }else{
        NSInteger index = [self.historyFamilyArray indexOfObject:old];
        if (index < self.historySelectFamily.count){
             [self.historySelectFamily replaceObjectAtIndex:index withObject:new];
        }
       
    }
    
}
- (void)replaceHistorySelectDisease:(NSString *)old new:(NSString *)new{
    if (old == nil) {
        [self.historySelectDisease addObject:new];
    }else{
        NSInteger index = [self.historySelectDisease indexOfObject:old];
        if (index < self.historyDiseaseArray.count) {
            [self.historySelectDisease replaceObjectAtIndex:index withObject:new];
        }
        
    }
    
}
//计委既往史更新数据处理
- (void)setDetailHistory:(NSArray *)array type:(HistoryUpdateType )type{
    if (type == HistoryUpdateFamily) {
        [self setDitailFamilyArray:array];
    }else if (type == HistoryUpdateHealth){
        [self setDitailHealthArray:array];
    }else if (type == HistoryUpdateDisease){
        [self setDitailDiseaseArray:array];
    }
}
- (NSMutableArray *)getUpdateDiseaseHistoryArray:(id )model index:(NSUInteger )index type:(HistoryUpdateType )type{
    if (type == HistoryUpdateFamily) {
        return [self getUpdateFamilyHistoryArray:model index:index];
    }else if (type == HistoryUpdateHealth){
        return [self getUpdateHealthHistoryArray:model index:index];
    }else if (type == HistoryUpdateDisease){
        return [self getUpdateDiseaseHistoryArray:model index:index];
    }
    return nil;
}
- (void )addHistoryWithModel:(id )model type:(HistoryUpdateType )type{
    if (type == HistoryUpdateFamily) {
        [self addFamilyHistory:model];;
    }else if (type == HistoryUpdateHealth){
        [self addHealthHistory:model];
    }else if (type == HistoryUpdateDisease){
        [self addDiseaseHistory:model];
    }
}
- (void)updateHistory:(id)model index:(NSInteger )index type:(HistoryUpdateType )type{
    if (type == HistoryUpdateFamily) {
        if (index < self.historyFamilyArray.count && index >= 0) {
            
            [self.historyFamilyArray replaceObjectAtIndex:index withObject:model];
        }else{
            [self addFamilyHistory:model];
        }
    }else if (type == HistoryUpdateHealth){
        if (index < self.historyHealthArray.count && index >= 0) {
            [self.historyHealthArray replaceObjectAtIndex:index withObject:model];
        }else{
            [self addHealthHistory:model];
        }
    }else if (type == HistoryUpdateDisease){
        if (index < self.historyDiseaseArray.count && index >= 0) {
            [self.historyDiseaseArray replaceObjectAtIndex:index withObject:model];
        }else{
            [self addDiseaseHistory:model];
        }
    }
}
- (NSMutableArray *)historyDiseaseArray{
    if (!_historyDiseaseArray) {
        _historyDiseaseArray = [[NSMutableArray alloc] init];
    }
    return _historyDiseaseArray;
}
- (NSMutableArray *)historyHealthArray{
    if (!_historyHealthArray) {
        _historyHealthArray = [[NSMutableArray alloc] init];
    }
    return _historyHealthArray;
}
- (NSMutableArray *)historyFamilyArray{
    if (!_historyFamilyArray) {
        _historyFamilyArray = [[NSMutableArray alloc] init];
    }
    return _historyFamilyArray;
}
- (void)setDitailDiseaseArray:(NSArray *)array{
    for (DiseaseModelDetail *model in array) {
        if ([model isKindOfClass:[DiseaseModelDetail class]]) {
            [self addDiseaseHistory:model];
        }
    }
}
- (void)setDitailHealthArray:(NSArray *)array{
    for (HistoryModelDetail *model in array) {
        if ([model isKindOfClass:[HistoryModelDetail class]]) {
            [self addHealthHistory:model];
        }
    }
}
- (void)setDitailFamilyArray:(NSArray *)array{
    for (FamilyHistoryModelDetail *model in array) {
        if ([model isKindOfClass:[FamilyHistoryModelDetail class]]) {
            [self addFamilyHistory:model];
        }
    }
}
- (void)addDiseaseHistory:(id )disease{
    if ([disease isKindOfClass:[AddDiseaseModel class]]) {
        [self.historyDiseaseArray addObject:disease];
    }else if ([disease isKindOfClass:[DiseaseModelDetail class]]){
        AddDiseaseModel *model = [self translateDetailModelToAddModel:disease type:HistoryUpdateDisease];
        if (model) {
            [self.historyDiseaseArray addObject:model];
        }
    }
}
- (void)addHealthHistory:(id )history{
    if ([history isKindOfClass:[AddHistoryModel class]]) {
        [self.historyHealthArray addObject:history];
    }else if ([history isKindOfClass:[HistoryModelDetail class]]){
        AddDiseaseModel *model = [self translateDetailModelToAddModel:history type:HistoryUpdateHealth];
        if (model) {
            [self.historyHealthArray addObject:model];
        }
    }
}
- (void)addFamilyHistory:(id )familyHistory{
    if ([familyHistory isKindOfClass:[AddFamilyHistoryModel class]]) {
        [self.historyFamilyArray addObject:familyHistory];
    }else if ([familyHistory isKindOfClass:[FamilyHistoryModelDetail class]]){
        AddDiseaseModel *model = [self translateDetailModelToAddModel:familyHistory type:HistoryUpdateFamily];
        if (model) {
            [self.historyFamilyArray addObject:model];
        }
    }
}
- (id)translateDetailModelToAddModel:(id )addModel type:(HistoryUpdateType )type{
    if (type == HistoryUpdateDisease) {
        AddDiseaseModel *model = [[AddDiseaseModel alloc] init];
        DiseaseModelDetail *diseaseModel = addModel;
        model.diagnosisDate = diseaseModel.DiagnosisDate;
//        model.diseaseKindName = diseaseModel.DiseaseName;
        model.diseaseKindId = diseaseModel.DiseaseKindID;
        model.doctorId = diseaseModel.DoctorID;
        model.doctorName = diseaseModel.DoctorName;
        model.orgId = diseaseModel.OrgID;
        model.personId = diseaseModel.PersonID;
        model.remark = diseaseModel.Remark;
        model.userId = diseaseModel.UserID;
        model.userName = diseaseModel.UserName;
        return model;
    }else if ([addModel isKindOfClass:[HistoryModelDetail class]]){
        AddHistoryModel *model = [[AddHistoryModel alloc] init];
        HistoryModelDetail *historyMode = addModel;
        model.name = historyMode.Name;
        model.occurrenceDate = historyMode.OccurrenceDate;
        model.personId = historyMode.PersonID;
        model.recordType = historyMode.RecordType;
        return model;
    }else if ([addModel isKindOfClass:[FamilyHistoryModelDetail class]]){
        AddFamilyHistoryModel *model = [[AddFamilyHistoryModel alloc] init];
        FamilyHistoryModelDetail *familyModel = addModel;
        model.disease = familyModel.Disease;
        model.personId = familyModel.PersonID;
        model.relationShipName = familyModel.RelationShipName;
        model.relationshipType = familyModel.RelationshipType;
        model.remark = familyModel.Remark;
        return model;
    }
    return nil;
}
- (NSMutableArray *)getUpdateDiseaseHistoryArray:(id )model index:(NSUInteger )index{
    NSMutableArray *listArray = [NSMutableArray arrayWithArray:self.historyDiseaseArray];
    if ([model isKindOfClass:[AddDiseaseModel class]]) {
        if (index < listArray.count) {
           [listArray replaceObjectAtIndex:index withObject:model];
        }else{
            [listArray addObject:model];
        }
    }
    return listArray;
}
- (NSMutableArray *)getUpdateHealthHistoryArray:(id )model index:(NSUInteger )index{
    NSMutableArray *listArray = [NSMutableArray arrayWithArray:self.historyHealthArray];
    if ([model isKindOfClass:[AddHistoryModel class]]) {
        if (index < listArray.count) {
            [listArray replaceObjectAtIndex:index withObject:model];
        }else{
            [listArray addObject:model];
        }
    }
    return listArray;
}
- (NSMutableArray *)getUpdateFamilyHistoryArray:(id )modle index:(NSUInteger )index{
    NSMutableArray *listArray = [NSMutableArray arrayWithArray:self.historyFamilyArray];
    if ([modle isKindOfClass:[AddFamilyHistoryModel class]]) {
        if (index < listArray.count) {
            [listArray replaceObjectAtIndex:index withObject:modle];
        }else {
            [listArray addObject:modle];
        }
    }
    return listArray;
}


//UI 卫计委相关
- (void)initDataModel{
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"CreatPABSModel" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _dataModel = [ArchivePersonModel mj_objectWithKeyValues:dic];
}
- (void)initHistoryModel{
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"PersonHistoryModel" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _historyModel = [PersonHistoryModel mj_objectWithKeyValues:dic];
}
- (void)initHistoryAddModel{
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"PersonHistoryAddModel" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _historyAddModel = [PersonHistoryAddModel mj_objectWithKeyValues:dic];
}
//UI 中年相关
- (void)initZLPersonModel{
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"ZLPersonModel" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _zlPersonUIModel = [ZLPersonUIModel mj_objectWithKeyValues:dic];
}
- (void)initZLHistoryAddModel{
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"ZLPersonHistoryAddModel" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _zlHistoryAddUIModel = [ZLHistoryAddUIModel mj_objectWithKeyValues:dic];
}
- (NSMutableArray *)zlFamilyRelationForHistory{
    if (!_zlFamilyRelationForHistory) {
        _zlFamilyRelationForHistory = [[NSMutableArray alloc] init];
    }
    return _zlFamilyRelationForHistory;
}
#pragma mark 获取数据
//相关字典数据
- (void)initWJWArchiveDatasuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure{
    
    [[BSAppManager sharedInstance] initWJWDataDicSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.dataDic = [BSAppManager sharedInstance].dataDic;
        success(request);
    } failure:failure];
    
}
//中年数据字典
- (void)initZLArchiveDatasuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure{
    BSFormsDicRequest *infoAllRequest = [[BSFormsDicRequest alloc]init];
    infoAllRequest.dictTypes = @[@"zl_resident_type",@"zl_node_type",@"zl_nation_type",@"zl_fload_type",@"zl_relationship_with_holder",@"zl_abo_flood_type",@"zl_rh_flood_type",@"zl_culture_type",@"zl_occupation_type",@"zl_marital_status_type",@"zl_medical_expense_payment_method",@"zl_relation_shape",@"zl_history_type",@"zl_history_of_exposure",@"zl_disability",@"zl_gender",@"zl_kitchen_exhaust_facilities",@"zl_fuel_type",@"zl_drinking_water",@"zl_toilet",@"zl_bird",@"zl_family_history_disease",@"zl_history_of_drug_allergyd",@"zl_history_of_drug_allergy_select",@"zl_household_relationship",@"previous_project_type",@"zl_attention_degree",@"zl_previous_project_type"];
//    NSString *detailUrl = [infoAllRequest requestUrl];
//    detailUrl = [detailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *temp = [NSURL URLWithString:detailUrl];
    [infoAllRequest startWithCompletionBlockWithSuccess:success failure:failure];
}
//中年区划字典
//省市区
- (void)getProvinceDict:(NSString *)code{
    ArchiveDivisionRequest *request = [[ArchiveDivisionRequest alloc] init];
    request.regionCode =code;
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveDivisionRequest * _Nonnull request) {
        Bsky_StrongSelf;
        //现只有重庆市
        ArchiveDivisionModel *proviceModel = [[ArchiveDivisionModel alloc] init];
        proviceModel.divisionName = @"四川省";
        proviceModel.divisionCode = @"51";
        proviceModel.divisionId = @"51";
        proviceModel.children = (NSMutableArray *)request.regionArray;
        self.zlCityArray = [NSArray arrayWithObject:proviceModel];
    } failure:^(__kindof ArchiveDivisionRequest * _Nonnull request) {
        
    }];
}
//乡镇与居委会
- (void)getCommitteeOfAdressDict:(NSString *)code{
    ArchiveDivisionRequest *request = [[ArchiveDivisionRequest alloc] init];
    request.regionCode = code;
    Bsky_WeakSelf;
    [MBProgressHUD showHud];
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveDivisionRequest * _Nonnull request) {
        Bsky_StrongSelf;
        [MBProgressHUD hideHud];
        self.zlCommitteeArrayOfAdress = request.regionArray;
    } failure:^(__kindof ArchiveDivisionRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
    }];
}
- (void)getCommitteeOfRegisterDict:(NSString *)code{
    ArchiveDivisionRequest *request = [[ArchiveDivisionRequest alloc] init];
    request.regionCode = code;
    Bsky_WeakSelf;
    [MBProgressHUD showHud];
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveDivisionRequest * _Nonnull request) {
        Bsky_StrongSelf;
        self.zlCommitteeArrayOfRegister = request.regionArray;
        [MBProgressHUD hideHud];
    } failure:^(__kindof ArchiveDivisionRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
    }];
}

//家族档案列表
//保存个人基本信息
- (void)savePersonBaseInfoWithModel:(PersonBaseInfoModel *)model success:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure{
    PersonBaseInfoModel *tempModel = [PersonBaseInfoModel mj_objectWithKeyValues:[model mj_keyValues]];
    [tempModel enctryptModel];
    NSMutableDictionary *dic =[tempModel mj_keyValues];
    NSString *body = [[model mj_JSONString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ArchiveSavePBInfoRequest *request = [[ArchiveSavePBInfoRequest alloc] init];
    request.bodyDic = dic;
    request.bodyStr = body;
    request.residentInVM = dic;
    [request startWithCompletionBlockWithSuccess:success failure:failure];
}
//获取疾病类型
- (void)getDiseaseLabary{
    BSDiseaseLibaryRequest *request = [[BSDiseaseLibaryRequest alloc] init];
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof BSDiseaseLibaryRequest * _Nonnull request) {
        Bsky_StrongSelf;
        self.diseaseArray = request.diseaseArray;
    } failure:^(__kindof BSDiseaseLibaryRequest * _Nonnull request) {
        
    }];
}
//获取家族成员
- (void)getFamilyMemberList{
    ArchiveFamilyMemberRequest *request = [[ArchiveFamilyMemberRequest alloc] init];
    request.familyID = self.familyListModel.FamilyID;
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveFamilyMemberRequest * _Nonnull request) {
        Bsky_StrongSelf;
        self.familyMemberArray = request.dataArray;
    } failure:^(__kindof ArchiveFamilyMemberRequest * _Nonnull request) {
        
    }];
}
+ (void)dellocManager{
    _instance = nil;
}
@end
