//
//  BSSignResidentInfoRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSSignResidentInfoRequest : BSBaseRequest

@property (nonatomic, copy) NSString *nameOrIdcard;
@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSNumber *pageIndex;

@property (nonatomic, strong) NSMutableArray *residentInfosData;

@end
