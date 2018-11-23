//
//  BSTotalMessageRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <BSKYCore/BSKYCore.h>

@interface BSTotalMessageRequest : BSBaseRequest

@property (nonatomic, copy)  NSString *num;
@property (nonatomic, strong) NSMutableArray *msgArrData;

@end
