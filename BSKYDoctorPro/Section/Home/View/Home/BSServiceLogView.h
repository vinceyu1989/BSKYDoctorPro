//
//  BSServiceLogView.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/31.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSServiceLogView;

@protocol BSServiceLogViewDataSource <NSObject>

@required
- (NSInteger)numberOfserviceLogInView:(BSServiceLogView*)serviceLogView;
- (BSServiceLog*)servieLogForIndex:(NSInteger)index;

@end

@interface BSServiceLogView : UIView

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, weak) id<BSServiceLogViewDataSource> dataSource;

- (void)reloadData;

@end
