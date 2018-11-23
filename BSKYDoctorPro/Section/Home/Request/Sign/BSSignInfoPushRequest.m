//
//  BSSignInfoPushRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignInfoPushRequest.h"

@implementation BSSignInfoPushRequest

- (NSString*)bs_requestUrl {
    return @"/face/sign/info";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return self.signForm;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil) {
        self.respondseModelArr = [SignInfoRespondseModel mj_objectArrayWithKeyValuesArray:self.ret];
        [self.respondseModelArr decryptArray];
    }
}

@end

@implementation SignInfoRequestModel

@end

@implementation SignInfoRespondseModel
- (void)decryptModel{
    self.uniqueId = [self.uniqueId decryptCBCStr];
}
@end
