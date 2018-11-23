//
//  AuxiliaryCheckSectionModel.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuxiliaryCheckSectionModel : NSObject

@property (nonatomic ,copy) NSString *title;

@property (nonatomic ,copy) NSArray *data;

@property (nonatomic ,assign) NSInteger type;

@property (nonatomic ,assign) BOOL isExpansion;   // 是否展开

@property (nonatomic ,assign) BOOL isEmpty;   // 是否输入的有内容

@end

@interface AuxiliaryCheckRowModel : NSObject

@property (nonatomic ,copy) NSString *title;

@property (nonatomic ,copy) NSString *content;

@property (nonatomic ,copy) NSArray *pickerModels;

@end
