//
//  BSTreatmentRequest.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/9/7.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTreatmentRequest : BSBaseRequest

@property (nonatomic, copy) NSNumber *pageIndex;
@property (nonatomic, copy) NSNumber *pageSize;
@property (nonatomic, copy) NSString *isFinish;//就诊状态 -1,全部 1,未完成 2,已完成
@property (nonatomic, copy) NSNumber *isSub;//是否复诊 -1,全部 1,是 0,否(传数字)
@property (nonatomic, copy) NSNumber *isPoverty;//贫困人口 -1,全部 1,是 0,否 (传数字)
@property (nonatomic, copy) NSString *beginDate;
@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, strong) NSMutableArray *dataList;
@end
