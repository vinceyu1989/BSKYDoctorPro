//
//  BSEduHealthModelRequest.h
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"

@interface BSEduHealthModelRequest : BSBaseRequest

@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSNumber *pageIndex;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSMutableArray *healthModelData;


@end
