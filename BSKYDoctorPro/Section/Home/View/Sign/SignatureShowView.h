//
//  SignatureShowView.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignatureShowView;
typedef void(^SignatureShowBlock)(UIImage *image);
typedef void(^SignatureDismissBlock)(SignatureShowView *view);
@interface SignatureShowView : UIView

@property (nonatomic, copy) SignatureShowBlock block;
@property (nonatomic, copy) SignatureDismissBlock dismissBlock;

@end
