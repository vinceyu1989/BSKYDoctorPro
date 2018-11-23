//
//  BSSignResidentInfoRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignResidentInfoRequest.h"
#import "SignResidentInfoModel.h"

@implementation BSSignResidentInfoRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageSize = @20;
        self.pageIndex = @1;
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/sign/residentInfo"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"nameOrIdcard":[self.nameOrIdcard encryptCBCStr],
             @"pageSize":self.pageSize,
             @"pageIndex":self.pageIndex,};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil) {
        self.residentInfosData = [SignResidentInfoModel mj_objectArrayWithKeyValuesArray:self.ret];
        [self.residentInfosData decryptArray];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
