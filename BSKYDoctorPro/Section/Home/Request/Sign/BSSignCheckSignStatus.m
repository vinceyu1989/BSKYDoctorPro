//
//  BSSignCheckSignStatus.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/18.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignCheckSignStatus.h"

@implementation BSSignCheckSignStatus

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageSize = @5;
        self.pageIndex = @1;
        self.doctorId = [BSAppManager sharedInstance].currentUser.phisInfo.EmployeeID;
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return @"/doctor/sign/isExistContractSignInfo";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"cardIds":[self.cardIds encryptCBCStr],
             @"doctorId":self.doctorId,
             @"pageSize":self.pageSize,
             @"pageIndex":self.pageIndex,};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.signStatusArr = [SignCheckSignStatusRespondse mj_objectArrayWithKeyValuesArray:self.ret];
    [self.signStatusArr decryptArray];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end

@implementation SignCheckSignStatusRespondse
- (void)decryptModel{
    self.personName = [self.personName decryptCBCStr];
    self.cardId = [self.cardId decryptCBCStr];
}
@end
