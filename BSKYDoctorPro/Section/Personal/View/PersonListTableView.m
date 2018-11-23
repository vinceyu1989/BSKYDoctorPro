//
//  PersonListTableView.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/15.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "PersonListTableView.h"
#import "PersonListTableViewCell.h"

@interface PersonListTableView() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@end

@implementation PersonListTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self setSeparatorColor:UIColorFromRGB(0xededed)];
        self.tableFooterView = [UIView new];
        self.listArray = [NSMutableArray array];
        self.nameArray = [NSMutableArray array];
    }
    return self;
}

- (void)setIsAudit:(BOOL)isAudit {
    _isAudit = isAudit;
    NSInteger sysType = [BSAppManager sharedInstance].currentUser.sysType.integerValue;
    NSString *accountTiTle = @"工作账号";
    switch (sysType) {
        case InterfaceServerTypeScwjw:
            accountTiTle = @"公卫账号";
            break;
        case InterfaceServerTypeSczl:
            accountTiTle = @"中联账号";
            break;
        case InterfaceServerTypeSchc:
            accountTiTle = @"航创账号";
            break;
        default:
            break;
    }
    if (isAudit) {
        self.listArray = [NSMutableArray arrayWithArray:@[@"gongwei",@"setting"]];
        self.nameArray = [NSMutableArray arrayWithArray:@[accountTiTle,@"设置"]];
    } else {
        self.listArray = [NSMutableArray arrayWithArray:@[@"my_income",@"my_order",@"prescription",@"gongwei",@"setting"]];
        self.nameArray = [NSMutableArray arrayWithArray:@[@"我的收入",@"我的订单",@"电子处方",accountTiTle,@"设置"]];
    }
    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PersonListTableViewCell"];
    if (!cell) {
        cell = [[PersonListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonListTableViewCell"];
        
    }
    cell.headImage.image = [UIImage imageNamed:self.listArray[indexPath.row]];
    cell.titleLabel.text = self.nameArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.myDelegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.myDelegate didSelectedIndex:indexPath.row];
    }
}

@end
