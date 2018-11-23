//
//  ZLUpdateFamilyRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/2/28.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLUpdateFamilyRequest.h"

@implementation ZLUpdateFamilyRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/sczl/putonrecord/upadteFamily";
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (id )requestArgument {
    return self.updateFamilyArchiveForm;
    //    return @{@"residentInVM":self.bodyStr};
    //    return @{@"residentInVM":_bodyDic};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
//    NSArray *data = (NSArray *)self.ret;
//    self.infoModel = [ZLPersonModel mj_objectWithKeyValues:self.ret];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
