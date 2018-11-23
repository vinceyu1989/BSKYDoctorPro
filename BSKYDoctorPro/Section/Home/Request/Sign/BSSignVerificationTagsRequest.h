//
//  BSSignVerificationTagsRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"

@interface BSSignVerificationTagsRequest : BSBaseRequest

@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *tags;

@end
