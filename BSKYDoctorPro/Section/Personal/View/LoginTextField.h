//
//  LoginTextField.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTextField : UITextField

@property (nonatomic ,assign) NSInteger maxNum;    // 限制输入字数

- (void)setLeftViewImage:(UIImage *)image;
- (void)setRightViewImage:(UIImage *)image;

@end
