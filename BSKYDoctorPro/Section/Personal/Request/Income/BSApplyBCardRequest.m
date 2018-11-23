//
//  BSApplyBCardRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/11.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSApplyBCardRequest.h"

@implementation BSApplyBCardRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/bank/saveBankInfo";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return self.paymentBank;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
