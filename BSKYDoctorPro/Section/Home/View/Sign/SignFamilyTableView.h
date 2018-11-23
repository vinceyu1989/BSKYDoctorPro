//
//  SignFamilyTableView.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FamilyTableDelegate;

@interface SignFamilyTableView : UITableView

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, weak) id<FamilyTableDelegate> myDelegate;
@end

@protocol FamilyTableDelegate <NSObject>

@optional
- (void)didSelectedFamilyCellWithIndex:(NSInteger)index;

@end
