//
//  StreetOrganRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface StreetOrganRequest : BSBaseRequest

@property (nonatomic, copy) NSString *divisionId;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *pageNo;

@property (nonatomic, copy) NSMutableArray *streetData;

@end
