//
//  ArchiveUpdateFamilyRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/4/3.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveUpdateFamilyRequest.h"

@implementation ArchiveUpdateFamilyRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/putonrecord/alterFamily";
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (id )requestArgument {
    return self.familyArchiveInVM;
    //    return @{@"residentInVM":self.bodyStr};
    //    return @{@"residentInVM":_bodyDic};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.familyModel = [FamilyArchiveModel mj_objectWithKeyValues:self.ret];
    [self.familyModel decryptModel];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
