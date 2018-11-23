//
//  DistrictCodeRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface DistrictCodeRequest : BSBaseRequest

@property (nonatomic, copy) NSString       *parentId;
@property (nonatomic, copy) NSMutableArray *districtData;

@end
