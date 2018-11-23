//
//  ZLCreatPersionRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLCreatPersionRequest.h"

@implementation ZLCreatPersionRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/sczl/putonrecord/addPersion";
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (id )requestArgument {
    return self.residentForm;
    //    return @{@"residentInVM":self.bodyStr};
    //    return @{@"residentInVM":_bodyDic};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.infoModel = [ZLPersonModel mj_objectWithKeyValues:self.ret];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
