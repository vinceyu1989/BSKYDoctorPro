//
//  BSFollowupPlanCell.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowupPlanCell.h"
#import "BSCalendarView.h"

@interface BSFollowupPlanCell ()<BSCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *overLabel;
@property (weak, nonatomic) IBOutlet BSCalendarView *calendarView;

@end

@implementation BSFollowupPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"逾期随访"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    self.overLabel.attributedText = str;
    
    UITapGestureRecognizer* tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.overLabel addGestureRecognizer:tapGr];
    self.overLabel.userInteractionEnabled = YES;
    
    self.calendarView.delegate = self;
}
- (void)setEventsByDayList:(NSArray *)eventsByDayList
{
    _eventsByDayList = eventsByDayList;
    self.calendarView.eventsByDate = _eventsByDayList;
    [self.calendarView reloadData];
}
#pragma mark - UI Actions

- (void)onTap:(id)sender {
    if (self.overBlock) {
        self.overBlock();
    }
}
#pragma mark - BSCalendarViewDelegate

- (void)calender:(BSCalendarView*)calendar didTouchDay:(NSDate*)date {
    if (self.dateTouchBlock) {
        self.dateTouchBlock(date);
    }
}

- (void)calender:(BSCalendarView*)calender didChangeMonth:(NSString*)month {
    if (self.monthChangeBlock) {
        self.monthChangeBlock(month);
    }
}
@end
