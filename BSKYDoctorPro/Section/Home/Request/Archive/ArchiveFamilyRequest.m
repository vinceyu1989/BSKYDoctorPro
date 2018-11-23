//
//  ArchiveFamilyRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveFamilyRequest.h"

@implementation ArchiveFamilyRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/putonrecord/familyAchive";
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
