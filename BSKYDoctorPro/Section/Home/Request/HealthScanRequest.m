//
//  HealthScanRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/12/1.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "HealthScanRequest.h"

@implementation HealthScanRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestModel = [[HealthScanRequestModel alloc] init];
    }
    return self;
}

- (NSString*)bs_requestUrl {
//    self.ehealthCode = [[self.requestModel.ewmsg encryptCBCStr] urlencode];
//    NSString *urlStr = [NSString stringWithFormat:@"/doctor/healthcard/scannV2?ehealthCode=%@",self.ehealthCode];
//    return urlStr;
    return @"/doctor/healthcard/scannV2";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{@"Content-Type": @"application/x-www-form-urlencoded",
             @"headMode": [[BSClientManager sharedInstance] headMode],
             @"token": [BSClientManager sharedInstance].tokenId};
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}

- (id)requestArgument {
//    self.requestModel.business = [self returnTheCodeWithScanBusinessType:self.businessType];
//    self.c5RequestForm = [self.requestModel mj_keyValues];
//    return self.c5RequestForm;
    self.ehealthCode = [self.requestModel.ewmsg encryptCBCStr];
    return @{@"ehealthCode":self.ehealthCode};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.responseModel = [HealthScanRespondseModel mj_objectWithKeyValues:self.ret];
    [self.responseModel decryptModel];
}

- (NSString *)returnTheCodeWithScanBusinessType:(ScanBusinessType)type {
    switch (type) {
        case ScanBusinessHomeDoctorType:
            return @"0300501";
        case ScanBusinessHealthFilesType:
            return @"0800101";
        case ScanBusinessEHVisitType:
            return @"0300701";
        case ScanBusinessDMVisitType:
            return @"0300702";
        default:
            return @"0300501";
    }
}

@end

@implementation HealthScanRequestModel

@end

@implementation HealthScanRespondseModel
- (void)decryptModel{
    self.zjhm = [self.zjhm decryptCBCStr];
    self.zjlb = [self.zjlb decryptCBCStr];
}
@end
