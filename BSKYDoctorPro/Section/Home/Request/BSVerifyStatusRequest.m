//
//  BSVerifyStatusRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSVerifyStatusRequest.h"

@interface VerifyStatusModel : NSObject

@property (nonatomic, copy) NSString * account;
@property (nonatomic, copy) NSString * mainRegionCode;
@property (nonatomic, copy) NSString * orgName;
@property (nonatomic, copy) NSString * phisUserName;
@property (nonatomic, copy) NSString * verifyMessage;
@property (nonatomic, copy) NSString * verifyStatus;
- (void)decryptModel;
@end

@implementation VerifyStatusModel
- (void)decryptModel{
    self.account = [self.account decryptCBCStr];
    self.orgName = [self.orgName decryptCBCStr];
    self.phisUserName = [self.phisUserName decryptCBCStr];
}
@end

@implementation BSVerifyStatusRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/phis/verify/status"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    VerifyStatusModel *model = [VerifyStatusModel mj_objectWithKeyValues:self.ret];
    [model decryptModel];
    BSUser *user = [BSAppManager sharedInstance].currentUser;
    if ([user.divisionCode isNotEmptyString] && model.verifyStatus.integerValue != PhisVerifyStatusUnregistered && ![user.divisionCode containsString:model.mainRegionCode]) {
        self.verifyStatus = PhisVerifyStatusRegionCodeMismatch;
        self.verifyMessage = @"您当前登录账号与绑定的公卫账号行政区划不统一，请重新绑定行政区划统一的公卫账号！";
        return;
    }
    self.verifyStatus = model.verifyStatus.integerValue;
    self.verifyMessage = model.verifyMessage;
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
