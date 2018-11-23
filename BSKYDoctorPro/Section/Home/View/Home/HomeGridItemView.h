//
//  HomeGridItemView.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/16.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridItemModel;

@interface HomeGridItemView : UIView

@property (nonatomic, strong) GridItemModel *itemModel;

@property (nonatomic, assign) BOOL hidenIcon;

@property (nonatomic, strong) UIImage *iconImage;

@property (nonatomic, assign) BOOL isRed;

@property (nonatomic, copy) void (^itemLongPressedOperationBlock)(UILongPressGestureRecognizer *longPressed);

@property (nonatomic, copy) void (^buttonClickedOperationBlock)(HomeGridItemView *item);

@property (nonatomic, copy) void (^iconViewClickedOperationBlock)(HomeGridItemView *view);

@end
