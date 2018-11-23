//
//  AuxiliaryCheckVC.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "AuxiliaryCheckVC.h"
#import "AuxiliaryCheckSectionCell.h"
#import "AuxiliaryCheckTextFieldCell.h"
#import "AuxiliaryCheckSelectCell.h"
#import "AuxiliaryCheckSectionModel.h"

@interface AuxiliaryCheckVC ()<AuxiliaryCheckSectionCellDelegate,AuxiliaryCheckTextFieldCellDelegate,AuxiliaryCheckSelectCellDelegate>

@property (nonatomic ,strong) NSMutableArray *sectionArray;

@property (nonatomic ,strong) AuxiliaryCheckSectionModel *prevModel;

@end

@implementation AuxiliaryCheckVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isTang = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"辅助检查";
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.tableView registerNib:[AuxiliaryCheckSectionCell nib] forCellReuseIdentifier:[AuxiliaryCheckSectionCell cellIdentifier]];
    [self.tableView registerNib:[AuxiliaryCheckTextFieldCell nib] forCellReuseIdentifier:[AuxiliaryCheckTextFieldCell cellIdentifier]];
    [self.tableView registerClass:[AuxiliaryCheckSelectCell class] forCellReuseIdentifier:[AuxiliaryCheckSelectCell cellIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (NSMutableArray *)sectionArray
{
    if (!_sectionArray) {
        
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AuxiliaryCheckSectionModel" ofType:@"json"]];
        NSArray *allda = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
        _sectionArray = [AuxiliaryCheckSectionModel mj_objectArrayWithKeyValuesArray:allda];
        if (!self.isTang) {
            [_sectionArray removeObjectAtIndex:11];
        }
    }
    return _sectionArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    AuxiliaryCheckSectionModel *model = self.sectionArray[section];
    
    if ( !model.isExpansion) {
        
        return 1;
    }
    
    if (model.type == 2) {
        
        return 2;
    }
    
    return model.data.count+1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AuxiliaryCheckSectionModel *model = self.sectionArray[indexPath.section];
    if (indexPath.row == 0) {
        AuxiliaryCheckSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:[AuxiliaryCheckSectionCell cellIdentifier] forIndexPath:indexPath];
        cell.model = model;
        if (!cell.delegate) {
            cell.delegate = self;
        }
        return cell;
    }
    else if(model.type == 1)
    {
        AuxiliaryCheckTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[AuxiliaryCheckTextFieldCell cellIdentifier] forIndexPath:indexPath];
        
        cell.upModel = self.upModel;
        AuxiliaryCheckRowModel *rowModel = model.data[indexPath.row -1];
        cell.rowModel = rowModel;
        if (!cell.delegate) {
            cell.delegate = self;
        }
        return cell;
    }
    else
    {
        AuxiliaryCheckSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:[AuxiliaryCheckSelectCell cellIdentifier] forIndexPath:indexPath];
        cell.upModel = self.upModel;
        cell.model = model;
        if (!cell.delegate) {
            cell.delegate = self;
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AuxiliaryCheckSectionCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        [self.tableView beginUpdates];
        
        AuxiliaryCheckSectionModel *model = self.sectionArray[indexPath.section];
        
        model.isExpansion = !model.isExpansion;
        
        [self updateSection:indexPath.section model:model];
        
        if (self.prevModel && self.prevModel.isExpansion && self.prevModel != model) {
            
            NSInteger prevSection = [self.sectionArray indexOfObject:self.prevModel];
            
            self.prevModel.isExpansion = NO;
            
            [self updateSection:prevSection model:self.prevModel];
        }
        [self.tableView endUpdates];
        
        self.prevModel = model;
    }
}
#pragma mark ---- UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)updateSection:(NSInteger)section model:(AuxiliaryCheckSectionModel *)model
{
    
    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
    
    [self.tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    AuxiliaryCheckSectionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectIcon.image = model.isExpansion ? [UIImage imageNamed:@"收起"] : [UIImage imageNamed:@"展开"];
}
#pragma mark ----- AuxiliaryCheckSectionCellDelegate

- (void)auxiliaryCheckSectionCell:(AuxiliaryCheckSectionCell *)cell select:(BOOL)isSelect
{
    
}
#pragma mark ----- AuxiliaryCheckTextFieldCellDelegate

- (void)auxiliaryCheckTextFieldCell:(AuxiliaryCheckTextFieldCell *)cell inputString:(NSString *)string
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AuxiliaryCheckSectionModel *model = self.sectionArray[indexPath.section];
    
    BOOL isEmpty = YES;
    for (AuxiliaryCheckRowModel *rowModel in model.data) {
        if ([rowModel.content isNotEmptyString]) {
            isEmpty = NO;
            break;
        }
    }
    if (model.isEmpty != isEmpty) {
        model.isEmpty = isEmpty;
        NSIndexPath *sectionIndexPtah = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[sectionIndexPtah] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
}
#pragma mark ----- AuxiliaryCheckSelectCellDelegate

- (void)auxiliaryCheckSelectCell:(AuxiliaryCheckSelectCell *)cell selectIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AuxiliaryCheckSectionModel *model = self.sectionArray[indexPath.section];
    model.isEmpty = index < 0 ? YES : NO;

    NSIndexPath *sectionIndexPtah = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[sectionIndexPtah] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
