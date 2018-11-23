//
//  SignatureView.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "SignatureView.h"

@interface SignatureView ()

@property (nonatomic,assign)NSInteger count;

@property (nonatomic,strong)UIImage *image;

@end

@implementation SignatureView {
    CAShapeLayer *shapeLayer;
    UIBezierPath *beizerPath;
    UIImage *incrImage;
    CGPoint points[5];
    uint control;
    BOOL isTouch;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    [self setMultipleTouchEnabled:NO];
    beizerPath = [UIBezierPath bezierPath];
    [beizerPath setLineWidth:2.5];
    self.drawColor = [UIColor blackColor];
    self.finalColor = [UIColor blackColor];
    isTouch = NO;
}

- (void)drawRect:(CGRect)rect {
    [incrImage drawInRect:rect];
    [beizerPath stroke];
    // Set initial color for drawing
    [self.drawColor setFill];
    [self.drawColor setStroke];
    [beizerPath stroke];
}

#pragma mark - UIView Touch Methods

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event] && self.isUserInteractionEnabled && !self.isHidden && self.alpha > 0.01) {
        if (!isTouch) {
            isTouch = YES;
        }
    }
    else {
        if (isTouch) {
            isTouch = NO;
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _count = 0;
    control = 0;
    UITouch *touch = [touches anyObject];
    points[0] = [touch locationInView:self];
    
    CGPoint startPoint = points[0];
    CGPoint endPoint = CGPointMake(startPoint.x + 1.5, startPoint.y
                                   + 2);
    
    [beizerPath moveToPoint:startPoint];
    [beizerPath addLineToPoint:endPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    control++;
    points[control] = touchPoint;
    
    if (control == 4)
    {
        points[3] = CGPointMake((points[2].x + points[4].x)/2.0, (points[2].y + points[4].y)/2.0);
        
        [beizerPath moveToPoint:points[0]];
        [beizerPath addCurveToPoint:points[3] controlPoint1:points[1] controlPoint2:points[2]];
        
        [self setNeedsDisplay];
        
        points[0] = points[3];
        points[1] = points[4];
        control = 1;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Bitmap Image Creation

- (void)drawBitmapImage {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if (!incrImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    [incrImage drawAtPoint:CGPointZero];
    
    //Set final color for drawing
    [self.finalColor setStroke];
    [beizerPath stroke];
    incrImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)clearSignature {
    incrImage = nil;
    self.userInteractionEnabled = YES;
    [self setNeedsDisplay];
    [beizerPath removeAllPoints];
}

#pragma mark - beginTimer
- (void)completeSignature {
    [self drawBitmapImage];
    [self setNeedsDisplay];
    UIImage *image = nil;
    if (![beizerPath isEmpty]) {
        image = [self getSignatureImage];
    }
    [beizerPath removeAllPoints];
    control = 0 ;
    self.userInteractionEnabled = NO;
    isTouch = NO;
    if (self.completeBlock) {
        self.completeBlock(image);
    }
}

#pragma mark - Get Signature image from given path

- (UIImage *)getSignatureImage {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return signatureImage;
}

#pragma mark - 懒加载

@end
