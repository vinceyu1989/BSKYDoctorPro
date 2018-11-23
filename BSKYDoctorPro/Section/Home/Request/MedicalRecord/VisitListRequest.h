//
//  VisitListRequest.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"

@interface VisitListRequest : BSBaseRequest
@property (nonatomic ,copy) NSString *personId;
@property (nonatomic ,strong) NSArray *listArray;
@end
