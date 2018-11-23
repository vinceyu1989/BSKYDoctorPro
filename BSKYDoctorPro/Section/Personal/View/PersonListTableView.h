//
//  PersonListTableView.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/15.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonListTableViewDelegate;

@interface PersonListTableView : UITableView

@property (nonatomic, assign) BOOL isAudit;
@property (nonatomic, weak) id<PersonListTableViewDelegate> myDelegate;

@end

@protocol PersonListTableViewDelegate <NSObject>

@optional
- (void)didSelectedIndex:(NSInteger)index;

@end
