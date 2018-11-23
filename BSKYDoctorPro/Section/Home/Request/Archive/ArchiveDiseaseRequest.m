//
//  ArchiveDiseaseRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveDiseaseRequest.h"

@implementation ArchiveDiseaseRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/putonrecord/cmPerson";
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (id )requestArgument {
    //    return @{@"residentInVM":self.bodyStr};
    return self.cmPersonInVMList;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end

@implementation UpdateDiseaseRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/putonrecord/alterCmPerson";
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (id )requestArgument {
    //    return @{@"residentInVM":self.bodyStr};
    return self.cmPersonInVMList;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.model = [AddDiseaseModel mj_objectWithKeyValues:self.ret];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
