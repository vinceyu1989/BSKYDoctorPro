//
//  BSSignContractListRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/4/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignContractListRequest.h"

@implementation BSSignContractListRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.status = @"2";
        self.doctorId = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;
        self.pageSize = @5;
        self.pageIndex = @1;
        self.ignoreType = @0;
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return @"/doctor/sign/contractSignInfo";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{@"cardIdOrName":[self.cardIdOrName encryptCBCStr],
//             @"teamId":self.teamId,
             @"status":self.status,
//             @"doctorId":self.doctorId,
             @"pageSize":self.pageSize,
             @"pageIndex":self.pageIndex,
             @"ignoreType":self.ignoreType};
}
- (void)startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    [super startWithCompletionBlockWithSuccess:success failure:failure];
    self.refreshStatus = ResidentRefreshStatusRuning;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataList = [SignContractModel mj_objectArrayWithKeyValuesArray:self.ret];
    [self.dataList decryptArray];
    self.refreshStatus = ResidentRefreshStatusSuccess;
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    self.refreshStatus = ResidentRefreshStatusFailure;
}

@end

@implementation SignContractModel
- (void)decryptModel{
    self.address = [self.address decryptCBCStr];
    self.cardId = [self.cardId decryptCBCStr];
    self.createEmp = [self.createEmp decryptCBCStr];
    self.personName = [self.personName decryptCBCStr];
    self.signPerson = [self.signPerson decryptCBCStr];
}
@end
