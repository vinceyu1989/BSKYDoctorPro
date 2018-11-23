//
//  OrganTableView.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "OrganTableView.h"

static NSString *identifier = @"OrganTableViewIdentifier";

@interface OrganTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation OrganTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.isBackground = NO;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.highlightedTextColor = [UIColor colorWithHexString:@"#4e7dd3"];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.numberOfLines = 0;
    }
    if (self.isBackground) {
        cell.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    }
    DivisionCodeModel *mode = _tableData[indexPath.row];
    cell.textLabel.text = mode.divisionName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DivisionCodeModel *mode = _tableData[indexPath.row];
    if ([self.myDelegate respondsToSelector:@selector(didSelectedTabelView:WithModel:Index:)]) {
        [self.myDelegate didSelectedTabelView:self WithModel:mode Index:indexPath.row];
    }
}

- (void)selectedToFirst {
//    NSIndexPath * selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
//    NSIndexPath * path = [NSIndexPath indexPathForItem:0 inSection:0];
//    [self tableView:self didSelectRowAtIndexPath:path];
}

- (void)setTableData:(NSMutableArray *)tableData {
    _tableData = tableData;
    [self reloadData];
}

@end
