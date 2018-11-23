//
//  ArchiveDiseaseTableView.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveDiseaseTableView.h"
#import "ArchivePickerTableViewCell.h"
#import "AllFormsSelectTableViewCell.h"
#import "ArchiveDivisionModel.h"
#import "SignResidentInfoModel.h"

@interface ArchiveDiseaseTableView ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic ,strong) NSArray *sectionTitleArray;

@end

@implementation ArchiveDiseaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withModel:(ArchiveDiseaseDataManager *)model
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
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerNib:[ArchivePickerTableViewCell nib] forCellReuseIdentifier:[ArchivePickerTableViewCell cellIdentifier]];
    [self registerClass:[AllFormsSelectTableViewCell class] forCellReuseIdentifier:[AllFormsSelectTableViewCell cellIdentifier]];
}
- (BSArchiveModel *)getModelWithIndexPath:(NSIndexPath *)indexPath{
    BSArchiveModel *model = nil;
    
    model = [self.dataManager.diseaseUIdata.content objectAtIndex:indexPath.row];
    
    return model;
}
- (UITableViewCell *)creatTableViewCellWithindexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    BSArchiveModel *model = [self getModelWithIndexPath:indexPath];
    if (model.type == ArchiveModelTypeCustomPicker || model.type == ArchiveModelTypeDatePicker || model.type == ArchiveModelTypeTextField || model.type == ArchiveModelTypeLabel || model.type == ArchiveModelTypeControllerPicker || model.type == ArchiveModelTypeCustomOptionsPicker) {
        cell = [self dequeueReusableCellWithIdentifier:[ArchivePickerTableViewCell cellIdentifier] forIndexPath:indexPath];
        ArchivePickerTableViewCell *tableCell = (ArchivePickerTableViewCell *)cell;
        tableCell.model = model;
        if ([model.code isEqualToString:@"personID"]) {
            Bsky_WeakSelf;
            tableCell.endBlock = ^(id model){
                Bsky_StrongSelf;
                [self reloadPersonInfoCellWithModel:(id )model indexPath:indexPath];
                
            };
        }else{
            tableCell.endBlock = nil;
        }
    }
    if (model.type == ArchiveModelTypeSlectAndTextView || model.type == ArchiveModelTypeSelect) {
        cell = [self dequeueReusableCellWithIdentifier:[AllFormsSelectTableViewCell cellIdentifier] forIndexPath:indexPath];
        AllFormsSelectTableViewCell *tableCell = (AllFormsSelectTableViewCell *)cell;
        tableCell.model = model;
    }
    if (!cell) {
        cell = [self dequeueReusableCellWithIdentifier:@"123"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        }
    }
    
    
    return cell;
}
- (void)reloadPersonInfoCellWithModel:(SignResidentInfoModel *)model indexPath:(NSIndexPath *)indexPath{
    if (![model isKindOfClass:[SignResidentInfoModel class]]) {
        return;
    }
    NSIndexPath *genderIndex = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    NSIndexPath *cardIdIndex = [NSIndexPath indexPathForRow:indexPath.row+2 inSection:indexPath.section];
    BSArchiveModel *genderModel = [self getModelWithIndexPath:genderIndex];
    BSArchiveModel *cardIdModel = [self getModelWithIndexPath:cardIdIndex];
    NSString *gender = model.sex;
    if (model.idcard.length) {
        cardIdModel.contentStr = cardIdModel.value = [model.idcard secretStrFromIdentityCard];
        gender = [cardIdModel.contentStr sexStrFromIdentityCard];
        if (gender.length) {
            if ([gender isEqualToString:@"1"]) {
                gender = @"男";
            }else if([gender isEqualToString:@"2"]){
                gender = @"女";
            }
        }
    }
    genderModel.contentStr = genderModel.value = gender;
//    [ArchiveFamilyDataManager dataManager].regionCode = model.divisionCode;
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:genderIndex,cardIdIndex, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}
#pragma mark talbeView Delegate && Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self creatTableViewCellWithindexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataManager.diseaseUIdata.content count];
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 124;
//}
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

@end
