//
//  BSBankBalanceInfoRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSBankBalanceInfoRequest.h"


@implementation BSBankBalanceInfoRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/bank/findBankCardSum";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    if (self.ret != nil) {
        self.model = [BSBankBalanceInfoModel mj_objectWithKeyValues:self.ret];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
