//
//  UIView+Badge.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "UIView+Badge.h"

static int MLT_BADGE_TAG = 6666;

@implementation BSBagdeView

-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:13.0];
        self.badgeColor = [UIColor redColor];
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.minimumDiameter = 18.0;
        self.opaque = YES;
    }
    
    return self;
}

-(void)setBadgeValue:(NSInteger)value {
    if(value != 0) {
        value = value > 999 ? 999 : value;
        
        CGSize numberSize = [[NSString stringWithFormat:@"%ld", value] sizeWithAttributes:@{NSFontAttributeName:self.font}];
        float diameterForNumber = numberSize.width;
        float diameter = diameterForNumber + 10;
        if(diameter < self.minimumDiameter) {
            diameter = self.minimumDiameter;
        }
        
        CGRect superviewFrame = self.superview.frame;
        self.bounds = CGRectMake(0, 0, diameter, 18);
        self.center = CGPointMake(superviewFrame.size.width - 5, +5);
    } else {
        self.frame = CGRectZero;
    }
    _badgeValue = value;
    [self setNeedsDisplay];
}
-(void)setMinimumDiameter:(float)f {
    _minimumDiameter = f;
    self.bounds = CGRectMake(0, 0, f, f);
}

-(void)drawRect:(CGRect)rect {
    if(self.badgeValue != 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.badgeColor set];
        float fw = rect.size.width;
        float fh = rect.size.height;
        float radius = fh / 2.;

        CGContextMoveToPoint(context, radius, 1);
        CGContextAddLineToPoint(context, fw - radius, 1);
        CGContextAddArc(context, fw - radius, radius, radius - 1, M_PI_2, -M_PI_2, 1);
        CGContextAddLineToPoint(context, fw - radius, fh - 1);
        CGContextAddLineToPoint(context, radius, fh - 1);
        CGContextAddArc(context, radius, radius, radius - 1, -M_PI_2, M_PI_2, 1);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
        
        [self.textColor set];
        CGSize numberSize = [[NSString stringWithFormat:@"%ld", self.badgeValue] sizeWithAttributes:@{NSFontAttributeName:self.font}];
        [[NSString stringWithFormat:@"%ld", self.badgeValue] drawInRect:CGRectMake(5, (rect.size.height / 2.0) - (numberSize.height / 2.0), rect.size.width - 10, numberSize.height) withFont:self.font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    }
}

@end

@implementation UIView (Badge)

-(BSBagdeView *)badge {
    UIView *existingView = [self viewWithTag:MLT_BADGE_TAG];
    if(existingView) {
        if(![existingView isKindOfClass:[BSBagdeView class]]) {
            return nil;
        } else {
            return (BSBagdeView *)existingView;
        }
    }
    BSBagdeView *badgeView = [[BSBagdeView alloc]initWithFrame:CGRectZero];
    badgeView.tag = MLT_BADGE_TAG;
    [self addSubview:badgeView];
    return badgeView;
}

@end
