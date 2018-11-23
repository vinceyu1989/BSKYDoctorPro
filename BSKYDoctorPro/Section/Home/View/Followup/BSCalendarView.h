//
//  BSCalendarView.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSCalendarView;

@protocol BSCalendarViewDelegate <NSObject>

@optional
- (void)calender:(BSCalendarView*)calendar didTouchDay:(NSDate*)date;
- (void)calender:(BSCalendarView*)calender didChangeMonth:(NSString*)month;

@end

@interface BSCalendarView : UIView

@property (nonatomic, weak) id<BSCalendarViewDelegate> delegate;
@property (nonatomic, copy) NSArray *eventsByDate;    //

- (void)reloadData;

@end

@interface BSMenuItemView : UIView

@property (nonatomic, retain) UILabel* label;
@property (nonatomic, copy) void (^leftBlock)(void);
@property (nonatomic, copy) void (^rightBlock)(void);

@end
