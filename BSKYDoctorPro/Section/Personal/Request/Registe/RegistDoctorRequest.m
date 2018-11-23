//
//  RegistDoctorRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "RegistDoctorRequest.h"

@implementation RegistDoctorRequest

- (NSString*)bs_requestUrl {
    NSString *urlStr = [NSString stringWithFormat:@"/doctor/v1/registerDoctor?randomCek=%@",[[NSString enctryptCBCKeyWithRSA] urlencode]];
    return urlStr;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return self.userInfoForm;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end

@implementation RegistDoctorModel
- (void)entryptModel{
    self.mobileNo = [self.mobileNo encryptCBCStr];
    self.smsCode = [self.smsCode encryptCBCStr];
    self.password = [self.password encryptCBCStr];
    self.realName = [self.realName encryptCBCStr];
    self.documentNo = [self.documentNo encryptCBCStr];
}
@end
