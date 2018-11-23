//
//  ResidentRefreshCell.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/20.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentRefreshCell.h"

@implementation ResidentRefreshCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}
- (void)initView
{
    if (!self.refreshView) {
        self.refreshView = [[ResidentRefreshView alloc]init];
        self.refreshView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.refreshView];
        [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}
- (void)setRefreshStatus:(ResidentRefreshStatus)refreshStatus
{
    _refreshStatus = refreshStatus;
    switch (_refreshStatus) {
        case ResidentRefreshStatusRuning:
            self.refreshView.hidden = NO;
            [self.refreshView startRefresh];
            break;
        case ResidentRefreshStatusFailure:
            self.refreshView.hidden = NO;
            [self.refreshView stopRefresh];
            break;
        case ResidentRefreshStatusSuccess:
            [self.refreshView stopRefresh];
            self.refreshView.hidden = YES;
            break;
        default:
            break;
    }
}

@end
