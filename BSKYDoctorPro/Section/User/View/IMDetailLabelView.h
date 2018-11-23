//
//  IMDetailLabelView.h
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/5/17.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChangeSuccessBlock)(NSString *value);

@interface IMDetailLabelView : UIView
@property (nonatomic ,copy) ChangeSuccessBlock block;
- (instancetype)initWithFrame:(CGRect)frame selectArray:(NSMutableArray *)array value:(NSString *)value;
- (void)show;
@end
