//
//  ArchivePersonHistoryRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchivePersonHistoryRequest.h"

@implementation ArchivePersonHistoryRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/putonrecord/personHistory";
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (id )requestArgument {
    //    return @{@"residentInVM":self.bodyStr};
    return self.personHistoryInVMList;
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

@implementation UpdatePersonHistoryRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/putonrecord/alterPersonHistory";
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (id )requestArgument {
    //    return @{@"residentInVM":self.bodyStr};
    return self.personHistoryInVMList;
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
