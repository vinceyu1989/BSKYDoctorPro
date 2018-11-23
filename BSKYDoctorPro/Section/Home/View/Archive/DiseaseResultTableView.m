//
//  DiseaseResultTableView.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "DiseaseResultTableView.h"
#import "DiseaseCell.h"
#import "ZLDiseaseModel.h"

@interface DiseaseResultTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DiseaseResultTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initilationUI];
    }
    return self;
}
- (void)initilationUI{
    self.dataSource = self;
    self.delegate = self;
    [self registerNib:[DiseaseCell nib] forCellReuseIdentifier:[DiseaseCell cellIdentifier]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}
#pragma mark TableDelegate & TableDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiseaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DiseaseCell cellIdentifier]];
    if (indexPath.row) {
        ZLDiseaseModel *model =  [self.dataArray objectAtIndex:indexPath.row - 1];
        cell.model =model;
    }else{
        cell.model = nil;
    }
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger )numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count] + 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row && self.selectBlock) {
        self.selectBlock([NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
@end
