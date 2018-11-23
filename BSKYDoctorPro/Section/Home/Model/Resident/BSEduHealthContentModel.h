//
//  BSEducationHealthModel.h
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSEduHealthContentModel : NSObject

@property (nonatomic, copy) NSString *Content;//内容 ,
@property (nonatomic, copy) NSString *ContentStr;//将空格和回车符替换后的html内容 ,
@property (nonatomic, copy) NSString *DocID;//医生ID ,
@property (nonatomic, copy) NSString *DocName;//医生姓名 ,
@property (nonatomic, copy) NSString *Gender;//性别对应值 ,
@property (nonatomic, copy) NSString *ID;//个人健康教育ID ,
@property (nonatomic, copy) NSString *KnowledgeTypeID;//知识类型ID ,
@property (nonatomic, copy) NSString *KnowledgeTypeName;//知识类型名称 ,
@property (nonatomic, copy) NSString *LifeCycleID ;//适应生命周期ID ,
@property (nonatomic, copy) NSString *LifeCycleName;//适应生命周期名称 ,
@property (nonatomic, copy) NSString *Remark;//备注 ,
@property (nonatomic, copy) NSNumber *Sex;//适应性别 0:女 1:男 3:全部 ,
@property (nonatomic, copy) NSString *Title;//健康教育模板ID

@end
