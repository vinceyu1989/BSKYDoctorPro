//
//  UIView+Badge.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSBagdeView : UIView

@property (nonatomic, assign) NSInteger badgeValue;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *badgeColor;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, assign) float minimumDiameter;

@end

@interface UIView (Badge)

@property(nonatomic, readonly) BSBagdeView *badge;

@end
