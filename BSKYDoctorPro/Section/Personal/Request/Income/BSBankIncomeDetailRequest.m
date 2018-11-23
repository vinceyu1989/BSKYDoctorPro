//
//  BSBankIncomeDetailRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBankIncomeDetailRequest.h"
#import "BSBankIncomeDetailModel.h"

@implementation BSBankIncomeDetailRequest

- (instancetype)init {
    if (self = [super init]) {
        self.pageSize = @(10);
        self.pageNo = @(1);
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return @"/doctor/bank/findBankTradeList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"pageSize":self.pageSize,
             @"pageNo":self.pageNo,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    if (self.ret != nil) {
        self.incomeDetailData = [BSBankIncomeDetailModel mj_objectArrayWithKeyValuesArray:self.ret];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
