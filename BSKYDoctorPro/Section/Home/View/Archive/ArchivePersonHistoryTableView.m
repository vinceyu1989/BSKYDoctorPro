//
//  ArchivePersonHistoryTableView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchivePersonHistoryTableView.h"
#import "AllFormsSectionCell.h"
#import "AllFormsAddDrugCell.h"
#import "ArchiveAddView.h"
#import "AddCell.h"

@interface ArchivePersonHistoryTableView ()<UITableViewDelegate,UITableViewDataSource,AllFormsAddCellDelegate>

@property (nonatomic ,strong) NSArray *sectionTitleArray;

@end

@implementation ArchivePersonHistoryTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withModel:(ArchivePersonDataManager *)model
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setFrame:frame];
        _dataManager = model;
        [self initInfo];
    }
    return self;
}
- (void)initInfo{
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.backgroundView = nil;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerNib:[AllFormsSectionCell nib] forCellReuseIdentifier:[AllFormsSectionCell cellIdentifier]];
    [self registerClass:[AllFormsAddCell class] forCellReuseIdentifier:[AllFormsAddCell cellIdentifier]];
    [self registerNib:[AddCell nib] forCellReuseIdentifier:[AddCell cellIdentifier]];
}
- (NSArray *)sectionTitleArray{
    if (!_sectionTitleArray) {
        
        _sectionTitleArray = @[self.dataManager.historyModel.pastHistory.contentStr];
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
    
    if (!indexPath.row && !indexPath.section) {
        cell = [self dequeueReusableCellWithIdentifier:[AllFormsSectionCell cellIdentifier] forIndexPath:indexPath];
        AllFormsSectionCell *tableCell = (AllFormsSectionCell *)cell;
        tableCell.upModel = [[FollowupUpModel alloc] init];
        tableCell.titleStr = self.sectionTitleArray[indexPath.section];
        tableCell.clickImageView.hidden = YES;
    }else{
        BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
        if (model.type == ArchiveModelTypeAddSection || model.type == ArchiveModelTypeAddCell) {
            cell = [self dequeueReusableCellWithIdentifier:[AllFormsAddCell cellIdentifier] forIndexPath:indexPath];
            AllFormsAddCell *tableCell = (AllFormsAddCell *)cell;
            tableCell.model = model;
            tableCell.delegate = self;
        }else if (model.type == ArchiveModelTypeAddSubCell){
            cell = [self dequeueReusableCellWithIdentifier:[AddCell cellIdentifier] forIndexPath:indexPath];
            AddCell *tableCell = (AddCell *)cell;
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
    if (!indexPath.section) {
        indexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:indexPath.section];
    }
    switch (indexPath.section) {
        case 0:
        {
            model = [self.dataManager.historyModel.pastHistory.content objectAtIndex:indexPath.row];
        }
            break;
        case 1:
        {
            model = [self.dataManager.historyModel.familyHistory.content objectAtIndex:indexPath.row];
        }
            break;
        case 2:
        {
            model = [self.dataManager.historyModel.geneticHistory.content objectAtIndex:indexPath.row];
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
            count = [self.dataManager.historyModel.pastHistory.content count];
            break;
        case 1:
            count = [self.dataManager.historyModel.familyHistory.content count];
            break;
        case 2:
            count = [self.dataManager.historyModel.geneticHistory.content count];
            break;
        default:
            return 0;
            break;
    }
    if (!section) {
        count ++;
    }
    return count;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 10;
    }
    return 0;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
    BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
    if (model.type == ArchiveModelTypeAddSubCell) {
        [self updateCellWithIndexPath:indexPath];
    }
}
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark add Delegate
- (void)updateCellWithIndexPath:(NSIndexPath *)indexPath{
    BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
    ArchiveModel *cellModel = nil;
    if ([model.code isEqualToString:@"diseaseHistory"]) {
        cellModel = self.dataManager.historyAddModel.diseaseHistory;
    }
    if ([model.code isEqualToString:@"surgeryHistory"]) {
        cellModel = self.dataManager.historyAddModel.surgeryHistory;
    }
    if ([model.code isEqualToString:@"traumaHistory"]) {
        cellModel = self.dataManager.historyAddModel.traumaHistory;
    }
    if ([model.code isEqualToString:@"bloodHistory"]) {
        cellModel = self.dataManager.historyAddModel.bloodHistory;
    }
    if ([model.code isEqualToString:@"familyHistory"]) {
        cellModel = self.dataManager.historyAddModel.familyHistory;
        BSArchiveModel *bsModel = cellModel.content.lastObject;
        bsModel.selectModel.options = [self.dataManager.dataDic objectForKey:@"gw_family_disease"];
    }
    if ([model.code isEqualToString:@"geneticHistory"]) {
        cellModel = self.dataManager.historyAddModel.geneticHistory;
    }
    if ([model.code isEqualToString:@"diseaseHistoryOther"]) {
        cellModel = self.dataManager.historyAddModel.diseaseHistoryOther;
    }
    //    [self insertAddCell:indexPath];
   
    ArchiveModel *newCellModel = [ArchiveModel mj_objectWithKeyValues:[cellModel mj_keyValues]];
    newCellModel.content = model.addModel.adds;
    ArchiveAddView *view = [[ArchiveAddView alloc] initWithFrame:self.bounds model:newCellModel];
    view.index = model.addModel.index;
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
    NSUInteger index = 0;
    if ([model.code isEqualToString:@"diseaseHistory"]) {
        cellModel = self.dataManager.historyAddModel.diseaseHistory;
        index = self.dataManager.historyDiseaseArray.count;
    }
    if ([model.code isEqualToString:@"surgeryHistory"]) {
        cellModel = self.dataManager.historyAddModel.surgeryHistory;
        index = self.dataManager.historyHealthArray.count;
    }
    if ([model.code isEqualToString:@"traumaHistory"]) {
        cellModel = self.dataManager.historyAddModel.traumaHistory;
        index = self.dataManager.historyHealthArray.count;
    }
    if ([model.code isEqualToString:@"bloodHistory"]) {
        cellModel = self.dataManager.historyAddModel.bloodHistory;
        index = self.dataManager.historyHealthArray.count;
    }
    if ([model.code isEqualToString:@"familyHistory"]) {
        cellModel = self.dataManager.historyAddModel.familyHistory;
        index = self.dataManager.historyFamilyArray.count;
        BSArchiveModel *bsModel = cellModel.content.lastObject;
        bsModel.selectModel.options = [self.dataManager.dataDic objectForKey:@"gw_family_disease"];
    }
    if ([model.code isEqualToString:@"geneticHistory"]) {
        cellModel = self.dataManager.historyAddModel.geneticHistory;
        index = self.dataManager.historyHealthArray.count;
    }
//    [self insertAddCell:indexPath];
    ArchiveAddView *view = [[ArchiveAddView alloc] initWithFrame:self.bounds model:cellModel];
    view.index = -1;
    Bsky_WeakSelf;
    view.successBlock = ^(id model){
        Bsky_StrongSelf;
        if ([model isKindOfClass:[AddDiseaseModel class]] && [[model valueForKey:@"diseaseKindName"] isEqualToString:@"其他"]) {
            [self insertAddCell:indexPath withModel:model cellsModel:self.dataManager.historyAddModel.diseaseHistoryOther index:(NSUInteger )index];
        }else{
            [self insertAddCell:indexPath withModel:model cellsModel:cellModel index:(NSUInteger )index];
        }
        
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
    NSUInteger count = cellsModel.addModel.adds.count;
    if ([model isKindOfClass:[AddDiseaseModel class]] && [[model valueForKey:@"diseaseKindName"] isEqualToString:@"其他"] && count == 2) {
        ArchiveModel *newCellModel = [ArchiveModel mj_objectWithKeyValues:[self.dataManager.historyAddModel.diseaseHistoryOther mj_keyValues]];
        cellsModel.addModel.adds = newCellModel.content;
        cellsModel.code = newCellModel.code;
    }
    if ([model isKindOfClass:[AddDiseaseModel class]] && ![[model valueForKey:@"diseaseKindName"] isEqualToString:@"其他"] && count == 3) {
        ArchiveModel *newCellModel = [ArchiveModel mj_objectWithKeyValues:[self.dataManager.historyAddModel.diseaseHistory mj_keyValues]];
        cellsModel.addModel.adds = newCellModel.content;
        cellsModel.code = newCellModel.code;
    }
    for (BSArchiveModel *subCellmodel in cellsModel.addModel.adds) {
        if ([model isKindOfClass:[AddDiseaseModel class]]) {
            AddDiseaseModel *currentModel = (AddDiseaseModel *)model;
            if ([subCellmodel.code isEqualToString:@"diseaseKindId"]) {
                subCellmodel.value = currentModel.diseaseKindId;
                subCellmodel.contentStr = currentModel.diseaseKindName;
            }else if ([subCellmodel.code isEqualToString:@"remark"]){
                subCellmodel.value = currentModel.remark;
                subCellmodel.contentStr = currentModel.remark;
            }else{
                subCellmodel.value = currentModel.diagnosisDate;
                subCellmodel.contentStr = currentModel.diagnosisDate;
            }
        }
        if ([model isKindOfClass:[AddFamilyHistoryModel class]]) {
            AddFamilyHistoryModel *currentModel = (AddFamilyHistoryModel *)model;
            if ([subCellmodel.code isEqualToString:@"disease"]) {
                subCellmodel.value = currentModel.disease;
            }else if ([subCellmodel.code isEqualToString:@"relationshipType"]){
                subCellmodel.value = currentModel.relationshipType;
                subCellmodel.contentStr = currentModel.relationShipName;
            }
        }
        if ([model isKindOfClass:[AddHistoryModel class]]) {
            AddHistoryModel *currentModel = (AddHistoryModel *)model;
            if ([subCellmodel.code isEqualToString:@"name"]) {
                subCellmodel.value = currentModel.name;
                subCellmodel.contentStr = currentModel.name;
            }else{
                subCellmodel.value = currentModel.occurrenceDate;
                subCellmodel.contentStr = currentModel.occurrenceDate;
            }
        }
    }
//    cellsModel.addModel.adds = [NSMutableArray arrayWithArray:cellsModel.addModel.adds];
    [self updateCellOtherSubCell:cellsModel.addModel.adds model:model];
    [self beginUpdates];
    [self reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
    
}
- (void)insertAddCell:(NSIndexPath *)indexPath withModel:(id )model cellsModel:(ArchiveModel *)cellsModel index:(NSUInteger )index{
    
//    BSArchiveModel *model1 = [[BSArchiveModel alloc] init];
//    model1.title = @"疾病";
//    model1.contentStr = @"高血压";
//
//    BSArchiveModel *model2 = [[BSArchiveModel alloc] init];
//    model2.title = @"确证时间";
//    model2.contentStr = @"2018-01-01";
    
    BSArchiveModel *cellModel = [[BSArchiveModel alloc] init];
    cellModel.code = cellsModel.code;
    cellModel.canEdit = YES;
    cellModel.title = cellsModel.contentStr;
    cellModel.addModel = [[ArchiveAddModel alloc] init];
    cellModel.addModel.adds = [self getAddCellArray:model cellModel:cellsModel];
    cellModel.addModel.index = index;
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
            }else if ([subCellmodel.code isEqualToString:@"remark"]){
                insetModel.value = currentModel.remark;
                insetModel.contentStr = currentModel.remark;
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
        [mutableArray insertObject:model atIndex:indexPath.row];
    }
    
    [cellModel setValue:mutableArray forKey:@"content"];
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    [self beginUpdates];
    [self insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
    [self endUpdates];
}
@end
