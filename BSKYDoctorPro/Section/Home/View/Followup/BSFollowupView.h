//
//  BSFollowupView.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSFollowupView;

@protocol BSFollowupViewDataSource <NSObject>

@optional
- (NSArray*)eventsByDayWithView:(BSFollowupView*)followupView;

@end

@protocol BSFollowupViewDelegate <NSObject>

@optional

/**
 点击逾期
 */
- (void)didTouchOverFollowup;

/**
 点击日期
 */
- (void)didTouchForDate:(NSDate*)date;

/**
 月份变动
 */
- (void)didChangeMonth:(NSString*)month;

#pragma mark - 创建随访

/**
 糖尿病
 */
- (void)didTouchCreateDiabetesFollowup;

/**
 高血压
 */
- (void)didTouchCreateHypertensionFollowup;

/**
 高糖
 */
- (void)didTouchCreateHighGlucoseFollowup;

/**
 精神病
 */
- (void)didTouchCreateMentalDiseaseFollowup;

@end

@interface BSFollowupView : UIView

@property (nonatomic, weak) id<BSFollowupViewDataSource> dataSource;
@property (nonatomic, weak) id<BSFollowupViewDelegate> delegate;

- (void)reloadData;

@end
