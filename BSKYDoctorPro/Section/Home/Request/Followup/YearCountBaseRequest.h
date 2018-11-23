//
//  YearCountBaseRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/11.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface YearCountBaseRequest : BSBaseRequest

@property (nonatomic ,copy) NSString *personId;

@property (nonatomic ,copy) NSString *doctorId;

@property (nonatomic ,assign) NSInteger count;   // 随访次数

@end
