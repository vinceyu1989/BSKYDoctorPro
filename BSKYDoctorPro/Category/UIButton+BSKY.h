//
//  UIButton+BSKY.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/20.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BSKY)

- (void)addUnderLine;

- (void)addBorderLine;

- (void)setSelectedAndChangeBorderColor:(BOOL)selected;

/** 设置可点击范围到按钮边缘的距离 */
- (void)setEnlargeEdge:(CGFloat)size;

/** 设置可点击范围到按钮上、右、下、左的距离 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
