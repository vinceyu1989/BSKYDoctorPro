//
//  BSSignFamilyArchiveRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignFamilyArchiveRequest.h"
#import "SignFamilyArchiveModel.h"

@implementation BSSignFamilyArchiveRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageSize = @20;
        self.pageIndex = @1;
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/sign/familyArchive"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"familyCodeOrName":[self.familyCodeOrName encryptCBCStr],
             @"pageSize":self.pageSize,
             @"pageIndex":self.pageIndex,};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil) {
        self.familyArchiveData = [SignFamilyArchiveModel mj_objectArrayWithKeyValuesArray:self.ret];
        [self.familyArchiveData decryptArray];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
