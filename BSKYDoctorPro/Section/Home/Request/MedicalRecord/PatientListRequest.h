//
//  PatientListRequest.h
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBaseRequest.h"

@interface PatientListRequest : BSBaseRequest
@property (nonatomic ,copy) NSString *pageSize;
@property (nonatomic ,copy) NSString *pageIndex;
@property (nonatomic ,copy) NSString *key;
@property (nonatomic ,strong) NSArray *listArray;
@end
