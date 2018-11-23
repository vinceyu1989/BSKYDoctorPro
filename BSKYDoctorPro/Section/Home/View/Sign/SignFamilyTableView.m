//
//  SignFamilyTableView.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "SignFamilyTableView.h"
#import "SignFamilyPersonCell.h"

@class SignFamilyArchiveModel;
@interface SignFamilyTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *footView;

@end

@implementation SignFamilyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.estimatedRowHeight = 140;
        self.rowHeight = UITableViewAutomaticDimension;
        self.tableData = [NSMutableArray array];
        [self registerNib:[SignFamilyPersonCell nib] forCellReuseIdentifier:[SignFamilyPersonCell cellIdentifier]];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SignFamilyPersonCell cellIdentifier] forIndexPath:indexPath];
    if (self.tableData.count!=0) {
        SignFamilyPersonCell *tableCell = (SignFamilyPersonCell *)cell;
        tableCell.model = (SignFamilyArchiveModel *)self.tableData[indexPath.section];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(didSelectedFamilyCellWithIndex:)]) {
        [self.myDelegate didSelectedFamilyCellWithIndex:indexPath.section];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!self.footView) { 
        self.footView = [UIView new];
    }
    return self.footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)setTableData:(NSMutableArray *)tableData {
    _tableData = tableData;
}

@end
