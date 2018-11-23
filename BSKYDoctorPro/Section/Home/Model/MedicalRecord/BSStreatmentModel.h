//
//  BSStreatmentModel.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/9/7.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSStreatmentModel : NSObject

@property (nonatomic, copy) NSString *age;//年龄
@property (nonatomic, copy) NSString *assessment;//诊断
@property (nonatomic, copy) NSString *doctorame;//医生姓名-加密
@property (nonatomic, copy) NSString *gender;//性别
@property (nonatomic, copy) NSString *treatmentId;// 就诊ID
@property (nonatomic, copy) NSString *moreAssessment;//诊断详情
@property (nonatomic, copy) NSString *name;//姓名-加密
@property (nonatomic, copy) NSString *personId;//居民ID
@property (nonatomic, copy) NSString *treatmentTime;//就诊时间

@end
