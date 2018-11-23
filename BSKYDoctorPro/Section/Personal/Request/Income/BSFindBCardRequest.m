//
//  BSFindBCardRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/11.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSFindBCardRequest.h"

@implementation BSFindBCardRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/bank/findBankList";
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
        self.model = [BSBankInfoModel mj_objectWithKeyValues:self.ret];
        self.model.bankBranch = [self.model.bankBranch decryptCBCStr];
        self.model.bankAccount = [self.model.bankAccount decryptCBCStr];
        self.model.bankOwner = [self.model.bankOwner decryptCBCStr];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
