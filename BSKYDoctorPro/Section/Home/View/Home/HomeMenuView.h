//
//  HomeMenuView.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/18.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeMenuView;

@protocol HomeMenuViewDelegate <NSObject>

- (void)homeMenuView:(HomeMenuView *)menuView selectItemAtIndex:(NSInteger)index;

@end

@interface HomeMenuView : UIView

@property (nonatomic, weak) id<HomeMenuViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) NSMutableArray *redArray;
- (void)setRedPointIndex:(NSUInteger )index on:(BOOL)on;
@end
