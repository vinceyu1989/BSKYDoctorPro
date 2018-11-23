//
//  ArchiveAddView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveAddView.h"
#import "AllFormsSelectOnlineCell.h"
#import "AllFormsSelectTableViewCell.h"
#import "ArchivePickerTableViewCell.h"
#import "ArchiveDiseaseRequest.h"
#import "ArchiveFamilyHistoryRequest.h"
#import "ArchivePersonHistoryRequest.h"
#import "PersonHistoryModel.h"
#import "PersonBaseInfoModel.h"
#import "BSDictModel.h"

@interface ArchiveAddView ()<UITableViewDelegate,UITableViewDataSource,ArchivePickerTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *contetView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIView *tilteLine;
@property (weak, nonatomic) IBOutlet UIView *saveLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic ,strong)AddDiseaseModel *saveDiseaseModel;
@property (nonatomic ,strong)AddHistoryModel *savePersonHistoryModel;
@property (nonatomic ,strong)AddFamilyHistoryModel *saveFamilyHistoryModel;
@property (nonatomic ,copy)NSString *diseaseName;
@property (nonatomic ,copy)NSString *relateShip;
@property (nonatomic ,copy)NSString *oldValue;
@end

@implementation ArchiveAddView
- (instancetype)initWithFrame:(CGRect)frame model:(ArchiveModel *)model
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ArchiveAddView" owner:self options:nil] objectAtIndex:0];
    self.contetView.layer.cornerRadius = 7.5;
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    [self setFrame:rect];
    if (self) {
        self.model = model;
        _index = -1;
        [self configUI];
    }
    return self;
}
- (void)setModel:(ArchiveModel *)model{
    id object = [model mj_keyValues];
    _model = [ArchiveModel mj_objectWithKeyValues:object];
    BSArchiveModel *bsModel = _model.content.firstObject;
    if([_model.code isEqualToString:@"familyHistory"]){
        _oldValue = [bsModel.value mutableCopy];
    }else{
        _oldValue = [bsModel.contentStr mutableCopy];
    }
    
}
- (void)show{
    [self.contentTableView layoutIfNeeded];
    [self updateContentViewHeight];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)updateContentViewHeight{
    CGFloat maxHeight = SCREEN_HEIGHT - 74;
    CGFloat currentHeight = self.contentTableView.contentSize.height + 85;
    CGFloat height = currentHeight < maxHeight ? currentHeight : maxHeight;
    if (currentHeight < maxHeight) {
        
        self.contentTableView.scrollEnabled = YES;
    }else{
        self.contentTableView.scrollEnabled = YES;
    }
    [self.contetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        
    }];
}
- (void)configUI{
    
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.contentTableView registerClass:[AllFormsSelectTableViewCell class] forCellReuseIdentifier:[AllFormsSelectTableViewCell cellIdentifier]];
    [self.contentTableView registerNib:[ArchivePickerTableViewCell nib] forCellReuseIdentifier:[ArchivePickerTableViewCell cellIdentifier]];
    
    
    
    
    
    
    
    _titleLabel.text = _model.contentStr;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
//    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_saveBtn setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [_cancelBtn setTintColor:UIColorFromRGB(0x4e7dd3)];
    [_cancelBtn setTitleColor:UIColorFromRGB(0x4e7dd3) forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    _tilteLine.backgroundColor = UIColorFromRGB(0xededed);
    _saveLine.backgroundColor = UIColorFromRGB(0xededed);
    
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.5;
    @weakify(self);
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        [self endEditing:YES];
    }];
    [_backView addGestureRecognizer:gesture];
}

- (void)saveAction:(UIButton *)button{
    [self endEditing:YES];
    if ([self.model.code isEqualToString:@"diseaseHistory"] || [self.model.code isEqualToString:@"diseaseHistoryOther"]) {
        [self saveAndUpdateDiseaseHistory];
    }else if ([self.model.code isEqualToString:@"familyHistory"]){
        [self saveAndUpdateFamilyHistory];
    }else{
        [self saveAndUpdatePersonHistory];
    }
}
- (void)saveAndUpdatePersonHistory{
    AddHistoryModel *model = [self initlationPersonHistoryModel];
    if (!model.name.length) {
        [UIView makeToast:@"请输入相关描述信息!"];
        return;
    }
    if (!model.occurrenceDate.length && ![model.recordType isEqualToString:@"4"]) {
        [UIView makeToast:@"请输入正确的日期!"];
        return;
    }
    if (!_isUpdate) {
        ArchivePersonHistoryRequest *request = [[ArchivePersonHistoryRequest alloc] init];
        request.personHistoryInVMList = [NSArray arrayWithObject:[model mj_keyValues]];
        Bsky_WeakSelf;
        [MBProgressHUD showHud];
        [request startWithCompletionBlockWithSuccess:^(__kindof ArchivePersonHistoryRequest * _Nonnull request) {
            Bsky_StrongSelf;
            if (self.successBlock) {
                self.successBlock(self.savePersonHistoryModel);
                
            }
             [[ArchivePersonDataManager dataManager] updateHistory:model index:_index type:HistoryUpdateHealth];
            [self dissmissViewWithSuccess:YES msg:request.msg];
           
        } failure:^(__kindof ArchivePersonHistoryRequest * _Nonnull request) {
            Bsky_StrongSelf;
            [self dissmissViewWithSuccess:NO msg:request.msg];
            
        }];
    }else{
        UpdatePersonHistoryRequest *request = [[UpdatePersonHistoryRequest alloc] init];
        NSMutableArray *array = [[ArchivePersonDataManager dataManager] getUpdateDiseaseHistoryArray:model index:_index type:HistoryUpdateHealth];
        request.personHistoryInVMList = [AddHistoryModel mj_keyValuesArrayWithObjectArray:array];
        NSString *str = [request.personHistoryInVMList mj_JSONString];
        [MBProgressHUD showHud];
        Bsky_WeakSelf;
        [request startWithCompletionBlockWithSuccess:^(__kindof UpdatePersonHistoryRequest * _Nonnull request) {
            Bsky_StrongSelf;
            if (self.successBlock) {
                self.successBlock(self.savePersonHistoryModel);
                
            }
            [[ArchivePersonDataManager dataManager] updateHistory:model index:_index type:HistoryUpdateHealth];
            [self dissmissViewWithSuccess:YES msg:request.msg];
            
        } failure:^(__kindof UpdatePersonHistoryRequest * _Nonnull request) {
            Bsky_StrongSelf;
            [self dissmissViewWithSuccess:NO msg:request.msg];
           
        }];
    }
}
- (void)saveAndUpdateFamilyHistory{
    AddFamilyHistoryModel *model = [self initlationFamilyHistoryModel];
    if (!model.disease.length) {
        [UIView makeToast:@"请选择疾病类型!"];
        return;
    }
    if (!model.relationshipType.length) {
        [UIView makeToast:@"请选择亲属关系!"];
        return;
    }
    if (!_isUpdate) {
        ArchiveFamilyHistoryRequest *request = [[ArchiveFamilyHistoryRequest alloc] init];
        request.familyHistoryInVMList = [NSArray arrayWithObject:[model mj_keyValues]];
        [MBProgressHUD showHud];
        Bsky_WeakSelf;
        [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveFamilyHistoryRequest * _Nonnull request) {
            Bsky_StrongSelf;
            if (self.successBlock) {
                self.saveFamilyHistoryModel.relationShipName = self.relateShip;
                self.successBlock(self.saveFamilyHistoryModel);
                
            }
            id remark = [self.saveFamilyHistoryModel mj_keyValues];
            AddFamilyHistoryModel *saveModel = [AddFamilyHistoryModel mj_objectWithKeyValues:remark];
            saveModel.relationShipName = nil;
            [[ArchivePersonDataManager dataManager] replaceHistorySelectFamily:nil new:self.saveFamilyHistoryModel.relationshipType];
            [[ArchivePersonDataManager dataManager] updateHistory:saveModel index:_index type:HistoryUpdateFamily];
            [self dissmissViewWithSuccess:YES msg:request.msg];
            
        } failure:^(__kindof ArchiveFamilyHistoryRequest * _Nonnull request) {
            Bsky_StrongSelf;
            [self dissmissViewWithSuccess:NO msg:request.msg];
            
        }];
    }else{
        UpdateFamilyHistoryRequest *request = [[UpdateFamilyHistoryRequest alloc] init];
        NSMutableArray *array = [[ArchivePersonDataManager dataManager] getUpdateDiseaseHistoryArray:model index:_index type:HistoryUpdateFamily];
        request.familyHistoryInVMList = [AddFamilyHistoryModel mj_keyValuesArrayWithObjectArray:array];
        NSString *str = [request.familyHistoryInVMList mj_JSONString];
        [MBProgressHUD showHud];
        Bsky_WeakSelf;
        [request startWithCompletionBlockWithSuccess:^(__kindof UpdateFamilyHistoryRequest * _Nonnull request) {
            Bsky_StrongSelf;
            if (self.successBlock) {
                self.saveFamilyHistoryModel.relationShipName = self.relateShip;
                self.successBlock(self.saveFamilyHistoryModel);
                
            }
            id remark = [self.saveFamilyHistoryModel mj_keyValues];
            AddFamilyHistoryModel *saveModel = [AddFamilyHistoryModel mj_objectWithKeyValues:remark];
            saveModel.relationShipName = nil;
            [[ArchivePersonDataManager dataManager] replaceHistorySelectFamily:_oldValue new:self.saveFamilyHistoryModel.relationshipType];
            [[ArchivePersonDataManager dataManager] updateHistory:saveModel index:_index type:HistoryUpdateFamily];
            [self dissmissViewWithSuccess:YES msg:request.msg];
        } failure:^(__kindof UpdateFamilyHistoryRequest * _Nonnull request) {
            Bsky_StrongSelf;
            [self dissmissViewWithSuccess:NO msg:request.msg];
        }];
    }
}
- (void)saveAndUpdateDiseaseHistory{
    AddDiseaseModel *model = [self initlationDiseaseModel];
    if (!model.diseaseKindId.length) {
        [UIView makeToast:@"请选择疾病类型!"];
        return;
    }
    if (!model.diagnosisDate.length) {
        [UIView makeToast:@"请输入正确的日期!"];
        return;
    }
    if ([self.model.code isEqualToString:@"diseaseHistoryOther"] && !model.remark.length) {
        [UIView makeToast:@"请输入正确的疾病!"];
        return;
    }
    if (!_isUpdate) {
        ArchiveDiseaseRequest *request = [[ArchiveDiseaseRequest alloc] init];
        request.cmPersonInVMList = [NSArray arrayWithObject:[model mj_keyValues]];
        NSString *str = [model mj_JSONString];
        [MBProgressHUD showHud];
        Bsky_WeakSelf;
        [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveDiseaseRequest * _Nonnull request) {
            Bsky_StrongSelf;
            if (self.successBlock) {
                self.saveDiseaseModel.diseaseKindName = self.diseaseName;
                self.successBlock(self.saveDiseaseModel);
                
            }
            [[ArchivePersonDataManager dataManager] replaceHistorySelectDisease:nil new:self.saveDiseaseModel.diseaseKindName];
            [[ArchivePersonDataManager dataManager] updateHistory:self.saveDiseaseModel index:_index type:HistoryUpdateDisease];
            [self dissmissViewWithSuccess:YES msg:request.msg];
        } failure:^(__kindof ArchiveDiseaseRequest * _Nonnull request) {
            Bsky_StrongSelf;
            [self dissmissViewWithSuccess:NO msg:request.msg];
        }];
    }else{
        UpdateDiseaseRequest *request = [[UpdateDiseaseRequest alloc] init];
        NSMutableArray *array = [[ArchivePersonDataManager dataManager] getUpdateDiseaseHistoryArray:model index:_index type:HistoryUpdateDisease];
        request.cmPersonInVMList = [AddDiseaseModel mj_keyValuesArrayWithObjectArray:array];
        NSString *str = [request.cmPersonInVMList mj_JSONString];
        [MBProgressHUD showHud];
        Bsky_WeakSelf;
        [request startWithCompletionBlockWithSuccess:^(__kindof UpdateDiseaseRequest * _Nonnull request) {
            Bsky_StrongSelf;
            self.saveDiseaseModel.diseaseKindName = self.diseaseName;
            self.successBlock(self.saveDiseaseModel);
            
//            NSString *old = [self.model.content.firstObject value];
            [[ArchivePersonDataManager dataManager] replaceHistorySelectDisease:self.oldValue new:self.saveDiseaseModel.diseaseKindName];
            [[ArchivePersonDataManager dataManager] updateHistory:self.saveDiseaseModel index:_index type:HistoryUpdateDisease];
            [self dissmissViewWithSuccess:YES msg:request.msg];
        } failure:^(__kindof UpdateDiseaseRequest * _Nonnull request) {
            Bsky_StrongSelf;
            [self dissmissViewWithSuccess:NO msg:request.msg];
        }];
    }
}
- (NSArray *)getUpdateDiseaseRequestArray{
    
    return nil;
}
- (void)dissmissViewWithSuccess:(BOOL )sender msg:(NSString *)msg{
    [MBProgressHUD hideHud];
    if (sender) {
        [UIView makeToast:msg];
    }else{
        [UIView makeToast:msg];
    }
//    [self clearAddUIModel];
    [self removeFromSuperview];
}
- (void)clearAddUIModel{
    for (BSArchiveModel *model in self.model.content) {
        model.value = nil;
        model.contentStr = nil;
    }
}
- (AddHistoryModel *)initlationPersonHistoryModel{
    self.savePersonHistoryModel = [[AddHistoryModel alloc] init];
    for (BSArchiveModel *model in self.model.content) {
        [self.savePersonHistoryModel setValue:model.value forKey:model.code];
    }
    PersonBaseInfoModel *person = [ArchivePersonDataManager dataManager].personBaseInof;
    self.savePersonHistoryModel.personId = person.ID;
//    self.savePersonHistoryModel.personId = @"F3127CEABCB0408CBE1A19931B4AC6F1";
    if ([self.model.code isEqualToString:@"surgeryHistory"]) {
        self.savePersonHistoryModel.recordType = @"1";
    }else if ([self.model.code isEqualToString:@"traumaHistory"]){
        self.savePersonHistoryModel.recordType = @"2";
    }else if ([self.model.code isEqualToString:@"bloodHistory"]){
        self.savePersonHistoryModel.recordType = @"3";
    }else if ([self.model.code isEqualToString:@"geneticHistory"]){
        self.savePersonHistoryModel.recordType = @"4";
    }else{
        
    }
        
    return self.savePersonHistoryModel;
}
- (AddFamilyHistoryModel *)initlationFamilyHistoryModel{
    self.saveFamilyHistoryModel = [[AddFamilyHistoryModel alloc] init];
    for (BSArchiveModel *model in self.model.content) {
        
        if (![model.code isEqualToString:@"other"]) {
            [self.saveFamilyHistoryModel setValue:model.value forKey:model.code];
        }
        if ([model.code isEqualToString:@"relationshipType"]) {
            self.relateShip = model.contentStr;
        }
        if ([model.code isEqualToString:@"disease"]) {
            if (model.value.integerValue & 2048) {
                self.saveFamilyHistoryModel.remark = model.contentStr;
            }
        }
    }
    PersonBaseInfoModel *person = [ArchivePersonDataManager dataManager].personBaseInof;
    self.saveFamilyHistoryModel.personId = person.ID;
//    self.saveFamilyHistoryModel.personId = @"F3127CEABCB0408CBE1A19931B4AC6F1";
    return self.saveFamilyHistoryModel;
}
- (AddDiseaseModel *)initlationDiseaseModel{
    self.saveDiseaseModel = [[AddDiseaseModel alloc] init];
    for (BSArchiveModel *model in self.model.content) {
        if ([model.code isEqualToString:@"diseaseKindId"]) {
            self.diseaseName = model.contentStr;
        }
        [self.saveDiseaseModel setValue:model.value forKey:model.code];
    }
    if (_isUpdate) {
        AddDiseaseModel *disease = [[ArchivePersonDataManager dataManager].historyDiseaseArray objectAtIndex:_index];
        self.saveDiseaseModel.orgId = disease.orgId;
        self.saveDiseaseModel.doctorId = disease.doctorId;
        self.saveDiseaseModel.doctorName = disease.doctorName;
        self.saveDiseaseModel.personId = disease.personId;
        //    self.saveDiseaseModel.orgId = @"AB5EC46E84F34EFD82673A55D0F97972";
        //    self.saveDiseaseModel.doctorId = @"037D8AAE89DB4C6692652D36C6C96A1E";
        //    self.saveDiseaseModel.doctorName = @"戴绍琳";
        //    self.saveDiseaseModel.personId = @"F3127CEABCB0408CBE1A19931B4AC6F1";
        self.saveDiseaseModel.userId =  disease.userId;
        self.saveDiseaseModel.userName = disease.userName;
    }else{
        PersonBaseInfoModel *person = [ArchivePersonDataManager dataManager].personBaseInof;
        BSPhisInfo *info = [BSAppManager sharedInstance].currentUser.phisInfo;
        self.saveDiseaseModel.orgId = info.OrgId;
        self.saveDiseaseModel.doctorId = person.ResponsibilityID;
        self.saveDiseaseModel.doctorName = person.ResponsibilityDoctor;
        self.saveDiseaseModel.personId = [person.ID mutableCopy];
        //    self.saveDiseaseModel.orgId = @"AB5EC46E84F34EFD82673A55D0F97972";
        //    self.saveDiseaseModel.doctorId = @"037D8AAE89DB4C6692652D36C6C96A1E";
        //    self.saveDiseaseModel.doctorName = @"戴绍琳";
        //    self.saveDiseaseModel.personId = @"F3127CEABCB0408CBE1A19931B4AC6F1";
        self.saveDiseaseModel.userId =  info.EmployeeID;
        self.saveDiseaseModel.userName = info.UserName;
    }
    
    return self.saveDiseaseModel;
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark tableview Delegat&&Datasource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.model.code isEqualToString:@"geneticHistory"]) {
        return 1;
    }else if ([self.model.code isEqualToString:@"diseaseHistoryOther"]){
        return 3;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
    
    if (model.type == ArchiveModelTypeCustomPicker || model.type == ArchiveModelTypeDatePicker || model.type == ArchiveModelTypeTextField || model.type == ArchiveModelTypeLabel) {
        cell = [self.contentTableView dequeueReusableCellWithIdentifier:[ArchivePickerTableViewCell cellIdentifier] forIndexPath:indexPath];
        ArchivePickerTableViewCell *tableCell = (ArchivePickerTableViewCell *)cell;
        tableCell.delegate = self;
        tableCell.model = model;
    }
    if (model.type == ArchiveModelTypeSlectAndTextView || model.type == ArchiveModelTypeSelect) {
        cell = [self.contentTableView dequeueReusableCellWithIdentifier:[AllFormsSelectTableViewCell cellIdentifier] forIndexPath:indexPath];
        AllFormsSelectTableViewCell *tableCell = (AllFormsSelectTableViewCell *)cell;
        tableCell.isCollapsible = YES;
        tableCell.cellWidth = self.contentTableView.width;
        tableCell.model = model;
        Bsky_WeakSelf;
        tableCell.reloadLayout = ^(UITableViewCell *senderCell){
            Bsky_StrongSelf;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.contentTableView reloadData];
                [self layoutIfNeeded];
                [self updateContentViewHeight];
            });
            
        };
    }
    if (model.type == ArchiveModelTypeSlectOnLine) {
        cell = [self.contentTableView dequeueReusableCellWithIdentifier:[AllFormsSelectOnlineCell cellIdentifier] forIndexPath:indexPath];
        AllFormsSelectOnlineCell *tableCell = (AllFormsSelectOnlineCell *)cell;
        tableCell.model = model;
    }
    if (!cell) {
        cell = [self.contentTableView dequeueReusableCellWithIdentifier:@"123"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (BSArchiveModel *)getArchiveModelWithIndexPath:(NSIndexPath *)indexPath{
    BSArchiveModel *cellModel = nil;
    cellModel = [_model.content objectAtIndex:indexPath.row];
    if ([cellModel.code isEqualToString:@"diseaseKindId"]) {
        cellModel.pickerModel = [[ArchivePickerModel alloc] init];
        cellModel.pickerModel.options = [ArchivePersonDataManager dataManager].diseaseArray;
    }else if ([cellModel.code isEqualToString:@"relationshipType"]){
        cellModel.pickerModel = [[ArchivePickerModel alloc] init];
        NSArray *dic = [[ArchivePersonDataManager dataManager].dataDic objectForKey:@"gw_relation_shape"];
        cellModel.pickerModel.options = dic;
    }
    return cellModel;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
#pragma mark ArchivePickerTableViewCellDelegate
- (void)pickAction:(id)model{
    if ([model isKindOfClass:[DiseaseModel class]] && ([self.model.code isEqualToString:@"diseaseHistoryEspecial"] || [self.model.code isEqualToString:@"diseaseHistoryOther"] || [self.model.code isEqualToString:@"diseaseHistory"])) {
        DiseaseModel *selectModel = model;
        if ([selectModel.diseaseName isEqualToString:@"其他"]){
            if ([self.model.code isEqualToString:@"diseaseHistoryOther"])return;
            self.model = [ArchivePersonDataManager dataManager].historyAddModel.diseaseHistoryOther;
            BSArchiveModel *bsModel = self.model.content.firstObject;
            bsModel.contentStr = selectModel.diseaseName;
            bsModel.value = selectModel.diseaseId;
            bsModel.pickerModel.selectOption = model;
            [self.contentTableView reloadData];
            [self.contentTableView layoutIfNeeded];
            [self updateContentViewHeight];
        }else {
            if ([self.model.code isEqualToString:@"diseaseHistory"])return;
            self.model = [ArchivePersonDataManager dataManager].historyAddModel.diseaseHistory;
            BSArchiveModel *bsModel = self.model.content.firstObject;
            bsModel.contentStr = selectModel.diseaseName;
            bsModel.value = selectModel.diseaseId;
            bsModel.pickerModel.selectOption = model;
            [self.contentTableView reloadData];
            [self.contentTableView layoutIfNeeded];
            [self updateContentViewHeight];
        }
    }
}
@end
