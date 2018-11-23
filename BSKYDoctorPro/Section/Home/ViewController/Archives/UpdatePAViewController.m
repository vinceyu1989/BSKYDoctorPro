    //
//  UpdatePAViewController.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/4/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "UpdatePAViewController.h"
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
#import "ArchivePersonDetailRequest.h"

@interface UpdatePAViewController ()
@property (nonatomic ,strong) HMSegmentedControl *segmentedControl;
@property (nonatomic ,strong) NSArray *sectionTitleArray;
@property (nonatomic ,strong) UIBarButtonItem *saveBtn;
@property (nonatomic ,strong) PersonBaseInfoModel *recodePerson;
@property (nonatomic ,strong) PersonBaseInfoModel *currentPerson;
@property (nonatomic ,copy) NSNumber *oldHouseShip;
@end

@implementation UpdatePAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    if (self.personModel) {
        [self dataToUI];
    }else if (self.personId.length){
        [self getDetailModel];
    }
    
    
}
- (void)dataToUI{
    [ArchivePersonDataManager dataManager].personBaseInof = self.personModel;
    [self.dataManager setDetailHistory:self.personModel.FamilyHistory type:HistoryUpdateFamily];
    [self.dataManager setDetailHistory:self.personModel.CmData type:HistoryUpdateDisease];
    [self.dataManager setDetailHistory:self.personModel.HealthHistory type:HistoryUpdateHealth];
    [self getArchiveDict];
}
- (void)getDetailModel{
    [MBProgressHUD showHud];
    ArchivePersonDetailRequest *request = [[ArchivePersonDetailRequest alloc] init];
    request.personId = self.personId;
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchivePersonDetailRequest * _Nonnull request) {
        Bsky_StrongSelf;
        self.personModel = request.personModel;
        [self dataToUI];
        [MBProgressHUD hideHud];
    } failure:^(__kindof ArchivePersonDetailRequest * _Nonnull request) {
        [UIView makeToast:request.msg];
        [MBProgressHUD hideHud];
    }];
}
- (void)getArchiveDict{
    if([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2){
//        [self getZLArchiveDict];
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
- (NSDictionary *)dictInfoToDic:(NSArray *)data{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (BSDictModel *model in data) {
        [dic setObject:model.dictList forKey:model.type];
    }
    return dic;
}
- (void)handleHistoryData{
    //添加顺序很重要，慎改
    ArchiveModel *cellModel = nil;
    NSMutableArray *surgeryArray = [NSMutableArray array];
    NSMutableArray *traumaArray = [NSMutableArray array];
    NSMutableArray *bloodArray = [NSMutableArray array];
    
    for (NSUInteger i = 0 ; i < self.personModel.HealthHistory.count ; i ++) {
        HistoryModelDetail *history = [self.personModel.HealthHistory objectAtIndex:i];
        if ([history.RecordType isEqualToString:@"1"]) {
            cellModel = self.dataManager.historyAddModel.surgeryHistory;
            [surgeryArray addObject:[self getSubAddModeFrom:cellModel dataModel:history index:i]];
        }else if ([history.RecordType isEqualToString:@"2"]){
            cellModel = self.dataManager.historyAddModel.traumaHistory;
            [traumaArray addObject:[self getSubAddModeFrom:cellModel dataModel:history index:i]];
        }else if ([history.RecordType isEqualToString:@"3"]){
            cellModel = self.dataManager.historyAddModel.bloodHistory;
            [bloodArray addObject:[self getSubAddModeFrom:cellModel dataModel:history index:i]];
        }else if ([history.RecordType isEqualToString:@"4"]){
            cellModel = self.dataManager.historyAddModel.geneticHistory;
            BSArchiveModel *bsModel = [self getSubAddModeFrom:cellModel dataModel:history index:i];
            [self insertContentArrayWithindexPath:[NSIndexPath indexPathForRow:0 inSection:2] model:bsModel];
        }
    }
    for (BSArchiveModel *bsModel in bloodArray) {
        [self insertContentArrayWithindexPath:[NSIndexPath indexPathForRow:3 inSection:0] model:bsModel];
    }
    for (BSArchiveModel *bsModel in traumaArray) {
        [self insertContentArrayWithindexPath:[NSIndexPath indexPathForRow:2 inSection:0] model:bsModel];
    }
    for (BSArchiveModel *bsModel in surgeryArray) {
        [self insertContentArrayWithindexPath:[NSIndexPath indexPathForRow:1 inSection:0] model:bsModel];
    }
    
    for (NSUInteger i = 0 ; i < self.personModel.FamilyHistory.count ; i ++) {
        FamilyHistoryModelDetail *family = [self.personModel.FamilyHistory objectAtIndex:i];
        cellModel = self.dataManager.historyAddModel.familyHistory;
        BSArchiveModel *diseaseModel = cellModel.content.lastObject;
        diseaseModel.selectModel.options = [self.dataManager.dataDic objectForKey:@"gw_family_disease"];
        BSArchiveModel *bsModel = [self getSubAddModeFrom:cellModel dataModel:family index:i];
        [self.dataManager replaceHistorySelectFamily:nil new:family.RelationshipType];
        [self insertContentArrayWithindexPath:[NSIndexPath indexPathForRow:0 inSection:1] model:bsModel];
    }
    for (NSUInteger i = 0 ; i < self.personModel.CmData.count ; i ++) {
        DiseaseModelDetail *disease = [self.personModel.CmData objectAtIndex:i];
        if ([disease.DiseaseName isEqualToString:@"其他"]) {
            cellModel = self.dataManager.historyAddModel.diseaseHistoryOther;
        }else{
            cellModel = self.dataManager.historyAddModel.diseaseHistory;
        }
        [self.dataManager replaceHistorySelectDisease:nil new:disease.DiseaseName];
        BSArchiveModel *bsModel = [self getSubAddModeFrom:cellModel dataModel:disease index:i];
        [self insertContentArrayWithindexPath:[NSIndexPath indexPathForRow:0 inSection:0] model:bsModel];
    }
    
}
- (BSArchiveModel *)getSubAddModeFrom:(ArchiveModel *)cellsModel dataModel:(id )model index:(NSUInteger )index{
    BSArchiveModel *cellModel = [[BSArchiveModel alloc] init];
    cellModel.code = cellsModel.code;
    cellModel.canEdit = YES;
    cellModel.title = cellsModel.contentStr;
    cellModel.addModel = [[ArchiveAddModel alloc] init];
    cellModel.addModel.adds = [self getAddCellArray:model cellModel:cellsModel];
    cellModel.addModel.index = index;
    cellModel.type = ArchiveModelTypeAddSubCell;
    return cellModel;
}
- (void)insertContentArrayWithindexPath:(NSIndexPath *)indexPath model:(BSArchiveModel *)model{
    NSArray *array = nil;
    ArchiveModel *cellModel = nil;
    switch (indexPath.section) {
        case 0:
            array = self.dataManager.historyModel.pastHistory.content;
            cellModel = self.dataManager.historyModel.pastHistory;
            break;
        case 1:
            array = self.dataManager.historyModel.familyHistory.content;
            cellModel = self.dataManager.historyModel.familyHistory;
            break;
        case 2:
            array = self.dataManager.historyModel.geneticHistory.content;
            cellModel = self.dataManager.historyModel.geneticHistory;
            break;
        default:
            
            break;
    }
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    if (indexPath.section) {
        [mutableArray insertObject:model atIndex:indexPath.row + 1];
    }else{
        [mutableArray insertObject:model atIndex:indexPath.row + 1];
    }
    
    [cellModel setValue:mutableArray forKey:@"content"];
}
- (NSArray *)getAddCellArray:(id )model cellModel:(ArchiveModel *)cellModel{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (BSArchiveModel *subCellmodel in cellModel.content) {
        BSArchiveModel *insetModel = [[BSArchiveModel alloc] init];
        insetModel.title = subCellmodel.title;
        insetModel.code = subCellmodel.code;
        insetModel.type = subCellmodel.type;
        insetModel.canEdit = YES;
        if ([model isKindOfClass:[DiseaseModelDetail class]]) {
            DiseaseModelDetail *currentModel = (DiseaseModelDetail *)model;
            if ([subCellmodel.code isEqualToString:@"diseaseKindId"]) {
                insetModel.value = currentModel.DiseaseKindID;
                if (!currentModel.DiseaseName.length) {
                    for (DiseaseModel *disease in self.dataManager.diseaseArray) {
                        if ([currentModel.DiseaseKindID isEqualToString:disease.diseaseId]) {
                            insetModel.contentStr = disease.diseaseName;
                            break;
                        }
                    }
                }else{
                    insetModel.contentStr = currentModel.DiseaseName;
                }
            }else if ([subCellmodel.code isEqualToString:@"remark"]){
                insetModel.value = currentModel.Remark;
                insetModel.contentStr = currentModel.Remark;
            }else{
                insetModel.value = [currentModel.DiagnosisDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
                insetModel.contentStr = [currentModel.DiagnosisDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
            }
        }
        if ([model isKindOfClass:[FamilyHistoryModelDetail class]]) {
            FamilyHistoryModelDetail *currentModel = (FamilyHistoryModelDetail *)model;
            if ([subCellmodel.code isEqualToString:@"relationshipType"]) {
                if (!currentModel.RelationShipName.length) {
                    insetModel.contentStr = [self getDictTitleWithValue:currentModel.RelationshipType dicName:@"gw_relation_shape"];
                }else{
                    insetModel.contentStr = currentModel.RelationShipName;
                }
                insetModel.value = currentModel.RelationshipType;
            }else if ([subCellmodel.code isEqualToString:@"disease"]){
                insetModel.value = currentModel.Disease;
                insetModel.contentStr = currentModel.Remark;
                insetModel.selectModel = subCellmodel.selectModel;
            }
        }
        if ([model isKindOfClass:[HistoryModelDetail class]]) {
            HistoryModelDetail *currentModel = (HistoryModelDetail *)model;
            if ([subCellmodel.code isEqualToString:@"name"]) {
                insetModel.contentStr = currentModel.Name;
                insetModel.value = currentModel.Name;
            }else{
                insetModel.contentStr = [currentModel.OccurrenceDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
                insetModel.value = [currentModel.OccurrenceDate convertDateStringWithTimeStr:@"yyyy-MM-dd"];
            }
        }
        [array addObject:insetModel];
    }
    [self updateCellOtherSubCell:array model:model];
    return array;
}
- (NSString *)getDictTitleWithValue:(NSString *)value dicName:(NSString *)name{
    NSArray *dataArray = [self.dataManager.dataDic objectForKey:name];
    if (!value.length) {
        return @"";
    }
    for (ArchiveSelectOptionModel *dict in dataArray) {
        if (value.length && [value isEqualToString:dict.value]) {
            return dict.title;
        }
    }
    return @"";
}
- (void)updateCellOtherSubCell:(NSArray *)array model:(id )dataModel{
    NSMutableArray *mutableArray = nil;
    if (![array isKindOfClass:[NSMutableArray class]]) {
        mutableArray = [NSMutableArray arrayWithArray:array];
    }else{
        mutableArray = (NSMutableArray *)array;
    }
    if ([dataModel isKindOfClass:[FamilyHistoryModelDetail class]]) {
        FamilyHistoryModelDetail *currentModel = (FamilyHistoryModelDetail *)dataModel;
        if (currentModel.Disease.integerValue & 2048) {
            if ([array count] > 2) {
                BSArchiveModel *insetModel = [array objectAtIndex:2];
                insetModel.title = @"其他";
                insetModel.code = @"other";
                insetModel.contentStr = currentModel.Remark;
                insetModel.value = currentModel.Remark;
            }else{
                BSArchiveModel *insetModel = [[BSArchiveModel alloc] init];
                insetModel.title = @"其他";
                insetModel.code = @"other";
                insetModel.contentStr = currentModel.Remark;
                insetModel.value = currentModel.Remark;
                [mutableArray addObject:insetModel];
            }
            
        }else{
            if ([array count] == 3) {
                [mutableArray removeObjectAtIndex:2];
            }
        }
    }
}
- (void)initWJWDictInfo:(NSArray *)data{
    NSArray *array = [self.dataManager.dataModel attributeList];
//    self.dataManager.dataDic = [self dictInfoToDic:data];
    [self handleHistoryData];
    for (NSString *str in array) {
        ArchiveModel *model = [self.dataManager.dataModel valueForKey:str];
        for (BSArchiveModel *bsModel in model.content) {
            if (bsModel.type == ArchiveModelTypeSelect || bsModel.type == ArchiveModelTypeSlectAndTextView || bsModel.type == ArchiveModelTypeSlectOnLine || bsModel.type == ArchiveModelTypeCustomPicker) {
                id value = [self.personModel valueForKey:bsModel.code];
                if ([value isKindOfClass:[NSNumber class]]) {
                     bsModel.value = [NSString stringWithFormat:@"%d",[value intValue]];
                }else{
                     bsModel.value = value;
                }
               
                if (bsModel.type == ArchiveModelTypeSelect || bsModel.type == ArchiveModelTypeSlectOnLine || bsModel.type == ArchiveModelTypeSlectAndTextView) {
                    if (bsModel.sourceCode.length) {
                        bsModel.selectModel.options = [self.dataManager.dataDic objectForKey:bsModel.sourceCode];
                    }
                    if (bsModel.type == ArchiveModelTypeSlectAndTextView) {\
                        ArchiveSelectOptionModel *optionModel = bsModel.selectModel.options.lastObject;
                        if ([value intValue] & [optionModel.value intValue]) {
                            if ([bsModel.code isEqualToString:@"Disability"]) {
                                bsModel.contentStr = self.personModel.OtherDisability;
                            }else if ([bsModel.code isEqualToString:@"DrugAllergyHistory"]) {
                                bsModel.contentStr = self.personModel.OtherDrugAllergyHistory;
                            }else if ([bsModel.code isEqualToString:@"PaymentWaystring"]) {
                                bsModel.contentStr = self.personModel.OtherPaymentWaystring;
                            }
                        }
                    }
                }
                if (bsModel.type == ArchiveModelTypeCustomPicker) {
                    if ([bsModel.code isEqualToString:@"NationCode"]) {
                        ArchivePickerModel *picker = [[ArchivePickerModel alloc] init];
                        NSArray *options = [self.dataManager.dataDic objectForKey:@"gw_nation"];
                        [picker setValue:options forKey:@"options"];
                        bsModel.pickerModel = picker;
                        bsModel.contentStr = [self getContentStrWithValue:value fromArray:options];
                    }
                    if ([bsModel.code isEqualToString:@"HouseholderRelationship"]) {
                        ArchivePickerModel *picker = [[ArchivePickerModel alloc] init];
                        NSArray *options = [self.dataManager.dataDic objectForKey:@"gw_relationship_with_holder"];
                        self.dataManager.memberShipArray = options;
                        [picker setValue:options forKey:@"options"];
                        bsModel.pickerModel = picker;
                        bsModel.contentStr = [self getContentStrWithValue:value fromArray:options];
                        self.oldHouseShip = self.personModel.HouseholderRelationship;
//                        bsModel.contentStr = [[options firstObject] valueForKey:@"lebel"];
//                        bsModel.value = [[options firstObject] valueForKey:@"value"];
                        
                    }
                }
            }else{
                
                id value = [self.personModel valueForKey:bsModel.code];
                if ([value isKindOfClass:[NSNumber class]]) {
                    bsModel.value = [NSString stringWithFormat:@"%d",[value intValue]];
                    if ([bsModel.code isEqualToString:@"GenderCode"]) {
                        if ([value intValue] == 1) {
                            bsModel.contentStr = @"男";
                        }else if ([value intValue] == 2){
                            bsModel.contentStr = @"女";
                        }else if ([value intValue] == 0){
                            bsModel.contentStr = @"未知";
                        }else{
                            bsModel.contentStr = @"未说明";
                        }
                    }
                    
                }else{
                    if ([bsModel.code isEqualToString:@"BirthDay"] || [bsModel.code isEqualToString:@"BuildDate"]) {
                        
                        value = [value length] >= 10 ?[value substringWithRange:NSMakeRange(0, 10)] : @"";
                        bsModel.value = value;
                        bsModel.contentStr = value;
                    }else if ([bsModel.code isEqualToString:@"ResponsibilityDoctor"]){
                        bsModel.value = self.personModel.ResponsibilityID;
                        bsModel.contentStr = value;
                    }else if ([bsModel.code isEqualToString:@"CurrentAddress"] || [bsModel.code isEqualToString:@"ResidenceAddress"]){
                        NSString *resultStr = [value stringByReplacingOccurrencesOfString:@">" withString:@""];
                        resultStr = [resultStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                        bsModel.value = resultStr;
                        bsModel.contentStr = resultStr;
                    }else{
                        bsModel.value = value;
                        bsModel.contentStr = value;
                    }
                    
                }
            }
        }
    }
}
- (NSString *)getContentStrWithValue:(id )value fromArray:(NSArray *)array{
    NSString *string = nil;
    for (ArchiveSelectOptionModel *option in array) {
        if (option.value.integerValue == [value integerValue]) {
            return string = option.title;
            break;
        }
    }
    return @"";
}
- (void)mapModelToTableView{
    
}
- (void)creatUI{
    if([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2){
//        [self creatZLUI];
    }else{
        [self creatWJWUI];
    }
    
    
    
}
- (void)creatWJWUI{
    self.title = @"编辑个人档案";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.navigationItem.rightBarButtonItem = self.saveBtn;
    
    [self.view addSubview:self.segmentedControl];
    
    
    [self.view addSubview:self.bsTableView];
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

//- (void)srollToCellWithCellCode:(NSString *)code{
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code contains %@",code]; // code不是随便写的, 是模型中的属性; contains是包含后面%@这个字符串
//    NSArray *array = self.dataManager.zlPersonUIModel.personInfo.content;
//    NSArray *resultCities = [array filteredArrayUsingPredicate:predicate];
//    if (resultCities.count) {
//        BSArchiveModel *bsModel = resultCities.firstObject;
//        NSUInteger index = [array indexOfObject:bsModel];
//        [self.zlTableView scrollToRow:index inSection:0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//}
- (void)pushToSuccessView{
    ArchiveSuccessView *view = [[ArchiveSuccessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    [view show];
}

- (void)saveWJWDataToServer{
    [self.view endEditing:YES];
    [self initilationPersonModel];
    
    NSString *wrongStr = [self handleTextFieldWithPersonModel];
    if (wrongStr.length) {
        [self srollToCellWithCellCode:wrongStr];
        return;
    }
    if (self.bsTableView.superview) {
        [self saveBaseInfoToServer];
    }else{
        
    }
}
- (void)saveDataToServer{
    if ([BSAppManager sharedInstance].currentUser.sysType.integerValue == 2) {
//        [self saveZLDataToServer];
    }else{
        [self saveWJWDataToServer];
    }
}
- (void)popToViewContoller{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveBaseInfoToServer{
    
    [MBProgressHUD showHud];
    if (self.personModel.ID) {
        ArchiveUpdatePBinfoRequest *request = [[ArchiveUpdatePBinfoRequest alloc] init];
        PersonBaseInfoModel *tempModel = [PersonBaseInfoModel mj_objectWithKeyValues:[self.personModel mj_keyValues]];
        [tempModel enctryptModel];
        request.residentInVM = [tempModel mj_keyValues];
//        NSString *str = [self.personModel mj_JSONString];
        Bsky_WeakSelf;
        [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveUpdatePBinfoRequest * _Nonnull request) {
            Bsky_StrongSelf;
            [UIView makeToast:@"个人档更新成功!"];
            [ArchivePersonDataManager dataManager].personBaseInof = request.infoModel;
            self.personModel.ID = request.infoModel.ID;
            self.recodePerson = self.currentPerson;
            if (self.updateBlock) {
                self.updateBlock(self.personModel.Photo);
            }
            NSArray *array = [self.dataManager.dataDic objectForKey:@"gw_relationship_with_holder"];
            ArchiveSelectOptionModel *option = array.firstObject;
            if (request.infoModel.HouseholderRelationship.integerValue == option.value.integerValue) {
                self.listModel.MasterName = request.infoModel.Name;
            }else{
                if (self.oldHouseShip.integerValue == option.value.integerValue) {
                    self.listModel.MasterName = @"建立成员时确定户主";
                }
            }
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
- (void )initilationPersonModel{
    [self savePerson];
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
- (NSString *)handleMutilableArrayToStr:(NSArray *)array attribute:(NSString *)attribute includeOther:(BOOL )include{
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (NSInteger i = 0 ; i < array.count ; i ++) {
        ArchiveSelectOptionModel *option = [array objectAtIndex:i];
        NSString *value = [option valueForKey:attribute];
        if (!include) {
            if ([option.title isEqualToString:@"其他"]) {
                NSString *subStr = [resultStr substringWithRange:NSMakeRange(0, resultStr.length - 1)];
                resultStr = [NSMutableString stringWithFormat:@"%@",subStr];
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
- (void )savePerson{
    [self saveTableInfoToPersonModel:self.personModel];
    self.personModel.FamilyHistory = nil;
    self.personModel.CmData = nil;
    self.personModel.HealthHistory = nil;
    
    BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
    
    
    if (!self.personModel.BuildOrgID.length || !self.personModel.BuildEmployeeID.length || !self.personModel.BuildEmployeeName.length) {
        self.personModel.BuildOrgID = info.OrgId;
        self.personModel.BuildEmployeeID = info.EmployeeID;
        self.personModel.BuildEmployeeName = [NSString stringWithString:info.UserName];
    }
    if (!self.personModel.PUserID.length || !self.personModel.PUserName.length) {
        self.personModel.PUserID = info.EmployeeID;
        self.personModel.PUserName = [NSString stringWithString:info.UserName];
    }
    if (!self.personModel.CustomNumber.length) {
        NSDate *date = [NSDate date]; 
        self.personModel.CustomNumber = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
    }
    
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
//        [self ZLSegmentedControlChangedValue:sender];
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
#pragma mark 懒加载
- (ArchiveBSInfoTableView *)bsTableView{
    if (!_bsTableView) {
        _bsTableView = [[ArchiveBSInfoTableView alloc]initWithFrame:CGRectMake(0, self.segmentedControl.bottom, self.view.width, SCREEN_HEIGHT - self.segmentedControl.bottom-TOP_BAR_HEIGHT) style:UITableViewStylePlain withModel:self.dataManager];
    }
    return _bsTableView;
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
        NSArray *array = [self.personModel attributeList];
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
                if (![value2 isKindOfClass:[NSArray class]] && !([value2 length] == 0 && [value length] == 0) && ![value isEqual:value2] && ![str isEqualToString:@"CustomNumber"] && ![str isEqualToString:@"ID"] && ![str isEqualToString:@"PUserID"] && value != nil) {
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
    [self alterViewAppear];
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
-(NSString *)handleTextFieldWithPersonModel{
    NSString *returnStr = nil;
    NSString *toaskStr = nil;
    
    if (!self.personModel.Name.length) {
        returnStr = returnStr.length ? returnStr : @"Name";
        toaskStr = toaskStr.length ? toaskStr : @"请完善姓名信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.GenderCode) {
        returnStr = returnStr.length ? returnStr : @"GenderCode";
        toaskStr = toaskStr.length ? toaskStr : @"请完善性别信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.BirthDay.length) {
        returnStr = returnStr.length ? returnStr : @"BirthDay";
        toaskStr = toaskStr.length ? toaskStr : @"请完善出生日期信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.CardID.length) {
        returnStr = returnStr.length ? returnStr : @"CardID";
        toaskStr = toaskStr.length ? toaskStr : @"请完善身份证信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.WorkOrgName.length) {
        returnStr = returnStr.length ? returnStr : @"WorkOrgName";
        toaskStr = toaskStr.length ? toaskStr : @"请完善工作单位信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.PersonTel.length) {
        returnStr = returnStr.length ? returnStr : @"PersonTel";
        toaskStr = toaskStr.length ? toaskStr : @"请完善个人电话信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.CurrentAddress.length) {
        returnStr = returnStr.length ? returnStr : @"CurrentAddress";
        toaskStr = toaskStr.length ? toaskStr : @"请完善现住地信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.ResidenceAddress.length) {
        returnStr = returnStr.length ? returnStr : @"ResidenceAddress";
        toaskStr = toaskStr.length ? toaskStr : @"请完善户籍地址信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.HouseholderRelationship) {
        returnStr = returnStr.length ? returnStr : @"HouseholderRelationship";
        toaskStr = toaskStr.length ? toaskStr : @"请完善与户主的关系!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.ResType) {
        returnStr = returnStr.length ? returnStr : @"ResType";
        toaskStr = toaskStr.length ? toaskStr : @"请完善户口类别信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.NationCode) {
        returnStr = returnStr.length ? returnStr : @"NationCode";
        toaskStr = toaskStr.length ? toaskStr : @"请完善民族信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (!self.personModel.ResponsibilityID) {
        returnStr = returnStr.length ? returnStr : @"ResponsibilityID";
        toaskStr = toaskStr.length ? toaskStr : @"请完善责任医生信息!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    NSString *personTel = self.personModel.PersonTel;
    NSString *contactTel = self.personModel.ContactTel;;
   
    
    
    if (personTel.length && ![personTel isPhoneNumber]) {
        returnStr = returnStr.length ? returnStr : @"PersonTel";
        toaskStr = toaskStr.length ? toaskStr : @"请输入有效手机号码!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (contactTel.length && ![contactTel isPhoneNumber] ) {
        returnStr = returnStr.length ? returnStr : @"ContactTel";
        toaskStr = toaskStr.length ? toaskStr : @"请输入有效手机号码!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    NSString *name = self.personModel.Name;
    NSString *contactPerson = self.personModel.ContactPerson;
    if (name.length && ![name isChinese]) {
        returnStr = returnStr.length ? returnStr : @"Name";
        toaskStr = toaskStr.length ? toaskStr : @"请输入中文名字!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (contactPerson.length && ![contactPerson isChinese]) {
        returnStr = returnStr.length ? returnStr : @"ContactPerson";
        toaskStr = toaskStr.length ? toaskStr : @"请输入中文名字!";
        if (toaskStr.length) {
            [UIView makeToast:toaskStr];
        }
        return returnStr;
    }
    if (![self.personModel.CardID isIdCard]) {
        returnStr = returnStr.length ? returnStr : @"CardID";
        toaskStr = toaskStr.length ? toaskStr : @"请输入有效的身份证号码!";
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
    NSUInteger section = 0;
    NSArray *array = nil;
    if ([code isEqualToString:@"WorkOrgName"]) {
        array = self.dataManager.dataModel.relateInfo.content;
        section = 1;
    }else{
        array = self.dataManager.dataModel.baseInfo.content;
    }
    
    NSArray *resultCities = [array filteredArrayUsingPredicate:predicate];
    if (resultCities.count) {
        BSArchiveModel *bsModel = resultCities.firstObject;
        NSUInteger index = [array indexOfObject:bsModel] + 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
//        [self.bsTableView scrollToRow:index + 1 inSection:section atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self.bsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self excuteCellAnimation:indexPath];
    }
}
- (void)excuteCellAnimation:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self.bsTableView cellForRowAtIndexPath:indexPath];
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.fromValue = [NSNumber numberWithFloat:-5];
    shake.toValue = [NSNumber numberWithFloat:5];
    shake.duration = 0.1;//执行时间
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 2;//次数
    [cell.layer addAnimation:shake forKey:@"shakeAnimation"];
}
@end
