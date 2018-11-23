//
//  ZLDoctorListRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/7.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "ZLDoctorModel.h"

@interface ZLDoctorListRequest : BSBaseRequest

@property (nonatomic, copy) NSString * key;

@property (nonatomic, copy) NSString * pageSize;

@property (nonatomic, copy) NSString * pageIndex;

@property (nonatomic, copy) NSArray * dataList;

@end
