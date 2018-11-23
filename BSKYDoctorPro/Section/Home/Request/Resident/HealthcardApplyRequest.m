//
//  HealthcardApplyRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/4/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "HealthcardApplyRequest.h"

@implementation HealthcardApplyRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/healthcard/applyV2";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    
    return self.healthCardFrom;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataModel = [HealthCardDataModel mj_objectWithKeyValues:self.ret];
}
- (void)requestFailedFilter {
    
    [super requestFailedFilter];
}

@end

@implementation HealthCardUpModel
- (void)encryptModel{
    self.documentNo = [self.documentNo encryptCBCStr];
    self.realName = [self.realName encryptCBCStr];
    self.phone = [self.phone encryptCBCStr];
}
@end

@implementation HealthCardDataModel

@end
