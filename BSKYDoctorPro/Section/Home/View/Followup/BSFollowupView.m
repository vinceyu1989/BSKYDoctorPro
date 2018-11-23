//
//  BSFollowupView.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowupView.h"
#import "BSFollowupCreatorCell.h"
#import "BSFollowupPlanCell.h"
#import "BSCalendarView.h"

@interface BSFollowupView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BSFollowupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = ({
            UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            [self addSubview:tableView];
            tableView.tableFooterView = [UIView new];
            tableView.sectionIndexColor = UIColorFromRGB(0x333333);
            tableView.sectionIndexBackgroundColor = [UIColor clearColor];
            tableView.separatorColor = UIColorFromRGB(0xededed);
            tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            [tableView registerNib:[UINib nibWithNibName:@"BSFollowupPlanCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BSFollowupPlanCell"];
            [tableView registerNib:[UINib nibWithNibName:@"BSFollowupCreatorCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BSFollowupCreatorCell"];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView;
        });
        [self setupFrame];
    }
    
    return self;
}

- (void)reloadData {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BSFollowupPlanCell* cell = (BSFollowupPlanCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(eventsByDayWithView:)]) {
        cell.eventsByDayList = [self.dataSource eventsByDayWithView:self];
    }
}
#pragma mark -

- (void)setupFrame {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Bsky_WeakSelf;
    if (indexPath.section == 0) {
        BSFollowupPlanCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BSFollowupPlanCell" forIndexPath:indexPath];
        [cell setOverBlock:^{
            Bsky_StrongSelf;
            if ([self.delegate respondsToSelector:@selector(didTouchOverFollowup)]) {
                [self.delegate didTouchOverFollowup];
            }
        }];
        [cell setDateTouchBlock:^(NSDate* date){
            Bsky_StrongSelf;
            if ([self.delegate respondsToSelector:@selector(didTouchForDate:)]) {
                [self.delegate didTouchForDate:date];
            }
        }];
        [cell setMonthChangeBlock:^(NSString* month){
            Bsky_StrongSelf;
            if ([self.delegate respondsToSelector:@selector(didChangeMonth:)]) {
                [self.delegate didChangeMonth:month];
            }
        }];
        return cell;
    }
    
    BSFollowupCreatorCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BSFollowupCreatorCell" forIndexPath:indexPath];
    [cell setDiabetesBlock:^{
        Bsky_StrongSelf;
        if ([self.delegate respondsToSelector:@selector(didTouchCreateDiabetesFollowup)]) {
            [self.delegate didTouchCreateDiabetesFollowup];
        }
    }];
    [cell setHypertensionBlock:^{
        Bsky_StrongSelf;
        if ([self.delegate respondsToSelector:@selector(didTouchCreateHypertensionFollowup)]) {
            [self.delegate didTouchCreateHypertensionFollowup];
        }
    }];
    [cell setHighGlucoseBlock:^{
        Bsky_StrongSelf;
        if ([self.delegate respondsToSelector:@selector(didTouchCreateHighGlucoseFollowup)]) {
            [self.delegate didTouchCreateHighGlucoseFollowup];
        }
    }];
    [cell setMentalDiseaseBlock:^{
        Bsky_StrongSelf;
        if ([self.delegate respondsToSelector:@selector(didTouchCreateMentalDiseaseFollowup)]) {
            [self.delegate didTouchCreateMentalDiseaseFollowup];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 405;
    }
    return 200;
}

@end
