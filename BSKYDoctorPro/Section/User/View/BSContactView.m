//
//  BSContactView.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSContactView.h"
#import "BSContactCell.h"

@interface BSContactView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@end

@implementation BSContactView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = ({
            UITableView* tableView = [UITableView new];
            [self addSubview:tableView];
            tableView.tableFooterView = [UIView new];
            tableView.sectionIndexColor = UIColorFromRGB(0x333333);
            tableView.sectionIndexBackgroundColor = [UIColor clearColor];
            tableView.separatorColor = UIColorFromRGB(0xededed);
            
            [tableView registerNib:[UINib nibWithNibName:@"BSContactCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BSContactCell"];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView;
        });
        
        [self setupFrame];
    }
    return self;
}

#pragma mark -

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)setupFrame {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource numberOfSectionsInView:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource contactView:self numberOfContactInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSContactCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BSContactCell"];
    cell.user = (NIMUser *)[self.dataSource  contactView:self contactForSection:indexPath.section index:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = ({
        UIView* view = [UIView new];
        view.backgroundColor = UIColorFromRGB(0xf7f7f7);
        
        UILabel* label = [UILabel new];
        [view addSubview:label];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:10];
        label.text = [self.dataSource contactView:self titleForSection:section];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view.mas_left).offset(10);
        }];
        
        view;
    });
    
    return view;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataSource contactView:self titleForSection:section];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.dataSource sectionIndexTitlesForContactView:self];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.delegate didSelectRowAtIndexPath:indexPath];
    }
}

@end
