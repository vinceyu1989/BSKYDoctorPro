//
//  InterviewPickerModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/6.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterviewPickerModel : NSObject

@property (nonatomic ,copy) NSString *title;   // 标题

@property (nonatomic ,copy) NSString *propertyName;   // 后台对应的属性名称

@property (nonatomic ,assign) NSInteger min;   // 最小值  有小数点乘，以相应的倍数

@property (nonatomic ,assign) NSInteger max;   // 最大值

@property (nonatomic ,copy) NSString *content;    // 被选中的

@property (nonatomic ,assign) NSInteger point;   //小数点处理，1，10，100

@property (nonatomic ,copy) NSString *unit;    // 单位

@property (nonatomic ,assign) NSInteger multiple;    // 倍数

@end
