//
//  BSSignLabelModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/6/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSSignLabelModel : NSObject

@property (nonatomic, copy) NSString *dictID;   //字典主键ID ,
@property (nonatomic, copy) NSString *dictName; //字典名称 ,
@property (nonatomic, copy) NSString *dictType; // 字典分类;

@end
