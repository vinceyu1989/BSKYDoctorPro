//
//  ArchiveBSInfoTableView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/4.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveBSInfoTableView.h"
#import "AllFormsSelectOnlineCell.h"
#import "AllFormsSelectTableViewCell.h"
#import "AllFormsSectionCell.h"
#import "AllFormsInputTextCell.h"
#import "ArchivePickerTableViewCell.h"
#import "BSimagePickerCell.h"
#import "ArchiveCardRequest.h"

@interface ArchiveBSInfoTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSArray *sectionTitleArray;

@end

@implementation ArchiveBSInfoTableView
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
    self.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerNib:[AllFormsSectionCell nib] forCellReuseIdentifier:[AllFormsSectionCell cellIdentifier]];
    [self registerNib:[ArchivePickerTableViewCell nib] forCellReuseIdentifier:[ArchivePickerTableViewCell cellIdentifier]];
    [self registerClass:[AllFormsSelectTableViewCell class] forCellReuseIdentifier:[AllFormsSelectTableViewCell cellIdentifier]];
    [self registerClass:[AllFormsSelectOnlineCell class] forCellReuseIdentifier:[AllFormsSelectOnlineCell cellIdentifier]];
    [self registerNib:[BSimagePickerCell nib] forCellReuseIdentifier:[BSimagePickerCell cellIdentifier]];
}
//验证身份证
- (void )checkCard:(BSArchiveModel *)card indexPath:(NSIndexPath *)indexPath{
    if (!card.contentStr.isIdCard) {
        [self reloadBirthDayAndGenderCellWith:card indexPath:indexPath right:NO];
        [UIView makeToast:@"请输入有效的证件号!"];
        return;
    }
    ArchiveCardRequest *request = [[ArchiveCardRequest alloc] init];
    request.card = card.value;
    [MBProgressHUD showHud];
    __weak typeof(BSArchiveModel *) usrCard = card;
    Bsky_WeakSelf;
    [request startWithCompletionBlockWithSuccess:^(__kindof ArchiveCardRequest * _Nonnull request) {
        Bsky_StrongSelf;
        [MBProgressHUD hideHud];
        if (![request.ret boolValue]) {
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
        
        _sectionTitleArray = @[self.dataManager.dataModel.baseInfo.contentStr,self.dataManager.dataModel.relateInfo.contentStr,self.dataManager.dataModel.medicalHistoryInfo.contentStr,self.dataManager.dataModel.environment.contentStr];
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
        cell = [self dequeueReusableCellWithIdentifier:[AllFormsSectionCell cellIdentifier] forIndexPath:indexPath];
        AllFormsSectionCell *tableCell = (AllFormsSectionCell *)cell;
        tableCell.upModel = [[FollowupUpModel alloc] init];
        tableCell.titleStr = self.sectionTitleArray[indexPath.section];
        tableCell.clickImageView.hidden = YES;
    }else{
        
        BSArchiveModel *model = [self getArchiveModelWithIndexPath:indexPath];
        if (model.type == ArchiveModelTypeCustomPicker || model.type == ArchiveModelTypeDatePicker || model.type == ArchiveModelTypeTextField || model.type == ArchiveModelTypeLabel || model.type == ArchiveModelTypeControllerPicker) {
            cell = [self dequeueReusableCellWithIdentifier:[ArchivePickerTableViewCell cellIdentifier] forIndexPath:indexPath];
            ArchivePickerTableViewCell *tableCell = (ArchivePickerTableViewCell *)cell;
            
            tableCell.model = model;
            
            if (model.type == ArchiveModelTypeTextField && [model.code isEqualToString:@"CardID"]) {
                Bsky_WeakSelf;
                tableCell.endBlock = ^(id model){
                    Bsky_StrongSelf;
                    [self checkCard:model indexPath:indexPath];
                    
                };
            }else{
                tableCell.endBlock = nil;
            }
        }
        if (model.type == ArchiveModelTypeSlectAndTextView || model.type == ArchiveModelTypeSelect) {
            cell = [self dequeueReusableCellWithIdentifier:[AllFormsSelectTableViewCell cellIdentifier] forIndexPath:indexPath];
            AllFormsSelectTableViewCell *tableCell = (AllFormsSelectTableViewCell *)cell;
            if (model.type == ArchiveModelTypeSlectAndTextView) {
                tableCell.isCollapsible = YES;
                Bsky_WeakSelf;
                tableCell.reloadLayout = ^(UITableViewCell *senderCell){
                    Bsky_StrongSelf;
                    [self reloadData];
                };
            }else{
                tableCell.isCollapsible = NO;
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
    indexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:indexPath.section];
    switch (indexPath.section) {
        case 0:
        {
            model = [self.dataManager.dataModel.baseInfo.content objectAtIndex:indexPath.row];
        }
            break;
        case 1:
        {
            model = [self.dataManager.dataModel.relateInfo.content objectAtIndex:indexPath.row];
        }
            break;
        case 2:
        {
            model = [self.dataManager.dataModel.medicalHistoryInfo.content objectAtIndex:indexPath.row];
        }
            break;
        case 3:
        {
            model = [self.dataManager.dataModel.environment.content objectAtIndex:indexPath.row];
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
            count = [self.dataManager.dataModel.baseInfo.content count];
            break;
        case 1:
            count = [self.dataManager.dataModel.relateInfo.content count];
            break;
        case 2:
            count = [self.dataManager.dataModel.medicalHistoryInfo.content count];
            break;
        case 3:
            count = [self.dataManager.dataModel.environment.content count];
            break;
        default:
            return 0;
            break;
    }
    if (count) {
        count ++;
    }
    return count;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
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
@end
