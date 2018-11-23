//
//  ArchiveUpdatePBinfoRequest.m
//  BSKYDoctorPro
//
//  Created by 快医科技 on 2018/1/25.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ArchiveUpdatePBinfoRequest.h"

@implementation ArchiveUpdatePBinfoRequest
- (NSString *)bs_requestUrl{
    return @"/doctor/putonrecord/alertResident";
    
}
- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (id )requestArgument {
    return self.residentInVM;
    //    return @{@"residentInVM":self.bodyStr};
    //    return @{@"residentInVM":_bodyDic};
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (void)requestCompleteFilter{
    [super requestCompleteFilter];
    self.infoModel = [PersonBaseInfoModel mj_objectWithKeyValues:self.ret];
    [self.infoModel decryptModel];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}
@end
