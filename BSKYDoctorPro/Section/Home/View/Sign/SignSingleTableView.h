//
//  SignSingleTableView.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleTableDelegate;
@interface SignSingleTableView : UITableView

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, weak) id<SingleTableDelegate> myDelegate;

@end

@protocol SingleTableDelegate <NSObject>

@optional
- (void)didSelectedSingleCellWithIndex:(NSInteger)index;

@end
