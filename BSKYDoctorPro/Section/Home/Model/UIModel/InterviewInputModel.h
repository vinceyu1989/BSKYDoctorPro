//
//  InterviewOptionalInputModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/5.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InterviewPickerModel,InterviewOtherModel ;

@interface InterviewInputModel : NSObject

@property (nonatomic ,copy) NSString *title;

@property (nonatomic ,assign) BSFormCellType type;   // cell样式类型

@property (nonatomic ,copy) NSString *propertyName;   // 后台对应的属性名称

@property (nonatomic ,copy) NSString *contentStr;

@property (nonatomic ,copy) NSString *placeholder;

@property (nonatomic, assign) UIKeyboardType keyboardType;  // 键盘类型

@property (nonatomic ,assign) BOOL isRequired;   //  是否是必填项

@property (nonatomic ,strong) InterviewOtherModel *otherModel;   // 输入其他

@property (nonatomic ,copy) NSArray *options;    // 标签类 nsstring 数组

@property (nonatomic ,copy) NSArray *pickerModels;   // InterviewPickerModel 数组

@property (nonatomic ,copy) NSArray *types;   //  随访分类选项

@property (nonatomic ,strong) id object;   // 备用属性

@end

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

@interface InterviewOtherModel : NSObject

@property (nonatomic ,copy) NSString *title;   // 标题

@property (nonatomic ,copy) NSString *placeholder;

@property (nonatomic ,copy) NSString *contentStr;

@property (nonatomic ,copy) NSString *propertyName;   // 后台对应的属性名称

@end



