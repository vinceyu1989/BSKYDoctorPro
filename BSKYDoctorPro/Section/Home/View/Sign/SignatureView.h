//
//  SignatureView.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureView : UIView

@property (nonatomic ,strong) UIColor *drawColor;  // 画的颜色 默认黑色

@property (nonatomic ,strong) UIColor *finalColor;  // 完成的颜色 默认黑色

@property (nonatomic, copy) void (^completeBlock)(UIImage *signatureImage);

- (void)completeSignature;
- (void)clearSignature;

@end
