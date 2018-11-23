//
//  BSTreatmentRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/9/7.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSTreatmentRequest.h"
#import "BSStreatmentModel.h"

@implementation BSTreatmentRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageIndex = @(1);
        self.pageSize = @(10);
    }
    return self;
}
- (NSString*)bs_requestUrl {
    return @"/doctor/visit/consultinglist";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"pageIndex" : self.pageIndex,
             @"pageSize" : self.pageSize,
             @"isFinish" : self.isFinish,
             @"isSub" : self.isSub,
             @"isPoverty" : self.isPoverty,
             @"beginDate" : self.beginDate,
             @"endDate" : self.endDate,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataList = [BSStreatmentModel mj_objectArrayWithKeyValuesArray:self.ret];
    [self.dataList decryptArray];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
