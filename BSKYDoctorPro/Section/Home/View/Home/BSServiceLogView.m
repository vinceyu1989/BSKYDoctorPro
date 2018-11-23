//
//  BSServiceLogView.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/31.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSServiceLogView.h"
#import "BSServiceLogCell.h"

@interface BSServiceLogView () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation BSServiceLogView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        
        self.tableView = ({
            UITableView* tableView = [UITableView new];
            [self addSubview:tableView];
            tableView.tableFooterView = [UIView new];
            tableView.sectionIndexColor = UIColorFromRGB(0x333333);
            tableView.sectionIndexBackgroundColor = [UIColor clearColor];
            tableView.separatorColor = UIColorFromRGB(0xededed);
            tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            [tableView registerNib:[UINib nibWithNibName:@"BSServiceLogCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BSServiceLogCell"];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView;
        });
        
        [self setupFrame];

    }
    
    return self;
}

#pragma mark -

- (void)setupFrame {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource numberOfserviceLogInView:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSServiceLogCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BSServiceLogCell"];
    BSServiceLog* model = [self.dataSource servieLogForIndex:indexPath.section];
    cell.serviceLog = model;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
