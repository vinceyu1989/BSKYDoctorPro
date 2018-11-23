//
//  ZLPersonTableView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/1.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLPersonTableView.h"
#import "AllFormsSelectOnlineCell.h"
#import "ZLAllFormsSelectTableViewCell.h"
#import "AllFormsSectionCell.h"
#import "AllFormsInputTextCell.h"
#import "ZLArchivePickerTableViewCell.h"
#import "BSimagePickerCell.h"
#import "ArchiveCardRequest.h"
#import "AllFormsAddCell.h"
#import "AllFormsAddDrugCell.h"
#import "ZLArchiveAddView.h"
#import "ZLAddCell.h"
#import "ArchiveEditSelectCell.h"
#import "DiseaseViewController.h"
#import "AppDelegate.h"
#import "ZLCheckCardRequest.h"

@interface ZLPersonTableView ()<UITableViewDelegate,UITableViewDataSource,AllFormsAddCellDelegate,ZLAddCellDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong) NSArray *sectionTitleArray;

@end

@implementation ZLPersonTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withModel:(ArchivePersonDataManager *)model
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _dataManager = model;
        [self initInfo];
    }
    return self;
}
- (void)initInfo{
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerNib:[AllFormsSectionCell nib] forCellReuseIdentifier:[AllFormsSectionCell cellIdentifier]];
    [self registerNib:[ZLArchivePickerTableViewCell nib] forCellReuseIdentifier:[ZLArchivePickerTableViewCell cellIdentifier]];
    [self registerClass:[ZLAllFormsSelectTableViewCell class] forCellReuseIdentifier:[ZLAllFormsSelectTableViewCell cellIdentifier]];
    [self registerClass:[AllFormsSelectOnlineCell class] forCellReuseIdentifier:[AllFormsSelectOnlineCell cellIdentifier]];
    [self registerClass:[ArchiveEditSelectCell class] forCellReuseIdentifier:[ArchiveEditSelectCell cellIdentifier]];
    [self registerNib:[BSimagePickerCell nib] forCellReuseIdentifier:[BSimagePickerCell cellIdentifier]];
    [self registerNib:[AllFormsSectionCell nib] forCellReuseIdentifier:[AllFormsSectionCell cellIdentifier]];
    [self registerClass:[AllFormsAddCell class] forCellReuseIdentifier:[AllFormsAddCell cellIdentifier]];
    [self registerNib:[ZLAddCell nib] forCellReuseIdentifier:[ZLAddCell cellIdentifier]];
}
//验证身份证
- (void )checkCard:(BSArchiveModel *)card indexPath:(NSIndexPath *)indexPath{
    if (!card.contentStr.isIdCard) {
        [self reloadBirthDayAndGenderCellWith:card indexPath:indexPath right:NO];
        [UIView makeToast:@"请输入有效的证件号!"];
        return;
    }
    ZLCheckCardRequest *request = [[ZLCheckCardRequest alloc] init];
    request.card = card.value;
    [MBProgressHUD showHud];
    __weak typeof(BSArchiveModel *) usrCard = card;
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveCardRequest * _Nonnull request) {
        Bsky_StrongSelf;
        [MBProgressHUD hideHud];  
        if (![[request.ret objectForKey:@"existence"] boolValue]) {
            [self reloadBirthDayAndGenderCellWith:usrCard indexPath:indexPath right:YES];
        }else{
            [self reloadBirthDayAndGenderCellWith:usrCard indexPath:indexPath right:NO];
            [UIView makeToast:@"对应档案已存在,请重新输入身份证号!"];
        }
    } failure:^(__kindof ArchiveCardRequest * _Nonnull request) {
        [MBProgressHUD hideHud];
        [UIView makeToast:request.msg];
        
    }];
}
- (void)reloadBirthDayAndGenderCellWith:(BSArchiveModel *)model indexPath:(NSIndexPath *)indexPath right:(BOOL )sender{
    BSArchiveModel *genderModel = [self getArchiveModelWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    BSArchiveModel *birthModel = [self getArchiveModelWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section]];
    if (sender) {
        birthModel.contentStr = model.contentStr.birthdayStrFromIdentityCard;
        birthModel.value = model.contentStr.birthdayStrFromIdentityCard;
        NSString *gender = model.contentStr.sexStrFromIdentityCard;
        if (gender.integerValue == 1) {
            genderModel.contentStr = @"男";
        }else if (gender.integerValue == 2){
            genderModel.contentStr = @"女";
        }
        
        genderModel.value = gender;
    }else{
        birthModel.contentStr = @"";
        birthModel.value = @"";
        genderModel.contentStr = @"";
        genderModel.value = @"";
        model.value = @"";
        model.contentStr = @"";
    }
    
    
    [self reloadRow:indexPath.row + 1 inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    [self reloadRow:indexPath.row + 2 inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    [self reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}
- (NSArray *)sectionTitleArray{
    if (!_sectionTitleArray) {
        
        _sectionTitleArray = @[self.dataManager.zlPersonUIModel.personInfo.contentStr,self.dataManager.zlPersonUIModel.otherInfo.contentStr,self.dataManager.zlPersonUIModel.medicalHistoryInfo.contentStr,self.dataManager.zlPersonUIModel.pastHistory.contentStr,self.dataManager.zlPersonUIModel.familyHistory.contentStr,self.dataManager.zlPersonUIModel.environment.contentStr];
    }
    return _sectionTitleArray;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (UITableViewCell *)creatTableViewCellWithindexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    
    if (!indexPath.row) {
        if(indexPath.section == 4){
            cell = [self dequeueReusableCellWithIdentifier:[AllFormsAddCell cellIdentifier] forIndexPath:indexPath];
            AllFormsAddCell *tableCell = (AllFormsAddCell *)cell;
            BSArchiveModel *model = [self getArchiveModelWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
            tableCell.model = model;
            tableCell.delegate = self;
        }else{
            cell = [self dequeueReusableCellWithIdentifier:[AllFormsSectionCell cellIdentifier] forIndexPath:indexPath];
            
            AllFormsSectionCell *tableCell = (AllFormsSectionCell *)cell;
            tableCell.upModel = [[FollowupUpModel alloc] init];
            tableCell.titleStr = self.sectionTitleArray[indexPath.section];
            tableCell.clickImageView.hidden = YES;
        }
        
        
        
    }else{
        
        BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
        if (model.type == ArchiveModelTypeCustomPicker || model.type == ArchiveModelTypeDatePicker || model.type == ArchiveModelTypeTextField || model.type == ArchiveModelTypeLabel || model.type == ArchiveModelTypeControllerPicker || model.type == ArchiveModelTypeCustomOptionsPicker) {
            cell = [self dequeueReusableCellWithIdentifier:[ZLArchivePickerTableViewCell cellIdentifier] forIndexPath:indexPath];
            ZLArchivePickerTableViewCell *tableCell = (ZLArchivePickerTableViewCell *)cell;
            
            tableCell.model = model;
            
            if (model.type == ArchiveModelTypeTextField && [model.code isEqualToString:@"cardId"]) {
                Bsky_WeakSelf;
                tableCell.endBlock = ^(id model){
                    Bsky_StrongSelf;
                    [self checkCard:model indexPath:indexPath];
                    
                };
            }else if (model.type == ArchiveModelTypeCustomOptionsPicker && ([model.code isEqualToString:@"registerProvince,registerCity,registerDistrict"] || [model.code isEqualToString:@"province,city,district"])) {
                Bsky_WeakSelf;
                tableCell.endBlock = ^(id model){
                    Bsky_StrongSelf;
                    NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
                    BSArchiveModel *nextModel = [self getArchiveModelWithIndexPath:index];
                    nextModel.contentStr = @"";
                    nextModel.value = @"";
                    [self beginUpdates];
                    [self reloadRowAtIndexPath:index withRowAnimation:UITableViewRowAnimationFade];
                    [self endUpdates];
                };
            }else{
                tableCell.endBlock = nil;
            }
        }
        if (model.type == ArchiveModelTypeSlectAndTextView || model.type == ArchiveModelTypeSelect) {
            cell = [self dequeueReusableCellWithIdentifier:[ZLAllFormsSelectTableViewCell cellIdentifier] forIndexPath:indexPath];
            ZLAllFormsSelectTableViewCell *tableCell = (ZLAllFormsSelectTableViewCell *)cell;
            if ([model.code isEqualToString:@"medicalPayment"]){
                tableCell.selectCount = 3;
            }else{
                tableCell.selectCount = 0;
            }
            if ([model.code isEqualToString:@"drugAllergy"]){
                Bsky_WeakSelf;
                tableCell.isCollapsible = YES;
                tableCell.otherBlock = ^(){
                    Bsky_StrongSelf;
                    [self showOtherSelectOptions:indexPath];
                    
                };
                tableCell.reloadLayout = ^(UITableViewCell *senderCell){
                    [self beginUpdates];
                    [self reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                    [self endUpdates];
                };
            }else{
                tableCell.otherBlock = nil;
                tableCell.reloadLayout = nil;
            }
            tableCell.model = model;
        }
        if (model.type == ArchiveModelTypeSlectOnLine) {
            cell = [self dequeueReusableCellWithIdentifier:[AllFormsSelectOnlineCell cellIdentifier] forIndexPath:indexPath];
            AllFormsSelectOnlineCell *tableCell = (AllFormsSelectOnlineCell *)cell;
            tableCell.model = model;
        }
        if (model.type == ArchiveModelTypeImagePicker) {
            cell = [self dequeueReusableCellWithIdentifier:[BSimagePickerCell cellIdentifier] forIndexPath:indexPath];
            BSimagePickerCell *tableCell = (BSimagePickerCell *)cell;
            tableCell.model = model;
        }
        if (model.type == ArchiveModelTypeAddSection || model.type == ArchiveModelTypeAddCell) {
            cell = [self dequeueReusableCellWithIdentifier:[AllFormsAddCell cellIdentifier] forIndexPath:indexPath];
            AllFormsAddCell *tableCell = (AllFormsAddCell *)cell;
            tableCell.model = model;
            tableCell.delegate = self;
        }else if (model.type == ArchiveModelTypeAddSubCell){
            cell = [self dequeueReusableCellWithIdentifier:[ZLAddCell cellIdentifier] forIndexPath:indexPath];
            ZLAddCell *tableCell = (ZLAddCell *)cell;
            tableCell.deleteBtn.hidden = NO;
            tableCell.delegate = self;
            tableCell.model = model;
        }else if (model.type == ArchiveModelTypeCanEditSelect){
            cell = [self dequeueReusableCellWithIdentifier:[ArchiveEditSelectCell cellIdentifier] forIndexPath:indexPath];
            ArchiveEditSelectCell *tableCell = (ArchiveEditSelectCell *)cell;
            tableCell.model = model;
        }
        if (!cell) {
            cell = [self dequeueReusableCellWithIdentifier:@"123"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
            }
        }
        
    }
    return cell;
}
- (BSArchiveModel *)getArchiveModelWithIndexPath:(NSIndexPath *)indexPath{
    BSArchiveModel *model = nil;
    if (indexPath.section != 4 && indexPath.row != 0) {
        indexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:indexPath.section];
    }
    switch (indexPath.section) {
        case 0:
        {
            model = [self.dataManager.zlPersonUIModel.personInfo.content objectAtIndex:indexPath.row];
        }
        break;
        case 1:
        {
            model = [self.dataManager.zlPersonUIModel.otherInfo.content objectAtIndex:indexPath.row];
        }
        break;
        case 2:
        {
            model = [self.dataManager.zlPersonUIModel.medicalHistoryInfo.content objectAtIndex:indexPath.row];
        }
        break;
        case 3:
        {
            model = [self.dataManager.zlPersonUIModel.pastHistory.content objectAtIndex:indexPath.row];
        }
        break;
        case 4:
        {
            model = [self.dataManager.zlPersonUIModel.familyHistory.content objectAtIndex:indexPath.row];
        }
        break;
        case 5:
        {
            model = [self.dataManager.zlPersonUIModel.environment.content objectAtIndex:indexPath.row];
        }
        break;
        default:
        
        break;
    }
    return model;
}
#pragma mark talbeView Delegate && Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self creatTableViewCellWithindexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    switch (section) {
        case 0:
        count = [self.dataManager.zlPersonUIModel.personInfo.content count];
        break;
        case 1:
        count = [self.dataManager.zlPersonUIModel.otherInfo.content count];
        break;
        case 2:
        count = [self.dataManager.zlPersonUIModel.medicalHistoryInfo.content count];
        break;
        case 3:
        count = [self.dataManager.zlPersonUIModel.pastHistory.content count];
        break;
        case 4:
        count = [self.dataManager.zlPersonUIModel.familyHistory.content count];
        break;
        case 5:
        count = [self.dataManager.zlPersonUIModel.environment.content count];
        break;
        default:
        return 0;
        break;
    }
    if (count && section != 4) {
        count ++;
    }
    return count;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4 && indexPath.section == 2) {
        DiseaseViewController *cv = [[DiseaseViewController alloc] init];
        BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
        if ([model.selectModel.options count]) {
            cv.selectedArray = [NSMutableArray arrayWithArray:model.selectModel.options];
        }
        cv.selectCount = 1;
        Bsky_WeakSelf;
        cv.block = ^(NSArray *options) {
            Bsky_StrongSelf;
            ArchiveSelectModel *select = [[ArchiveSelectModel alloc] init];
            [select setOptions:options];
            model.selectModel = select;
            [self reloadData];
        };
        AppDelegate *deleate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *viewController = (UITabBarController *)deleate.window.rootViewController;
        UINavigationController *nav = [viewController.viewControllers firstObject];
        [nav pushViewController:cv animated:YES];
    }
    if (indexPath.section == 4 || indexPath.section == 3) {
        BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
        if (model.type == ArchiveModelTypeAddSubCell) {
            [self updateCellWithIndexPath:indexPath];
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.scrollBlock) {
        NSIndexPath *topVisibleIndexPath = [[self indexPathsForVisibleRows] objectAtIndex:self.indexPathsForVisibleRows.count / 2];
        NSUInteger index = topVisibleIndexPath.section - 1 >= 0 ? topVisibleIndexPath.section : 0;
        self.scrollBlock(index);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.scrollBlock) {
        NSIndexPath *topVisibleIndexPath = [[self indexPathsForVisibleRows] objectAtIndex:self.indexPathsForVisibleRows.count / 2];
        NSUInteger index = topVisibleIndexPath.section - 1 >= 0 ? topVisibleIndexPath.section : 0;
        self.scrollBlock(index);
    }
}
//- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    if (self.scrollBlock) {
//        NSIndexPath *topVisibleIndexPath = [[self indexPathsForVisibleRows] objectAtIndex:0];
//        NSUInteger selectedSegmentIndex = topVisibleIndexPath.section-1 >= 0 ? topVisibleIndexPath.section : 0;
//        self.scrollBlock(selectedSegmentIndex);
//    }
//}
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    if (self.scrollBlock) {
//        NSIndexPath *topVisibleIndexPath = [[self indexPathsForVisibleRows] objectAtIndex:0];
//        NSUInteger selectedSegmentIndex = topVisibleIndexPath.section-1 >= 0 ? topVisibleIndexPath.section : 0;
//        self.scrollBlock(selectedSegmentIndex);
//    }
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 40;
    CGFloat sectionFooterHeight = 10;
    CGFloat offsetY = self.contentOffset.y;
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
    {
        self.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= self.contentSize.height - self.frame.size.height - sectionFooterHeight)
    {
        self.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= scrollView.contentSize.height - self.frame.size.height - sectionFooterHeight && offsetY <= self.contentSize.height - self.frame.size.height)
    {
        self.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(self.contentSize.height - self.frame.size.height - sectionFooterHeight), 0);
    }
}
#pragma mark ZLAddCell Delegate
- (void)delectAction:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    if (indexPath.section == 4){
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataManager.zlPersonUIModel.familyHistory.content];
        BSArchiveModel *model = [array objectAtIndex:indexPath.row];
        NSString *familyCode = [[model.addModel.adds.firstObject valueForKey:@"value"] mutableCopy];
        [self.dataManager.zlFamilyRelationForHistory removeObject:familyCode];
        [array removeObjectAtIndex:indexPath.row];
        self.dataManager.zlPersonUIModel.familyHistory.content = array;
        
    }else{
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataManager.zlPersonUIModel.pastHistory.content];
        
        [array removeObjectAtIndex:indexPath.row - 1];
        self.dataManager.zlPersonUIModel.pastHistory.content = array;
    }
    [self beginUpdates];
    [self deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
    [self endUpdates];
}
- (void )showOtherSelectOptions:(NSIndexPath *)indexPath{
    BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
    ArchiveModel *cellModel = self.dataManager.zlHistoryAddUIModel.drugAllergyOther;
    BSArchiveModel *cellSubModel = cellModel.content.firstObject;
    ArchiveSelectModel *selectModel = [[ArchiveSelectModel alloc] init];
    selectModel.multiple = YES;
    if ([model.selectModel.others count]) {
        selectModel.selectArray = model.selectModel.others;
    }
    selectModel.options = [[ArchivePersonDataManager dataManager].dataDic objectForKey:@"zl_history_of_drug_allergy_select"];
    cellSubModel.selectModel = selectModel;
//    ArchiveModel *newCellModel = [ArchiveModel mj_objectWithKeyValues:[cellModel mj_keyValues]];
//    newCellModel.content = model.addModel.adds;
    ZLArchiveAddView *view = [[ZLArchiveAddView alloc] initWithFrame:self.bounds model:cellModel];
    Bsky_WeakSelf;
    view.isUpdate = YES;
    view.successBlock = ^(id returnModel){
        Bsky_StrongSelf;
        //        [self insertAddCell:indexPath withModel:model cellsModel:cellModel];
        ArchiveModel *subModel = returnModel;
        BSArchiveModel *bsModel = subModel.content.firstObject;
        model.selectModel.others = bsModel.selectModel.selectArray;
        [self beginUpdates];
        [self reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
        [self endUpdates];
    };
    [view show];
}
#pragma mark Add Delegate
- (void)updateCellWithIndexPath:(NSIndexPath *)indexPath{
    BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
    ArchiveModel *cellModel = nil;
    if ([model.code isEqualToString:@"diseaseHistory"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.diseaseHistory;
    }
    if ([model.code isEqualToString:@"diseaseHistoryEspecial"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.diseaseHistoryEspecial;
    }
    if ([model.code isEqualToString:@"diseaseHistoryOther"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.diseaseHistoryOther;
    }
    if ([model.code isEqualToString:@"surgeryHistory"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.surgeryHistory;
    }
    if ([model.code isEqualToString:@"traumaHistory"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.traumaHistory;
    }
    if ([model.code isEqualToString:@"bloodHistory"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.bloodHistory;
    }
    if ([model.code isEqualToString:@"familyHistory"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.familyHistory;
    }
//    if ([model.code isEqualToString:@"geneticHistory"]) {
//        cellModel = self.dataManager.zlHistoryAddUIModel.geneticHistory;
//    }
    //    [self insertAddCell:indexPath];
    
    ArchiveModel *newCellModel = [ArchiveModel mj_objectWithKeyValues:[cellModel mj_keyValues]];
    newCellModel.content = model.addModel.adds;
    ZLArchiveAddView *view = [[ZLArchiveAddView alloc] initWithFrame:self.bounds model:newCellModel];
    Bsky_WeakSelf;
    view.isUpdate = YES;
    view.successBlock = ^(id model){
        Bsky_StrongSelf;
        //        [self insertAddCell:indexPath withModel:model cellsModel:cellModel];
        [self updateAddCell:indexPath withModel:model];
    };
    [view show];
}
- (void)allFormsAddCellAddClick:(AllFormsAddCell *)cell{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
    ArchiveModel *cellModel = nil;
    if ([model.code isEqualToString:@"diseaseHistory"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.diseaseHistory;
    }
    if ([model.code isEqualToString:@"surgeryHistory"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.surgeryHistory;
    }
    if ([model.code isEqualToString:@"traumaHistory"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.traumaHistory;
    }
    if ([model.code isEqualToString:@"bloodHistory"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.bloodHistory;
    }
    if ([model.code isEqualToString:@"familyHistory"]) {
        cellModel = self.dataManager.zlHistoryAddUIModel.familyHistory;
    }
    //    [self insertAddCell:indexPath];
    ZLArchiveAddView *view = [[ZLArchiveAddView alloc] initWithFrame:self.bounds model:cellModel];
    Bsky_WeakSelf;
    view.successBlock = ^(id model){
        Bsky_StrongSelf;
        [self insertAddCell:indexPath withModel:model cellsModel:cellModel];
    };
    [view show];
}
- (void)updateAddCell:(NSIndexPath *)indexPath withModel:(id )model{
    
    //    BSArchiveModel *model1 = [[BSArchiveModel alloc] init];
    //    model1.title = @"疾病";
    //    model1.contentStr = @"高血压";
    //
    //    BSArchiveModel *model2 = [[BSArchiveModel alloc] init];
    //    model2.title = @"确证时间";
    //    model2.contentStr = @"2018-01-01";
    
    BSArchiveModel *cellsModel = [self getArchiveModelWithIndexPath:indexPath];
//    for (BSArchiveModel *subCellmodel in cellsModel.addModel.adds) {
//        if ([model isKindOfClass:[AddDiseaseModel class]]) {
//            AddDiseaseModel *currentModel = (AddDiseaseModel *)model;
//            if ([subCellmodel.code isEqualToString:@"diseaseKindId"]) {
//                subCellmodel.value = currentModel.diseaseKindId;
//                subCellmodel.contentStr = currentModel.diseaseKindName;
//            }else{
//                subCellmodel.value = currentModel.diagnosisDate;
//                subCellmodel.contentStr = currentModel.diagnosisDate;
//            }
//        }
//        if ([model isKindOfClass:[AddFamilyHistoryModel class]]) {
//            AddFamilyHistoryModel *currentModel = (AddFamilyHistoryModel *)model;
//            if ([subCellmodel.code isEqualToString:@"disease"]) {
//                subCellmodel.value = currentModel.disease;
//            }else if ([subCellmodel.code isEqualToString:@"relationshipType"]){
//                subCellmodel.value = currentModel.relationshipType;
//                subCellmodel.contentStr = currentModel.relationShipName;
//            }
//        }
//        if ([model isKindOfClass:[AddHistoryModel class]]) {
//            AddHistoryModel *currentModel = (AddHistoryModel *)model;
//            if ([subCellmodel.code isEqualToString:@"name"]) {
//                subCellmodel.value = currentModel.name;
//                subCellmodel.contentStr = currentModel.name;
//            }else{
//                subCellmodel.value = currentModel.occurrenceDate;
//                subCellmodel.contentStr = currentModel.occurrenceDate;
//            }
//        }
//    }
//    cellsModel.co
//    //    cellsModel.addModel.adds = [NSMutableArray arrayWithArray:cellsModel.addModel.adds];
//    [self updateCellOtherSubCell:cellsModel.addModel.adds model:model];
    ArchiveModel *resultModel = model;
    if (indexPath.section == 4) {
        NSString *oldFamilyCode = [cellsModel.addModel.adds.firstObject valueForKey:@"value"];
        NSString *newFamilyCode = [resultModel.content.firstObject valueForKey:@"value"];
        if (![oldFamilyCode isEqualToString:newFamilyCode]) {
            if ([self.dataManager.zlFamilyRelationForHistory containsObject:oldFamilyCode]) {
                [self.dataManager.zlFamilyRelationForHistory removeObject:oldFamilyCode];
            }
            if (![self.dataManager.zlFamilyRelationForHistory containsObject:newFamilyCode]) {
                [self.dataManager.zlFamilyRelationForHistory addObject:newFamilyCode];
            }
        }
    }
    
    cellsModel.title = resultModel.contentStr;
    cellsModel.code = resultModel.code;
    cellsModel.addModel.adds = resultModel.content;
    [self beginUpdates];
    [self reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
    
}
- (void)insertAddCell:(NSIndexPath *)indexPath withModel:(id )model cellsModel:(ArchiveModel *)cellsModel{
    
    //    BSArchiveModel *model1 = [[BSArchiveModel alloc] init];
    //    model1.title = @"疾病";
    //    model1.contentStr = @"高血压";
    //
    //    BSArchiveModel *model2 = [[BSArchiveModel alloc] init];
    //    model2.title = @"确证时间";
    //    model2.contentStr = @"2018-01-01";
    
    BSArchiveModel *cellModel = [[BSArchiveModel alloc] init];
    cellModel.code = [model valueForKey:@"code"];
    cellModel.canEdit = YES;
    cellModel.title = cellsModel.contentStr;
    cellModel.addModel = [[ArchiveAddModel alloc] init];
    cellModel.addModel.adds = [model valueForKey:@"content"];
    cellModel.type = ArchiveModelTypeAddSubCell;
    [self insertContentArrayWithindexPath:indexPath model:cellModel];
    
}
- (NSArray *)getAddCellArray:(id )model cellModel:(ArchiveModel *)cellModel{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (BSArchiveModel *subCellmodel in cellModel.content) {
        BSArchiveModel *insetModel = [[BSArchiveModel alloc] init];
        insetModel.title = subCellmodel.title;
        insetModel.code = subCellmodel.code;
        insetModel.type = subCellmodel.type;
        insetModel.canEdit = YES;
        if ([model isKindOfClass:[AddDiseaseModel class]]) {
            AddDiseaseModel *currentModel = (AddDiseaseModel *)model;
            if ([subCellmodel.code isEqualToString:@"diseaseKindId"]) {
                insetModel.value = currentModel.diseaseKindId;
                insetModel.contentStr = currentModel.diseaseKindName;
            }else{
                insetModel.value = currentModel.diagnosisDate;
                insetModel.contentStr = currentModel.diagnosisDate;
            }
        }
        if ([model isKindOfClass:[AddFamilyHistoryModel class]]) {
            AddFamilyHistoryModel *currentModel = (AddFamilyHistoryModel *)model;
            if ([subCellmodel.code isEqualToString:@"relationshipType"]) {
                insetModel.contentStr = currentModel.relationShipName;
                insetModel.value = currentModel.relationshipType;
            }else if ([subCellmodel.code isEqualToString:@"disease"]){
                insetModel.value = currentModel.disease;
                insetModel.contentStr = currentModel.remark;
                insetModel.selectModel = subCellmodel.selectModel;
            }
        }
        if ([model isKindOfClass:[AddHistoryModel class]]) {
            AddHistoryModel *currentModel = (AddHistoryModel *)model;
            if ([subCellmodel.code isEqualToString:@"name"]) {
                insetModel.contentStr = currentModel.name;
                insetModel.value = currentModel.name;
            }else{
                insetModel.contentStr = currentModel.occurrenceDate;
                insetModel.value = currentModel.occurrenceDate;
            }
        }
        [array addObject:insetModel];
    }
    [self updateCellOtherSubCell:array model:model];
    return array;
}
- (void)updateCellOtherSubCell:(NSArray *)array model:(id )dataModel{
    NSMutableArray *mutableArray = nil;
    if (![array isKindOfClass:[NSMutableArray class]]) {
        mutableArray = [NSMutableArray arrayWithArray:array];
    }else{
        mutableArray = (NSMutableArray *)array;
    }
    if ([dataModel isKindOfClass:[AddFamilyHistoryModel class]]) {
        AddFamilyHistoryModel *currentModel = (AddFamilyHistoryModel *)dataModel;
        if (currentModel.disease.integerValue & 2048) {
            if ([array count] > 2) {
                BSArchiveModel *insetModel = [array objectAtIndex:2];
                insetModel.title = @"其他";
                insetModel.code = @"other";
                insetModel.contentStr = currentModel.remark;
                insetModel.value = currentModel.remark;
            }else{
                BSArchiveModel *insetModel = [[BSArchiveModel alloc] init];
                insetModel.title = @"其他";
                insetModel.code = @"other";
                insetModel.contentStr = currentModel.remark;
                insetModel.value = currentModel.remark;
                [mutableArray addObject:insetModel];
            }
            
        }else{
            if ([array count] == 3) {
                [mutableArray removeObjectAtIndex:2];
            }
        }
    }
}
- (void)insertContentArrayWithindexPath:(NSIndexPath *)indexPath model:(BSArchiveModel *)model{
    NSArray *array = nil;
    ArchiveModel *cellModel = nil;
    switch (indexPath.section) {
        case 3:
        array = self.dataManager.zlPersonUIModel.pastHistory.content;
        cellModel = self.dataManager.zlPersonUIModel.pastHistory;
        break;
        case 4:
        array = self.dataManager.zlPersonUIModel.familyHistory.content;
        cellModel = self.dataManager.zlPersonUIModel.familyHistory;
        break;
        case 2:
//        array = self.dataManager.historyModel.geneticHistory.content;
//        cellModel = self.dataManager.historyModel.geneticHistory;
        break;
        default:
        
        break;
    }
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    if (indexPath.section == 4) {
        [mutableArray insertObject:model atIndex:indexPath.row + 1];
    }else{
        [mutableArray insertObject:model atIndex:indexPath.row];
    }
    if (indexPath.section == 4) {
        NSString *familyRelationCode = [[model.addModel.adds.firstObject valueForKey:@"value"] mutableCopy];
        if (![self.dataManager.zlFamilyRelationForHistory containsObject:familyRelationCode]) {
            [self.dataManager.zlFamilyRelationForHistory addObject:familyRelationCode];
        }else{
            
        }
    }
    [cellModel setValue:mutableArray forKey:@"content"];
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    [self beginUpdates];
    [self insertRowAtIndexPath:path withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
    
}

@end
