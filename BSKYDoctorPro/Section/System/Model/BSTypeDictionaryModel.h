//
//  BSTypeDictionaryMdel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTypeDictionaryModel : NSObject

@property (nonatomic, copy) NSNumber *dictId; //主键ID
@property (nonatomic, copy) NSString *value;  //键值
@property (nonatomic, copy) NSString *lebel;  //标签显示值

@end
