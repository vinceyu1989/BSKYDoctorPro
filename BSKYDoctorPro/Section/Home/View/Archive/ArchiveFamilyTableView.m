//
//  ArchiveFamilyTableView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/16.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveFamilyTableView.h"
#import "ArchivePickerTableViewCell.h"
#import "AllFormsSelectTableViewCell.h"
#import "ArchiveDivisionModel.h"

@interface ArchiveFamilyTableView ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic ,strong) NSArray *sectionTitleArray;

@end

@implementation ArchiveFamilyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withModel:(ArchiveFamilyDataManager *)model
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
- (BSArchiveModel *)getArchiveModelWithIndexPath:(NSIndexPath *)indexPath{
    BSArchiveModel *model = nil;
    
    model = [self.dataManager.familyUIdata.content objectAtIndex:indexPath.row];
    
    return model;
}
- (UITableViewCell *)creatTableViewCellWithindexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
        
        BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
        if (model.type == ArchiveModelTypeCustomPicker || model.type == ArchiveModelTypeDatePicker || model.type == ArchiveModelTypeTextField || model.type == ArchiveModelTypeLabel || model.type == ArchiveModelTypeControllerPicker || model.type == ArchiveModelTypeCustomOptionsPicker) {
            cell = [self dequeueReusableCellWithIdentifier:[ArchivePickerTableViewCell cellIdentifier] forIndexPath:indexPath];
            ArchivePickerTableViewCell *tableCell = (ArchivePickerTableViewCell *)cell;
            tableCell.model = model;
            if ([model.code isEqualToString:@"RegionID"]) {
                Bsky_WeakSelf;
                tableCell.endBlock = ^(id model){
                    Bsky_StrongSelf;
                    [self reloadAddressCellWithModel:(ArchiveDivisionModel *)model indexPath:indexPath];
                    
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
- (void)reloadAddressCellWithModel:(ArchiveDivisionModel *)model indexPath:(NSIndexPath *)indexPath{
    if (![model isKindOfClass:[ArchiveDivisionModel class]]) {
        return;
    }
    NSIndexPath *addressIndex = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    BSArchiveModel *uiModel = [self getArchiveModelWithIndexPath:addressIndex];
    NSString *resultStr = [model.divisionFullName stringByReplacingOccurrencesOfString:@">" withString:@""];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    uiModel.contentStr = resultStr;
    uiModel.value = resultStr;
    [ArchiveFamilyDataManager dataManager].regionCode = model.divisionCode;
    [self beginUpdates];
    [self reloadRowAtIndexPath:addressIndex withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}
#pragma mark talbeView Delegate && Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self creatTableViewCellWithindexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataManager.familyUIdata.content count];
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
