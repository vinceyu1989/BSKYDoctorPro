//
//  ZLSearchPersonalRequest.h
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>
#import "ZLSearchPersonalModel.h"

@interface ZLSearchPersonalRequest : BSBaseRequest

@property (nonatomic, copy) NSString * personalParam;

@property (nonatomic, copy) NSString * pageSize;

@property (nonatomic, copy) NSString * pageIndex;

@property (nonatomic, copy) NSArray * dataList;

@end
