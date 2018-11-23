//
//  BSServiceLogRequest.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSServiceLogRequest : BSBaseRequest

@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *pageNo;

@property (nonatomic, retain) NSArray *serviceLogList;

@end
