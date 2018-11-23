//
//  ArchiveFamilyHistoryRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/15.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveFamilyHistoryRequest.h"

@implementation ArchiveFamilyHistoryRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/putonrecord/familyHistory";
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (id )requestArgument {
    //    return @{@"residentInVM":self.bodyStr};
    return self.familyHistoryInVMList;
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

@implementation UpdateFamilyHistoryRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/putonrecord/alterFamilyHistory";
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (id )requestArgument {
    //    return @{@"residentInVM":self.bodyStr};
    return self.familyHistoryInVMList;
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

