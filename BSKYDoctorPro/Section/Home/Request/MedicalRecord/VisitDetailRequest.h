//
//  VisitDetailRequest.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"
#import "VisitDetailModel.h"

@interface VisitDetailRequest : BSBaseRequest
@property (nonatomic ,copy) NSString *mzId;
@property (nonatomic ,strong) VisitDetailModel *model;
@end
