//
//  BSCalendarView.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSCalendarView.h"
#import "JTCalendar.h"
#import "FollowupMonthCountModel.h"

@class BSMenuItemView;

@interface BSCalendarView () <JTCalendarDelegate>

@property (nonatomic, retain) JTCalendarMenuView *menuView;
@property (nonatomic, retain) JTHorizontalCalendarView *calendar;
@property (nonatomic, retain) JTCalendarManager *calendarManager;

@property (nonatomic, retain) NSDate *todayDate;
@property (nonatomic, retain) NSDate *minDate;
@property (nonatomic, retain) NSDate *maxDate;
@property (nonatomic, retain) NSDate *selectedDate;

@end

@implementation BSCalendarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        
        self.menuView = ({
            JTCalendarMenuView* menuView = [JTCalendarMenuView new];
            [self addSubview:menuView];
            
            menuView;
        });
        self.calendar = ({
            JTHorizontalCalendarView* calender = [JTHorizontalCalendarView new];
            [self addSubview:calender];
            
            calender;
        });
        
        self.calendarManager = ({
            JTCalendarManager* calendarManager = [JTCalendarManager new];
            calendarManager.delegate = self;
            
            [calendarManager setContentView:self.calendar];
            [calendarManager setMenuView:self.menuView];
            
            calendarManager;
        });
        self.todayDate = [NSDate date];
        self.minDate = [self.calendarManager.dateHelper addToDate:self.todayDate months:-12];
        self.maxDate = [self.calendarManager.dateHelper addToDate:self.todayDate months:12];
        [self.calendarManager setDate:self.todayDate];
        
        [self setupFrame];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.layer.borderWidth = .5f;
        self.layer.borderColor = UIColorFromRGB(0xededed).CGColor;
        
        self.menuView = ({
            JTCalendarMenuView* menuView = [JTCalendarMenuView new];
            [self addSubview:menuView];
            
            menuView;
        });
        self.calendar = ({
            JTHorizontalCalendarView* calender = [JTHorizontalCalendarView new];
            [self addSubview:calender];
            
            calender;
        });
        
        self.calendarManager = ({
            JTCalendarManager* calendarManager = [JTCalendarManager new];
            calendarManager.delegate = self;
            
            [calendarManager setContentView:self.calendar];
            [calendarManager setMenuView:self.menuView];
            
            calendarManager;
        });
        self.todayDate = [NSDate date];
        self.minDate = [self.calendarManager.dateHelper addToDate:self.todayDate months:-12];
        self.maxDate = [self.calendarManager.dateHelper addToDate:self.todayDate months:12];
        [self.calendarManager setDate:self.todayDate];
        
        [self setupFrame];
    }
    
    return self;
}

- (void)reloadData {
    [self.calendarManager reload];
}

#pragma mark -

- (void)setupFrame {
    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@50);
    }];
    [self.calendar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 0, 10, 0));
    }];
}

- (FollowupMonthCountModel *)haveEventForDay:(NSDate *)date {
    
    NSString *key = [[NSDateFormatter eventDateFormatter] stringFromDate:date];
    
    for (FollowupMonthCountModel *countModel in self.eventsByDate) {
        if ([countModel.day isEqualToString:key]) {
            return countModel;
        }
    }
    return nil;
}

#pragma mark - JTCalendarDelegate
- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar
{
    Bsky_WeakSelf
    BSMenuItemView *menuItemView = [[BSMenuItemView alloc]init];
    menuItemView.leftBlock = ^{
        [calendar.scrollManager updateHorizontalContentOffset:0];
    };
    menuItemView.rightBlock = ^{
        Bsky_StrongSelf
        [calendar.scrollManager updateHorizontalContentOffset:(2 * self.menuView.scrollView.bounds.size.width / self.menuView.scrollView.contentSize.width)];
    };
    return  menuItemView;
}

-(void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UIView *)menuItemView date:(NSDate *)date
{
    NSString *text = nil;
    
    if(date){
        NSDateComponents *comps = [calendar.dateHelper.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        NSInteger currentMonthIndex = comps.month;
        
        static NSDateFormatter *dateFormatter = nil;
        if(!dateFormatter){
            dateFormatter = [calendar.dateHelper createDateFormatter];
        }
        
        dateFormatter.timeZone = calendar.dateHelper.calendar.timeZone;
        dateFormatter.locale = calendar.dateHelper.calendar.locale;
        
        while(currentMonthIndex <= 0){
            currentMonthIndex += 12;
        }
        
        text = [NSString stringWithFormat:@"%ld年%ld月", comps.year, comps.month];
    }
    
    BSMenuItemView* view = (BSMenuItemView *)menuItemView;
    view.label.text = text;
}
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date {
    return [self.calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = UIColorFromRGB(0x599dff);
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:self.calendar.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Selected date
    else if(self.selectedDate && [_calendarManager.dateHelper date:self.selectedDate isTheSameDayThan:dayView.date]){
        dayView.circleView.backgroundColor = UIColorFromRGB(0xededed);
        if ([self haveEventForDay:self.selectedDate]) {
            dayView.circleView.hidden = NO;
            dayView.textLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            dayView.circleView.hidden = YES;
            dayView.textLabel.textColor = [UIColor blackColor];
        }
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    FollowupMonthCountModel *countModel = [self haveEventForDay:dayView.date];
    if (countModel) {
//        if ([self.calendarManager.dateHelper date:dayView.date isEqualOrAfter:self.todayDate]) {
            dayView.dotView.badgeValue = countModel.count;
        if (countModel.count == countModel.standard) {
            dayView.dotView.backgroundColor = UIColorFromRGB(0x64da88);
        }
        else
        {
            dayView.dotView.backgroundColor = [UIColor redColor];
        }
//        }else {
//            dayView.dotView.warning = YES;
//        }
    }else {
        dayView.dotView.warning = NO;
        dayView.dotView.badgeValue = -1;
  }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    self.selectedDate = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    dayView.circleView.hidden = NO;
    dayView.circleView.backgroundColor = UIColorFromRGB(0xededed);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                    } completion:^(BOOL finished){
                        [_calendarManager reload];
                    }];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![self.calendarManager.dateHelper date:self.calendar.date isTheSameMonthThan:dayView.date]){
        if([self.calendar.date compare:dayView.date] == NSOrderedAscending){
            [self.calendar loadNextPageWithAnimation];
        }
        else{
            [self.calendar loadPreviousPageWithAnimation];
        }
    }
    
    // delegate
    if ([self.delegate respondsToSelector:@selector(calender:didTouchDay:)]) {
        if ([self haveEventForDay:self.selectedDate]) {
            [self.delegate calender:self didTouchDay:self.selectedDate];
        }
    }
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar {
    [self changeMonth:calendar.date];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar {
    [self changeMonth:calendar.date];
}

- (void)changeMonth:(NSDate*) date{
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString* month = [[NSDateFormatter monthFormatter] stringFromDate:date];
        if ([weakSelf.delegate respondsToSelector:@selector(calender:didChangeMonth:)]) {
            [weakSelf.delegate calender:weakSelf didChangeMonth:month];
        }
    });
}
@end

@interface BSMenuItemView ()

@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *rightButton;

@end

@implementation BSMenuItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = ({
            UILabel *label = [UILabel new];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:17];
            label.textColor = [UIColor blackColor];
            [self addSubview:label];
            
            label;
        });
        self.leftButton = ({
            UIButton* button = [UIButton new];
            [button setImage:[UIImage imageNamed:@"<"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onLeft:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            button;
        });
        self.rightButton = ({
            UIButton* button = [UIButton new];
            [button setImage:[UIImage imageNamed:@">"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onRight:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            button;
        });
        
        [self setupFrame];
    }
    
    return self;
}

-(void)setupFrame {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.right.equalTo(self.label.mas_left).offset(-15);
        make.width.equalTo(@50);
        make.centerY.equalTo(self);
    }];
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.equalTo(self.label.mas_right).offset(15);
        make.width.equalTo(@50);
        make.centerY.equalTo(self);
    }];
}

#pragma mark -

- (void)onLeft:(id)sender {
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)onRight:(id)sender {
    if (self.rightBlock) {
        self.rightBlock();
    }
}

@end
