//
//  CheckPhoneRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "CmsCodeAndCheckRequest.h"

@implementation CmsCodeAndCheckRequest

- (instancetype)init {
    if (self = [super init]) {
        self.model = [[CheckPhoneModel alloc] init];
        self.isValid = YES;
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return @"/user/v1/cmsCode/checkPhone";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{@"randomCek": [NSString enctryptCBCKeyWithRSA],
             @"phone": [self.phone encryptCBCStr],
             @"type": self.type,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.msg.length > 0 && [self.msg isEqualToString:@"账号不存在"]) {
        self.isValid = NO;
    }
    if (self.ret && [self.ret isKindOfClass:[NSDictionary class]]) {
        self.model = [CheckPhoneModel mj_objectWithKeyValues:self.ret];
        [self.model decryptModel];
    }
}

@end

@implementation CheckPhoneModel
- (void)decryptModel{
    self.idCard = [self.idCard decryptCBCStr];
    self.userName = [self.userName decryptCBCStr];
}
@end
